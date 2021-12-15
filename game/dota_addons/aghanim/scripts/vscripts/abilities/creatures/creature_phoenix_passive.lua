
creature_phoenix_passive = class( {} )

LinkLuaModifier( "modifier_creature_phoenix_passive", "modifiers/creatures/modifier_creature_phoenix_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_phoenix_passive:GetIntrinsicModifierName()
	return "modifier_creature_phoenix_passive"
end

--------------------------------------------------------------------------------
