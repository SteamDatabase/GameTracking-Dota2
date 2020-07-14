
modifier_item_bear_cloak = class({})

------------------------------------------------------------------------------

function modifier_item_bear_cloak:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:OnCreated( kv )
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor( "bonus_magic_resist" )
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:GetModifierAura()
	return  "modifier_item_bear_cloak_effect"
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_bear_cloak:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end

--------------------------------------------------------------------------------


