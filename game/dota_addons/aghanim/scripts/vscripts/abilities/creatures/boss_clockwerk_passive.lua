
boss_clockwerk_passive = class( {} )

LinkLuaModifier( "modifier_boss_clockwerk_passive", "modifiers/creatures/modifier_boss_clockwerk_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_clockwerk_enraged", "modifiers/creatures/modifier_boss_clockwerk_enraged", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_clockwerk_passive:GetIntrinsicModifierName()
	return "modifier_boss_clockwerk_passive"
end

--------------------------------------------------------------------------------
