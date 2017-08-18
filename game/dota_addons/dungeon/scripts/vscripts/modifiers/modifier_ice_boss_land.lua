modifier_ice_boss_land = class({})

--------------------------------------------------------------------------------

function modifier_ice_boss_land:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ice_boss_land:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_boss_land:CheckState()
	local state = 
	{
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end
