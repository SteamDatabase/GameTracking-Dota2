
if modifier_hero_buy_phase == nil then
	modifier_hero_buy_phase = class( {} )
end

--------------------------------------------------------------------------------

function modifier_hero_buy_phase:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_hero_buy_phase:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_buy_phase:CheckState()
	local state =
	{
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_MUTED ] = true,
		[ MODIFIER_STATE_COMMAND_RESTRICTED  ] = true,
	}

	return state
end

-----------------------------------------------------------------------------
