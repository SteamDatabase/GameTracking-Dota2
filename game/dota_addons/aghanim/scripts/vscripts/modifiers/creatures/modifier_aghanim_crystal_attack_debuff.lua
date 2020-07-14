modifier_aghanim_crystal_attack_debuff = class({})


function modifier_aghanim_crystal_attack_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


---------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:IsPurgable()
	return false
end


---------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"; 
end

---------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_iceblast.vpcf";
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:OnCreated( kv )
	self.heal_suppression_pct = self:GetAbility():GetSpecialValueFor( "heal_suppression_pct" )
	self.nArmorReductionPerStack = math.max( math.floor( self:GetAbility():GetSpecialValueFor( "armor_reduction_pct" ) * self:GetParent():GetPhysicalArmorValue( false ) / 100 ), 1 )
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

	}
	return funcs
end
-----------------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:GetModifierPhysicalArmorBonus()
	if self.nArmorReductionPerStack == nil then
		return 0
	end

	return self.nArmorReductionPerStack * -1
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:GetModifierHealAmplify_PercentageTarget( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:GetModifierHPRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:GetModifierLifestealRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_debuff:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end