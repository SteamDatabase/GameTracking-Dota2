-- Channel Digging Modifier - Forces visibility while channeling

modifier_channel_ability_building = class({})

--------------------------------------------------------------------------------

function modifier_channel_ability_building:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_channel_ability_building:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_channel_ability_building:GetPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_channel_ability_building:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_channel_ability_building:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_channel_ability_building:GetModifierProvidesFOWVision( params )
	return 1
end




