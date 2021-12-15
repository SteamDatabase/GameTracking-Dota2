modifier_blessing_evasion = class({})

--------------------------------------------------------------------------------

function modifier_blessing_evasion:IsHidden()
	return true
end
-----------------------------------------------------------------------------------------

function modifier_blessing_evasion:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_evasion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_evasion:GetModifierEvasion_Constant()
	return self:GetStackCount()
end
