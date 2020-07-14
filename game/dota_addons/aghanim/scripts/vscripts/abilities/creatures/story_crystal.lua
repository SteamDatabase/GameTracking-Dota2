story_crystal = class( {} )

LinkLuaModifier( "modifier_story_crystal", "modifiers/creatures/modifier_story_crystal", LUA_MODIFIER_MOTION_VERTICAL )

--------------------------------------------------------------------------------

function story_crystal:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_spellswap_ambient.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_wisp.vsndevts", context )
end

--------------------------------------------------------------------------------

function story_crystal:GetIntrinsicModifierName()
	return "modifier_story_crystal"
end

--------------------------------------------------------------------------------
