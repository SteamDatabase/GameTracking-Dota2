
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_BurningMesa == nil then
	CMapEncounter_BurningMesa = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_BurningMesa:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		Wave1Ember =
		{
			SpawnerName = "wave_1_ember",
			Count = 2,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 3.0,
				},
			},
		},
		Wave1Phoenix =
		{
			SpawnerName = "wave_1_phoenix",
			Count = 1,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 3.0,
				},
			},
		},

		Wave2Ember =
		{
			SpawnerName = "wave_2_ember",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1Ember",
					HealthPercent = 50,
				},
			},
		},

		Wave2Phoenix =
		{
			SpawnerName = "wave_2_phoenix",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1Phoenix",
					HealthPercent = 50,
				},
			},
		},

		Wave3Ember =
		{
			SpawnerName = "wave_3_ember",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave2Ember",
					HealthPercent = 50,
				},
			},
		},

		Wave3Phoenix =
		{
			SpawnerName = "wave_3_phoenix",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave2Phoenix",
					HealthPercent = 50,
				},
			},
		},

		Wave4Ember =
		{
			SpawnerName = "wave_4_ember",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave3Ember",
					HealthPercent = 50,
				},
			},
		},

		Wave4Phoenix =
		{
			SpawnerName = "wave_4_phoenix",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave3Phoenix",
					HealthPercent = 50,
				},
			},
		},
	}

	local bInvulnerable = true

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_ember", "portal_v2_ember", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ember_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 150.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_phoenix", "portal_v2_phoenix", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_phoenix",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_ember", "portal_v2_ember", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ember_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 150.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_phoenix", "portal_v2_phoenix", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_phoenix",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )
		
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3_ember", "portal_v2_ember", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ember_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 150.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3_phoenix", "portal_v2_phoenix", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_phoenix",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

		self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4_ember", "portal_v2_ember", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ember_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 150.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4_phoenix", "portal_v2_phoenix", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_phoenix",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_BurningMesa:GetPreviewUnit()
	return "npc_dota_creature_phoenix"
end

--------------------------------------------------------------------------------

function CMapEncounter_BurningMesa:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BurningMesa:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

end

--------------------------------------------------------------------------------

return CMapEncounter_BurningMesa
