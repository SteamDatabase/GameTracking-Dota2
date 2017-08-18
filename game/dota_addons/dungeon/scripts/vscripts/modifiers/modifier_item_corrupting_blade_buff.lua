
modifier_item_corrupting_blade_buff = class({})

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade_buff:GetTexture()
	return "item_corrupting_blade"
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade_buff:OnCreated( kv )
	self.corruption_armor = self:GetAbility():GetSpecialValueFor( "corruption_armor" )
end

--------------------------------------------------------------------------------

function modifier_item_corrupting_blade_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------


function modifier_item_corrupting_blade_buff:GetModifierPhysicalArmorBonus( params )
	return self.corruption_armor
end 

--------------------------------------------------------------------------------

