
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Spectres == nil then
	CMapEncounter_Spectres = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Spectres:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- Initial Spawns
	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"

	self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_wolf",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 75.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{
			{
				EntityName = "npc_dota_creature_spectre",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	-- Dynamic Spawns
	self.vWaveSchedule =
	{
		{
			Time = 15,
			Count = 1,
		},
		{
			Time = 30,
			Count = 2,
		},
		{
			Time = 45,
			Count = 2,
		},
		{
			Time = 60,
			Count = 2,
		},
	}

	--DeepPrintTable( self.vWaveSchedule )

	self.szDynamicPortal = "dynamic_portal"
	local bInvulnerable = true

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szDynamicPortal, self.szDynamicPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_wolf",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_spectre",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szDynamicPortal, self.vWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Spectres:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Spectres:GetPreviewUnit()
	return "npc_dota_creature_spectre"
end

--------------------------------------------------------------------------------

function CMapEncounter_Spectres:Start()
	CMapEncounter.Start( self )

	self:CreateUnits()
	self:StartSpawnerSchedule( self.szDynamicPortal, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Spectres:CreateUnits()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Spectres:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Spectres:OnSpawnerFinished" )
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

return CMapEncounter_Spectres
