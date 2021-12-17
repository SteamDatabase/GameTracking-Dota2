
bonus_chicken_small = class({})

LinkLuaModifier( "modifier_bonus_chicken_small", "modifiers/creatures/modifier_bonus_chicken_small", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_chicken_small_status_resist", "modifiers/creatures/modifier_bonus_chicken_small_status_resist", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function bonus_chicken_small:Precache( context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
end

--------------------------------------------------------------------------------

function bonus_chicken_small:GetIntrinsicModifierName()
	return "modifier_bonus_chicken_small"
end

--------------------------------------------------------------------------------
