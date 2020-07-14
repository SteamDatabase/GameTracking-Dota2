require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_DarkSeer == nil then
	CMapEncounter_DarkSeer = class( {}, {}, CMapEncounter )
end


--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_dark_seer", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_lich", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_dark_seer", "spawner_dark_seer",
		{ 
			{
				EntityName = "npc_dota_creature_dark_seer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_lich", "spawner_lich",
		{ 
			{
				EntityName = "npc_dota_creature_lich",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_frost_kobold",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 0.0,
			},
		} ) )

end


--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:GetPreviewUnit()
	return "npc_dota_creature_dark_seer"
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DarkSeer:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	--print( "CMapEncounter_Wildwings:OnSpawnerFinished" )
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

return CMapEncounter_DarkSeer
