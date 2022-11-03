
spider_death_explosion = class({})
LinkLuaModifier( "modifier_spider_death_explosion_trigger", "modifiers/creatures/modifier_spider_death_explosion_trigger", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_death_explosion", "modifiers/creatures/modifier_spider_death_explosion", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function spider_death_explosion:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/pumpkin_giant/pumpkin_giant_explosion_warning.vpcf", context )
end

-----------------------------------------------------------------------------------------

function spider_death_explosion:GetIntrinsicModifierName()
	return "modifier_spider_death_explosion_trigger"
end

-----------------------------------------------------------------------------------------
