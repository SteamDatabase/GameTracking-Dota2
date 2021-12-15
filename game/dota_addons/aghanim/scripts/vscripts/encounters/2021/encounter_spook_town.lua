
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_SpookTown == nil then
	CMapEncounter_SpookTown = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/destruction/candy_well_destruction.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/candy_well/bucket_soldier_leash.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_dire_hulk_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_right.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_dire_hulk_swipe_left.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_radiant_hulk_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_right.vpcf", context )
	PrecacheResource( "particle", "particles/creeps/lane_creeps/creep_radiant_hulk_swipe_left.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_creature_bucket_soldier", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bInitialSpawn = true
	self.nCandyWells = 1
	self.nCandyWellsDestroyed = 0
	self.bAllWavesSpawned = false
	self.nBucketGuardsSpawned = 0

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
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
		PrePlacedCaptain =
		{
			SpawnerName = "spawner_preplaced_captain",
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
		CandyWell =
		{
			SpawnerName = "spawner_candy_well",
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

		Wave1 =
		{
			SpawnerName = "wave_1",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "CandyWell",
					HealthPercent = 50,
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
					KillPercent = 50,
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
					KillPercent = 50,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_assault_captain_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_ogre_seal_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_candy_well", "spawner_candy_well", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_building_candy_well",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_assault_captain_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_large_ogre_seal_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_assault_captain_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_large_ogre_seal_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_wave_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dire_assault_captain_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_large_ogre_seal_diretide",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
	
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:GetPreviewUnit()
	return "npc_dota_creature_large_ogre_seal_diretide"
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self.nEnemies = self:GetMaxSpawnedUnitCount()
	self:AddEncounterObjective( "defeat_all_enemies", 0, self.nEnemies )
	self:AddEncounterObjective( "destroy_candy_well", self.nCandyWellsDestroyed, self.nCandyWells )
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:CheckForCompletion()
	local nCurrentEnemyValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	local nCurrentCandyWellValue = self:GetEncounterObjectiveProgress( "destroy_candy_well" )
	if self.bAllWavesSpawned == true then
		if ( nCurrentCandyWellValue == self.nCandyWells ) and nCurrentEnemyValue >= self.nEnemies then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:OnEnemyCreatureSpawned( hEnemyCreature ) 
	CMapEncounter.OnEnemyCreatureSpawned( self, hEnemyCreature )

	if hEnemyCreature == nil then 
		return 
	end

	if hEnemyCreature:GetUnitName() == "npc_dota_creature_bucket_soldier" then 
		self.nBucketGuardsSpawned = self.nBucketGuardsSpawned + 1
		self.nEnemies = self.nEnemies + 1 
		self:UpdateEncounterObjective( "defeat_all_enemies", self:GetEncounterObjectiveProgress( "defeat_all_enemies" ), self.nEnemies )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:GetMaxSpawnedUnitCount()
	-- local nCount = 0

	-- local hPeonSpawners = self:GetSpawner( "spawner_peon")
	-- if hPeonSpawners then
	-- 	nCount = nCount + ( 4 * 2 )
	-- end
	-- local hCaptainSpawners = self:GetSpawner( "spawner_captain")
	-- if hCaptainSpawners then
	-- 	nCount = nCount + 2
	-- end
	-- local hWave1Spawners = self:GetSpawner( "spawner_wave_1")
	-- if hCaptainSpawners then
	-- 	nCount = nCount + ( 2 * 3 )
	-- end
	-- local hWave2Spawners = self:GetSpawner( "spawner_wave_2")
	-- if hCaptainSpawners then
	-- 	nCount = nCount + ( 2 * 4 )
	-- end
	-- local hWave3Spawners = self:GetSpawner( "spawner_wave_3")
	-- if hCaptainSpawners then
	-- 	nCount = nCount + ( 3 * 3 )
	-- end

	local nCount = 33 + self.nBucketGuardsSpawned
	print( "Number of spawned enemies = " .. nCount )
	return nCount 
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szLocatorName == "spawner_wave_3" then
		-- Hack for completion to wait until all spawners have completed
		self.bAllWavesSpawned = true
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SpookTown:OnEntityKilled( event )
	CMapEncounter.OnEntityKilled( self, event )

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then
		return
	end

	if killedUnit:GetUnitName() =="npc_dota_building_candy_well" then
		self.nCandyWellsDestroyed = 1
		self:UpdateEncounterObjective( "destroy_candy_well", self.nCandyWellsDestroyed, self.nCandyWells )
		
		EmitSoundOn( "Building_DireTower.Destruction", killedUnit )
		killedUnit:AddEffects( EF_NODRAW )
		local nFXIndex = ParticleManager:CreateParticle( "particles/destruction/candy_well_destruction.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, killedUnit, PATTACH_ABSORIGIN, nil, killedUnit:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_SpookTown
