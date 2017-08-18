undead_tusk_skeleton = class({})
LinkLuaModifier( "modifier_undead_skeleton", "modifiers/modifier_undead_skeleton", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_undead_skeleton_wake", "modifiers/modifier_undead_skeleton_wake", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function undead_tusk_skeleton:GetIntrinsicModifierName()
	return "modifier_undead_skeleton"
end

--------------------------------------------------------------------------------
