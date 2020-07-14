require( "modifiers/modifier_blessing_base" )

modifier_blessing_magic_resist = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_magic_resist:OnBlessingCreated( kv )
	self.bonus_magic_resist = kv.bonus_magic_resist
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_resist:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_resist:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end
