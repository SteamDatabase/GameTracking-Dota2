modifier_blessing_damage_bonus = class({})

--------------------------------------------------------------------------------

function modifier_blessing_damage_bonus:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_damage_bonus:DeclareFunctions()

	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end
--------------------------------------------------------------------------------
function modifier_blessing_damage_bonus:IsPermanent()
	return true
end
---------
--------------------------------------------------------------------------------

function modifier_blessing_damage_bonus:GetModifierPreAttack_BonusDamage( params )
	return self:GetStackCount()
end
