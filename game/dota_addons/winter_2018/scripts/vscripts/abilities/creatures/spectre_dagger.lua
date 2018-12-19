
spectre_dagger = class({})
LinkLuaModifier( "modifier_spectre_dagger", "modifiers/creatures/modifier_spectre_dagger", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spectre_dagger:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function spectre_dagger:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 100 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function spectre_dagger:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function spectre_dagger:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.forced_attack_duration = self:GetSpecialValueFor( "forced_attack_duration" )

		local vPos = self:GetCursorPosition()
		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local info = {
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

		EmitSoundOn( "SpectralTuskMage.FreezingBlast.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function spectre_dagger:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self,
			}
			ApplyDamage( damage )

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_spectre_dagger", { duration = self.forced_attack_duration } )

			EmitSoundOn( "SpectralTuskMage.FreezingBlast.Impact", self:GetCaster() )
		end

		return true
	end
end

--------------------------------------------------------------------------------

