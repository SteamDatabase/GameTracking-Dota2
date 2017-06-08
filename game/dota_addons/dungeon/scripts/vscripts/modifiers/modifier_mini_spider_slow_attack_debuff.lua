modifier_mini_spider_slow_attack_debuff = class({})

------------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack_debuff:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

------------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack_debuff:OnCreated( kv )
	self.movement_speed_slow = self:GetAbility():GetSpecialValueFor( "movement_speed_slow" )
end

------------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

------------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movement_speed_slow * self:GetStackCount()
end