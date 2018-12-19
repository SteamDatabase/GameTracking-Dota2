modifier_rubick_boss_linear_fade_bolts_debuff = class({})

function modifier_rubick_boss_linear_fade_bolts_debuff:OnCreated( kv )
	self.slow_pct = self:GetAbility():GetSpecialValueFor( "slow_pct" )
end 

-----------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.slow_pct
end

-----------------------------------------------------------------------

function modifier_rubick_boss_linear_fade_bolts_debuff:GetEffectName()
	return  "particles/units/heroes/hero_rubick/rubick_fade_bolt_debuff.vpcf"
end