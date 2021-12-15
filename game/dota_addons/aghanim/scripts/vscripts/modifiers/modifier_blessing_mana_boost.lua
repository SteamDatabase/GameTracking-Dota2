modifier_blessing_mana_boost = class({})

--------------------------------------------------------------------------------

function modifier_blessing_mana_boost:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_mana_boost:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_MANA_BONUS,

	}
	return funcs	
end

--------------------------------------------------------------------------------

function modifier_blessing_mana_boost:GetModifierExtraManaBonus( params )
	return self:GetParent():GetLevel() * self:GetStackCount()
end


--------------------------------------------------------------------------------
function modifier_blessing_mana_boost:IsPermanent()
	return true
end