creature_bonus_fish = class({})
LinkLuaModifier( "modifier_creature_bonus_fish", "modifiers/modifier_creature_bonus_fish", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_bonus_fish:Precache( context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
	PrecacheResource( "model", "models/items/hex/fish_hex_retro/fish_hex_retro.vmdl", context )
end

--------------------------------------------------------------------------------

function creature_bonus_fish:GetIntrinsicModifierName()
	return "modifier_creature_bonus_fish"
end
