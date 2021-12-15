
fat_golem_burst = class({})
LinkLuaModifier( "modifier_fat_golem_burst", "modifiers/creatures/modifier_fat_golem_burst", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fat_golem_burst_thinker", "modifiers/creatures/modifier_fat_golem_burst_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fat_golem_burst_debuff", "modifiers/creatures/modifier_fat_golem_burst_debuff", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function fat_golem_burst:Precache( context )
	PrecacheUnitByNameSync( "npc_dota_creature_skeleteeny", context, -1 )

	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", context )
	PrecacheResource( "particle", "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced.vpcf", context )
end

-----------------------------------------------------------------------------------------

function fat_golem_burst:GetIntrinsicModifierName()
	return "modifier_fat_golem_burst"
end

-----------------------------------------------------------------------------------------
