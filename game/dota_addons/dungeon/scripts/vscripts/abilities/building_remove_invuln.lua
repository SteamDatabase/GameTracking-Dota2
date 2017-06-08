building_remove_invuln = class({})
LinkLuaModifier( "modifier_building_remove_invuln", "modifiers/modifier_building_remove_invuln", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function building_remove_invuln:GetIntrinsicModifierName()
	return "modifier_building_remove_invuln"
end

--------------------------------------------------------------------------------
