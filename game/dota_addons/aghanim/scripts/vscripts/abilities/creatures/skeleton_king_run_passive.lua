
skeleton_king_run_passive = class({})

LinkLuaModifier( "modifier_skeleton_king_boss_run", "modifiers/creatures/modifier_skeleton_king_boss_run", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function skeleton_king_run_passive:GetIntrinsicModifierName()
	return "modifier_skeleton_king_boss_run"
end

--------------------------------------------------------------------------------

