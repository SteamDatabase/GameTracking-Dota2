modifier_command_restricted = class({})

--------------------------------------------------------------------------------

function modifier_command_restricted:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_command_restricted:CheckState()
	local state = 
	{
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	
	return state
end


