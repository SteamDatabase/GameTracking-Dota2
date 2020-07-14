
require( "map_encounter" )
require( "aghanim_utility_functions" )

require( "spawner" )
require( "portalspawnerv2" )
require( "utility_functions" )

--------------------------------------------------------------------------------

if CMapEncounter_Broodmothers == nil then
	CMapEncounter_Broodmothers = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Broodmothers:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_flaming_lasso.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Broodmothers:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- Pre-placed eggs (done this way to use only a subset of the map spawners)
	self.szEggSpawner = "spider_sac_position"

	local nAscLevel = GameRules.Aghanim:GetAscensionLevel()
	local nPreplacedSacs = 9 + ( 2 * nAscLevel )

	self.vEggSchedule =
	{
		{
			Time = 0,
			Count = nPreplacedSacs,
		},
	}

	self:AddSpawner( CDotaSpawner( self.szEggSpawner, self.szEggSpawner,
		{
			{
				EntityName = "npc_dota_spider_sac",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:SetSpawnerSchedule( self.szEggSpawner, self.vEggSchedule )

	-- Pre-placed broodmothers
	self.szBroodmotherSpawner = "preplaced_broodmother"

	self.vBroodmotherSchedule =
	{
		{
			Time = 0,
			Count = 5,
		},
	}

	self:AddSpawner( CDotaSpawner( self.szBroodmotherSpawner, self.szBroodmotherSpawner,
		{
			{
				EntityName = "npc_dota_creature_broodmother",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:SetSpawnerSchedule( self.szBroodmotherSpawner, self.vBroodmotherSchedule )

	-- Portals
	self.vHugeBroodSchedule =
	{
		{
			Time = 34,
			Count = 1,
		},
		{
			Time = 64,
			Count = 1,
		},
	}

	self.vKidnapperSchedule =
	{
		{
			Time = 10,
			Count = 1,
		},
		{
			Time = 30,
			Count = 1,
		},
		{
			Time = 50,
			Count = 1,
		},
		{
			Time = 70,
			Count = 1,
		},
	}

	self.szHugeBroodPortal = "portal_huge_brood"
	self.szKidnapperPortal = "portal_kidnapper"

	local bInvulnerable = true
	local nHealth = 1

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szHugeBroodPortal, self.szHugeBroodPortal, nHealth, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_huge_broodmother",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szKidnapperPortal, self.szKidnapperPortal, nHealth, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_kidnap_spider",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szHugeBroodPortal, self.vHugeBroodSchedule )
	self:SetSpawnerSchedule( self.szKidnapperPortal, self.vKidnapperSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Broodmothers:GetPreviewUnit()
	return "npc_dota_creature_huge_broodmother"
end

--------------------------------------------------------------------------------

function CMapEncounter_Broodmothers:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Broodmothers:OnThink()
	-- We'll pop the eggs when all the important spiders are dead
	if self:AreScheduledSpawnsComplete() and not self:HasAnyPortals() then
		--printf( "Scheduled spawns are complete and there are no portals" )
		-- Search for enemies remaining
		local fSearchRange = 6000
		local vRoomOrigin = self:GetRoom():GetOrigin()
		local hCreatures = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vRoomOrigin, nil, fSearchRange,
				DOTA_TEAM_BADGUYS, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false
		)

		local nCaptainsRemaining = 0
		for _, hCreature in pairs( hCreatures ) do
			if hCreature and ( not hCreature:IsNull() ) and hCreature:IsAlive() then
				if hCreature:GetUnitName() == "npc_dota_creature_kidnap_spider" or hCreature:GetUnitName() == "npc_dota_creature_broodmother" or hCreature:GetUnitName() == "npc_dota_creature_huge_broodmother" then
					nCaptainsRemaining = nCaptainsRemaining + 1
				end
			end
		end

		if nCaptainsRemaining == 0 then
			--printf( "All the captain spiders are dead" )
			for _, hCreature in pairs( hCreatures ) do
				if hCreature:GetUnitName() == "npc_dota_spider_sac" then
					--printf( "Popping an egg" )
					hCreature:Kill( nil, nil )
				end
			end
		end
	end

	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Broodmothers:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	if hSpawner:GetSpawnerName() == self.szKidnapperPortal then -- kidnap spiders do their own thing, their ai was getting broken by SetInitialGoalEntity
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

return CMapEncounter_Broodmothers
