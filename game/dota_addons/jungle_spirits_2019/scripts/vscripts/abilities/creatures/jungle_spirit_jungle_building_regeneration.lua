jungle_spirit_jungle_building_regeneration = class({})
LinkLuaModifier( "modifier_jungle_spirit_jungle_building_regeneration_thinker", "modifiers/creatures/modifier_jungle_spirit_jungle_building_regeneration_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jungle_spirit_jungle_building_regeneration", "modifiers/creatures/modifier_jungle_spirit_jungle_building_regeneration", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_jungle_building_regeneration:GetIntrinsicModifierName()
	return "modifier_jungle_spirit_jungle_building_regeneration_thinker"
end
