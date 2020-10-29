
ghost_pool = class ({})
LinkLuaModifier( "modifier_ghost_pool_thinker", "modifiers/creatures/modifier_ghost_pool_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ghost_pool_debuff", "modifiers/creatures/modifier_ghost_pool_debuff", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function ghost_pool:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_flamebreak_dummy.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/ghost/ghost_visual_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/ghost/ghost_puddle.vpcf", context )
end

----------------------------------------------------------------------------------------

function ghost_pool:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 75, 75, 75 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 230, 100, 223 ) )

		EmitSoundOn( "Creature.StartCast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function ghost_pool:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		StopSoundOn( "Creature.StartCast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function ghost_pool:OnSpellStart()
	if IsServer() then
		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )

			StopSoundOn( "Creature.StartCast", self:GetCaster() )
		end

		self.radius = self:GetSpecialValueFor( "radius" )
		self.pool_duration = self:GetSpecialValueFor( "pool_duration" )
		self.impact_damage = self:GetSpecialValueFor( "impact_damage" )
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

		local vStartPos = self:GetCaster():GetOrigin()
		local vEndPos = self:GetCursorPosition()
		local vToEnd = vEndPos - vStartPos
		vToEnd.z = 0.0
		local fProjectileDistance = vToEnd:Length2D()
		local vDirection = vToEnd:Normalized()

		local projectile =
		{
			EffectName = "particles/units/heroes/hero_batrider/batrider_flamebreak_dummy.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			vVelocity = vDirection * self.projectile_speed,
			fDistance = fProjectileDistance,
			Source = self:GetCaster(),
			iUnitTargetTeam = self:GetAbilityTargetTeam(),
			iUnitTargetType = self:GetAbilityTargetType(),
		}

		ProjectileManager:CreateLinearProjectile( projectile )

		self.nProjectileFX = ParticleManager:CreateParticle( "particles/creatures/ghost/ghost_visual_projectile.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nProjectileFX, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nProjectileFX, 1, vDirection * self.projectile_speed )
		local nFinalWidth = 200
		ParticleManager:SetParticleControl( self.nProjectileFX, 5, Vector( ( fProjectileDistance / self.projectile_speed ), nFinalWidth, 0 ) )
		ParticleManager:ReleaseParticleIndex( self.nProjectileFX );

		--EmitSoundOn( "OgreMagi.Ignite.Cast", self:GetCaster() )
	end
end

----------------------------------------------------------------------------------------

function ghost_pool:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if not hTarget then
			CreateModifierThinker( self:GetCaster(), self, "modifier_ghost_pool_thinker",
					{ duration = self.pool_duration }, vLocation, self:GetCaster():GetTeamNumber(), false
			)

			-- Impact Damage
			local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
			if #hEnemies > 0 then
				for _, hEnemy in pairs( hEnemies ) do
					if hEnemy and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false then
						local damage = {
							victim = hEnemy,
							attacker = self:GetCaster(),
							damage = self.impact_damage,
							damage_type = self:GetAbilityDamageType(),
							ability = self
						}

						ApplyDamage( damage )

						--EmitSoundOn( "Hero_Viper.NetherToxin.Damage", hEnemy )
					end
				end
			end

			--[[
			if self.nProjectileFX ~= nil then
				ParticleManager:DestroyParticle( self.nProjectileFX, false )
			end
			]]

			EmitSoundOn( "Ghost.Pool.Impact", self:GetCaster() )
		end
	end

	return true
end

----------------------------------------------------------------------------------------