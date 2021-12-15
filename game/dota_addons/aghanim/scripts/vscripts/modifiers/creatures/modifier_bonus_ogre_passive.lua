
modifier_bonus_ogre_passive = class({})

--------------------------------------------------------------------------------

function modifier_bonus_ogre_passive:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ROOTED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_bonus_ogre_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------