
modifier_item_double_damage_potion = class({})

--------------------------------------------------------------------------------

function modifier_item_double_damage_potion:GetEffectName()
	return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_double_damage_potion:GetTexture()
	return "rune_doubledamage"
end

--------------------------------------------------------------------------------

function modifier_item_double_damage_potion:OnCreated( kv )
	self.damage_bonus_pct = self:GetAbility():GetSpecialValueFor( "damage_bonus_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_double_damage_potion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_double_damage_potion:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetParent():IsIllusion() then
		return 0
	end

	return self.damage_bonus_pct
end

--------------------------------------------------------------------------------
