
lifestealer_passive = class({})
LinkLuaModifier( "modifier_lifestealer_passive", "modifiers/creatures/modifier_lifestealer_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lifestealer_damage_counter", "modifiers/creatures/modifier_lifestealer_damage_counter", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lifestealer_enraged", "modifiers/creatures/modifier_lifestealer_enraged", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function lifestealer_passive:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_life_stealer_rage.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/lifestealer/lifestealer_damage_counter_overhead.vpcf", context )
end

-----------------------------------------------------------------------------------------

function lifestealer_passive:GetIntrinsicModifierName()
	return "modifier_lifestealer_passive"
end

-----------------------------------------------------------------------------------------
