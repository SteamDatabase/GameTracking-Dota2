
bucket_soldier_attack = class({})

----------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_bucket_soldier_attack", "modifiers/creatures/modifier_bucket_soldier_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bucket_soldier_attack_debuff", "modifiers/creatures/modifier_bucket_soldier_attack_debuff", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function bucket_soldier_attack:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end

----------------------------------------------------------------------------------------

function bucket_soldier_attack:GetIntrinsicModifierName()
	return "modifier_bucket_soldier_attack"
end

----------------------------------------------------------------------------------------
