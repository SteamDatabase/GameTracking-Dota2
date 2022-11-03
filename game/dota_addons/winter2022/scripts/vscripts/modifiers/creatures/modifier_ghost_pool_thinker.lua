
modifier_ghost_pool_thinker = class({})

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:GetModifierAura()
	return "modifier_ghost_pool_debuff"
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		self.pool_interval = self:GetAbility():GetSpecialValueFor( "pool_interval" )
		self.pool_dps = self:GetAbility():GetSpecialValueFor( "pool_dps" )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ghost/ghost_puddle.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 1, 1 ) );
		ParticleManager:SetParticleFoWProperties( self.nFXIndex, 0, -1, self.radius );

		--EmitSoundOn( "Hero_Viper.Nethertoxin", self:GetCaster() )

		self:StartIntervalThink( self.pool_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster() then
			self:Destroy()
			return
		end

		local fDamagePerInterval = self.pool_dps / ( 1.0 / self.pool_interval )

		local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		if #hEnemies > 0 then
			for _, hEnemy in pairs( hEnemies ) do
				if hEnemy and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false then
					local damage = {
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = fDamagePerInterval,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility()
					}

					ApplyDamage( damage )

					--EmitSoundOn( "Hero_Viper.NetherToxin.Damage", hEnemy )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_ghost_pool_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		--self:GetParent():StopSound( "Hero_Viper.Nethertoxin" )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
