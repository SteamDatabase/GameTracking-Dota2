modifier_blessing_strength = class({})

--------------------------------------------------------------------------------

function modifier_blessing_strength:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_strength:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs	
end

--------------------------------------------------------------------------------

function modifier_blessing_strength:GetModifierBonusStats_Strength( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_blessing_strength:IsPermanent()
	return true
end