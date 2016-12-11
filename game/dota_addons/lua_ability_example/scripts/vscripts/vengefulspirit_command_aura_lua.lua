vengefulspirit_command_aura_lua = class({})
LinkLuaModifier( "modifier_vengefulspirit_command_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vengefulspirit_command_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function vengefulspirit_command_aura_lua:GetIntrinsicModifierName()
	return "modifier_vengefulspirit_command_aura_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
