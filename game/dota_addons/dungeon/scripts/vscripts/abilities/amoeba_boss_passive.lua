amoeba_boss_passive = class({})
LinkLuaModifier( "modifier_amoeba_boss_passive", "modifiers/modifier_amoeba_boss_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_amoeba_boss_ink", "modifiers/modifier_amoeba_boss_ink", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function amoeba_boss_passive:GetIntrinsicModifierName()
	return "modifier_amoeba_boss_passive"
end

