modifier_hidden_lua = class({})

function modifier_hidden_lua:IsHidden()
    return true
end

function modifier_hidden_lua:CheckState()
    local state = {
    [MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    }
 
    return state
end