
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

LinkLuaModifier( "modifier_restorative_flower_thinker", "modifiers/creatures/modifier_restorative_flower_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CMapEncounter_SwampOfSadness == nil then
	CMapEncounter_SwampOfSadness = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_SwampOfSadness:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.nMaxFlowers = 5

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedBugs1 =
		{
			SpawnerName = "spawner_preplaced_bugs_1",
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
		PrePlacedBugs2 =
		{
			SpawnerName = "spawner_preplaced_bugs_2",
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
		PrePlacedBugs3 =
		{
			SpawnerName = "spawner_preplaced_bugs_3",
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
		PrePlacedBugs4 =
		{
			SpawnerName = "spawner_preplaced_bugs_4",
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


		Wave1 =
		{
			SpawnerName = "wave_1",
			Count = 2,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBugs1",
					KillPercent = 30,
				},
			},
		},
		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBugs2",
					KillPercent = 30,
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
					TriggerAfterWave = "PrePlacedBugs3",
					KillPercent = 30,
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
					TriggerAfterWave = "PrePlacedBugs4",
					KillPercent = 30,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_bugs_1", "bugs_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_bug",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 300.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_bugs_2", "bugs_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_bug",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 300.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_bugs_3", "bugs_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_bug",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 300.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_bugs_4", "bugs_4", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_bug",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 300.0,
			},
		}, bInvulnerable ) )

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_bug",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_venomancer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_venomancer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "wave_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_bug",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_venomancer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4", "wave_4", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_swamp_bug",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_swamp_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_venomancer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )
	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_SwampOfSadness:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_restorative_flower", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_SwampOfSadness:GetPreviewUnit()
	return "npc_dota_creature_venomancer"
end

--------------------------------------------------------------------------------

function CMapEncounter_SwampOfSadness:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	--self.szObjectiveEnts = "objective"
	--self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	--if #self.hObjectiveEnts == 0 then
	--	printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	--end

	GameRules:SetRiverPaint( 3, 50000 )

	self.SpawnedFlowers = {}

	self.nNumFlowers = 0

	local hSpawners = self:GetRoom():FindAllEntitiesInRoomByName( 'flower_spawner', false )
	ShuffleListInPlace( hSpawners, self:GetRoom():GetRoomRandomStream() )
	for i, hSpawner in pairs( hSpawners ) do
		local vSpawnLoc = hSpawner:GetOrigin()

		local vAngles = VectorAngles( RandomVector( 1 ) )
		local flowerTable = 
		{ 	
			MapUnitName = 'npc_dota_restorative_flower', 
			origin = tostring( vSpawnLoc.x ) .. " " .. tostring( vSpawnLoc.y ) .. " " .. tostring( vSpawnLoc.z ),
			angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z ),
			teamnumber = DOTA_TEAM_BADGUYS,
			NeverMoveToClearSpace = false,
		}
		local hUnit = CreateUnitFromTable( flowerTable, vSpawnLoc )
		if hUnit ~= nil then
			local hAbility = hUnit:FindAbilityByName( "aghsfort_restorative_flower" )
			hAbility:UpgradeAbility( true )

			table.insert( self.SpawnedFlowers, hUnit )

			printf( "^^^Spawned flower" )
			self.nNumFlowers = self.nNumFlowers + 1
			if self.nNumFlowers >= self.nMaxFlowers then
				print( 'MAX FLOWERS SPAWNED!' )
				goto continue
			end
		end
	end

	::continue::

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_SwampOfSadness:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_SwampOfSadness:Start()!' )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_aghsfort_swamp_sickness", { duration = -1, slow_percent = 30 } )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SwampOfSadness:OnComplete()
	CMapEncounter.OnComplete( self )

	GameRules:ClearRiverPaint()

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero and not hPlayerHero:IsNull() and hPlayerHero:IsRealHero() then 
			hPlayerHero:RemoveModifierByName( "modifier_aghsfort_swamp_sickness" )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SwampOfSadness:DestroyRemainingSpawnedUnits()
	CMapEncounter.DestroyRemainingSpawnedUnits( self )

	for k, hFlower in pairs ( self.SpawnedFlowers ) do
		UTIL_Remove( hFlower )
		self.SpawnedFlowers[ k ] = nil
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_SwampOfSadness
