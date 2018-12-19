
huge_broodmother_accrue_children = class({})
LinkLuaModifier( "modifier_huge_broodmother_accrue_children", "modifiers/creatures/modifier_huge_broodmother_accrue_children", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_huge_broodmother_generate_children_thinker", "modifiers/creatures/modifier_huge_broodmother_generate_children_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function huge_broodmother_accrue_children:GetIntrinsicModifierName()
	return "modifier_huge_broodmother_accrue_children"
end

--------------------------------------------------------------------------------
