
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_BigOgres == nil then
	CMapEncounter_BigOgres = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_BigOgres:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"

	self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_ogre_seer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 150.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_ogre_tank_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self.vMagiSchedule =
	{
		{
			Time = 15,
			Count = 1,
		},
		{
			Time = 40,
			Count = 2,
		},
		{
			Time = 55,
			Count = 3,
		},
	}

	local bInvulnerable = true

	self.szDynamicPortal = "dynamic_portal"
	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szDynamicPortal, self.szDynamicPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ogre_seer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szDynamicPortal, self.vMagiSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_BigOgres:GetPreviewUnit()
	return "npc_dota_creature_ogre_tank"
end

--------------------------------------------------------------------------------

function CMapEncounter_BigOgres:Start()
	CMapEncounter.Start( self )

	for _, hSpawner in pairs( self:GetSpawners() ) do
		hSpawner:SpawnUnits()
	end

	self:StartSpawnerSchedule( self.szDynamicPortal, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BigOgres:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_BigOgres:OnSpawnerFinished" )
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

return CMapEncounter_BigOgres
