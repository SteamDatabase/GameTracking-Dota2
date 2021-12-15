
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Misty_Plateau == nil then
	CMapEncounter_Misty_Plateau = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:constructor( hRoom, szEncounterName )

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

		PrePlacedPeons =
		{
			SpawnerName = "spawner_preplaced_peons",
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

		Wave1_Peons =
		{
			SpawnerName = "pordlers_a_peons",
			Count = 1,
			TriggerData =
			{
				TimeAbsolute =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 10.0,
				},
			},
		},

		Wave2_Peons =
		{
			SpawnerName = "pordlers_b_peons",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1_Peons",
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave1_Peons",
					Time = 30.0,
				},
			},
		},

		Wave3_Peons =
		{
			SpawnerName = "pordlers_c_peons",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2_Peons",
					KillPercent = 50,
				},
			},
		},
	}

	local bInvulnerable = true

	-- Preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "preplaced_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tinker_turret",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peons", "preplaced_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rattletrap",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	-- Portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_a_peons", "portal_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rattletrap",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_b_peons", "portal_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rattletrap",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_c_peons", "portal_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rattletrap",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self.PortalNames = {}

	local spawners = self:GetSpawners()
	for _, v in pairs( spawners ) do
		if v and v.UsePortals == true then
			table.insert( self.PortalNames, v:GetSpawnerName() )
			printf( "Found a portal named \"%s\" to add to self.PortalNames", v:GetSpawnerName() )
		end
	end

	printf( "self.PortalNames:" )
	PrintTable( self.PortalNames, " -- " )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:GetPreviewUnit()
	return "npc_dota_creature_tinker_turret"
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	--self.szObjectiveEnts = "objective"
	--self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	--if #self.hObjectiveEnts == 0 then
	--	printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	--end

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_Misty_Plateau:Start()!' )
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vMasterWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Misty_Plateau:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	--if hSpawner.szLocatorName == "portal_peons" or hSpawner.szLocatorName == "portal_captain" then
	if TableContainsValue( self.PortalNames, hSpawner.szLocatorName ) then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Misty_Plateau
