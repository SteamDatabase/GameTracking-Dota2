require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_CollapsedMines == nil then
	CMapEncounter_CollapsedMines = class( {}, {}, CMapEncounter )
end


--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_tiny", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_warlock", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
		{
			SpawnerName = "spawner_peon",
			Count = 2,
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
		PrePlacedCaptain =
		{
			SpawnerName = "spawner_captain",
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
		PrePlacedTower =
		{
			SpawnerName = "spawner_tower",
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

		Wave1Peon =
		{
			SpawnerName = "wave_1_peon",
			Count = 2,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedTower",
					KillPercent = 100,
				},
			},
		},

		Wave1Captain =
		{
			SpawnerName = "wave_1_captain",
			Count = 1,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedTower",
					KillPercent = 100,
				},
			},
		},

		Wave1Tower =
		{
			SpawnerName = "wave_1_tower",
			Count = 1,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedTower",
					KillPercent = 100,
				},
			},
		},

		Wave2Peon =
		{
			SpawnerName = "wave_2_peon",
			Count = 2,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1Tower",
					KillPercent = 100,
				},
			},
		},

		Wave2Captain =
		{
			SpawnerName = "wave_2_captain",
			Count = 1,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1Tower",
					KillPercent = 100,
				},
			},
		},

		Wave2Tower =
		{
			SpawnerName = "wave_2_tower",
			Count = 1,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1Tower",
					KillPercent = 100,
				},
			},
		},

		Wave3Peon =
		{
			SpawnerName = "wave_3_peon",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1Tower",
					HealthPercent = 97,
				},
			},
		},

		Wave4Peon =
		{
			SpawnerName = "wave_4_peon",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave2Tower",
					HealthPercent = 97,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_golem",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_tower", "spawner_tower", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_golem_tower",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_peon", "spawner_peon_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_captain", "spawner_captain_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_golem",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_tower", "spawner_tower_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_golem_tower",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_peon", "spawner_peon_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_captain", "spawner_captain_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_golem",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_tower", "spawner_tower_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_golem_tower",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3_peon", "spawner_peon_wave_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_golem",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_magma_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 8,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4_peon", "spawner_peon_wave_4", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magma_golem",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_magma_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 8,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end


--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:GetPreviewUnit()
	return "npc_dota_creature_golem_tower"
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
end

--------------------------------------------------------------------------------

function CMapEncounter_CollapsedMines:OnComplete()
	CMapEncounter.OnComplete( self )

	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "end_encounter_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	
end

--------------------------------------------------------------------------------

return CMapEncounter_CollapsedMines
