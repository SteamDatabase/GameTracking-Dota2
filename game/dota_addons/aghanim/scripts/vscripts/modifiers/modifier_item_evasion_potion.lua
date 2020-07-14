
modifier_item_evasion_potion = class({})

--------------------------------------------------------------------------------

function modifier_item_evasion_potion:GetEffectName()
	return "particles/generic_gameplay/evasion_potion_owner.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_evasion_potion:GetTexture()
	return "evasion_potion"
end

--------------------------------------------------------------------------------

function modifier_item_evasion_potion:OnCreated( kv )
	self.evasion_bonus_pct = self:GetAbility():GetSpecialValueFor( "evasion_bonus_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_evasion_potion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_evasion_potion:GetModifierEvasion_Constant( params )
	if self:GetParent():IsIllusion() then
		return 0
	end

	return self.evasion_bonus_pct
end

--------------------------------------------------------------------------------
