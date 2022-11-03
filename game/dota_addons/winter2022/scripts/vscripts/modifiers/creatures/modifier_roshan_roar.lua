if modifier_roshan_roar == nil then
	modifier_roshan_roar = class( {} ) 
end

----------------------------------------------------------------------------------------
function modifier_roshan_roar:IsDebuff()
	return true
end

-----------------------------------------------------------------------------
function modifier_roshan_roar:StatusEffectPriority()
	return 35
end

--------------------------------------------------------------------------------
function modifier_roshan_roar:OnCreated( kv )
    local hAbility = self:GetAbility()
	self.move_speed_slow_pct = hAbility:GetSpecialValueFor("move_speed_slow_pct")
	self.attack_speed_slow = hAbility:GetSpecialValueFor("attack_speed_slow")
end

--------------------------------------------------------------------------------
function modifier_roshan_roar:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------
function modifier_roshan_roar:GetModifierMoveSpeedBonus_Percentage()
    return -self.move_speed_slow_pct
end

--------------------------------------------------------------------------------
function modifier_roshan_roar:GetModifierAttackSpeedBonus_Constant()
    return -self.attack_speed_slow
end