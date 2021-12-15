
acid_blob_death_explosion = class({})
LinkLuaModifier( "modifier_acid_blob_death_explosion_trigger", "modifiers/creatures/modifier_acid_blob_death_explosion_trigger", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_acid_blob_death_explosion", "modifiers/creatures/modifier_acid_blob_death_explosion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_acid_blob_explosion_slow", "modifiers/creatures/modifier_acid_blob_explosion_slow", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function acid_blob_death_explosion:Precache( context )
	PrecacheUnitByNameSync( "npc_dota_dummy_caster", context, -1 )
	PrecacheResource( "particle", "particles/creatures/slime_acid_spray.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context )	
end

-----------------------------------------------------------------------------------------

function acid_blob_death_explosion:GetIntrinsicModifierName()
	return "modifier_acid_blob_death_explosion_trigger"
end

-----------------------------------------------------------------------------------------
