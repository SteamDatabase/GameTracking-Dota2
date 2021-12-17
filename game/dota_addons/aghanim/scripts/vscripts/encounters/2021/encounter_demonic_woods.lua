require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_DemonicWoods == nil then
	CMapEncounter_DemonicWoods = class( {}, {}, CMapEncounter )
end


--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_bane", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_night_stalker", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nightstalker.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
		{
			SpawnerName = "spawner_preplaced_peon",
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
		PrePlacedCaptain =
		{
			SpawnerName = "spawner_preplaced_captain",
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

		Wave1Peons =
		{
			SpawnerName = "wave_1_peons",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					KillPercent = 100,
				},
			},
		},

		Wave1Captains =
		{
			SpawnerName = "wave_1_captains",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					KillPercent = 100,
				},
			},
		},

		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					KillPercent = 100,
				},
			},
		},

		Wave3 =
		{
			SpawnerName = "wave_3",
			Count = 2,
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
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_nightstalker_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bane",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_peons", "spawner_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_nightstalker_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )
	
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_captains", "spawner_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bane",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_boss", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_nightstalker_miniboss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_nightstalker_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 8,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_bane",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end


--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:GetPreviewUnit()
	return "npc_dota_creature_nightstalker_miniboss"
end

--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DemonicWoods:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
end

--------------------------------------------------------------------------------

return CMapEncounter_DemonicWoods
