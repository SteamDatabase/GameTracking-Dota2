
vision_dummy = class({})
LinkLuaModifier( "modifier_vision_dummy", "modifiers/modifier_vision_dummy", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function vision_dummy:GetIntrinsicModifierName()
	return "modifier_vision_dummy"
end

--------------------------------------------------------------------------------
