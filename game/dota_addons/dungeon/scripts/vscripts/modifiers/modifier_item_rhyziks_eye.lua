modifier_item_rhyziks_eye = class({})

--------------------------------------------------------------------------------

function modifier_item_rhyziks_eye:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_rhyziks_eye:IsPurgable()
	return false
end

----------------------------------------

function modifier_item_rhyziks_eye:OnCreated( kv )
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor( "bonus_damage_pct" )
	self.damage_reduction = self:GetAbility():GetSpecialValueFor( "damage_reduction" )
	self.mana_regen_sec = self:GetAbility():GetSpecialValueFor( "mana_regen_sec" )
	self.hp_regen_sec = self:GetAbility():GetSpecialValueFor( "hp_regen_sec" )
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor( "bonus_all_stats" )
end

----------------------------------------

function modifier_item_rhyziks_eye:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

	}
	return funcs
end

----------------------------------------

function modifier_item_rhyziks_eye:GetModifierDamageOutgoing_Percentage( params )
	return self.bonus_damage_pct
end

----------------------------------------

function modifier_item_rhyziks_eye:GetModifierIncomingDamage_Percentage( params )
	return -self.damage_reduction
end

----------------------------------------

function modifier_item_rhyziks_eye:GetModifierBonusStats_Strength( params )
	return self.bonus_all_stats
end

----------------------------------------

function modifier_item_rhyziks_eye:GetModifierBonusStats_Agility( params )
	return self.bonus_all_stats
end

----------------------------------------

function modifier_item_rhyziks_eye:GetModifierBonusStats_Intellect( params )
	return self.bonus_all_stats
end

----------------------------------------

function modifier_item_rhyziks_eye:GetModifierConstantHealthRegen( params )
	return self.hp_regen_sec
end

----------------------------------------

function modifier_item_rhyziks_eye:GetModifierConstantManaRegen( params )
	return self.mana_regen_sec
end
