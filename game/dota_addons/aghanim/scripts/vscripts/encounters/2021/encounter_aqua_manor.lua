
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_AquaManor == nil then
	CMapEncounter_AquaManor = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_AquaManor:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
		{
			SpawnerName = "spawner_preplaced_peon",
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

		Wave1Peons =
		{
			SpawnerName = "wave_1_peon",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedPeons",
					KillPercent = 100,
				},
			},
		},

		Wave1Captains =
		{
			SpawnerName = "wave_1_captain",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedPeons",
					KillPercent = 100,
				},
			},
		},

		Wave2Peons =
		{
			SpawnerName = "wave_2_peon",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1Peons",
					KillPercent = 100,
				},
			},
		},

		Wave2Captains =
		{
			SpawnerName = "wave_2_captain",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1Captains",
					KillPercent = 100,
				},
			},
		},

		Wave3Peons =
		{
			SpawnerName = "wave_3_peon",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2Peons",
					KillPercent = 75,
				},
			},
		},

		Wave3Captains =
		{
			SpawnerName = "wave_3_captain",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2Captains",
					KillPercent = 75,
				},
			},
		},

		Wave4Peons =
		{
			SpawnerName = "wave_4_peon",
			Count = 4,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave3Peons",
					KillPercent = 50,
				},
			},
		},

		Wave4Captains =
		{
			SpawnerName = "wave_4_captain",
			Count = 4,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave3Captains",
					KillPercent = 50,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tiny_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 225.0,
			},
		}, bInvulnerable ) )

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_peon", "portal_v2_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tiny_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 8,
				PositionNoise = 225.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_captain", "portal_v2_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_morphling_big",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_peon", "portal_v2_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tiny_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 10,
				PositionNoise = 225.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_captain", "portal_v2_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_morphling_big",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3_peon", "portal_v2_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tiny_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 8,
				PositionNoise = 225.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3_captain", "portal_v2_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_morphling_big",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4_peon", "portal_v2_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tiny_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 7,
				PositionNoise = 225.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4_captain", "portal_v2_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_morphling_big",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_AquaManor:InitializeObjectives()
	--CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_AquaManor:GetMaxSpawnedUnitCount()
	local nCount = 0
	-- Standing trash
	local hPeonSpawners = self:GetSpawner( "spawner_peon")
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount() * 2
	end
	-- Peons = 88
	nCount = nCount + 88
	-- Captains = 24
	nCount = nCount + 24
	-- Total should be 124
	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_AquaManor:GetPreviewUnit()
	return "npc_dota_creature_morphling_big"
end

--------------------------------------------------------------------------------

function CMapEncounter_AquaManor:Start()
	CMapEncounter.Start( self )

	self:CreateUnits()
	self:StartAllSpawnerSchedules( 0 )	
end

--------------------------------------------------------------------------------

function CMapEncounter_AquaManor:CreateUnits()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_AquaManor
