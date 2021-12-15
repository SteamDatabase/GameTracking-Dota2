modifier_blessing_agility = class({})

--------------------------------------------------------------------------------

function modifier_blessing_agility:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_agility:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_agility:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end
--------------------------------------------------------------------------------
function modifier_blessing_agility:IsPermanent()
	return true
end