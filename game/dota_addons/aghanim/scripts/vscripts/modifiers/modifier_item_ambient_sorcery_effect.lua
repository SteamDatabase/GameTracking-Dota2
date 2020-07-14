
modifier_item_ambient_sorcery_effect = class({})

----------------------------------------

function modifier_item_ambient_sorcery_effect:GetTexture()
	return "item_ambient_sorcery"
end

----------------------------------------

function modifier_item_ambient_sorcery_effect:OnCreated( kv )
	self.aura_magic_reduction = self:GetAbility():GetSpecialValueFor( "aura_magic_reduction" )
end

----------------------------------------

function modifier_item_ambient_sorcery_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

----------------------------------------

function modifier_item_ambient_sorcery_effect:GetModifierMagicalResistanceBonus( params )
	return self.aura_magic_reduction
end

----------------------------------------

