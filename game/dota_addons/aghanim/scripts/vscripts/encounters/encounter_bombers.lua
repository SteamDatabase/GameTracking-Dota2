
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Bombers == nil then
	CMapEncounter_Bombers = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	local bInvulnerable = true
	local nWaves = 8
	local flFirstWaveSpawnDelay = 0.0
	local flTimeBetweenWaves = 9.0

	self.vWave1Schedule =
	{
		{
			Time = 0,
			Count = 1,
		},
		{
			Time = 9,
			Count = 1,
		},
		{
			Time = 18,
			Count = 1,
		},
	}

	self.vWave2Schedule =
	{
		{
			Time = 27,
			Count = 1,
		},
		{
			Time = 36,
			Count = 1,
		},
		{
			Time = 45,
			Count = 1,
		},
	}

	self.vWave3Schedule =
	{
		{
			Time = 54,
			Count = 2,
		},
		{
			Time = 63,
			Count = 2,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bomber",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_gyrocopter",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bomber",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_gyrocopter",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bomber",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_gyrocopter",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( "wave_1", self.vWave1Schedule )
	self:SetSpawnerSchedule( "wave_2", self.vWave2Schedule )
	self:SetSpawnerSchedule( "wave_3", self.vWave3Schedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_gyrocopter", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_rattletrap", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:GetPreviewUnit()
	return "npc_dota_creature_bomber"
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.szObjectiveEnts = "objective"
	self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	if #self.hObjectiveEnts == 0 then
		printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vWave1Schedule + #self.vWave2Schedule + #self.vWave3Schedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szLocatorName == "spawner_peon" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	--print( heroes )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		local hero = heroes[RandomInt(1, #heroes)]
		if hero ~= nil then
			printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
			hSpawnedUnit:SetInitialGoalEntity( hero )
		elseif #self.hObjectiveEnts > 0 then
			print( "Can't find a hero to attack - setting a goal position to Objective Entity" )
			hSpawnedUnit:SetInitialGoalPosition( self.hObjectiveEnts[1]:GetOrigin() )
		end
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_Bombers:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	printf( "szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

	if self.bCreatureSpawnsActivated == nil and szTriggerName == "trigger_spawn_creatures" then
		self.bCreatureSpawnsActivated = true

		self:StartAllSpawnerSchedules( 0 )	

		printf( "Unit \"%s\" triggered creature spawning!", hUnit:GetUnitName() )
   		EmitGlobalSound( "RoundStart" )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Bombers
