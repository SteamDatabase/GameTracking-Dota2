
bomber_death_explosion = class({})
LinkLuaModifier( "modifier_bomber_death_explosion_trigger", "modifiers/creatures/modifier_bomber_death_explosion_trigger", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bomber_death_explosion", "modifiers/creatures/modifier_bomber_death_explosion", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function bomber_death_explosion:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )
end

-----------------------------------------------------------------------------------------

function bomber_death_explosion:GetIntrinsicModifierName()
	return "modifier_bomber_death_explosion_trigger"
end

-----------------------------------------------------------------------------------------
