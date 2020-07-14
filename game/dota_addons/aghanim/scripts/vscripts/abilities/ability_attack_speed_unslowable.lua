ability_attack_speed_unslowable = class( {} )

LinkLuaModifier( "modifier_attack_speed_unslowable", "modifiers/modifier_attack_speed_unslowable", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ability_attack_speed_unslowable:GetIntrinsicModifierName()
	return "modifier_attack_speed_unslowable"
end