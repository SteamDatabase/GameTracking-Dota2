modifier_item_creed_of_omniscience = class({})

--------------------------------------------------------------------------------

function modifier_item_creed_of_omniscience:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_creed_of_omniscience:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_creed_of_omniscience:OnCreated( kv )
	self.bonus_xp = self:GetAbility():GetSpecialValueFor( "bonus_xp" )
end

--------------------------------------------------------------------------------

function modifier_item_creed_of_omniscience:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_creed_of_omniscience:GetModifierPercentageExpRateBoost( params )
	return self.bonus_xp
end 