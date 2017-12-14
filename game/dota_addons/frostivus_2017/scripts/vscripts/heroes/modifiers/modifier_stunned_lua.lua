modifier_stunned_lua = class({})

function modifier_stunned_lua:IsHidden()
    return true
end

function modifier_stunned_lua:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    }
 
    return state
end