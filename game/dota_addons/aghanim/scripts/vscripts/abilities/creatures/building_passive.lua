building_passive = class({})
LinkLuaModifier( "modifier_building_passive", "modifiers/creatures/modifier_building_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function building_passive:GetIntrinsicModifierName()
	return "modifier_building_passive"
end
