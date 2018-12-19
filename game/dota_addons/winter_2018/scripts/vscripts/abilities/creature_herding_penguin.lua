creature_herding_penguin = class({})
LinkLuaModifier( "modifier_creature_herding_penguin", "modifiers/modifier_creature_herding_penguin", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function creature_herding_penguin:GetIntrinsicModifierName()
	return "modifier_creature_herding_penguin"
end
