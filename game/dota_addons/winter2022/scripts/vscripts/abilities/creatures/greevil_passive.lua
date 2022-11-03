
greevil_passive = class({})

LinkLuaModifier( "modifier_greevil_passive", "modifiers/creatures/modifier_greevil_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_greevil_status_resist", "modifiers/creatures/modifier_greevil_status_resist", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function greevil_passive:Precache( context )
	PrecacheItemByNameSync( "item_candy", context )
	PrecacheItemByNameSync( "item_candy_bag", context )
end

--------------------------------------------------------------------------------

function greevil_passive:GetIntrinsicModifierName()
	return "modifier_greevil_passive"
end

--------------------------------------------------------------------------------
