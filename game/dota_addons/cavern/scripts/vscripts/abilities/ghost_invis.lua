
ghost_invis = class({})
LinkLuaModifier( "modifier_ghost", "modifiers/modifier_ghost", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ghost_slow", "modifiers/modifier_ghost_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ghost_invis:GetIntrinsicModifierName()
	return "modifier_ghost"
end

--------------------------------------------------------------------------------
