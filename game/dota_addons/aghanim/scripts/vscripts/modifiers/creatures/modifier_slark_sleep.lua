
modifier_slark_sleep = class({})

--------------------------------------------------------------------------------

function modifier_slark_sleep:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_slark_sleep:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_slark_sleep:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_STUNNED] = true
		state[MODIFIER_STATE_SILENCED] = true
	end

	return state
end

-----------------------------------------------------------------------

function modifier_slark_sleep:GetEffectName()
    return "particles/generic_gameplay/generic_sleep.vpcf"
end

--------------------------------------------------------------------------------

function modifier_slark_sleep:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-----------------------------------------------------------------------------