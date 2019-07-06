jungle_spirit_volcano_golden_tree = class({})
LinkLuaModifier( "modifier_jungle_spirit_volcano_golden_tree_thinker", "modifiers/creatures/modifier_jungle_spirit_volcano_golden_tree_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jungle_spirit_volcano_golden_tree", "modifiers/creatures/modifier_jungle_spirit_volcano_golden_tree", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_volcano_golden_tree:GetIntrinsicModifierName()
	return "modifier_jungle_spirit_volcano_golden_tree_thinker"
end
