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
	self.flMoveSpeed = self:GetParent():GetIdealSpeedNoSlows()
	self.flAttackSpeed = self:GetParent():GetAttackSpeed()
	self:StartIntervalThink( 0.5 )
end

----------------------------------------

function modifier_item_guardian_shell:OnIntervalThink()
	self.flMoveSpeed = 0
	self.flMoveSpeed = self:GetParent():GetIdealSpeedNoSlows()
end

----------------------------------------

function modifier_item_guardian_shell:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
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

----------------------------------------

function modifier_item_guardian_shell:GetModifierMoveSpeed_AbsoluteMin( params )
	return self.flMoveSpeed
end