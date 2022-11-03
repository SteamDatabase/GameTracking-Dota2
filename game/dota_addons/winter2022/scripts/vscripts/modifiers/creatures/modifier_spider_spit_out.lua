modifier_spider_spit_out = class({})

--------------------------------------------------------------------------------

local SPIT_DURATION = 0.5
local SPIT_MINIMUM_HEIGHT_ABOVE_LOWEST = 400
local SPIT_MINIMUM_HEIGHT_ABOVE_HIGHEST = 100
local SPIT_ACCELERATION = 2500

--------------------------------------------------------------------------------

function modifier_spider_spit_out:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
            --print( '^^^modifier_spider_spit_out DESTROYED!' )
			self:Destroy()
			return
		end

        self.flAcceleration = SPIT_ACCELERATION * RandomFloat( 0.8, 1.2 )

		--self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
        self.vStartPosition = self:GetParent():GetAbsOrigin()
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = SPIT_DURATION * RandomFloat( 0.8, 1.2 )
		local flDesiredHeight = SPIT_MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + SPIT_MINIMUM_HEIGHT_ABOVE_HIGHEST )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.flAcceleration )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.flAcceleration * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ( self.flAcceleration ), ( self.flInitialVelocityZ - flSqrtDet) / ( self.flAcceleration ) )
        --print( 'PREDICTED TIME = ' .. self.flPredictedTotalTime )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:UpdateHorizontalMotion( me, dt )
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
		local flVelDelta = math.min( flVelDif, self.flAcceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
        
        --DebugDrawSphere( vNewPos, Vector(0,255,255), 0.8, 50, false, 0.2 )

		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.flAcceleration * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
        --print( 'GOING DOWN? ' .. tostring( bGoingDown ) )
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.flAcceleration * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
            --print( 'LANDED!' )
			vNewPos.z = flGroundHeight
			bLanded = true
		end

        --DebugDrawSphere( vNewPos, Vector(255,255,0), 0.8, 50, false, 0.2 )

		me:SetOrigin( vNewPos )
		if bLanded == true then
            --print( '^^^modifier_spider_spit_out - LANDED! DESTROYED!' )
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:OnHorizontalMotionInterrupted()
	if IsServer() then
        --print( '^^^modifier_spider_spit_out - HORIZONTAL MOTION INTERRUPTED! DESTROYED!' )
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:OnVerticalMotionInterrupted()
	if IsServer() then
        --print( '^^^modifier_spider_spit_out - VERTICAL MOTION INTERRUPTED! DESTROYED!' )
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_spider_spit_out:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end