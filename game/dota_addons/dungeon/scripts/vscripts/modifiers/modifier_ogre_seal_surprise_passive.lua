modifier_ogre_seal_surprise_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_passive:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_ogre_seal_surprise_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_INVISIBLE] = true
	}

	return state
end

