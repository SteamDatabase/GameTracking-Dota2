
modifier_item_glimmerdark_shield = class({})

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:OnCreated( kv )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_agility = self:GetAbility():GetSpecialValueFor( "bonus_agility" )
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------


function modifier_item_glimmerdark_shield:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierBonusStats_Intellect( params )
	return self.bonus_intellect
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierConstantHealthRegen( params )
	return self.bonus_health_regen
end 

--------------------------------------------------------------------------------

function modifier_item_glimmerdark_shield:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end

--------------------------------------------------------------------------------

