
boss_tinker_passive = class( {} )

LinkLuaModifier( "modifier_boss_tinker_passive", "modifiers/creatures/modifier_boss_tinker_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_tinker_enraged", "modifiers/creatures/modifier_boss_tinker_enraged", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_tinker_passive:GetIntrinsicModifierName()
	return "modifier_boss_tinker_passive"
end

--------------------------------------------------------------------------------
