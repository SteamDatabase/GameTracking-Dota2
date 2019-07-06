creature_bonus_chicken = class({})
LinkLuaModifier( "modifier_creature_bonus_chicken", "modifiers/creatures/modifier_creature_bonus_chicken", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_bonus_chicken:GetIntrinsicModifierName()
	return "modifier_creature_bonus_chicken"
end
