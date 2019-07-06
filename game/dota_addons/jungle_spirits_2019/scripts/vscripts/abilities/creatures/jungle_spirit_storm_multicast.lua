jungle_spirit_storm_multicast = class({})
LinkLuaModifier( "modifier_jungle_spirit_storm_multicast_thinker", "modifiers/creatures/modifier_jungle_spirit_storm_multicast_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_storm_multicast:GetIntrinsicModifierName()
	return "modifier_jungle_spirit_storm_multicast_thinker"
end
