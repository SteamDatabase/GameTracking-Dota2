modifier_blessing_health_boost = class({})

--------------------------------------------------------------------------------

function modifier_blessing_health_boost:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_health_boost:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_health_boost:GetModifierHealthBonus( params )
	return self:GetParent():GetLevel() * self:GetStackCount()
end


--------------------------------------------------------------------------------
function modifier_blessing_health_boost:IsPermanent()
	return true
end