require( "modifiers/modifier_blessing_base" )

modifier_blessing_mana_boost = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_mana_boost:OnBlessingCreated( kv )
	self.bonus_mana = kv.bonus_mana
end

--------------------------------------------------------------------------------

function modifier_blessing_mana_boost:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_mana_boost:GetModifierExtraManaPercentage( params )
	return self.bonus_mana
end
