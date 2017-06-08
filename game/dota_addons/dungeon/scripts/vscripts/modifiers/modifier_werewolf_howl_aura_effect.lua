modifier_werewolf_howl_aura_effect = class({})


----------------------------------------

function modifier_werewolf_howl_aura_effect:OnCreated( kv )
	if self:GetAbility() then
		self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
		self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	end
end

----------------------------------------

function modifier_werewolf_howl_aura_effect:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

----------------------------------------

function modifier_werewolf_howl_aura_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

----------------------------------------

function modifier_werewolf_howl_aura_effect:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_move_speed
end

----------------------------------------

function modifier_werewolf_howl_aura_effect:GetModifierPreAttack_BonusDamage( params )
	return self.bonus_damage
end