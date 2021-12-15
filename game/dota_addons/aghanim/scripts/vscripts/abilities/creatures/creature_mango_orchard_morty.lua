creature_mango_orchard_morty = class({})
LinkLuaModifier( "modifier_creature_mango_orchard_morty", "modifiers/creatures/modifier_creature_mango_orchard_morty", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_mango_orchard_morty:Precache( context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
end

--------------------------------------------------------------------------------

function creature_mango_orchard_morty:GetIntrinsicModifierName()
	return "modifier_creature_mango_orchard_morty"
end
