sand_king_boss_sandstorm_storm_passive = class({})
LinkLuaModifier( "modifier_sand_king_boss_sandstorm", "modifiers/modifier_sand_king_boss_sandstorm", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sand_king_boss_sandstorm_effect", "modifiers/modifier_sand_king_boss_sandstorm_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_king_boss_sandstorm_blind", "modifiers/modifier_sand_king_boss_sandstorm_blind", LUA_MODIFIER_MOTION_NONE )


-----------------------------------------------------------------------------------------

function sand_king_boss_sandstorm_storm_passive:GetIntrinsicModifierName()
	return "modifier_sand_king_boss_sandstorm"
end

-----------------------------------------------------------------------------------------
