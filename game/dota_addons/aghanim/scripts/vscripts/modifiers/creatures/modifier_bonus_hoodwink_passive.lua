
modifier_bonus_hoodwink_passive = class({})

--------------------------------------------------------------------------------

function modifier_bonus_hoodwink_passive:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ROOTED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_bonus_hoodwink_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------