
modifier_not_on_minimap = class({})

--------------------------------------------------------------------------------

function modifier_not_on_minimap:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_not_on_minimap:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_not_on_minimap:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

--------------------------------------------------------------------------------

function modifier_not_on_minimap:CheckState()
	local state = {}
	state[MODIFIER_STATE_INVULNERABLE] = true
	state[MODIFIER_STATE_BLIND] = true
	state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true

	return state
end

