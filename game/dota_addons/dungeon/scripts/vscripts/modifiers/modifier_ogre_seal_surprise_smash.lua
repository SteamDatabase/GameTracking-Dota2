modifier_ogre_seal_surprise_smash = class({})

--------------------------------------------------------------------------------

local OGRE_MINIMUM_HEIGHT_ABOVE_LOWEST = 150
local OGRE_MINIMUM_HEIGHT_ABOVE_HIGHEST = 33
local OGRE_ACCELERATION_Z = 1250
local OGRE_MAX_HORIZONTAL_ACCELERATION = 1000

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:OnCreated( kv )
	if IsServer() then
		self.bHorizontalMotionInterrupted = false
		self.bDamageApplied = false
		self.bTargetTeleported = false

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			print("modifier_ogre_seal_surprise_smash - no motion controllers")
			self:Destroy()
			return
		end

		EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/ogre_seal_icebreak.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.vStartPosition.z = self.vStartPosition.z - 200
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = OGRE_MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + OGRE_MINIMUM_HEIGHT_ABOVE_HIGHEST )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * OGRE_ACCELERATION_Z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * OGRE_ACCELERATION_Z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ( OGRE_ACCELERATION_Z), ( self.flInitialVelocityZ - flSqrtDet) / ( OGRE_ACCELERATION_Z ) )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end
end

-- --------------------------------------------------------------------------------

-- function modifier_ogre_seal_surprise_smash:DeclareFunctions()
-- 	local funcs = 
-- 	{
-- 		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
-- 	}
-- 	return funcs
-- end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:UpdateHorizontalMotion( me, dt )
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
		local flVelDelta = math.min( flVelDif, OGRE_MAX_HORIZONTAL_ACCELERATION )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -OGRE_ACCELERATION_Z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * OGRE_ACCELERATION_Z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				self:ApplySmash()
			end

			self:GetParent():RemoveHorizontalMotionController( self )
			self:GetParent():RemoveVerticalMotionController( self )

			self:SetDuration( 0.15, true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_smash:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

-- --------------------------------------------------------------------------------

-- function modifier_ogre_seal_surprise_smash:GetOverrideAnimation( params )
-- 	return ACT_DOTA_OVERRIDE_ABILITY_2
-- end

function modifier_ogre_seal_surprise_smash:ApplySmash()
	local damage_amount = self:GetAbility():GetSpecialValueFor( "damage" )
	local stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	local impact_radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )

	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "OgreTank.GroundSmash", self:GetParent() )
	local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/ogre_seal_suprise.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsInvulnerable() == false then
			local damageInfo = 
			{
				victim = enemy,
				attacker = self:GetCaster(),
				damage = damage_amount,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self,
			}

			ApplyDamage( damageInfo )

			if enemy:IsAlive() == false then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
			else
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = stun_duration } )
			end
		end
	end
end