
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_PineGrove == nil then
	CMapEncounter_PineGrove = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_PineGrove:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedWarriors =
		{
			SpawnerName = "spawner_preplaced_warriors",
			Count = 6,
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

		PrePlacedCaptain1 =
		{
			SpawnerName = "spawner_captain_1",
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
		PrePlacedCaptain2 =
		{
			SpawnerName = "spawner_captain_2",
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
		PrePlacedCaptain3 =
		{
			SpawnerName = "spawner_captain_3",
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

		PrePlacedSnipers =
		{
			SpawnerName = "spawner_sniper",
			Count = 3,
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

		-- WAVE 1
		Wave1 =
		{
			SpawnerName = "wave_1",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain1",
					KillPercent = 100,
				},
			},
		},

		-- WAVE 2
		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain2",
					KillPercent = 100,
				},
			},
		},
		Wave2Snipers =
		{
			SpawnerName = "wave_2_snipers",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain2",
					KillPercent = 100,
				},
			},
		},

		-- WAVE 3
		Wave3 =
		{
			SpawnerName = "wave_3",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain3",
					KillPercent = 100,
				},
			},
		},

	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_warriors", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain_1", "spawner_captain_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain_2", "spawner_captain_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain_3", "spawner_captain_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_sniper", "spawner_sniper", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_sniper",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal enemies
	-- wave 1
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 2
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_snipers", "spawner_wave_2_snipers", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_pinecone_sniper",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 3
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_wave_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_pinecone_sniper",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_PineGrove:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_PineGrove:GetPreviewUnit()
	return "npc_dota_pinecone_champion"
end

--------------------------------------------------------------------------------

function CMapEncounter_PineGrove:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_PineGrove:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_PineGrove:Start()!' )
end

--------------------------------------------------------------------------------

return CMapEncounter_PineGrove
