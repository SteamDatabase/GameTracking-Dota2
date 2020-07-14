require( "modifiers/modifier_blessing_base" )

modifier_blessing_strength = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_strength:OnBlessingCreated( kv )
	self.bonus_strength = kv.str_bonus
	--print ( "Strength Bonus = " .. self.bonus_strength )
end

--------------------------------------------------------------------------------

function modifier_blessing_strength:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_strength:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end
