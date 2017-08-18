
weather_dummy_passive = class({})

LinkLuaModifier( "modifier_weather_dummy_passive", "modifiers/modifier_weather_dummy_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function weather_dummy_passive:GetIntrinsicModifierName()
	return "modifier_weather_dummy_passive"
end

--------------------------------------------------------------------------------

