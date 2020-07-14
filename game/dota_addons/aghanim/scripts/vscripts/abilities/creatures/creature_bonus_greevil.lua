creature_bonus_greevil = class({})
LinkLuaModifier( "modifier_creature_bonus_greevil", "modifiers/modifier_creature_bonus_greevil", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_bonus_greevil:Precache( context )
	PrecacheItemByNameSync( "item_bag_of_gold", context )
end

--------------------------------------------------------------------------------

function creature_bonus_greevil:GetIntrinsicModifierName()
	return "modifier_creature_bonus_greevil"
end
