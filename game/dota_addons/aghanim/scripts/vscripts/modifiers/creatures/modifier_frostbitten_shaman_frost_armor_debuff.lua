
modifier_frostbitten_shaman_frost_armor_debuff = class({})

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor_debuff:IsDebuff()
	return true
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor_debuff:GetEffectName()
	return "particles/units/heroes/hero_lich/lich_slowed_cold.vpcf"
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor_debuff:GetStatusEffectName()  
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor_debuff:OnCreated( kv )
	if self:GetAbility() then
		self.slow_movement_speed = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )
		self.slow_attack_speed = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" )
	else
		self.slow_movement_speed = -20
		self.slow_attack_speed = -30
	end

	if IsServer() then
		EmitSoundOn( "FrostbittenShaman.FrostArmor.Debuff", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.slow_movement_speed
end

-----------------------------------------------------------------------------

function modifier_frostbitten_shaman_frost_armor_debuff:GetModifierAttackSpeedBonus_Constant( params )
	return self.slow_attack_speed
end

-----------------------------------------------------------------------------

