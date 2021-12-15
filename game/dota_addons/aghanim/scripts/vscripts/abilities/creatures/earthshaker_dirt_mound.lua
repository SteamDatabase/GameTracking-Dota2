
earthshaker_dirt_mound = class({})
LinkLuaModifier( "modifier_earthshaker_dirt_mound", "modifiers/creatures/modifier_earthshaker_dirt_mound", LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------------------------------

function earthshaker_dirt_mound:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_earthshaker_minion", context, -1 )
end

--------------------------------------------------------------------------------

function earthshaker_dirt_mound:GetIntrinsicModifierName()
	return "modifier_earthshaker_dirt_mound"
end

--------------------------------------------------------------------------------
