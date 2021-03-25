
modifier_disable_healing = class({})

--------------------------------------------------------------------------------

function modifier_disable_healing:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_disable_healing:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_disable_healing:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_disable_healing:GetDisableHealing( params )
	return 1
end

--------------------------------------------------------------------------------
