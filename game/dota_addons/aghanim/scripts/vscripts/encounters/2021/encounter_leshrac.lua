
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Leshrac == nil then
	CMapEncounter_Leshrac = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:Precache( context )
	CMapEncounter.Precache( self, context )
	--PrecacheResource( "particle", "particles/neutral_fx/troll_heal.vpcf", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_leshrac", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )
	PrecacheResource( "particle", "particles/econ/events/plus/high_five/high_five_lvl3_overhead_hearts.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:constructor( hRoom, szEncounterName )

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
			Count = 2,
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
			SpawnerName = "wave_3",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2",
					KillPercent = 50,
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
			Count = 3,
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

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creep_nemestice_mega_melee_dire",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_leshrac",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creep_nemestice_mega_melee_dire",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_leshrac",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creep_nemestice_mega_melee_dire",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_leshrac",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creep_nemestice_mega_melee_dire",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_leshrac",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_leshrac", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )
	PrecacheUnitByNameSync( "npc_dota_holdout_tower", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:GetPreviewUnit()
	return "npc_dota_creature_leshrac"
end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.szObjectiveEnts = "objective"
	self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	if #self.hObjectiveEnts == 0 then
		printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	end

	self.hTower = CreateUnitByName( "npc_dota_holdout_tower", self.hObjectiveEnts[1]:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )

	if self.hTower ~= nil then
		--self.hTower:SetForwardVector( RandomVector( 1 ) )
		self.vGoalPos = self.hTower:GetAbsOrigin()
		self.hTower.Encounter = self
	else
		printf( "WARNING - Failed to spawn Tower!" )
		return
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Leshrac:OnSpawnerFinished( hSpawner, hSpawnedUnits )
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

function CMapEncounter_Leshrac:OnTriggerStartTouch( event )
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

function CMapEncounter_Leshrac:OnComplete()
	CMapEncounter.OnComplete( self )

	-- If tower is still alive, grant some rewards
	if self.hTower ~= nil and ( not self.hTower:IsNull() ) and self.hTower:IsAlive() then
		self.hTower:Heal( self.hTower:GetMaxHealth(), nil )
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/plus/high_five/high_five_lvl3_overhead_hearts.vpcf", PATTACH_OVERHEAD_FOLLOW, self.hTower )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nLives = 1
		for i = 1, nLives do
			self:DropLifeRuneFromUnit( self.hTower, nil, true )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Leshrac
