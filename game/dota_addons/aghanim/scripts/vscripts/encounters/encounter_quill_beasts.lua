
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_QuillBeasts == nil then
	CMapEncounter_QuillBeasts = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_QuillBeasts:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_creature_dire_hound",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 225.0,
			}
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain_trigger", "spawner_captain_trigger",
		{
			{
				EntityName = "npc_dota_creature_dire_hound_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 225.0,
			}
		} ) )

	self:SetPortalTriggerSpawner( "spawner_captain_trigger", 0.8 )

	self:SetSpawnerSchedule( "spawner_peon", { { Time = 0, Count = 8 } } )	-- spawn 8 units when triggered
	self:SetSpawnerSchedule( "spawner_captain_trigger", nil )	-- means spawn once when triggered 

	------------------------
	-- Dynamic Portals
	------------------------
	local nNumPortals_1 = 2
	local nNumPortals_2 = 3
	local nNumPortals_3 = 3
	local nNumPortals_4 = 3
	self.nTotalPortals = nNumPortals_1 + nNumPortals_2 + nNumPortals_3 + nNumPortals_4

	self.vWaveSchedule =
	{
		{
			Time = 0,
			Count = nNumPortals_1,
		},
		{
			Time = 15,
			Count = nNumPortals_2,
		},
		{
			Time = 30,
			Count = nNumPortals_3,
		},
		{
			Time = 45,
			Count = nNumPortals_4,
		},
	}

	local PortalUnits =
	{
		{
			EntityName = "npc_dota_creature_dire_hound",
			Team = DOTA_TEAM_BADGUYS,
			Count = 6,
			PositionNoise = 0.0,
		},
		{
			EntityName = "npc_dota_creature_dire_hound_boss",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0.0,
		},
	}

	local bInvulnerable = true

	local nHealth = 1
	local fSummonTime = 5
	local fModelScale = 1.0

	local szLocatorName = "dynamic_portal"
	local szName = szLocatorName

	self:AddPortalSpawnerV2( CPortalSpawnerV2( szName, szLocatorName, nHealth, fSummonTime, fModelScale,
		PortalUnits, bInvulnerable
	) )

	self:SetSpawnerSchedule( szLocatorName, self.vWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_QuillBeasts:GetPreviewUnit()
	return "npc_dota_creature_dire_hound_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_QuillBeasts:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_QuillBeasts:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_QuillBeasts:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_QuillBeasts:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	--print( "CMapEncounter_QuillBeasts:OnSpawnerFinished" )
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

return CMapEncounter_QuillBeasts
