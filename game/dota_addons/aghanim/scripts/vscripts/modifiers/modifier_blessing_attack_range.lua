modifier_blessing_attack_range = class({})

--------------------------------------------------------------------------------

function modifier_blessing_attack_range:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_attack_range:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_attack_range:GetModifierAttackRangeBonus( params )
	if self:GetParent():IsRangedAttacker() then
		return self:GetStackCount()
	end

	return 0

end


--------------------------------------------------------------------------------
function modifier_blessing_attack_range:IsPermanent()
	return true
end