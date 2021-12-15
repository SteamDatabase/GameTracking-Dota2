
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_DarkForest == nil then
	CMapEncounter_DarkForest = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bBossSpawned = false

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_treant", "spawner_boss",
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_bears", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_forest_bear",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
		}, true
	) )

	self.nBearSpawnersToUse	= 4
	self.nBearSpawnerIncrement = 2
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:GetPreviewUnit()
	return "npc_dota_creature_treant_miniboss"
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:Start()
	CMapEncounter.Start( self )

	self.bBossSpawned = true
	self:GetSpawner( "spawner_treant" ):SpawnUnits()
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerName() == "spawner_treant" then
		for _,hUnit in pairs ( hSpawnedUnits ) do
			if hUnit then
				hUnit.AI:SetEncounter( self )
			end
		end
	else
		local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
		if #heroes > 0 then
			for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
				local hero = heroes[RandomInt(1, #heroes)]
				if hero ~= nil then
					--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
					hSpawnedUnit:SetInitialGoalEntity( hero )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:GetMaxSpawnedUnitCount()
	-- count the miniboss
	local nCount = 1
	local nBearSpawnersToUse = self.nBearSpawnersToUse
	local nBearSpawnerIncrement = self.nBearSpawnerIncrement

	-- miniboss is set to escape 3 times and spawn an increasing number of bears
	for i = 1, 3 do
		local nBearsPerSpawn = self:GetPortalSpawnerV2( "spawner_bears" ):GetSpawnCountPerSpawnPosition()
		nCount = nCount + ( nBearSpawnersToUse * nBearsPerSpawn )
		nBearsPerSpawn = nBearsPerSpawn + nBearSpawnerIncrement
	end

	print( 'CMapEncounter_DarkForest:GetMaxSpawnedUnitCount() - max unit count is ' .. nCount )

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:OnTreantMinibossEscape()
	print( 'CMapEncounter_DarkForest:OnTreantMinibossEscape()' )

	printf( "self.nBearSpawnersToUse == %d", self.nBearSpawnersToUse )
	if self:GetPortalSpawnerV2( "spawner_bears" ) == nil then
		printf( "ERROR - CMapEncounter_DarkForest:OnTreantMinibossEscape - no portalspawner named \"spawner_peon\" found" )
	end

	self:GetPortalSpawnerV2( "spawner_bears" ):SpawnUnitsFromRandomSpawners( self.nBearSpawnersToUse )
	self.nBearSpawnersToUse = self.nBearSpawnersToUse + self.nBearSpawnerIncrement
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkForest:CheckForCompletion()
	if self.bBossSpawned and not self:HasRemainingEnemies() then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

return CMapEncounter_DarkForest
