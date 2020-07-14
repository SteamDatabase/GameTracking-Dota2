
modifier_warlock_hp_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:OnCreated( kv )
	if IsServer() then
		--print( "test" )
	end
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
	if self:GetCaster() == nil or self:GetCaster():PassivesDisabled() then
		return 0
	end

	-- How is this number intended to work? It seems to have regressed.
	return 600 --8.0 --self.bonus_hp_multiplier
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:GetModifierModelScale( params )
	if self:GetCaster() == nil or self:GetCaster():PassivesDisabled() then
		return 0
	end

	return 130
end

--------------------------------------------------------------------------------

function modifier_warlock_hp_aura_effect:GetModifierDamageOutgoing_Percentage( params )
	if self:GetCaster() == nil or self:GetCaster():PassivesDisabled() then
		return 0
	end

	return 100
end

--------------------------------------------------------------------------------
