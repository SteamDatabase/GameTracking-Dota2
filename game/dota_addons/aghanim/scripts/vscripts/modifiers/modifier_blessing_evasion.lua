require( "modifiers/modifier_blessing_base" )

modifier_blessing_evasion = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_evasion:OnBlessingCreated( kv )
	self.bonus_evasion = kv.bonus_evasion
end

--------------------------------------------------------------------------------

function modifier_blessing_evasion:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_evasion:GetModifierEvasion_Constant( params )
	return self.bonus_evasion
end
