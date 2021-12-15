creature_bonus_room_mine = class({})
LinkLuaModifier( "modifier_creature_bonus_room_mine", "modifiers/modifier_creature_bonus_room_mine", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_bonus_room_mine:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
end

--------------------------------------------------------------------------------

function creature_bonus_room_mine:GetIntrinsicModifierName()
	return "modifier_creature_bonus_room_mine"
end
