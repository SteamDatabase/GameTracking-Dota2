if modifier_eaten_by_roshan == nil then
    modifier_eaten_by_roshan = class({})
end

----------------------------------------------------------------------------------

function modifier_eaten_by_roshan:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_STUNNED] = true
	}
	return state
end
    
------------------------------------------------------------------------------

function modifier_eaten_by_roshan:IsHidden() 
    return true
end

--------------------------------------------------------------------------------

function modifier_eaten_by_roshan:IsPurgable()
    return false
end