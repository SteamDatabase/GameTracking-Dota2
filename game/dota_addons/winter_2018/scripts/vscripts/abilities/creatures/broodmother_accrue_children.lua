
broodmother_accrue_children = class({})
LinkLuaModifier( "modifier_broodmother_accrue_children", "modifiers/creatures/modifier_broodmother_accrue_children", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_broodmother_generate_children", "modifiers/creatures/modifier_broodmother_generate_children", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function broodmother_accrue_children:GetIntrinsicModifierName()
	return "modifier_broodmother_accrue_children"
end

--------------------------------------------------------------------------------
