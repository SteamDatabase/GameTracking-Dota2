require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Hellbears == nil then
	CMapEncounter_Hellbears = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )
	
	local flInitialPortalSpawnDelay = 0.0
	local flInitialSummonTime = 5.0
	local flPortalIntervalInput = DEFAULT_PORTAL_SPAWN_INTERVAL
	local flScaleInput = 1.0
	local nNumPortals = 4

	for i=1,nNumPortals do
		local name = string.format( "portal_%i", i )

		self:AddPortalSpawner( CPortalSpawner( name, "dynamic_portal", 60 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_creature_small_hellbear",
					Team = DOTA_TEAM_BADGUYS,
					Count = 4,
					PositionNoise = 0.0,
				},
				{
					EntityName = "npc_dota_creature_hellbear",
					Team = DOTA_TEAM_BADGUYS,
					Count = 2,
					PositionNoise = 0.0,
				},

		} ) )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:GetPreviewUnit()
	return "npc_dota_creature_hellbear"
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:GetMaxSpawnedUnitCount()
	local nCount = 0
	local hWarriorSpawners = self:GetSpawner( self.szPeonSpawner )
	if hWarriorSpawners then
		nCount = nCount + hWarriorSpawners:GetSpawnPositionCount() * 4
	end

	local hChampionSpawners = self:GetSpawner( self.szCaptainSpawner )
	if hChampionSpawners then
		nCount = nCount + hChampionSpawners:GetSpawnPositionCount() * 2
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	--print( "CMapEncounter_Hellbears:OnSpawnerFinished" )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes > 0 then
		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
			local hero = heroes[RandomInt(1, #heroes)]
			if hero ~= nil then
				--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			else
				print( "CMapEncounter_Hellbears:OnSpawnerFinished: WARNING: Can't find a living hero" )
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Hellbears
