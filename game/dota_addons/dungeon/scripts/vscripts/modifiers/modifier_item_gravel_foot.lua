modifier_item_gravel_foot = class({})

------------------------------------------------------------------------------

function modifier_item_gravel_foot:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_gravel_foot:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_gravel_foot:OnCreated( kv )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.damage_block = self:GetAbility():GetSpecialValueFor( "damage_block" )
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
	self.bonus_hp_regen = self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )
end

--------------------------------------------------------------------------------

function modifier_item_gravel_foot:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
	return funcs
end

----------------------------------------

function modifier_item_gravel_foot:GetModifierMoveSpeedBonus_Special_Boots( params )
	return self.bonus_movement_speed
end

----------------------------------------

function modifier_item_gravel_foot:GetModifierBonusStats_Strength( params )
	return self.bonus_all_stats
end

----------------------------------------

function modifier_item_gravel_foot:GetModifierBonusStats_Agility( params )
	return self.bonus_all_stats
end

----------------------------------------

function modifier_item_gravel_foot:GetModifierBonusStats_Intellect( params )
	return self.bonus_all_stats
end

--------------------------------------------------------------------------------

function modifier_item_gravel_foot:GetModifierConstantHealthRegen( params )
	return self.bonus_hp_regen
end

--------------------------------------------------------------------------------

function modifier_item_gravel_foot:GetModifierTotal_ConstantBlock( params )
	return self.damage_block
end


