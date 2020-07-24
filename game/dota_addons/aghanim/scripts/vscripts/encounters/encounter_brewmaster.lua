require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Brewmaster == nil then
	CMapEncounter_Brewmaster = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Brewmaster:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_brewmaster", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Brewmaster:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	local bInvulnerable = true

	self:AddSpawner( CDotaSpawner( "spawner_captain_trigger", "spawner_captain_trigger",
		{
			{
				EntityName = "npc_dota_creature_brewmaster_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			}
		} ) )

	self:SetSpawnerSchedule( "spawner_captain_trigger", nil )
	self:SetPortalTriggerSpawner( "spawner_captain_trigger", 0.5 )

	-- Captain:
	self.vCaptainSchedule =
	{
		{
			Time = 0,
			Count = 3,
		},
		{
			Time = 20,
			Count = 3,
		},
		{
			Time = 40,
			Count = 3,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "dynamic_portal", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_brewmaster_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "dynamic_portal", self.vCaptainSchedule )
end

function CMapEncounter_Brewmaster:GetPreviewUnit()
	return "npc_dota_creature_brewmaster_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_Brewmaster:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	self:AddEncounterObjective( "survive_waves", 0, #self.vCaptainSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Brewmaster:ShouldAutoStartGlobalAscensionAbilities()
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_Brewmaster:Start()
	CMapEncounter.Start( self )
	local spawnerFocusPath = self:GenerateSpawnFocusPath( "portal_v2_captain", 300, 1000 )
	self:AssignSpawnFocusPath( "portal_v2_peon", spawnerFocusPath )
	self:AssignSpawnFocusPath( "portal_v2_captain", spawnerFocusPath )
	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Brewmaster:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	if hSpawner.szSpawnerName == "dynamic_portal" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	--print( "CMapEncounter_Brewmaster:OnSpawnerFinished" )
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

return CMapEncounter_Brewmaster
