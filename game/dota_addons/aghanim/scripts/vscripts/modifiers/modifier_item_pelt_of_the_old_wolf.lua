modifier_item_pelt_of_the_old_wolf = class({})

--------------------------------------------------------------------------------

function modifier_item_pelt_of_the_old_wolf:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_pelt_of_the_old_wolf:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_pelt_of_the_old_wolf:OnCreated( kv )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
end

--------------------------------------------------------------------------------

function modifier_item_pelt_of_the_old_wolf:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_pelt_of_the_old_wolf:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end

--------------------------------------------------------------------------------

function modifier_item_pelt_of_the_old_wolf:GetModifierMoveSpeedBonus_Constant( params )
	return self.bonus_move_speed
end

--------------------------------------------------------------------------------

function modifier_item_pelt_of_the_old_wolf:GetModifierEvasion_Constant( params )
	return self.bonus_evasion
end