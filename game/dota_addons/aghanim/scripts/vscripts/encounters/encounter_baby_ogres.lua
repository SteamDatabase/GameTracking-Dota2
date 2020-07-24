
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_BabyOgres == nil then
	CMapEncounter_BabyOgres = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_BabyOgres:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"

	self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_baby_ogre_magi",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 150.0,
			},
		}
	))

	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_baby_ogre_tank",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	))

	self.vWaveSchedule =
	{
		{
			Time = 5,
			Count = 2,
		},
		{
			Time = 24,
			Count = 3,
		},
		{
			Time = 43,
			Count = 3,
		},
		{
			Time = 62,
			Count = 4,
		},
	}

	local bInvulnerable = true

	self.szDynamicPortal = "dynamic_portal"
	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szDynamicPortal, self.szDynamicPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_baby_ogre_magi",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_baby_ogre_tank",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szDynamicPortal, self.vWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_BabyOgres:GetPreviewUnit()
	return "npc_dota_creature_baby_ogre_tank"
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_BabyOgres:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() ) -- doesn't capture pre-placed spawns?
end

--------------------------------------------------------------------------------

function CMapEncounter_BabyOgres:GetMaxSpawnedUnitCount()
	local nCount = 0

	local hPeonSpawners = self:GetSpawner( self.szPeonSpawner )
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount()
	end

	local hCaptainSpawners = self:GetSpawner( self.szCaptainSpawner )
	if hCaptainSpawners then
		nCount = nCount + hCaptainSpawners:GetSpawnPositionCount()
	end

	return nCount
end
]]

--------------------------------------------------------------------------------

function CMapEncounter_BabyOgres:Start()
	CMapEncounter.Start( self )

	for _, hSpawner in pairs( self:GetSpawners() ) do
		hSpawner:SpawnUnits()
	end

	self:StartSpawnerSchedule( self.szDynamicPortal, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BabyOgres:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	--[[
	if hSpawner.szSpawnerName == self.szDynamicPortal then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end
	]]

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	print( "CMapEncounter_BabyOgres:OnSpawnerFinished" )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes > 0 then
		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
			local hero = heroes[RandomInt(1, #heroes)]
			if hero ~= nil then
				--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			else
				print( "CMapEncounter_BabyOgres:OnSpawnerFinished: WARNING: Can't find a living hero" )
			end
		end
	end
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_BabyOgres:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end
]]

--------------------------------------------------------------------------------

return CMapEncounter_BabyOgres
