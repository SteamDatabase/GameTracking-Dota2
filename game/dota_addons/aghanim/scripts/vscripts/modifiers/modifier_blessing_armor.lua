modifier_blessing_armor = class({})

--------------------------------------------------------------------------------

function modifier_blessing_armor:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_armor:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_armor:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_blessing_armor:IsPermanent()
	return true
end