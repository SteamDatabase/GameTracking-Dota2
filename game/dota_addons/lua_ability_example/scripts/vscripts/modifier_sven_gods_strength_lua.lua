modifier_sven_gods_strength_lua = class({})
--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:HeroEffectPriority()
	return 100
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:IsAura()
	if IsServer() then
		return self:GetCaster():HasScepter()
	end
	
	return false
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetModifierAura()
	return "modifier_sven_gods_strength_child_lua"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraRadius()
	return self.scepter_aoe
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if self:GetParent() == hEntity then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:OnCreated( kv )
	self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "gods_strength_damage" )
	self.scepter_aoe = self:GetAbility():GetSpecialValueFor( "scepter_aoe" )

	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:OnRefresh( kv )
	self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "gods_strength_damage" )
	self.gods_strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "gods_strength_damage_scepter" )
	self.scepter_aoe = self:GetAbility():GetSpecialValueFor( "scepter_aoe" )
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.gods_strength_damage
end

--------------------------------------------------------------------------------
