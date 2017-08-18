
modifier_item_slippers_of_the_abyss = class({})

------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:OnCreated( kv )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_agility = self:GetAbility():GetSpecialValueFor( "bonus_agility" )
	self.bonus_atk_speed = self:GetAbility():GetSpecialValueFor( "bonus_atk_speed" )
end

--------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:GetModifierMoveSpeedBonus_Special_Boots( params )
	return self.bonus_movement_speed
end

--------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end

--------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end

--------------------------------------------------------------------------------

function modifier_item_slippers_of_the_abyss:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_atk_speed
end

--------------------------------------------------------------------------------

