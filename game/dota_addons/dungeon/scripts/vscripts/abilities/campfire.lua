
campfire = class({})

LinkLuaModifier( "modifier_campfire", "modifiers/modifier_campfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_campfire_effect", "modifiers/modifier_campfire_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function campfire:GetIntrinsicModifierName()
	return "modifier_campfire"
end

--------------------------------------------------------------------------------

