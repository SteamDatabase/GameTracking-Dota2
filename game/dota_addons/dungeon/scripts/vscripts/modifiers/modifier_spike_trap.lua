
modifier_spike_trap = class({})

--------------------------------------------------------------------------------

function modifier_spike_trap:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spike_trap:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spike_trap:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------

function modifier_spike_trap:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_spike_trap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_spike_trap:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_spike_trap:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

