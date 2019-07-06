
jungle_spirit_range_attack = class({})
--------------------------------------------------------------------------------

function jungle_spirit_range_attack:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/neutral_fx/black_dragon_fireball_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouthbase", self:GetCaster():GetAbsOrigin(), true )

		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )
		EmitSoundOn( "JungleSpirit.Generic.CastPointStart", self:GetCaster() )
		

	end

	return true
end

--------------------------------------------------------------------------------

function jungle_spirit_range_attack:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function jungle_spirit_range_attack:GetPlaybackRateOverride()
	return 3
end

--------------------------------------------------------------------------------

function jungle_spirit_range_attack:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		self.projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.damage_mult_vs_buildings = self:GetSpecialValueFor( "damage_mult_vs_buildings" )
		self.damage = self:GetCaster():GetAttackDamage()


		local vPos = self:GetCursorPosition()
		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()


			local info =
			{
				EffectName = "particles/lycanboss_ruptureball_gale.vpcf",
				Ability = self,
				vSpawnOrigin = self:GetCaster():GetOrigin(), 
				fStartRadius = self.projectile_radius,
				fEndRadius = self.projectile_radius,
				vVelocity = vDirection * self.projectile_speed,
				fDistance = self.projectile_distance,
				Source = self:GetCaster(),
				iUnitTargetTeam = self:GetAbilityTargetTeam(),
				iUnitTargetType = self:GetAbilityTargetType(),
			}

			ProjectileManager:CreateLinearProjectile( info )


		EmitSoundOn( "JungleSpirit.Hex.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function jungle_spirit_range_attack:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
			
			local fDmg = self.damage
			if hTarget:IsBuilding() then
				fDmg = fDmg * self.damage_mult_vs_buildings
			end

			local damage =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = fDmg,
				damage_type = self:GetAbilityDamageType(),
				ability = self,
			}


			ApplyDamage( damage )

		end

		return true
	end
end

--------------------------------------------------------------------------------



function jungle_spirit_range_attack:GetCastAnimation()
	if IsServer() then
		if  self:GetSpecialValueFor( "animation_change_level" ) > 0 and self:GetCaster():GetLevel() >= self:GetSpecialValueFor( "animation_change_level" ) then
			return ACT_DOTA_OVERRIDE_ABILITY_5
		else
			return ACT_DOTA_CAST_ABILITY_5
		end
	end
end