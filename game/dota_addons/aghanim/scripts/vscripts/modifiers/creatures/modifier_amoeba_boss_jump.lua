modifier_amoeba_boss_jump = class({})

--------------------------------------------------------------------------------

local AMOEBA_MINIMUM_HEIGHT_ABOVE_LOWEST = 800

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:OnCreated( kv )
	if IsServer() then
		self.bHorizontalMotionInterrupted = false
		self.bDamageApplied = false
		self.bTargetTeleported = false

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			print( 'CANNOT APPLY MOTION CONTROLLERS - DESTROYING modifier_amoeba_boss_jump' )
			self:Destroy()
			return
		end

		if self:GetParent():FindModifierByName( 'modifier_amoeba_boss_death_explosion' ) ~= nil then
			print( 'Amoeba Boss is trying to die! Cancelling jump!' )
			self:Destroy()
			return
		end

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		-- lowering this height significantly lowers the hand time
		self.amoeba_min_height = self:GetAbility():GetSpecialValueFor( "amoeba_min_height" )
	
		-- higher acceleration leads to a shorter hang time
		-- 1400 ~1.5s
		-- 1800 ~1.333s
		-- 2000 ~1.26s
		-- 3000 ~1.03
		-- 4000 ~0.89s
		self.amoeba_acceleration = self:GetAbility():GetSpecialValueFor( "amoeba_acceleration" )

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		--print( 'modifier_amoeba_boss_jump:OnCreated() duration = ' .. duration )
		local flDesiredHeight = AMOEBA_MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.amoeba_min_height )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.amoeba_acceleration )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.amoeba_acceleration * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ( self.amoeba_acceleration ), ( self.flInitialVelocityZ - flSqrtDet) / ( self.amoeba_acceleration ) )
		--print( 'modifier_amoeba_boss_jump:OnCreated() flPredictedTotalTime = ' .. self.flPredictedTotalTime )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.amoeba_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.amoeba_acceleration * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.amoeba_acceleration * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				self:GetAbility():Splatter()
			end

			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:OnVerticalMotionInterrupted()
	if IsServer() then
		print( 'VERTICAL MOTION CONTROLLER INTERRUPTED - DESTROYING modifier_amoeba_boss_jump' )
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_amoeba_boss_jump:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_1
end