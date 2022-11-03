modifier_mount_impairment = class({})

----------------------------------------------------------------------------------

function modifier_mount_impairment:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_mount_impairment:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mount_impairment:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_mount_impairment:GetStatusEffectName()
	return "particles/status_fx/status_effect_brewmaster_drunken_haze.vpcf"
end

--------------------------------------------------------------------------------

function modifier_mount_impairment:StatusEffectPriority()
	return 50
end

--------------------------------------------------------------------------------
