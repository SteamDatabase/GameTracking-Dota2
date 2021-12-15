modifier_mango_orchard_mute = class({})

--------------------------------------------------------------------------------

function modifier_mango_orchard_mute:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_mango_orchard_mute:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mango_orchard_mute:CheckState()
	local state =
	{
		[ MODIFIER_STATE_MUTED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_mango_orchard_mute:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_mango_orchard_mute:GetModifierMoveSpeed_Absolute( params )
	return 350
end