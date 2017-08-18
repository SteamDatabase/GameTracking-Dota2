
modifier_item_wand_of_the_brine = class({})

--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:OnCreated( kv )
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
	self.bonus_mana_regen_pct = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:GetModifierBonusStats_Intellect( params )
	return self.bonus_intelligence
end 

--------------------------------------------------------------------------------

function modifier_item_wand_of_the_brine:GetModifierPercentageManaRegen( params )
	return self.bonus_mana_regen_pct
end 

--------------------------------------------------------------------------------

