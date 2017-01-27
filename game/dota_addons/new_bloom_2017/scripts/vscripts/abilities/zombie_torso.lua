zombie_torso = class({})
LinkLuaModifier( "modifier_zombie_torso", "modifiers/modifier_zombie_torso", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_torso_thinker", "modifiers/modifier_zombie_torso_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_torso:GetIntrinsicModifierName()
	return "modifier_zombie_torso"
end
