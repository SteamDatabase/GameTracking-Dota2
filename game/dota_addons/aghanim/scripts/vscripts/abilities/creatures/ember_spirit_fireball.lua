
ember_spirit_fireball = class({})

--------------------------------------------------------------------------------

function ember_spirit_fireball:Precache( context )
	PrecacheResource( "particle", "particles/lycanboss_ruptureball_gale.vpcf", context )
end

--------------------------------------------------------------------------------

function  ember_spirit_fireball:GetPlaybackRateOverride()
	return 0.3333
end

--------------------------------------------------------------------------------

function ember_spirit_fireball:OnAbilityPhaseStart()
	if IsServer() then
		--EmitSoundOn( "lycan_lycan_attack_09", self:GetCaster() )

		self.preview_fx_radius = self:GetSpecialValueFor( "preview_fx_radius" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.preview_fx_radius, self.preview_fx_radius, self.preview_fx_radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 247, 86, 9 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function ember_spirit_fireball:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function ember_spirit_fireball:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.projectile_width_initial = self:GetSpecialValueFor( "projectile_width_initial" )
		self.projectile_width_end = self:GetSpecialValueFor( "projectile_width_end" )
		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		self.impact_damage = self:GetSpecialValueFor( "impact_damage" )
		
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.projectile_speed = self.projectile_speed * ( self.projectile_distance / ( self.projectile_distance - self.projectile_width_initial ) )

		local info = {
			EffectName = "particles/lycanboss_ruptureball_gale.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.projectile_width_initial,
			fEndRadius = self.projectile_width_end,
			vVelocity = vDirection * self.projectile_speed,
			fDistance = self.projectile_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		ProjectileManager:CreateLinearProjectile( info )
		--EmitSoundOn( "Lycan.RuptureBall", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function ember_spirit_fireball:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			--EmitSoundOn( "Lycan.RuptureBall.Impact", hTarget );

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_disarmed", { duration = self:GetSpecialValueFor( "disarm_duration" ) } )

			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.impact_damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self
			}
			ApplyDamage( damage )
		end

		return true
	end
end

--------------------------------------------------------------------------------
