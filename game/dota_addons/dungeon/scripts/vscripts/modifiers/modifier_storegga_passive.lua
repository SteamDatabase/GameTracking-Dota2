modifier_storegga_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_storegga_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end