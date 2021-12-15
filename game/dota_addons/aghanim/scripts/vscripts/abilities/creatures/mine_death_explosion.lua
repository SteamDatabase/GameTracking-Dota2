
mine_death_explosion = class({})
LinkLuaModifier( "modifier_mine_death_explosion_thinker", "modifiers/creatures/modifier_mine_death_explosion_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mine_death_explosion", "modifiers/creatures/modifier_mine_death_explosion", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function mine_death_explosion:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )
end

-----------------------------------------------------------------------------------------

function mine_death_explosion:GetIntrinsicModifierName()
	return "modifier_mine_death_explosion_thinker"
end

-----------------------------------------------------------------------------------------
