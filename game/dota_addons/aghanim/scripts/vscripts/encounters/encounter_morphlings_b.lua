
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Morphlings_B == nil then
	CMapEncounter_Morphlings_B = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.szPeonSpawner = "spawner_peon"

	self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{
			{
				EntityName = "npc_dota_creature_tiny_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 225.0,
			},
		} ) )

	self.szPeonPortalV2 = "portal_v2_peon"
	self.szCaptainPortalV2 = "portal_v2_captain"

	local vPeonSchedule =
	{
		{
			Time = 6,
			Count = 4,
		},
		{
			Time = 26,
			Count = 5,
		},
		{
			Time = 46,
			Count = 6,
		},
		{
			Time = 66,
			Count = 7,
		},
	}

	self.vCaptainSchedule =
	{
		{
			Time = 6,
			Count = 2,
		},
		{
			Time = 26,
			Count = 3,
		},
		{
			Time = 46,
			Count = 3,
		},
		{
			Time = 66,
			Count = 4,
		},
	}

	-- szSpawnerNameInput, nPortalHealthInput, flSummonTimeInput, flScaleInput, rgUnitsInfoInput

	local nSmallPortalHealth = 10 * hRoom:GetDepth()
	local nBigPortalHealth = 35 * hRoom:GetDepth()

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szPeonPortalV2, self.szPeonPortalV2, nSmallPortalHealth, 6, 0.7,
		{
			{
				EntityName = "npc_dota_creature_tiny_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szCaptainPortalV2, self.szCaptainPortalV2, nBigPortalHealth, 6, 1.3,
		{
			{
				EntityName = "npc_dota_creature_morphling_big",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:SetSpawnerSchedule( self.szPeonPortalV2, vPeonSchedule )
	self:SetSpawnerSchedule( self.szCaptainPortalV2, self.vCaptainSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:InitializeObjectives()
	--CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "destroy_spawning_portals", 0, 0 )
	self:AddEncounterObjective( "survive_waves", 0, #self.vCaptainSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:GetMaxSpawnedUnitCount()
	local nCount = 0
	-- Standing trash
	local hPeonSpawners = self:GetSpawner( "spawner_peon")
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount() * 2
	end
	-- Peons = 88
	nCount = nCount + 88
	-- Captains = 24
	nCount = nCount + 24
	-- Total should be 124
	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:OnPortalV2Killed( hVictim, hAttacker, nUnitCountSuppressed )
	CMapEncounter.OnPortalV2Killed( self, hVictim, hAttacker, nUnitCountSuppressed )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + nUnitCountSuppressed, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

------------

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:GetPreviewUnit()
	return "npc_dota_creature_morphling_big"
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:Start()
	CMapEncounter.Start( self )

	self:CreateUnits()

	self:StartAllSpawnerSchedules( 0 )	
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:CreateUnits()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Morphlings_B:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	if hSpawner.szSpawnerName == "portal_v2_captain" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	--print( "CMapEncounter_Morphlings_B:OnSpawnerFinished " )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		local hero = heroes[ RandomInt( 1, #heroes ) ]
		if hero ~= nil then
			--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
			hSpawnedUnit:SetInitialGoalEntity( hero )
		end
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_Morphlings_B
