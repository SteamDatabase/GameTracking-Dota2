modifier_frozen_giant_dance_smash = class({})

--------------------------------------------------------------------------------

function modifier_frozen_giant_dance_smash:OnCreated( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
end

-----------------------------------------------------------------------------------------

function modifier_frozen_giant_dance_smash:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function modifier_frozen_giant_dance_smash:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

--------------------------------------------------------------------------------

function modifier_frozen_giant_dance_smash:GetModifierPhysicalArmorBonus( params )
	return -self.armor_reduction
end
