gaoler_passive = class({})
LinkLuaModifier( "modifier_gaoler_passive", "modifiers/creatures/modifier_gaoler_passive", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function gaoler_passive:GetIntrinsicModifierName()
	return "modifier_gaoler_passive"
end
