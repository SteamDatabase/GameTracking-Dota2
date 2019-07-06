
vision_revealer = class({})

LinkLuaModifier( "modifier_vision_revealer", "modifiers/modifier_vision_revealer", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function vision_revealer:GetIntrinsicModifierName()
	return "modifier_vision_revealer"
end

--------------------------------------------------------------------------------
