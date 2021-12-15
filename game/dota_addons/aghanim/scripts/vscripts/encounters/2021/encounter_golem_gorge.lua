
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_GolemGorge == nil then
	CMapEncounter_GolemGorge = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_GolemGorge:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		Wave1 =
		{
			SpawnerName = "wave_1",
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

		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1",
					KillPercent = 100,
				},
			},
		},

		Wave3 =
		{
			SpawnerName = "wave_3",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2",
					KillPercent = 100,
				},
			},
		},

	}

	local bInvulnerable = true

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rock_golem_a",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rock_golem_a",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rock_golem_a",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_GolemGorge:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_GolemGorge:GetPreviewUnit()
	return "npc_dota_creature_rock_golem_a"
end

--------------------------------------------------------------------------------

function CMapEncounter_GolemGorge:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_GolemGorge:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_GolemGorge:GetMaxSpawnedUnitCount()
	local nBigGolems = 6
	local nMediumGolems = nBigGolems * 3
	local nSmallGolems = nMediumGolems * 4

	local nTotal = nBigGolems + nMediumGolems + nSmallGolems -- isn't working, it's 0
	printf( "GetMaxSpawnedUnitCount - nTotal: %d", nTotal )
	return nTotal
end

--------------------------------------------------------------------------------

function CMapEncounter_GolemGorge:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

end

--------------------------------------------------------------------------------

return CMapEncounter_GolemGorge
