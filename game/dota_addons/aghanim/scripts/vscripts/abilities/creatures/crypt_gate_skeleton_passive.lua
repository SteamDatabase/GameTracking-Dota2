crypt_gate_skeleton_passive = class({})
LinkLuaModifier( "modifier_crypt_gate_skeleton_passive", "modifiers/creatures/modifier_crypt_gate_skeleton_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crypt_gate_skeleton_passive_wake", "modifiers/creatures/modifier_crypt_gate_skeleton_passive_wake", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function crypt_gate_skeleton_passive:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function crypt_gate_skeleton_passive:GetIntrinsicModifierName()
	return "modifier_crypt_gate_skeleton_passive"
end

--------------------------------------------------------------------------------
