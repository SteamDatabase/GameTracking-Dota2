
modifier_item_slippers_of_the_abyss_sprint = class({})

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:GetTexture()
	return "item_slippers_of_the_abyss"
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:GetEffectName()
	return "particles/units/heroes/hero_slardar/slardar_sprint.vpcf"
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:OnCreated( kv )
	self.sprint_bonus_ms = self:GetAbility():GetSpecialValueFor( "sprint_bonus_ms" )
	self.sprint_bonus_dmg = self:GetAbility():GetSpecialValueFor( "sprint_bonus_dmg" )
	self.sprint_bonus_atk_speed = self:GetAbility():GetSpecialValueFor( "sprint_bonus_atk_speed" )
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:GetModifierMoveSpeedBonus_Constant( params )
	return self.sprint_bonus_ms
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:GetModifierMoveSpeed_Max( params )
	if IsServer() then
		return 750
	end

	return 750
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:GetModifierPreAttack_BonusDamage( params )
	return self.sprint_bonus_dmg
end

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss_sprint:GetModifierAttackSpeedBonus_Constant( params )
	return self.sprint_bonus_atk_speed
end

------------------------------------------------------------------------------

