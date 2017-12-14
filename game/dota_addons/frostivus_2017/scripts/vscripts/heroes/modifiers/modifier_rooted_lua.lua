modifier_rooted_lua = class({})

function modifier_rooted_lua:CheckState()
    local state = {
    [MODIFIER_STATE_ROOTED] = true,
    }
 
    return state
end

function modifier_rooted_lua:IsHidden()
	return true
end