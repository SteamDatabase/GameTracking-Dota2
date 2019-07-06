jungle_spirit_volcano_damage_block = class({})
LinkLuaModifier( "modifier_jungle_spirit_volcano_damage_block_thinker", "modifiers/creatures/modifier_jungle_spirit_volcano_damage_block_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jungle_spirit_volcano_damage_block", "modifiers/creatures/modifier_jungle_spirit_volcano_damage_block", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_volcano_damage_block:GetIntrinsicModifierName()
	return "modifier_jungle_spirit_volcano_damage_block_thinker"
end
