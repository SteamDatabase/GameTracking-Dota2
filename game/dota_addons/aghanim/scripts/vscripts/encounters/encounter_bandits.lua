
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Bandits == nil then
	CMapEncounter_Bandits = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_riki/riki_blink_strike.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- Pre-placed creatures (done this way to use a specific subset of existing map spawners)
	self.vPreplacedSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
	}

	self.szPreplacedSpawner = "spawner_preplaced"

	self:AddSpawner( CDotaSpawner( self.szPreplacedSpawner, self.szPreplacedSpawner,
		{
			{
				EntityName = "npc_dota_creature_bandit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_bandit_archer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	-- Players have to kill the pre-placed creatures to trigger the dynamic portals
	self:SetPortalTriggerSpawner( self.szPreplacedSpawner, 0.8 )
	self:SetSpawnerSchedule( self.szPreplacedSpawner, self.vPreplacedSchedule )

	-- Additional creatures
	self.szGroupSpawner = "spawner_group"

	self.vExtraCreaturesSchedule =
	{
		{
			Time = 0,
			Count = 1,
		},
	}

	self:AddSpawner( CDotaSpawner( self.szGroupSpawner, self.szGroupSpawner,
		{
			{
				EntityName = "npc_dota_creature_bandit_archer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:SetSpawnerSchedule( self.szGroupSpawner, self.vExtraCreaturesSchedule )

	-- Wave 1
	local nNumPortals = 3
	local flInitialPortalSpawnDelay = 0.0
	local flInitialSummonTime = 6.0
	local flPortalIntervalInput = 60.0
	local flScaleInput = 1.0

	local nNameCounter = 1
	local szLocatorName = "dynamic_portal"
	self.nTotalPortals = nNumPortals

	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, 80 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_creature_bandit",
					Team = DOTA_TEAM_BADGUYS,
					Count = 2,
					PositionNoise = 250.0,
				},
				{
					EntityName = "npc_dota_creature_bandit_archer",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 200.0,
				},
			}
		))
	end

	-- Wave 2A
	nNumPortals = 3
	flInitialPortalSpawnDelay = 24.0
	flInitialSummonTime = 6.0
	flScaleInput = 1.0

	self.nTotalPortals = self.nTotalPortals + nNumPortals

	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, 80 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_creature_bandit",
					Team = DOTA_TEAM_BADGUYS,
					Count = 2,
					PositionNoise = 250.0,
				},
				{
					EntityName = "npc_dota_creature_bandit_archer",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 200.0,
				},
			}
		))
	end

	-- Wave 2B
	nNumPortals = 1
	flInitialPortalSpawnDelay = 24.0
	flInitialSummonTime = 6.0
	flScaleInput = 1.3

	self.nTotalPortals = self.nTotalPortals + nNumPortals

	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, 120 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_creature_bandit_captain",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 200.0,
				},
			}
		))
	end

	-- Wave 3A
	nNumPortals = 2
	flInitialPortalSpawnDelay = 48.0
	flInitialSummonTime = 6.0
	flScaleInput = 1.0

	self.nTotalPortals = self.nTotalPortals + nNumPortals

	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, 80 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_creature_bandit",
					Team = DOTA_TEAM_BADGUYS,
					Count = 2,
					PositionNoise = 250.0,
				},
				{
					EntityName = "npc_dota_creature_bandit_archer",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 200.0,
				},
			}
		))
	end

	-- Wave 3B
	nNumPortals = 2
	flInitialPortalSpawnDelay = 48.0
	flInitialSummonTime = 6.0
	flScaleInput = 1.3

	self.nTotalPortals = self.nTotalPortals + nNumPortals

	for i = 1, nNumPortals do
		local name = string.format( "portal_%i", nNameCounter )
		nNameCounter = nNameCounter + 1
		self:AddPortalSpawner( CPortalSpawner( name, szLocatorName, 120 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_creature_bandit_archer",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 200.0,
				},
				{
					EntityName = "npc_dota_creature_bandit_captain",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 200.0,
				},
			}
		))
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:GetPreviewUnit()
	return "npc_dota_creature_bandit_captain"
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "destroy_spawning_portals", 0, self.nTotalPortals )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:GetMaxSpawnedUnitCount()
	local nCount = 0
	local hPeonSpawners = self:GetSpawner( self.szPreplacedSpawner )
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount() * 3
	end

	for _,hPortalSpawner in pairs ( self.PortalSpawners ) do
		for _,rgUnitInfo in pairs ( hPortalSpawner.rgUnitsInfo ) do
			nCount = nCount + rgUnitInfo.Count
		end
	end

	print( 'CMapEncounter_Bandits:GetMaxSpawnedUnitCount() calculated ' .. nCount .. ' units' )

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:Start()
	CMapEncounter.Start( self )

	self:StartSpawnerSchedule( self.szPreplacedSpawner, 0 )
	self:StartSpawnerSchedule( self.szGroupSpawner, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bandits:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Bandits:OnSpawnerFinished" )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes > 0 then
		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
			local hero = heroes[RandomInt(1, #heroes)]
			if hero ~= nil then
				--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			else
				print( "CMapEncounter_Bandits:OnSpawnerFinished: WARNING: Can't find a living hero" )
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Bandits
