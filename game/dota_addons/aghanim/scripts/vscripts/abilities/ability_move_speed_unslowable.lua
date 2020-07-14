ability_move_speed_unslowable = class( {} )

LinkLuaModifier( "modifier_move_speed_unslowable", "modifiers/modifier_move_speed_unslowable", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ability_move_speed_unslowable:GetIntrinsicModifierName()
	return "modifier_move_speed_unslowable"
end