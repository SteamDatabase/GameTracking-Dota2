require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Elemental_Tiny == nil then
	CMapEncounter_Elemental_Tiny = class( {}, {}, CMapEncounter )
end

function CMapEncounter_Elemental_Tiny:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )
	
	local bInvulnerable = true
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_elemental_tiny",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 100.0,
			},
		}, bInvulnerable ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain_trigger", "spawner_captain_trigger",
		{
			{
				EntityName = "npc_dota_creature_elemental_tiny",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 100.0,
			}
		}, bInvulnerable ) )

	self.nCaptains = 5
	
self.vPeonSchedule =
	{
		{
			Time = 1,
			Count = 2,
		},
		{
			Time = 16,
			Count = 2,
		},
	}

	self:SetPortalTriggerSpawner( "spawner_captain_trigger", 0.8 )
	self:SetSpawnerSchedule( "spawner_captain_trigger", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_peon", self.vPeonSchedule )
	self:SetCalculateRewardsFromUnitCount( true )
end

--------------------------------------------------------------------------------

function CMapEncounter_Elemental_Tiny:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	self:AddEncounterObjective( "kill_tinies", 0, self.nCaptains )
end
--------------------------------------------------------------------------------

function CMapEncounter_Elemental_Tiny:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_elemental_tiny" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "kill_tinies" )
		self:UpdateEncounterObjective( "kill_tinies", nCurrentValue + 1, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Elemental_Tiny:GetPreviewUnit()
	return "npc_dota_creature_elemental_tiny"
end

--------------------------------------------------------------------------------

function CMapEncounter_Elemental_Tiny:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )	
end

--------------------------------------------------------------------------------

function CMapEncounter_Elemental_Tiny:OnThink()
	CMapEncounter.OnThink( self )

	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes <= 0 then
		return
	end

	--print( "CMapEncounter_Elemental_Tiny:OnThink() - iterating through portal units" )
	for _,hEnemy in pairs( self.SpawnedEnemies ) do
		if hEnemy == nil or hEnemy:IsNull() or hEnemy:IsAlive() == false then
			goto continue
		end


		::continue::
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_Elemental_Tiny:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	--print( "CMapEncounter_Elemental_Tiny:OnSpawnerFinished" )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	--if #heroes > 0 then
	--	for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
	--		local hero = heroes[RandomInt(1, #heroes)]
	--		if hero ~= nil then
	--			--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
	--			hSpawnedUnit:SetInitialGoalEntity( hero )
	--		end
	--	end
	--end
end

--------------------------------------------------------------------------------

return CMapEncounter_Elemental_Tiny
