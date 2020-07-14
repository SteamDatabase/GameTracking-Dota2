require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Wildwings == nil then
	CMapEncounter_Wildwings = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )
	
	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"

	self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_wildwing_laborer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 225.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_dazzle",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	local flInitialPortalSpawnDelay = 0.0
	local flInitialSummonTime = 30.0
	local flPortalIntervalInput = DEFAULT_PORTAL_SPAWN_INTERVAL
	local flScaleInput = 1.0
	self.nNumPortals = 4

	for i=1,self.nNumPortals do
		local name = string.format( "portal_%i", i )

		self:AddPortalSpawner( CPortalSpawner( name, "dynamic_portal", 60 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_creature_wildwing_laborer",
					Team = DOTA_TEAM_BADGUYS,
					Count = 3,
					PositionNoise = 0.0,
				},
				{
					EntityName = "npc_dota_creature_dazzle",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 0.0,
				},

		} ) )
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "destroy_spawning_portals", 0, self.nNumPortals )
end

--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:GetPreviewUnit()
	return "npc_dota_creature_dazzle"
end

--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:GetMaxSpawnedUnitCount()
	local nCount = 0
	local hWarriorSpawners = self:GetSpawner( self.szPeonSpawner )
	if hWarriorSpawners then
		nCount = nCount + hWarriorSpawners:GetSpawnPositionCount() * 4 --* self.nWaves
	end

	local hChampionSpawners = self:GetSpawner( self.szCaptainSpawner )
	if hChampionSpawners then
		nCount = nCount + hChampionSpawners:GetSpawnPositionCount() --* self.nWaves
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Wildwings:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Wildwings:OnSpawnerFinished" )
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

--------------------------------------------------------------------------------

return CMapEncounter_Wildwings
