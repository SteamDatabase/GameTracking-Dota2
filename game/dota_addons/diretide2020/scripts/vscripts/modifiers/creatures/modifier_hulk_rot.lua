
modifier_hulk_rot = class({})

--------------------------------------------------------------------------------

function modifier_hulk_rot:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
--[[function modifier_hulk_rot:IsAura()
	return true
end
--------------------------------------------------------------------------------

function modifier_hulk_rot:GetModifierAura()
	return "modifier_hulk_rot_debuff"
end

--------------------------------------------------------------------------------

function modifier_hulk_rot:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_hulk_rot:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_hulk_rot:GetAuraRadius()
	return self.radius
end
--]]
--------------------------------------------------------------------------------

function modifier_hulk_rot:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

		if self:GetParent():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/hulk/hulk_radiant_pudge_black_death_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		else
			self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/hulk/hulk_dire_pudge_black_death_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		end

		--self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		--self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_tassles_of_black_death/pudge_black_death_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		--self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		--ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 1, self.radius ) )

		--EmitSoundOn( "Hero_Viper.Nethertoxin", self:GetCaster() )

		self:StartIntervalThink( 1 )
	end
end

--------------------------------------------------------------------------------

function modifier_hulk_rot:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster() or self:GetCaster():IsAlive() == false then
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

					--EmitSoundOn( "Hero_Viper.NetherToxin.Damage", hEnemy )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_hulk_rot:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		--self:GetParent():StopSound( "Hero_Viper.Nethertoxin" )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

