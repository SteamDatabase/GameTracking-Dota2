
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Phoenix == nil then
	CMapEncounter_Phoenix = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Phoenix:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- Portal-spawned creatures
	self.vEmberSchedule =
	{
		{
			Time = 3,
			Count = 2,
		},
		{
			Time = 21,
			Count = 2,
		},
		{
			Time = 39,
			Count = 2,
		},
		{
			Time = 57,
			Count = 2,
		},
	}

	self.vPhoenixSchedule =
	{
		{
			Time = 3,
			Count = 1,
		},
		{
			Time = 21,
			Count = 1,
		},
		{
			Time = 39,
			Count = 1,
		},
		{
			Time = 57,
			Count = 2,
		},
	}

	local bInvulnerable = true

	self.szEmberPortal = "portal_v2_ember"

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szEmberPortal, self.szEmberPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_ember_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 150.0,
			},
		}, bInvulnerable ) )

	self.szPhoenixPortal = "portal_v2_phoenix"

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szPhoenixPortal, self.szPhoenixPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_phoenix",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( self.szEmberPortal, self.vEmberSchedule )
	self:SetSpawnerSchedule( self.szPhoenixPortal, self.vPhoenixSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Phoenix:GetPreviewUnit()
	return "npc_dota_creature_phoenix"
end

--------------------------------------------------------------------------------

function CMapEncounter_Phoenix:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Phoenix:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	local nWaves = #self.vEmberSchedule + #self.vPhoenixSchedule
	self:AddEncounterObjective( "survive_waves", 0, nWaves )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_Phoenix:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Phoenix:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	if hSpawner.szSpawnerName == self.szEmberPortal or hSpawner.szSpawnerName == self.szPhoenixPortal then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	--print( heroes )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		local hero = heroes[RandomInt(1, #heroes)]
		if hero ~= nil then
			--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
			hSpawnedUnit:SetInitialGoalEntity( hero )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Phoenix
