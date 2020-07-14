
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Pinecones == nil then
	CMapEncounter_Pinecones = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pinecones:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	------------------------
	-- Pre-placed units
	------------------------
	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_pinecone_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 200.0,
			}
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain_trigger", "spawner_captain_trigger",
		{
			{
				EntityName = "npc_dota_pinecone_champion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 200.0,
			}
		} ) )

	self:SetPortalTriggerSpawner( "spawner_captain_trigger", 0.8 )
	self:SetSpawnerSchedule( "spawner_peon", { { Time = 0, Count = 16 } } )	-- spawn N units when triggered
	self:SetSpawnerSchedule( "spawner_captain_trigger", nil )	-- means spawn once when triggered 

	------------------------
	-- WAVE: A
	------------------------
	local nNumPortals = 1
	self.nTotalPortals = nNumPortals

	self.vWaveSchedule_A =
	{
		{
			Time = 0,
			Count = nNumPortals,
		},
	}

	local PortalUnits_A =
	{
		{
			EntityName = "npc_dota_pinecone_warrior",
			Team = DOTA_TEAM_BADGUYS,
			Count = 4,
			PositionNoise = 200.0,
		},
		{
			EntityName = "npc_dota_pinecone_champion",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 200.0,
		},
	}

	local bInvulnerable = true

	local nHealth = 1
	local fSummonTime = 5
	local fModelScale = 1.0

	local szLocatorNameA = "dynamic_portal_a"
	local szNameA = szLocatorNameA

	self:AddPortalSpawnerV2( CPortalSpawnerV2( szNameA, szLocatorNameA, nHealth, fSummonTime, fModelScale,
		PortalUnits_A, bInvulnerable
	) )

	self:SetSpawnerSchedule( szLocatorNameA, self.vWaveSchedule_A )

	------------------------
	-- WAVE: B
	------------------------
	nNumPortals = 2
	self.nTotalPortals = self.nTotalPortals + nNumPortals

	self.vWaveSchedule_B =
	{
		{
			Time = 15,
			Count = nNumPortals,
		},
	}

	local PortalUnits_B =
	{
		{
			EntityName = "npc_dota_pinecone_warrior",
			Team = DOTA_TEAM_BADGUYS,
			Count = 5,
			PositionNoise = 200.0,
		},
		{
			EntityName = "npc_dota_pinecone_champion",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 200.0,
		},
	}

	local szLocatorNameB = "dynamic_portal_b"
	local szNameB = szLocatorNameB

	self:AddPortalSpawnerV2( CPortalSpawnerV2( szNameB, szLocatorNameB, nHealth, fSummonTime, fModelScale,
		PortalUnits_B, bInvulnerable
	) )

	self:SetSpawnerSchedule( szLocatorNameB, self.vWaveSchedule_B )

	------------------------
	-- WAVE: C
	------------------------
	nNumPortals = 3
	self.nTotalPortals = self.nTotalPortals + nNumPortals

	self.vWaveSchedule_C =
	{
		{
			Time = 30,
			Count = nNumPortals,
		},
	}

	local PortalUnits_C =
	{
		{
			EntityName = "npc_dota_pinecone_warrior",
			Team = DOTA_TEAM_BADGUYS,
			Count = 7,
			PositionNoise = 200.0,
		},
		{
			EntityName = "npc_dota_pinecone_champion",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 200.0,
		},
	}

	local szLocatorNameC = "dynamic_portal_c"
	local szNameC = szLocatorNameC

	self:AddPortalSpawnerV2( CPortalSpawnerV2( szNameC, szLocatorNameC, nHealth, fSummonTime, fModelScale,
		PortalUnits_C, bInvulnerable
	) )

	self:SetSpawnerSchedule( szLocatorNameC, self.vWaveSchedule_C )
end

--------------------------------------------------------------------------------


function CMapEncounter_Pinecones:GetPreviewUnit()
	return "npc_dota_pinecone_champion"
end

--------------------------------------------------------------------------------

function CMapEncounter_Pinecones:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pinecones:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pinecones:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pinecones:OnThink()
	CMapEncounter.OnThink( self )

	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes <= 0 then
		return
	end

	--print( "CMapEncounter_Pinecones:OnThink() - iterating through portal units" )
	for _,hEnemy in pairs( self.SpawnedEnemies ) do
		if hEnemy == nil or hEnemy:IsNull() or hEnemy:IsAlive() == false then
			goto continue
		end

		if hEnemy.bPortalUnit ~= nil and hEnemy.bPortalUnit == true then
			--print( "CMapEncounter_Pinecones:OnThink() -found a portal unit" )
			local hAggroTarget = hEnemy:GetAggroTarget()
			local hInitialGoalEnt = hEnemy:GetInitialGoalEntity()

			if hAggroTarget == nil and hInitialGoalEnt == nil then
				--print( "CMapEncounter_Pinecones:OnThink() - Found a portal unit that doesn't have an aggro target or a goal ent! Searching for a goal ent for this unit" )
				local hero = heroes[RandomInt(1, #heroes)]
				if hero ~= nil then
					--printf( "CMapEncounter_Pinecones:OnThink() - Set initial goal entity for unit \"%s\" to \"%s\"", hEnemy:GetUnitName(), hero:GetUnitName() )
					hEnemy:SetInitialGoalEntity( hero )
				end
			end
		end

		::continue::
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_Pinecones:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	--print( "CMapEncounter_Pinecones:OnSpawnerFinished" )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

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

return CMapEncounter_Pinecones
