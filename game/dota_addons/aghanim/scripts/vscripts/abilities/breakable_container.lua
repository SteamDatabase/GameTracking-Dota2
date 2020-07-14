
breakable_container = class({})
LinkLuaModifier( "modifier_breakable_container", "modifiers/modifier_breakable_container", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function breakable_container:GetIntrinsicModifierName()
	return "modifier_breakable_container"
end

--------------------------------------------------------------------------------
