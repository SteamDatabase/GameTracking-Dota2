
baby_broodmother_passive = class({})

LinkLuaModifier( "modifier_baby_broodmother_passive", "modifiers/creatures/modifier_baby_broodmother_passive", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_baby_broodmother_venom_pool", "modifiers/creatures/modifier_baby_broodmother_venom_pool", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function baby_broodmother_passive:GetIntrinsicModifierName()
	return "modifier_baby_broodmother_passive"
end

--------------------------------------------------------------------------------

