
jungle_spirit_greater_hex = class({})
LinkLuaModifier( "modifier_jungle_spirit_greater_hex", "modifiers/creatures/modifier_jungle_spirit_greater_hex", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_greater_hex:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 100 ) )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStart", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function jungle_spirit_greater_hex:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function jungle_spirit_greater_hex:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function jungle_spirit_greater_hex:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		self.projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.projectile_count = self:GetSpecialValueFor( "projectile_count" )
		self.angle_per_projectile = self:GetSpecialValueFor( "angle_per_projectile" )
		self.debuff_duration = self:GetSpecialValueFor( "debuff_duration" )

		local vPos = self:GetCursorPosition()
		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local angle = self:GetCaster():GetAngles()
		angle.y = angle.y - self.angle_per_projectile

		for i = 1, self.projectile_count do 
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

			info.vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) ) * self.projectile_speed

			ProjectileManager:CreateLinearProjectile( info )

			self.last_y = angle.y
			angle.y = self.last_y + self.angle_per_projectile
		end

		EmitSoundOn( "JungleSpirit.Hex.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function jungle_spirit_greater_hex:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self:GetAbilityDamage(),
				damage_type = self:GetAbilityDamageType(),
				ability = self,
			}
			ApplyDamage( damage )

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_jungle_spirit_greater_hex", { duration = self.debuff_duration } )

			--ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget ) )

			--EmitSoundOn( "Spider.PoisonSpit.Impact", self:GetCaster() )
		end

		return true
	end
end

--------------------------------------------------------------------------------
