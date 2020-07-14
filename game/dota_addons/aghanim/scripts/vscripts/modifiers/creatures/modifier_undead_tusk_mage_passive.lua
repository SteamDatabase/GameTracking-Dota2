modifier_undead_tusk_mage_passive = class({})

---------------------------------------------------------------------------

function modifier_undead_tusk_mage_passive:IsHidden()
	return true
end

---------------------------------------------------------------------------

function modifier_undead_tusk_mage_passive:IsPurgable()
	return false
end

---------------------------------------------------------------------------

function modifier_undead_tusk_mage_passive:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

---------------------------------------------------------------------------

function modifier_undead_tusk_mage_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end

---------------------------------------------------------------------------

function modifier_undead_tusk_mage_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

---------------------------------------------------------------------------

function modifier_undead_tusk_mage_passive:GetAbsoluteNoDamagePhysical( params )
	return 1
end