imprisoned_soldier = class({})
LinkLuaModifier( "modifier_imprisoned_soldier", "modifiers/modifier_imprisoned_soldier", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imprisoned_soldier_animation", "modifiers/modifier_imprisoned_soldier_animation", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function imprisoned_soldier:GetIntrinsicModifierName()
	return "modifier_imprisoned_soldier"
end

--------------------------------------------------------------------------------

