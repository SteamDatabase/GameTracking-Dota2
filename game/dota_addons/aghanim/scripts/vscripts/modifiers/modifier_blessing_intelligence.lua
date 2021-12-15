modifier_blessing_intelligence = class({})

--------------------------------------------------------------------------------

function modifier_blessing_intelligence:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_intelligence:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_intelligence:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_blessing_intelligence:IsPermanent()
	return true
end