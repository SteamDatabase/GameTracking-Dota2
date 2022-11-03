if modifier_frosttoad_hop == nil then
modifier_frosttoad_hop = class({})
end

--------------------------------------------------------------------------------

local FROG_MINIMUM_HEIGHT_ABOVE_HIGHEST = 50
local FROG_ACCELERATION_Z = 1250
local FROG_MAX_HORIZONTAL_ACCELERATION = 800

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:OnCreated( kv )
	if IsServer() then
		if self.nHopCount == nil then
			self.nMaxHops = self:GetAbility():GetSpecialValueFor("hop_count") + 1
			self.hop_distance = self:GetAbility():GetSpecialValueFor("hop_distance")
			self.nHopCount = 2 -- HACK: Starting at the first hop has really slow acceleration and I didn't want to rewrite it...
		end

		self.bHorizontalMotionInterrupted = false

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.flTimer = 0.0
		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0
		self.flDeltaZ = 0

		local vToTarget = self:GetCaster():GetForwardVector() * self.hop_distance
		self.vLastKnownTargetPos = self:GetCaster():GetOrigin() + vToTarget

		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = flHighZ + FROG_MINIMUM_HEIGHT_ABOVE_HIGHEST * self.nHopCount

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * FROG_ACCELERATION_Z * self.nHopCount )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * FROG_ACCELERATION_Z * self.nHopCount * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ( FROG_ACCELERATION_Z * self.nHopCount ), ( self.flInitialVelocityZ - flSqrtDet) / ( FROG_ACCELERATION_Z * self.nHopCount ) )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )

		self:GetAbility():StartCooldown( -1 )

		if self:GetCaster():GetOwnerEntity() ~= nil and self:GetCaster():GetOwnerEntity():HasModifier("modifier_mounted") then
			-- Owner is still mounted, continue moving
			local hPassiveAbility = self:GetCaster():FindAbilityByName("frosttoad_passive")
			if hPassiveAbility ~= nil then
				self:GetCaster():AddNewModifier(self:GetCaster(), hPassiveAbility, "modifier_mount_movement", {})
			end

			-- Set owner cooldown to the same as ours for a visual indicator of when the next hop is
			local hSummonAbility = self:GetCaster():GetOwnerEntity():FindAbilityByName("summon_penguin")
			if hSummonAbility ~= nil then
				hSummonAbility:StartCooldown(self:GetAbility():GetCooldown(-1))
			end
		else
			-- Handle despawn since we removed mount_movement
			self:GetCaster():AddNewModifier( nil, nil, "modifier_kill", { duration = 0.2 } )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:DeclareFunctions()
	local funcs = 
	{
	--	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		self.flTimer = self.flTimer + dt
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
		local flVelDelta = math.min( flVelDif, FROG_MAX_HORIZONTAL_ACCELERATION * self.nHopCount )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -FROG_ACCELERATION_Z * self.nHopCount * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * FROG_ACCELERATION_Z * self.nHopCount * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		self.flDeltaZ = vNewPos.z - self.vStartPosition.z
		me:SetOrigin( vNewPos )
		if bLanded == true then

			local bDoneHopping = self.nHopCount >= self.nMaxHops

			if self.bHorizontalMotionInterrupted == false then
				if self.nHopCount > 1 then
					GridNav:DestroyTreesAroundPoint( me:GetAbsOrigin(), 75, false )
					self:GetAbility():TryToDamage()
					self.flTimer = 0.0
				end
			else
				bDoneHopping = true
			end

			if bDoneHopping then
				self:Destroy()
			else
				self.nHopCount = self.nHopCount + 1
				self:OnCreated( {} )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_frosttoad_hop:GetOverrideAnimation( params )
	return ACT_DOTA_OVERRIDE_ABILITY_2
end

--------------------------------------------------------------------------------
