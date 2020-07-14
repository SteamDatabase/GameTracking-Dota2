
tidehunter_passive = class({})
LinkLuaModifier( "modifier_tidehunter_passive", "modifiers/creatures/modifier_tidehunter_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tidehunter_damage_counter", "modifiers/creatures/modifier_tidehunter_damage_counter", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function tidehunter_passive:Precache( context )
	PrecacheResource( "particle", "particles/creatures/lifestealer/lifestealer_damage_counter_overhead.vpcf", context )
end

-----------------------------------------------------------------------------------------

function tidehunter_passive:GetIntrinsicModifierName()
	return "modifier_tidehunter_passive"
end

-----------------------------------------------------------------------------------------

