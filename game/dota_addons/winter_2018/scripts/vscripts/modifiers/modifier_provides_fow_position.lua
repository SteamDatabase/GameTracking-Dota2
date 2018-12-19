
modifier_provides_fow_position = class({})

--------------------------------------------------------------------------------

function modifier_provides_fow_position:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_provides_fow_position:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_provides_fow_position:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_provides_fow_position:GetModifierProvidesFOWVision( params )
	return 1
end

--------------------------------------------------------------------------------
