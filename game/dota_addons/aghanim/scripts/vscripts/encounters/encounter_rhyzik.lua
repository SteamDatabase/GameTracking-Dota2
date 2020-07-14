
require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Rhyzik == nil then
	CMapEncounter_Rhyzik = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_Rhyzik:constructor( hRoom, szEncounterName )

	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )
	self.szBossSpawner = "spawner_boss"

	self:AddSpawner( CDotaSpawner( self.szBossSpawner, self.szBossSpawner,
		{
			{
				EntityName = "npc_dota_creature_sand_king",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_Rhyzik:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_creature_timbersaw_treant", context, -1 )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_sandking", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_sandking.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Rhyzik:GetBossUnitName()
	return "npc_dota_creature_sand_king"
end

--------------------------------------------------------------------------------

function CMapEncounter_Rhyzik:Start()
	CMapEncounter_BossBase.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Rhyzik:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

return CMapEncounter_Rhyzik
