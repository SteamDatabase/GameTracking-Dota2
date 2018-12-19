
invoker_bonus_ability_points = class({})

LinkLuaModifier( "modifier_invoker_bonus_ability_points", "modifiers/heroes/modifier_invoker_bonus_ability_points", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function invoker_bonus_ability_points:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function invoker_bonus_ability_points:GetIntrinsicModifierName()
	return "modifier_invoker_bonus_ability_points"
end

--------------------------------------------------------------------------------
