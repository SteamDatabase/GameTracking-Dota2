require( "modifiers/modifier_blessing_base" )

modifier_blessing_agility = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_agility:OnBlessingCreated( kv )
	self.bonus_agility = kv.agi_bonus
	--print ( "Agility Bonus = " .. self.bonus_agility )
end

--------------------------------------------------------------------------------

function modifier_blessing_agility:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_agility:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end
