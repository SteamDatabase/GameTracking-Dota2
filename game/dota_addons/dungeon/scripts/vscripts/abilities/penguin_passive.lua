penguin_passive = class({})
LinkLuaModifier( "modifier_penguin_passive", "modifiers/modifier_penguin_passive", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

function penguin_passive:GetIntrinsicModifierName()
	return "modifier_penguin_passive"
end
