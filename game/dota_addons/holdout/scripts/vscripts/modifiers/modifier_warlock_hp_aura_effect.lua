modifier_warlock_hp_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:OnCreated( kv )
	--self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp_multiplier" )
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:OnRefresh( kv )
	--self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp_multiplier" )
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:GetModifierExtraHealthPercentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return 800 --self.bonus_hp_multiplier
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:GetModifierModelScale( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return 130
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:GetModifierDamageOutgoing_Percentage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	return 100
end

--------------------------------------------------------------------------------
