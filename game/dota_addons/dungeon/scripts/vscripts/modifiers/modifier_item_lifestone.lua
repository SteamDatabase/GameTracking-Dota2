
modifier_item_lifestone = class({})

------------------------------------------------------------------------------

function modifier_item_lifestone:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_lifestone:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_lifestone:OnCreated( kv )
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" )
end

--------------------------------------------------------------------------------

function modifier_item_lifestone:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_lifestone:GetModifierConstantHealthRegen( params )
	return self.hp_regen
end

--------------------------------------------------------------------------------

