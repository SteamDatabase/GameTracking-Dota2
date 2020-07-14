
spider_egg_sack = class({})
LinkLuaModifier( "modifier_spider_egg_sack", "modifiers/creatures/modifier_spider_egg_sack", LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------------------------------

function spider_egg_sack:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_newborn_spider", context, -1 )
end

--------------------------------------------------------------------------------

function spider_egg_sack:GetIntrinsicModifierName()
	return "modifier_spider_egg_sack"
end
