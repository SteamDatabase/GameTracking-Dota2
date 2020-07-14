
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_OgreSeals == nil then
	CMapEncounter_OgreSeals = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_OgreSeals:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )
	
	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"

	-- Pre-placed creatures (done this way to use a specific subset of existing map spawners)
	self.vPeonSchedule = 
	{
		{
			Time = 0,
			Count = 4,
		},
	}

	self.vCaptainSchedule = 
	{
		{
			Time = 0,
			Count = 2,
		},
	}

	self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{
			{
				EntityName = "npc_dota_creature_small_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 225.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{
			{
				EntityName = "npc_dota_creature_large_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:SetSpawnerSchedule( self.szPeonSpawner, self.vPeonSchedule )
	self:SetSpawnerSchedule( self.szCaptainSpawner, self.vCaptainSchedule )

	-- Portal-spawned creatures
	local bInvulnerable = true
	self.vWaveSchedule =
	{
		{
			Time = 20,
			Count = 2,
		},
		{
			Time = 40,
			Count = 2,
		},
		{
			Time = 55,
			Count = 2,
		},
		{
			Time = 65,
			Count = 3,
		},
	}

	--DeepPrintTable( self.vWaveSchedule )

	self.szPortal = "dynamic_portal"

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szPortal, self.szPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 225.0,
			},
			{
				EntityName = "npc_dota_creature_large_ogre_seal",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( self.szPortal, self.vWaveSchedule )

end

--------------------------------------------------------------------------------

function CMapEncounter_OgreSeals:GetPreviewUnit()
	return "npc_dota_creature_large_ogre_seal"
end

--------------------------------------------------------------------------------

function CMapEncounter_OgreSeals:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_OgreSeals:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() ) -- does this capture the pre-placed spawns?
end

--------------------------------------------------------------------------------

function CMapEncounter_OgreSeals:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_OgreSeals:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	if hSpawner.szSpawnerName == self.szPortal then
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

return CMapEncounter_OgreSeals
