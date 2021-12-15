ability_absolute_no_healing = class( {} )

LinkLuaModifier( "modifier_absolute_no_healing", "modifiers/modifier_absolute_no_healing", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ability_absolute_no_healing:GetIntrinsicModifierName()
	return "modifier_absolute_no_healing"
end

--------------------------------------------------------------------------------
