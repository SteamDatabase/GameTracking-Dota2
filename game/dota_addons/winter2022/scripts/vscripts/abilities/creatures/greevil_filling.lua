
greevil_filling = class({})

LinkLuaModifier( "modifier_greevil_filling", "modifiers/creatures/modifier_greevil_filling", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function greevil_filling:Precache( context )
	PrecacheItemByNameSync( "item_candy", context )
	PrecacheItemByNameSync( "item_candy_bag", context )
	--PrecacheResource( "particle", "particles/units/heroes/hero_broodmother/broodmother_spiderlings_spawn.vpcf", context )
end

--------------------------------------------------------------------------------

function greevil_filling:GetIntrinsicModifierName()
	return "modifier_greevil_filling"
end

--------------------------------------------------------------------------------
