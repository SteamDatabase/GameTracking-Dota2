modifier_primal_beast_outro_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura_effect:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_primal_beast_outro_aura_effect:CheckState()
	local state =
	{

		[MODIFIER_STATE_INVULNERABLE] = IsServer(),
		[MODIFIER_STATE_STUNNED] = IsServer(),
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state 
end
