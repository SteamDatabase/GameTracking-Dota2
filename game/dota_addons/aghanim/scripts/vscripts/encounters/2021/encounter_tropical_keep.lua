
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_TropicalKeep == nil then
	CMapEncounter_TropicalKeep = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TropicalKeep:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	local bInvulnerable = true
	local nWaves = 8
	local flFirstWaveSpawnDelay = 0.0
	local flTimeBetweenWaves = 9.0

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
					Time = 0.0,
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
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave2",
					Time = 30.0,
				},
			},
		},

		Wave4 =
		{
			SpawnerName = "wave_4",
			Count = 4,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave3",
					KillPercent = 50,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave3",
					Time = 30.0,
				},
			},
		},

	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_beetle",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_weaver",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_beetle",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_weaver",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_beetle",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_weaver",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_beetle",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_weaver",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_TropicalKeep:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_right.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_left.vpcf", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_weaver", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_weaver.vsndevts", context )
	PrecacheResource( "particle", "particles/econ/events/plus/high_five/high_five_lvl3_overhead_hearts.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_friendly_radiant_guard", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_TropicalKeep:GetPreviewUnit()
	return "npc_dota_creature_weaver"
end

--------------------------------------------------------------------------------

function CMapEncounter_TropicalKeep:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.szObjectiveEnts = "objective"
	self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	if #self.hObjectiveEnts == 0 then
		printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	end

	self.szAllyEnts = "spawner_ally"
	self.hAllyEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szAllyEnts, true )

	if #self.hAllyEnts == 0 then
		printf( "WARNING - self.hAllyEnts is nil (looked for classname \"%s\")", self.szAllyEnts )
	else
		local hAllyEnt = self.hAllyEnts[1]
		self.hAlly = CreateUnitByName( "npc_dota_creature_friendly_radiant_guard", hAllyEnt:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
		if self.hAlly then 
			local nLevel = self:GetRoom():GetEliteRank() + GameRules.Aghanim:GetAscensionLevel()
			self.hAlly:CreatureLevelUp( nLevel )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TropicalKeep:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_TropicalKeep:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_TropicalKeep:OnSpawnerFinished( hSpawner, hSpawnedUnits )
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

function CMapEncounter_TropicalKeep:OnTriggerStartTouch( event )
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

function CMapEncounter_TropicalKeep:OnComplete()
	CMapEncounter.OnComplete( self )

	-- If tower is still alive, grant some rewards
	if self.hAlly ~= nil and ( not self.hAlly:IsNull() ) and self.hAlly:IsAlive() then
		self.hAlly:Heal( self.hAlly:GetMaxHealth(), nil )
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/plus/high_five/high_five_lvl3_overhead_hearts.vpcf", PATTACH_OVERHEAD_FOLLOW, self.hAlly )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nLives = 1
		for i = 1, nLives do
			self:DropLifeRuneFromUnit( self.hAlly, nil, true )
		end

		self.hAlly.bStartRescue = true
		self.hAlly.nRescueGoldAmount = 0
		self.hAlly.szGoalEntity = "objective"
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_TropicalKeep
