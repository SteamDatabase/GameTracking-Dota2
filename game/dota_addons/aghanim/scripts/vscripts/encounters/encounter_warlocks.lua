
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Warlocks == nil then
	CMapEncounter_Warlocks = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_warlock/warlock_shadow_word_buff.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- Pre-placed creatures (done this way to use a specific subset of existing map spawners)
	self.vGatekeepersSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
	}

	self:AddSpawner( CDotaSpawner( "spawner_gatekeepers", "spawner_gatekeepers",
		{
			{
				EntityName = "npc_dota_creature_demon_golem",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 225.0,
			},
			{
				EntityName = "npc_dota_creature_warlock",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	-- Players have to kill these creatures to trigger the dynamic portals
	self:SetPortalTriggerSpawner( "spawner_gatekeepers", 0.8 )
	self:SetSpawnerSchedule( "spawner_gatekeepers", self.vGatekeepersSchedule )

	-- Additional creatures
	self.vGroupCreaturesSchedule =
	{
		{
			Time = 0,
			Count = 1,
		},
	}

	self:AddSpawner( CDotaSpawner( "spawner_group", "spawner_group",
		{
			{
				EntityName = "npc_dota_creature_demon_golem",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 225.0,
			},
			{
				EntityName = "npc_dota_creature_warlock",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:SetSpawnerSchedule( "spawner_group", self.vGroupCreaturesSchedule )

	-- Dynamic Portals
	local nPortalHealth = 70 * hRoom:GetDepth()
	local flInitialPortalSpawnDelay = 0.0
	local flInitialSummonTime = 6.0
	local flPortalIntervalInput = 45.0
	local flScaleInput = 1.0
	local nNumPortals = 3

	local nNameCounter = 1
	local szLocatorName = "dynamic_portal"
	self.nTotalPortals = nNumPortals

	local PortalUnits =
	{
		{
			EntityName = "npc_dota_creature_demon_golem",
			Team = DOTA_TEAM_BADGUYS,
			Count = 2,
			PositionNoise = 200.0,
		},
		{
			EntityName = "npc_dota_creature_warlock",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0.0,
		},
	}

	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, nPortalHealth, flInitialPortalSpawnDelay,
			flInitialSummonTime, flPortalIntervalInput, flScaleInput, PortalUnits
		) )
	end

	flInitialPortalSpawnDelay = 24.0
	flInitialSummonTime = 6.0
	nNumPortals = 3
	self.nTotalPortals = self.nTotalPortals + nNumPortals
	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, nPortalHealth, flInitialPortalSpawnDelay,
			flInitialSummonTime, flPortalIntervalInput, flScaleInput, PortalUnits
		) )
	end

	flInitialPortalSpawnDelay = 48.0
	flInitialSummonTime = 6.0
	nNumPortals = 3
	self.nTotalPortals = self.nTotalPortals + nNumPortals
	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, nPortalHealth, flInitialPortalSpawnDelay,
			flInitialSummonTime, flPortalIntervalInput, flScaleInput, PortalUnits
		) )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "destroy_spawning_portals", 0, self.nTotalPortals )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() ) -- doesn't capture pre-placed spawns?
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:OnPortalV2Killed( hVictim, hAttacker, nUnitCountSuppressed )
	CMapEncounter.OnPortalV2Killed( self, hVictim, hAttacker, nUnitCountSuppressed )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + nUnitCountSuppressed, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:GetPreviewUnit()
	return "npc_dota_creature_warlock"
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:Start()
	CMapEncounter.Start( self )

	self:StartSpawnerSchedule( "spawner_gatekeepers", 0 )
	self:StartSpawnerSchedule( "spawner_group", 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Warlocks:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Warlocks:OnSpawnerFinished" )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes > 0 then
		for _, hSpawnedUnit in pairs( hSpawnedUnits ) do
			local hero = heroes[RandomInt( 1, #heroes ) ]
			if hero ~= nil then
				--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Warlocks
