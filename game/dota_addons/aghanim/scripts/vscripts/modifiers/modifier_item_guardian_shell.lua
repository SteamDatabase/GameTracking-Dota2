modifier_item_guardian_shell = class({})

--------------------------------------------------------------------------------

function modifier_item_guardian_shell:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_guardian_shell:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_guardian_shell:CheckState()
	local state = 
	{
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_item_guardian_shell:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

----------------------------------------

function modifier_item_guardian_shell:OnCreated( kv )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.magic_resistance = self:GetAbility():GetSpecialValueFor( "magic_resistance" )
end


----------------------------------------

function modifier_item_guardian_shell:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

----------------------------------------

function modifier_item_guardian_shell:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end

----------------------------------------

function modifier_item_guardian_shell:GetModifierMagicalResistanceBonus( params )
	return self.magic_resistance
end

