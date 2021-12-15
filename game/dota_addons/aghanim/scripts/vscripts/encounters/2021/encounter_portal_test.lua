
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Portal_Test == nil then
	CMapEncounter_Portal_Test = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedWarriors =
		{
			SpawnerName = "spawner_preplaced_warriors",
			Count = 5,
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
		PrePlacedChampion =
		{
			SpawnerName = "spawner_preplaced_champion",
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

		--[[
		Wave1 =
		{
			SpawnerName = "spawner_a",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedChampion",
					KillPercent = 100,
				},
			},
		},
		--]]
		Wave1 =
		{
			SpawnerName = "spawner_a",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedChampion",
					HealthPercent = 50,
				},
			},
		},
		Wave2 =
		{
			SpawnerName = "spawner_b",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1",
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave1",
					Time = 30.0,
				},
			},
		},
		Wave3 =
		{
			SpawnerName = "spawner_c",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2",
					KillPercent = 50,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_warriors", "spawner_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_champion", "spawner_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_a", "spawner_portal", 8, 5, 1.0,
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

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_b", "spawner_portal", 8, 5, 1.0,
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

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_c", "spawner_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 7,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:GetPreviewUnit()
	return "npc_dota_pinecone_champion"
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	--self.szObjectiveEnts = "objective"
	--self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	--if #self.hObjectiveEnts == 0 then
	--	printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	--end

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_Portal_Test:Start()!' )
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vMasterWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Portal_Test:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szLocatorName == "spawner_portal" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Portal_Test
