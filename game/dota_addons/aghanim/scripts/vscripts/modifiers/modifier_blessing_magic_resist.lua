modifier_blessing_magic_resist = class({})

--------------------------------------------------------------------------------

function modifier_blessing_magic_resist:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_resist:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

	}
	return funcs	
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_resist:GetModifierMagicalResistanceBonus( params )
	return self:GetStackCount()
end


--------------------------------------------------------------------------------
function modifier_blessing_magic_resist:IsPermanent()
	return true
end