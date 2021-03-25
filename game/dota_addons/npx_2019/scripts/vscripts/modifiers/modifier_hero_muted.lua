
if modifier_hero_muted == nil then
	modifier_hero_muted = class( {} )
end

-----------------------------------------------------------------------------

function modifier_hero_muted:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_muted:CheckState()
	local state =
	{
		[ MODIFIER_STATE_MUTED ] = true,
	}

	return state
end

-----------------------------------------------------------------------------
