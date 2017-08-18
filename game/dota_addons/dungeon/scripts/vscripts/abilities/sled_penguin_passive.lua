sled_penguin_passive = class({})
LinkLuaModifier( "modifier_sled_penguin_passive", "modifiers/modifier_sled_penguin_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sled_penguin_movement", "modifiers/modifier_sled_penguin_movement", LUA_MODIFIER_MOTION_HORIZONTAL )

----------------------------------------------------------------------------------

function sled_penguin_passive:GetIntrinsicModifierName()
	return "modifier_sled_penguin_passive"
end
