
modifier_eimermole_emerge = class({})

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:OnCreated( kv )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_eimermole_burrow" )

		self.bHorizontalMotionInterrupted = false
		self.bDamageApplied = false
		self.bTargetTeleported = false

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()

			return
		end

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local nMinHeightAboveLowest = self:GetAbility():GetSpecialValueFor( "min_height_above_lowest" )
		local nMinHeightAboveHighest = self:GetAbility():GetSpecialValueFor( "min_height_above_highest" )
		self.nAccelerationZ = self:GetAbility():GetSpecialValueFor( "acceleration_z" )
		self.nMaxHorizontalAcceleration = self:GetAbility():GetSpecialValueFor( "max_horizontal_acceleration" )

		local flDesiredHeight = nMinHeightAboveLowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + nMinHeightAboveHighest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.nAccelerationZ )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.nAccelerationZ * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.nAccelerationZ, ( self.flInitialVelocityZ - flSqrtDet) / self.nAccelerationZ )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )

		if self:GetAbility() then
			-- Do this weird thing because we don't want to destroy the particle in ability's
			-- OnSpellStart while the Eimermole is still in the air
			ParticleManager:DestroyParticle( self:GetAbility().nPreviewFX, false )

			self:GetCaster():FadeGesture( ACT_DOTA_VICTORY ) -- cleanup leftover from modifier_eimermole_burrow
		end
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:UpdateHorizontalMotion( me, dt )
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
		local flVelDelta = math.min( flVelDif, self.nMaxHorizontalAcceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.nAccelerationZ * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.nAccelerationZ * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )

		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				self:DoLanding()
			end

			self:GetParent():RemoveHorizontalMotionController( self )
			self:GetParent():RemoveVerticalMotionController( self )

			self:SetDuration( 0.15, true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:DoLanding()
	if IsServer() then
		ParticleManager:DestroyParticle( self:GetAbility().nPreviewFX, true )

		local radius = self:GetAbility():GetSpecialValueFor( "radius" )
		local damage = self:GetAbility():GetSpecialValueFor( "damage" )
		local stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun_duration } )

					local DamageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						ability = self,
						damage = damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
					}
					ApplyDamage( DamageInfo )
				end
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/eimermole/eimermole_emerge.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 0.0, 1.0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( radius, 0.0, 1.0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Eimermole.Emerge.Impact", self:GetCaster() )

		GridNav:DestroyTreesAroundPoint( self:GetCaster():GetOrigin(), radius, false )
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_emerge:CheckState()
	local state =
	{
		[ MODIFIER_STATE_STUNNED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
