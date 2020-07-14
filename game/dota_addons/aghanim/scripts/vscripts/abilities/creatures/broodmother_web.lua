
broodmother_web = class({})
LinkLuaModifier( "modifier_broodmother_web", "modifiers/creatures/modifier_broodmother_web", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function broodmother_web:Precache( context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/rod_of_atos.vpcf", context )

end

--------------------------------------------------------------------------------

function broodmother_web:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function broodmother_web:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 100 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function broodmother_web:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function broodmother_web:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.root_duration = self:GetSpecialValueFor( "root_duration" )

		self.knockback_distance = self:GetSpecialValueFor( "knockback_distance" )
		self.knockback_height = self:GetSpecialValueFor( "knockback_height" )
		self.knockback_duration = self:GetSpecialValueFor( "knockback_duration" )

		local vPos = self:GetCursorPosition()
		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local info = {
			EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
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

		EmitSoundOn( "Spider.PoisonSpit", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function broodmother_web:OnProjectileHit( hTarget, vLocation )
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

			local kv_knockback =
			{
				center_x = vLocation.x,
				center_y = vLocation.y,
				center_z = vLocation.z,
				should_stun = false, 
				duration = self.knockback_duration,
				knockback_duration = self.knockback_duration,
				knockback_distance = self.knockback_distance,
				knockback_height = self.knockback_height,
			}
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_knockback", kv_knockback )

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_broodmother_web", { duration = self.root_duration } )

			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget ) )

			EmitSoundOn( "Spider.PoisonSpit.Impact", self:GetCaster() )
		end

		return true
	end
end

--------------------------------------------------------------------------------

