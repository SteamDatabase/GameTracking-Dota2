
twilight_maze_vision = class({})

LinkLuaModifier( "modifier_twilight_maze_vision_aura", "modifiers/creatures/modifier_twilight_maze_vision_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_twilight_maze_vision_aura_effect", "modifiers/creatures/modifier_twilight_maze_vision_aura_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function twilight_maze_vision:GetIntrinsicModifierName()
	return "modifier_twilight_maze_vision_aura"
end

--------------------------------------------------------------------------------
