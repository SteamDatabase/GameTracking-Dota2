creature_generic_high_status_resist_passive = class({})
LinkLuaModifier( "modifier_creature_generic_high_status_resist_passive", "modifiers/creatures/modifier_creature_generic_high_status_resist_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_generic_high_status_resist_passive:GetIntrinsicModifierName()
	return "modifier_creature_generic_high_status_resist_passive"
end
