
modifier_absolute_no_healing = class({})

--------------------------------------------------------------------------------

function modifier_absolute_no_healing:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_absolute_no_healing:IsHidden()
	return false
end
--------------------------------------------------------------------------------

function modifier_absolute_no_healing:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_absolute_no_healing:GetDisableHealing( params )
	return 1
end
