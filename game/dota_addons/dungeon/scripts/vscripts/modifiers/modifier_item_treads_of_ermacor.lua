modifier_item_treads_of_ermacor = class({})

------------------------------------------------------------------------------

function modifier_item_treads_of_ermacor:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_treads_of_ermacor:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_treads_of_ermacor:OnCreated( kv )
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed" )
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

----------------------------------------

function modifier_item_treads_of_ermacor:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

----------------------------------------

function modifier_item_treads_of_ermacor:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end

----------------------------------------

function modifier_item_treads_of_ermacor:GetModifierMoveSpeedBonus_Special_Boots( params )
	return self.bonus_movement_speed
end

----------------------------------------

function modifier_item_treads_of_ermacor:GetModifierBonusStats_Strength( params )
	return self.bonus_all_stats
end

----------------------------------------

function modifier_item_treads_of_ermacor:GetModifierBonusStats_Agility( params )
	return self.bonus_all_stats
end

----------------------------------------

function modifier_item_treads_of_ermacor:GetModifierBonusStats_Intellect( params )
	return self.bonus_all_stats
end




