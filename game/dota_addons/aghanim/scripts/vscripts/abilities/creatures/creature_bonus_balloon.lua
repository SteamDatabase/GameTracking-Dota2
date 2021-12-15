creature_bonus_balloon = class({})
LinkLuaModifier( "modifier_creature_bonus_balloon", "modifiers/modifier_creature_bonus_balloon", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_bonus_balloon:Precache( context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
	PrecacheResource( "model", "models/items/courier/hand_courier/hand_courier_radiant_lv2_flying.vmdl", context )
end

--------------------------------------------------------------------------------

function creature_bonus_balloon:GetIntrinsicModifierName()
	return "modifier_creature_bonus_balloon"
end
