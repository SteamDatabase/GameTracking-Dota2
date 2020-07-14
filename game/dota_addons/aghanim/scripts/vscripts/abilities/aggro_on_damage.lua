aggro_on_damage = class({})
LinkLuaModifier( "modifier_aggro_on_damage", "modifiers/modifier_aggro_on_damage", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function aggro_on_damage:GetIntrinsicModifierName()
	return "modifier_aggro_on_damage"
end
