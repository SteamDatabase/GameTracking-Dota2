
dummy_target_passive = class({})

LinkLuaModifier( "modifier_dummy_target_passive", "modifiers/creatures/modifier_dummy_target_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function dummy_target_passive:GetIntrinsicModifierName()
	return "modifier_dummy_target_passive"
end

--------------------------------------------------------------------------------

