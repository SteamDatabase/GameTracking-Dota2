require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Hellbears == nil then
	CMapEncounter_Hellbears = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vPeonSchedule =
	{
		{
			Time = 6,
			Count = 3,
		},
		{
			Time = 14,
			Count = 3,
		},
		{
			Time = 22,
			Count = 3,
		},
		{
			Time = 38,
			Count = 3,
		},
		{
			Time = 46,
			Count = 3,
		},
		{
			Time = 62,
			Count = 4,
		},
		{
			Time = 70,
			Count = 4,
		},
		{
			Time = 78,
			Count = 4,
		},
	}
	self.vCaptainSchedule =
	{
		{
			Time = 6,
			Count = 1,
		},
		{
			Time = 14,
			Count = 2,
		},
		{
			Time = 22,
			Count = 2,
		},
		{
			Time = 38,
			Count = 2,
		},
		{
			Time = 46,
			Count = 2,
		},
		{
			Time = 62,
			Count = 3,
		},
		{
			Time = 70,
			Count = 3,
		},
		{
			Time = 78,
			Count = 3,
		},
	}

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_creature_small_hellbear",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 225.0,
			}
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain_trigger", "spawner_captain_trigger",
		{
			{
				EntityName = "npc_dota_creature_hellbear",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 225.0,
			}
		} ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_v2_peon", "portal_v2_peon", 16, 8, 0.8,
		{
			{
				EntityName = "npc_dota_creature_small_hellbear",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_v2_captain", "portal_v2_captain", 70, 8, 1.5,
		{
			{
				EntityName = "npc_dota_creature_hellbear",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:SetPortalTriggerSpawner( "spawner_captain_trigger", 0.5 )

	self:SetSpawnerSchedule( "spawner_peon", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_captain_trigger", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "portal_v2_peon", self.vPeonSchedule )
	self:SetSpawnerSchedule( "portal_v2_captain", self.vCaptainSchedule )
end


--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:GetPreviewUnit()
	return "npc_dota_creature_hellbear"
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:Start()
	CMapEncounter.Start( self )

	local spawnerFocusPath = self:GenerateSpawnFocusPath( "portal_v2_captain", 300, 1000 )
	self:AssignSpawnFocusPath( "portal_v2_peon", spawnerFocusPath )
	self:AssignSpawnFocusPath( "portal_v2_captain", spawnerFocusPath )

	self:StartAllSpawnerSchedules( 0 )	

end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:InitializeObjectives()
	--CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "destroy_spawning_portals", 0, 0 )
	self:AddEncounterObjective( "survive_waves", 0, #self.vCaptainSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:OnPortalV2Killed( hVictim, hAttacker, nUnitCountSuppressed )
	CMapEncounter.OnPortalV2Killed( self, hVictim, hAttacker, nUnitCountSuppressed )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + nUnitCountSuppressed, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hellbears:OnSpawnerFinished( hSpawner, hSpawnedUnits )
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

	--print( "CMapEncounter_Hellbears:OnSpawnerFinished " )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		local hero = heroes[RandomInt(1, #heroes)]
		if hero ~= nil then
			--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
			hSpawnedUnit:SetInitialGoalEntity( hero )
		end
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_Hellbears
