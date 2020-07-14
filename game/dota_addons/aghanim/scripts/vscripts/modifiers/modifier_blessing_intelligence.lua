require( "modifiers/modifier_blessing_base" )

modifier_blessing_intelligence = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_intelligence:OnBlessingCreated( kv )
	self.bonus_intelligence = kv.int_bonus
	--print ( "Intelligence Bonus = " .. self.bonus_intelligence )
end

--------------------------------------------------------------------------------

function modifier_blessing_intelligence:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_intelligence:GetModifierBonusStats_Intellect( params )
	return self.bonus_intelligence
end
