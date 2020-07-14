
modifier_item_spell_amp_potion = class({})

--------------------------------------------------------------------------------

function modifier_item_spell_amp_potion:GetEffectName()
	return "particles/generic_gameplay/spell_amp_potion_owner.vpcf"
end

--------------------------------------------------------------------------------

function modifier_item_spell_amp_potion:GetTexture()
	return "spell_amp_potion"
end

--------------------------------------------------------------------------------

function modifier_item_spell_amp_potion:OnCreated( kv )
	self.spell_amp_bonus_pct = self:GetAbility():GetSpecialValueFor( "spell_amp_bonus_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_spell_amp_potion:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_spell_amp_potion:GetModifierSpellAmplify_PercentageUnique( params )
	if self:GetParent():IsIllusion() then
		return 0
	end

	return self.spell_amp_bonus_pct
end

--------------------------------------------------------------------------------
