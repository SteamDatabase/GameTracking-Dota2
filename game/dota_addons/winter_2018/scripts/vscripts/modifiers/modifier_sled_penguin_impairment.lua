
modifier_sled_penguin_impairment = class({})

----------------------------------------------------------------------------------

function modifier_sled_penguin_impairment:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_impairment:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_impairment:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_impairment:GetStatusEffectName()
	return "particles/status_fx/status_effect_brewmaster_drunken_haze.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_impairment:StatusEffectPriority()
	return 50
end

--------------------------------------------------------------------------------
