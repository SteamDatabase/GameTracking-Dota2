
creature_bonus_pig = class({})
LinkLuaModifier( "modifier_creature_bonus_pig", "modifiers/creatures/modifier_creature_bonus_pig", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_pig_damage_counter", "modifiers/creatures/modifier_bonus_pig_damage_counter", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function creature_bonus_pig:Precache( context )
	PrecacheResource( "particle", "particles/creatures/lifestealer/lifestealer_damage_counter_overhead.vpcf", context )
end

-----------------------------------------------------------------------------------------

function creature_bonus_pig:GetIntrinsicModifierName()
	return "modifier_creature_bonus_pig"
end

-----------------------------------------------------------------------------------------
