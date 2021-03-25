
if modifier_command_restricted == nil then
	modifier_command_restricted = class( {} )
end

-----------------------------------------------------------------------------

function modifier_command_restricted:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_command_restricted:CheckState()
	local state =
	{
		[ MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
	}

	return state
end

-----------------------------------------------------------------------------
