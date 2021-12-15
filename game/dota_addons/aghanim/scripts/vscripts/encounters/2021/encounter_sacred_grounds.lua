require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_SacredGrounds == nil then
	CMapEncounter_SacredGrounds = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bBossSpawned = false
	self.bInitialSpawn = true

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_boss", "spawner_boss",
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_creature_drow_ranger_skeleton_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
		} ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "dynamic_portal", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_drow_ranger_skeleton_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
		}, true
	) )

	self.nSkeletonSpawnersToUse	= 4
	self.nSkeletonSpawnerIncrement = 2
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:GetPreviewUnit()
	return "npc_dota_creature_drow_ranger_miniboss"
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:Start()
	CMapEncounter.Start( self )

	self.bBossSpawned = true
	self:GetSpawner( "spawner_boss" ):SpawnUnits()
	self:GetSpawner( "spawner_peon" ):SpawnUnits()
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:GetMaxSpawnedUnitCount()

	-- count the drow ranger
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

	print( 'CMapEncounter_SacredGrounds:GetMaxSpawnedUnitCount() - max unit count is ' .. nCount )

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerName() == "spawner_boss" then
		for _,hUnit in pairs ( hSpawnedUnits ) do
			if hUnit then
				--hUnit:AddNewModifier( hUnit, nil, "modifier_provide_vision", { duration = -1 } )
				hUnit.AI:SetEncounter( self )
			end
		end
	else
		if self.bInitialSpawn == false then
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
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:KillSkeletons()
	local vecSkeletons = self:GetSpawnedSecondaryUnits()
	print( 'Trying to kill ' .. #vecSkeletons .. " Skeletons")
	if #vecSkeletons > 0 then
		for _,hSkeleton in pairs ( vecSkeletons ) do
			print( 'Attempting to kill skeleton' )
			hSkeleton:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:OnDrowShadowBladed()
	print( 'CMapEncounter_SacredGrounds:OnDrowShadowBladed()' )

	--self:KillSkeletons()
	-- Set the spawned units to target the heroes
	self.bInitialSpawn = false

	self:GetPortalSpawnerV2( "dynamic_portal" ):SpawnUnitsFromRandomSpawners( self.nSkeletonSpawnersToUse )
	self.nSkeletonSpawnersToUse = self.nSkeletonSpawnersToUse + self.nSkeletonSpawnerIncrement
end

--------------------------------------------------------------------------------

function CMapEncounter_SacredGrounds:CheckForCompletion()
	--print( 'CMapEncounter_SacredGrounds:CheckForCompletion() )
	if self.bBossSpawned and not self:HasRemainingEnemies() then
		return true
	end
	return false
end


--------------------------------------------------------------------------------

return CMapEncounter_SacredGrounds
