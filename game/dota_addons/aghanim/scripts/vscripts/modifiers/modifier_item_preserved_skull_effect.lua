modifier_item_preserved_skull_effect = class({})

----------------------------------------

function modifier_item_preserved_skull_effect:GetTexture()
	return "item_preserved_skull"
end

----------------------------------------

function modifier_item_preserved_skull_effect:OnCreated( kv )
	self.cooldown_reduction_pct = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_pct" )
	self.aura_mana_regen = self:GetAbility():GetSpecialValueFor( "aura_mana_regen" )
end

----------------------------------------

function modifier_item_preserved_skull_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

----------------------------------------

function modifier_item_preserved_skull_effect:GetModifierConstantManaRegen( params )
	return self.aura_mana_regen
end

----------------------------------------

function modifier_item_preserved_skull_effect:GetModifierPercentageCooldown( params )
	return self.cooldown_reduction_pct
end



