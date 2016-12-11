modifier_lina_light_strike_array_lua = class({})

--------------------------------------------------------------------------------

function modifier_lina_light_strike_array_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_lina_light_strike_array_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_lina_light_strike_array_lua:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_lina_light_strike_array_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_lina_light_strike_array_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_lina_light_strike_array_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_lina_light_strike_array_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
