modifier_blessing_cast_range = class({})

--------------------------------------------------------------------------------

function modifier_blessing_cast_range:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_cast_range:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_cast_range:GetModifierCastRangeBonusStacking( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_blessing_cast_range:IsPermanent()
	return true
end