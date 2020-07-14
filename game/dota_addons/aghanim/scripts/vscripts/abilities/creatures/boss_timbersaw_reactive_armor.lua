
boss_timbersaw_reactive_armor = class({})
LinkLuaModifier( "modifier_boss_timbersaw_reactive_armor", "modifiers/creatures/modifier_boss_timbersaw_reactive_armor", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function boss_timbersaw_reactive_armor:Precache( context )

	PrecacheResource( "particle", "particles/items2_fx/vanguard_active_launch.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/pipe_of_insight_launch.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/vanguard_active.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/pipe_of_insight.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_timbersaw/shredder_armor_lyr1.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_timbersaw/shredder_armor_lyr2.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_timbersaw/shredder_armor_lyr3.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_timbersaw/shredder_armor_lyr4.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_reactive_hit.vpcf", context )
end

-----------------------------------------------------------------------------------------

function boss_timbersaw_reactive_armor:GetIntrinsicModifierName()
	return "modifier_boss_timbersaw_reactive_armor"
end

-----------------------------------------------------------------------------------------
