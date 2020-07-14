require( "modifiers/modifier_blessing_base" )

modifier_blessing_armor = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_armor:OnBlessingCreated( kv )
	self.flArmor = kv.bonus_armor
end

--------------------------------------------------------------------------------

function modifier_blessing_armor:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_armor:GetModifierPhysicalArmorBonus( params )
	return self.flArmor
end
