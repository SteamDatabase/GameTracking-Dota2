
LinkLuaModifier( "modifier_ascension_heal_suppression", "modifiers/modifier_ascension_heal_suppression", LUA_MODIFIER_MOTION_NONE )

modifier_ascension_heal_suppression_aura = class({})

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:GetTexture()
	return "events/aghanim/interface/hazard_healsupress"
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:GetEffectName() 
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:GetStatusEffectName() 
	return "particles/status_fx/status_effect_necrolyte_spirit.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.heal_suppression_pct = self:GetAbility():GetSpecialValueFor( "heal_suppression_pct" )
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:OnRefresh( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.heal_suppression_pct = self:GetAbility():GetSpecialValueFor( "heal_suppression_pct" )
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:GetModifierAura()
	return  "modifier_ascension_heal_suppression"
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression_aura:OnTooltip( params )
	return -self.heal_suppression_pct
end

