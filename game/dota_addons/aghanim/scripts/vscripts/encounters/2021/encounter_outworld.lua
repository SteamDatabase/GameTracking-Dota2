
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Outworld == nil then
	CMapEncounter_Outworld = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Outworld:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vReinforcementSchedule =
	{	
		OD1 =
		{
			SpawnerName = "spawner_od",
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 0.0,
				},
			},
			Count = 1,
		},

		OD2 =
		{
			SpawnerName = "portal_od",
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "OD1",
					HealthPercent = 60,
				},
			},
			Count = 1,
		},

		Peons1 =
		{
			SpawnerName = "portal_peons",
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 8.0,
				},
			},
			Count = 2,
		},
		Peons2 =
		{
			SpawnerName = "portal_peons",
			TriggerData = 
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "OD1",
					HealthPercent = 80,
				},
			},
			Count = 2,
		},
		Peons3 =
		{
			SpawnerName = "portal_peons",
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 50.0,
				},
			},
			Count = 3,
		},
		Peons4 =
		{
			SpawnerName = "portal_peons",
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "OD1",
					HealthPercent = 60,
				},
			},
			Count = 2,
		},
		Peons5 =
		{
			SpawnerName = "portal_peons",
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 70.0,
				},
			},
			Count = 3,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_od", "spawner_od", 8, 5, 1.0,
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_peons", "portal_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_od_satyr",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 225.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_od", "portal_od", 8, 5, 1.0,
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:SetMasterSpawnSchedule( self.vReinforcementSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Outworld:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_end_dmg.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Outworld:GetPreviewUnit()
	return "npc_dota_creature_outworld"
end

--------------------------------------------------------------------------------

function CMapEncounter_Outworld:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

return CMapEncounter_Outworld
