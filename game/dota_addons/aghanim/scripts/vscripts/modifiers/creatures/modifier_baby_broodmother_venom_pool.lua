
modifier_baby_broodmother_venom_pool = class({})

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:GetModifierAura()
	return  "modifier_viper_nethertoxin"
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/baby_brood_venom_pool.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 1, 1 ) )

		EmitSoundOn( "Hero_Viper.Nethertoxin", self:GetCaster() )

		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster() then
			self:Destroy()
			return
		end

		local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #hEnemies > 0 then
			for _, hEnemy in pairs( hEnemies ) do
				if hEnemy and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false then
					local damage = {
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility()
					}

					ApplyDamage( damage )

					EmitSoundOn( "Hero_Viper.NetherToxin.Damage", hEnemy )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_venom_pool:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		self:GetParent():StopSound( "Hero_Viper.Nethertoxin" )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

