
modifier_ascension_heal_suppression = class({})

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:GetTexture()
	return "events/aghanim/interface/hazard_healsupress"
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:OnCreated( kv )
	self.heal_suppression_pct = self:GetAbility():GetSpecialValueFor( "heal_suppression_pct" )
end


--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:OnRefresh( kv )
	self.heal_suppression_pct = self:GetAbility():GetSpecialValueFor( "heal_suppression_pct" )
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:GetModifierHealAmplify_PercentageTarget( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:GetModifierHPRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:GetModifierLifestealRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_ascension_heal_suppression:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end