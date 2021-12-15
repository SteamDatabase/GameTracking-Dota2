modifier_blessing_damage_on_stunned = class({})

--------------------------------------------------------------------------------

function modifier_blessing_damage_on_stunned:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_damage_on_stunned:DeclareFunctions()

	local funcs =
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end
--------------------------------------------------------------------------------
function modifier_blessing_damage_on_stunned:IsPermanent()
	return true
end
---------
--------------------------------------------------------------------------------

function modifier_blessing_damage_on_stunned:GetModifierPreAttack_BonusDamage( params )
	if params.target and params.target:IsStunned() then
		return self:GetStackCount()
	end
	return 0
end
