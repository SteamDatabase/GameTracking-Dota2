
snapfire_run_passive = class({})

LinkLuaModifier( "modifier_snapfire_run", "modifiers/creatures/modifier_snapfire_run", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function snapfire_run_passive:GetIntrinsicModifierName()
	return "modifier_snapfire_run"
end

--------------------------------------------------------------------------------

