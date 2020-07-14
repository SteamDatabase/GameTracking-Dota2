require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Mirana == nil then
	CMapEncounter_Mirana = class( {}, {}, CMapEncounter )
end

function CMapEncounter_Mirana:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- Initial Spawns
	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_creature_luna_mini",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 225.0,
			}
		} ) )

	-- Wave Spawns
	local vPeonSchedule =
	{
		{
			Time = 0,
			Count = 4,
		},
		{
			Time = 16,
			Count = 5,
		},
		{
			Time = 32,
			Count = 5,
		},
		{
			Time = 48,
			Count = 5,
		},
		{
			Time = 64,
			Count = 6,
		},
		{
			Time = 80,
			Count = 6,
		},
	}
	local vCaptainSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
		{
			Time = 16,
			Count = 2,
		},
		{
			Time = 32,
			Count = 2,
		},
		{
			Time = 48,
			Count = 2,
		},
		{
			Time = 64,
			Count = 2,
		},
		{
			Time = 80,
			Count = 3,
		},
	}

	local nPeonPortalHealth = 10 * hRoom:GetDepth()

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_v2_peon", "portal_v2_peon", nPeonPortalHealth, 8, 0.7,
		{
			{
				EntityName = "npc_dota_creature_luna_mini",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		} ), vPeonSchedule )

	local nCaptainPortalHealth = 30 * hRoom:GetDepth()

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_v2_captain", "portal_v2_captain", nCaptainPortalHealth, 8, 1.3,
		{
			{
				EntityName = "npc_dota_creature_mirana",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ), vCaptainSchedule )

	self:SetSpawnerSchedule( "spawner_peon", { { Time = 0, Count = 12 } } ) 
	self:SetSpawnerSchedule( "portal_v2_peon", vPeonSchedule )
	self:SetSpawnerSchedule( "portal_v2_captain", vCaptainSchedule )

end

--------------------------------------------------------------------------------

function CMapEncounter_Mirana:GetPreviewUnit()
	return "npc_dota_creature_mirana"
end

--------------------------------------------------------------------------------

function CMapEncounter_Mirana:Start()
	CMapEncounter.Start( self )

	self:StartSpawnerSchedule( "spawner_peon", 0 )
	self:StartSpawnerSchedule( "portal_v2_peon", 4 )
	self:StartSpawnerSchedule( "portal_v2_captain", 4 )

end

--------------------------------------------------------------------------------

function CMapEncounter_Mirana:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Hellbears:OnSpawnerFinished " )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		local hero = heroes[RandomInt(1, #heroes)]
		if hero ~= nil then
			--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
			hSpawnedUnit:SetInitialGoalEntity( hero )
		else
			print( "WARNING: Can't find a living hero and the objective entitiy is missing!" )
		end
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_Mirana
