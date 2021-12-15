
modifier_ascension_magic_resist = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_magic_resist:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ascension_magic_resist:GetTexture()
	return "events/aghanim/interface/hazard_magicresist"
end

----------------------------------------

function modifier_ascension_magic_resist:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_magic_resist:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor( "bonus_magic_resist" )
end

--------------------------------------------------------------------------------

function modifier_ascension_magic_resist:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_magic_resist:GetModifierMagicalResistanceBonus( params )
	return self.bonus_magic_resist
end
