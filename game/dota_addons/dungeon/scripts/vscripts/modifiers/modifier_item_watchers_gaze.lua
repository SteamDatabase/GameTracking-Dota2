modifier_item_watchers_gaze = class({})

------------------------------------------------------------------------------

function modifier_item_watchers_gaze:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_watchers_gaze:IsPurgable()
	return false
end
----------------------------------------

function modifier_item_watchers_gaze:OnCreated( kv )
	self.bonus_stats = self:GetAbility():GetSpecialValueFor( "bonus_stats" )
end

----------------------------------------

function modifier_item_watchers_gaze:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

----------------------------------------

function modifier_item_watchers_gaze:GetModifierBonusStats_Strength( params )
	return self.bonus_stats
end

----------------------------------------

function modifier_item_watchers_gaze:GetModifierBonusStats_Agility( params )
	return self.bonus_stats
end

----------------------------------------

function modifier_item_watchers_gaze:GetModifierBonusStats_Intellect( params )
	return self.bonus_stats
end

