modifier_sven_gods_strength_child_lua = class({})
--------------------------------------------------------------------------------

function modifier_sven_gods_strength_child_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------


function modifier_sven_gods_strength_child_lua:OnCreated( kv )
	self.gods_strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "gods_strength_damage_scepter" )
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_child_lua:OnRefresh( kv )
	self.gods_strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "gods_strength_damage_scepter" )
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_child_lua:DeclareFunctions()
	local funcs = {
		func1 = MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_child_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.gods_strength_damage_scepter
end

--------------------------------------------------------------------------------
