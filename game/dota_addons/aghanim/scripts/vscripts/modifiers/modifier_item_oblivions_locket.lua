modifier_item_oblivions_locket = class({})

--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:OnCreated( kv )
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:GetModifierBonusStats_Strength( params )
	return self.bonus_all_stats
end 
--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:GetModifierBonusStats_Agility( params )
	return self.bonus_all_stats
end 
--------------------------------------------------------------------------------

function modifier_item_oblivions_locket:GetModifierBonusStats_Intellect( params )
	return self.bonus_all_stats
end 