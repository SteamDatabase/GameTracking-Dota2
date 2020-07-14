
bomber_suicide_on_attack = class({})
LinkLuaModifier( "modifier_bomber_suicide_on_attack", "modifiers/creatures/modifier_bomber_suicide_on_attack", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function bomber_suicide_on_attack:GetIntrinsicModifierName()
	return "modifier_bomber_suicide_on_attack"
end

-----------------------------------------------------------------------------------------
