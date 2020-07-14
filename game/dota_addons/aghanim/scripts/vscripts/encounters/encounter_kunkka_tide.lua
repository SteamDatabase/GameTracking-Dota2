
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_KunkkaTide == nil then
	CMapEncounter_KunkkaTide = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_KunkkaTide:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_tidehunter", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_kunkka", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_KunkkaTide:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	local bInvulnerable = true

	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"
	self.szBossSpawner = "spawner_boss"
	
	-- Peon:
	self.vPeonSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
		{
			Time = 24,
			Count = 2,
		},
		{
			Time = 48,
			Count = 2,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tidehunter_mini",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_tidehunter_medium",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_peon", self.vPeonSchedule )

	-- Captain:
	self.vCaptainSchedule =
	{
		{
			Time = 24,
			Count = 1,
		},
		{
			Time = 48,
			Count = 1,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_kunkka_medium",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_captain", self.vCaptainSchedule )

	-- Boss:
	self.vBossSchedule =
	{
		{
			Time = 0,
			Count = 1,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_boss", "spawner_boss", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tidehunter_large",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_boss", self.vBossSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_KunkkaTide:GetPreviewUnit()
	return "npc_dota_creature_tidehunter_medium"
end

--------------------------------------------------------------------------------

function CMapEncounter_KunkkaTide:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	--self:AddEncounterObjective( "survive_waves", 0, #self.vPeonSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_KunkkaTide:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_KunkkaTide:Start()
	CMapEncounter.Start( self )

	--self:StartSpawnerSchedule( self.szPeonSpawner, 6 )	
	--self:StartSpawnerSchedule( self.szCaptainSpawner, 6 )	
	--self:StartSpawnerSchedule( self.szBossSpawner, 6 )	

	self:StartAllSpawnerSchedules( 0 )	
end

--------------------------------------------------------------------------------

function CMapEncounter_KunkkaTide:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Hellbears:OnSpawnerFinished " )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		local hero = heroes[RandomInt(1, #heroes)]
		if hero ~= nil then
			printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
			hSpawnedUnit:SetInitialGoalEntity( hero )
		else
			print( "WARNING: Can't find a living hero and the objective entitiy is missing!" )
		end
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_KunkkaTide
