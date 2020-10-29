
detect_invisible = class({})
LinkLuaModifier( "modifier_detect_invisible", "modifiers/gameplay/modifier_detect_invisible", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function detect_invisible:GetIntrinsicModifierName()
	return "modifier_detect_invisible"
end

--------------------------------------------------------------------------------
