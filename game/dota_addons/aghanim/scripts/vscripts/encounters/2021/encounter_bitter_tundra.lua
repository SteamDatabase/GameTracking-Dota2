
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_BitterTundra == nil then
	CMapEncounter_BitterTundra = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_BitterTundra:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

    self.vMasterWaveSchedule =
	{
		PrePlacedCaptain =
		{
			SpawnerName = "spawner_preplaced_captain",
			Count = 4,
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

        PrePlacedPeon =
		{
			SpawnerName = "spawner_preplaced_peon",
			Count = 4,
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
					TriggerAfterWave = "PrePlacedCaptain",
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
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1",
					HealthPercent = 50,
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
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave2",
					HealthPercent = 50,
				},
			},
		},

        -- WAVE 4
		Wave4 =
		{
			SpawnerName = "wave_4",
			Count = 4,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave3",
					HealthPercent = 75,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

    self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 225.0,
			},
		}, bInvulnerable ) )

	-- portal enemies
	-- wave 1
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 225.0,
			},
			{
				EntityName = "npc_dota_creature_large_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 2
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 225.0,
			},
			{
				EntityName = "npc_dota_creature_large_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 3
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 225.0,
			},
			{
				EntityName = "npc_dota_creature_large_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

    -- wave 4
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4", "dynamic_portal", 8, 5, 1.0,
    {
        {
            EntityName = "npc_dota_creature_small_ogre_seal",
            Team = DOTA_TEAM_BADGUYS,
            Count = 5,
            PositionNoise = 225.0,
        },
        {
            EntityName = "npc_dota_creature_large_ogre_seal",
            Team = DOTA_TEAM_BADGUYS,
            Count = 1,
            PositionNoise = 0.0,
        },
    }, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule ) 
end

--------------------------------------------------------------------------------

function CMapEncounter_BitterTundra:GetPreviewUnit()
	return "npc_dota_creature_large_ogre_seal"
end

--------------------------------------------------------------------------------

function CMapEncounter_BitterTundra:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BitterTundra:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

return CMapEncounter_BitterTundra
