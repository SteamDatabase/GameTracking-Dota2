
modifier_shroomling_weakened = class({})

-----------------------------------------------------------------------------------------

function modifier_shroomling_weakened:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_shroomling_weakened:OnCreated( kv )
	self.enrage_model_scale_bonus = -20
end

--------------------------------------------------------------------------------

function modifier_shroomling_weakened:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_shroomling_weakened:GetModifierModelScale( params )
	return self.enrage_model_scale_bonus
end

-----------------------------------------------------------------------------------------

function modifier_shroomling_weakened:GetModifierExtraHealthPercentage( params )
	if self:GetCaster() == nil or self:GetCaster():PassivesDisabled() then
		return 0
	end

	-- How is this number intended to work? It seems to have regressed.
	return -200 --8.0 --self.bonus_hp_multiplier
end

