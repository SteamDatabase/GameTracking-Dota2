
if modifier_bucket_soldier_attack_ready == nil then
	modifier_bucket_soldier_attack_ready = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_bucket_soldier_attack_ready:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_ready:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_ready:GetStatusEffectName()
	return "particles/status_fx/status_effect_diretide_hulk.vpcf"
end

-----------------------------------------------------------------------------

function modifier_bucket_soldier_attack_ready:StatusEffectPriority()
	return 140
end

-----------------------------------------------------------------------------
