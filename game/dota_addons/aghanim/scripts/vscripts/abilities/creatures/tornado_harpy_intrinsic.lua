
tornado_harpy_intrinsic = class({})
LinkLuaModifier( "modifier_tornado_harpy_intrinsic", "modifiers/creatures/modifier_tornado_harpy_intrinsic", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tornado_harpy_surge", "modifiers/creatures/modifier_tornado_harpy_surge", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function tornado_harpy_intrinsic:GetIntrinsicModifierName()
	return "modifier_tornado_harpy_intrinsic"
end

-----------------------------------------------------------------------------------------
