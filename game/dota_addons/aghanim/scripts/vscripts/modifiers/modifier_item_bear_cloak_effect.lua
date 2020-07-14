
modifier_item_bear_cloak_effect = class({})

------------------------------------------------------------------------------

function modifier_item_bear_cloak_effect:GetTexture()
	return "item_bear_cloak"
end

------------------------------------------------------------------------------

function modifier_item_bear_cloak_effect:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_item_bear_cloak_effect:OnCreated( kv )
	self.aura_bonus_magic_resist = self:GetAbility():GetSpecialValueFor( "aura_bonus_magic_resist" )
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak_effect:GetModifierMagicalResistanceBonus( params )
	return self.aura_bonus_magic_resist
end

--------------------------------------------------------------------------------


