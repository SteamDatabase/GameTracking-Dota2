require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_FrigidPinnacle == nil then
	CMapEncounter_FrigidPinnacle = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bBossSpawned = false
	self.bInitialSpawn = true

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedFodder =
		{
			SpawnerName = "spawner_preplaced_wolves",
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
		PrePlacedCaptain1 =
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

		-- BOSS
		Boss =
		{
			SpawnerName = "spawner_boss",
			Count = 1,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain1",
					HealthPercent = 75.0,
				},
			},
		},

		-- BOSS WAVE 1
		Wave1Wolves =
		{
			SpawnerName = "portal_wolf_1",
			Count = 2,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Boss",
					HealthPercent = 75,
				},
			},
		},
		Wave1Captains =
		{
			SpawnerName = "portal_captain_1",
			Count = 2,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Boss",
					HealthPercent = 75,
				},
			},
		},

		-- RETREAT WAVE
		RetreatWaveWolves =
		{
			SpawnerName = "portal_wolf_1",
			Count = 4,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Boss",
					HealthPercent = 50,
				},
			},
		},		
		RetreatWaveCaptains =
		{
			SpawnerName = "portal_captain_1",
			Count = 1,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Boss",
					HealthPercent = 50,
				},
			},
		},

		-- BOSS WAVE 2
		Wave2Wolves =
		{
			SpawnerName = "portal_wolf_2",
			Count = 3,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Boss",
					HealthPercent = 25,
				},
			},
		},
		Wave2Captains =
		{
			SpawnerName = "portal_captain_2",
			Count = 2,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Boss",
					HealthPercent = 25,
				},
			},
		},
	}

	local bInvulnerable = true

	-- boss
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_boss", "spawner_boss", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_crystal_maiden_miniboss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_wolves", "spawner_wolf", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ice_wolf",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 400.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_vengeful_spirit_captain",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- boss portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_wolf_1", "portal_wolf_1", 8, 3, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ice_wolf",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 400.0,
			},
		}, bInvulnerable ) )
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_captain_1", "portal_captain_1", 8, 3, 1.0,
		{
			{
				EntityName = "npc_dota_creature_vengeful_spirit_captain",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_wolf_2", "portal_wolf_2", 8, 3, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ice_wolf",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 400.0,
			},
		}, bInvulnerable ) )
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_captain_2", "portal_captain_2", 8, 3, 1.0,
		{
			{
				EntityName = "npc_dota_creature_vengeful_spirit_captain",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:GetPreviewUnit()
	return "npc_dota_creature_crystal_maiden_miniboss"
end

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
	--self.bBossSpawned = true
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_FrigidPinnacle:GetMaxSpawnedUnitCount()

	-- count the crystal maiden
	local nCount = 1
	local nSkeletonSpawnersToUse = self.nSkeletonSpawnersToUse
	local nSkeletonSpawnerIncrement = self.nSkeletonSpawnerIncrement

	-- count the pre-placed skeletons
	local peonSpawners = self:GetSpawner( "spawner_peon" )
	local nSkeletonSpawners = #peonSpawners
	local nSpawnedSkeletons = self:GetSpawner( "spawner_peon" ):GetSpawnCountPerSpawnPosition()
	nCount = nCount + ( nSkeletonSpawners * nSpawnedSkeletons )

	-- drow is set to go invis 3 times and spawn an increasing number of skeletons
	for i = 1, 3 do
		local nSkeletonsPerSpawn = self:GetPortalSpawnerV2( "dynamic_portal" ):GetSpawnCountPerSpawnPosition()
		nCount = nCount + ( nSkeletonSpawnersToUse * nSkeletonsPerSpawn )
		nSkeletonsPerSpawn = nSkeletonsPerSpawn + nSkeletonSpawnerIncrement
	end

	print( 'CMapEncounter_FrigidPinnacle:GetMaxSpawnedUnitCount() - max unit count is ' .. nCount )

	return nCount
end
]]--

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	print( 'CMapEncounter_FrigidPinnacle:OnSpawnerFinished()!' )
	if hSpawner:GetSpawnerName() == "spawner_boss" then
		print( 'BOSS SPAWNED!' )
		for _,hUnit in pairs ( hSpawnedUnits ) do
			if hUnit then
				--hUnit:AddNewModifier( hUnit, nil, "modifier_provide_vision", { duration = -1 } )
				self.bBossSpawned = true
				self.hBoss = hUnit
				self.hBoss.AI:SetEncounter( self )
			end
		end
	end
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_FrigidPinnacle:OnCrystalMaidenColdEmbrace()
	print( 'CMapEncounter_FrigidPinnacle:OnCrystalMaidenColdEmbrace()' )

	-- Set the spawned units to target the heroes
	self.bInitialSpawn = false

	self:GetPortalSpawnerV2( "portal_peon" ):SpawnUnitsFromRandomSpawners( self.nSkeletonSpawnersToUse )
	self.nSkeletonSpawnersToUse = self.nSkeletonSpawnersToUse + self.nSkeletonSpawnerIncrement
end
]]--

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	if szTriggerName == "pinnacle_entrance" then
		print( "^^^Pinnacle entrance touched!" )
		if self.hBoss ~= nil and self.hBoss:IsNull() == false and self.hBoss:IsAlive() == true then
			self.hBoss.AI:OnPlayerTouchedPinnacleTrigger()
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_FrigidPinnacle:CheckForCompletion()
	--print( 'CMapEncounter_FrigidPinnacle:CheckForCompletion() )
	if self.bBossSpawned and not self:HasRemainingEnemies() then
		return true
	end
	return false
end


--------------------------------------------------------------------------------

return CMapEncounter_FrigidPinnacle
