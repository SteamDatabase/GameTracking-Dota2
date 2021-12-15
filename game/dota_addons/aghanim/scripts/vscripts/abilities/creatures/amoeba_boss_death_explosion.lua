
amoeba_boss_death_explosion = class({})
amoeba_boss_death_explosion_boss = amoeba_boss_death_explosion
amoeba_boss_death_explosion_large = amoeba_boss_death_explosion
amoeba_boss_death_explosion_medium = amoeba_boss_death_explosion
amoeba_boss_death_explosion_small = amoeba_boss_death_explosion

LinkLuaModifier( "modifier_amoeba_boss_death_explosion_trigger", "modifiers/creatures/modifier_amoeba_boss_death_explosion_trigger", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_amoeba_boss_death_explosion", "modifiers/creatures/modifier_amoeba_boss_death_explosion", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function amoeba_boss_death_explosion:Precache( context )
	PrecacheUnitByNameSync( "npc_dota_dummy_caster", context, -1 )
	PrecacheResource( "particle", "particles/creatures/slime_acid_spray.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context )	
end

-----------------------------------------------------------------------------------------

function amoeba_boss_death_explosion:GetIntrinsicModifierName()
	return "modifier_amoeba_boss_death_explosion_trigger"
end

-----------------------------------------------------------------------------------------
