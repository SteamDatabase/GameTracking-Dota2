require( "modifiers/modifier_blessing_base" )

modifier_blessing_magic_damage_bonus = class( modifier_blessing_base )

----------------------------------------

function modifier_blessing_magic_damage_bonus:OnBlessingCreated( kv )
	self.bonus_magic_damage = kv.bonus_magic_damage
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_damage_bonus:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_damage_bonus:GetModifierSpellAmplify_Percentage( params )
	return self.bonus_magic_damage
end
