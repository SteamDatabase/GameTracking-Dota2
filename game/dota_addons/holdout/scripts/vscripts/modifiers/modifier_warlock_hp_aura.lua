modifier_warlock_hp_aura = class({})

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:GetModifierAura()
	return "modifier_warlock_hp_aura_effect"
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
