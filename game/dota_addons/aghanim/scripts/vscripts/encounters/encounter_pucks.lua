
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Pucks == nil then
	CMapEncounter_Pucks = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pucks:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter_move.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_cast_combined_detail.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/puck/flying_bomb_destination.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pucks:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- Initial Spawns
	self.szCaptainSpawner = "spawner_captain"

	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_puck",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
		} ) )

	-- Dynamic Spawns
	self.vPuckSchedule =
	{
		{
			Time = 5,
			Count = 2,
		},
		{
			Time = 25,
			Count = 2,
		},
		{
			Time = 45,
			Count = 2,
		},
		{
			Time = 65,
			Count = 2,
		},
	}

	self.vTitanSchedule =
	{
		{
			Time = 35,
			Count = 1,
		},
		{
			Time = 55,
			Count = 1,
		},
		{
			Time = 65,
			Count = 1,
		},
	}

	--DeepPrintTable( self.vWaveSchedule )

	local bInvulnerable = true

	self.szPuckPortal = "dynamic_portal_puck"
	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szPuckPortal, self.szPuckPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_puck",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 150.0,
			},
		}, bInvulnerable
	) )

	self.szTitanPortal = "dynamic_portal_titan"
	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szTitanPortal, self.szTitanPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_elder_titan",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szPuckPortal, self.vPuckSchedule )
	self:SetSpawnerSchedule( self.szTitanPortal, self.vTitanSchedule )
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_Pucks:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end
]]

--------------------------------------------------------------------------------

function CMapEncounter_Pucks:GetPreviewUnit()
	return "npc_dota_creature_puck"
end

--------------------------------------------------------------------------------

function CMapEncounter_Pucks:Start()
	CMapEncounter.Start( self )

	for _, hSpawner in pairs( self:GetSpawners() ) do
		hSpawner:SpawnUnits()
	end

	self:StartSpawnerSchedule( self.szPuckPortal, 0 )
	self:StartSpawnerSchedule( self.szTitanPortal, 0 )
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_Pucks:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end
]]

--------------------------------------------------------------------------------

function CMapEncounter_Pucks:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Pucks:OnSpawnerFinished" )
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

return CMapEncounter_Pucks
