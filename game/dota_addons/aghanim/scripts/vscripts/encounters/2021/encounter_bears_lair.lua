require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BearsLair == nil then
	CMapEncounter_BearsLair = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_BearsLair:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PreplacedUrsa =
		{
			SpawnerName = "spawner_ursa",
			Count = 1,
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
		},
		
		Wave1 =
		{
			SpawnerName = "spawner_cubs",
			Count = 3,
			AggroHeroes = true,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
   					TriggerAfterWave = "PreplacedUrsa",
    				HealthPercent = 80,
				},
			},
		},
		Wave2 =
		{
			SpawnerName = "spawner_cubs",
			Count = 4,
			AggroHeroes = true,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
   					TriggerAfterWave = "PreplacedUrsa",
    				HealthPercent = 55,
				},
			},
		},
		Wave3 =
		{
			SpawnerName = "spawner_cubs",
			Count = 5,
			AggroHeroes = true,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
   					TriggerAfterWave = "PreplacedUrsa",
    				HealthPercent = 30,
				},
			},
		},
	}


	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_ursa", "spawner_ursa", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bear_cave_ursa",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_cubs", "spawner_cubs", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bear_cave_ursa_cub",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 0.0,
			},
		}, true ) )	


	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )

end

--------------------------------------------------------------------------------

function CMapEncounter_BearsLair:GetPreviewUnit()
	return "npc_dota_creature_bear_cave_ursa"
end

--------------------------------------------------------------------------------

function CMapEncounter_BearsLair:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_BearsLair:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BearsLair:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

return CMapEncounter_BearsLair
