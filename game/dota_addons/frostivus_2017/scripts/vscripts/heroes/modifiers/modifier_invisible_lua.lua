modifier_invisible_lua = class({})

function modifier_invisible_lua:CheckState()
    local state = {
    [MODIFIER_STATE_INVISIBLE] = true,
    }
 
    return state
end