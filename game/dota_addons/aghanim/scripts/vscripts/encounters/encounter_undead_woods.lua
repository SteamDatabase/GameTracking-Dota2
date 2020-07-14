require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_UndeadWoods == nil then
	CMapEncounter_UndeadWoods = class( {}, {}, CMapEncounter )
end


--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_skeleton_king", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_skeleton_king.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_sk", "spawner_sk",
		{ 
			{
				EntityName = "npc_dota_undead_woods_skeleton_king",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )


	local flInitialPortalSpawnDelay = 0.0
	local flInitialSummonTime = 30.0
	local flPortalIntervalInput = DEFAULT_PORTAL_SPAWN_INTERVAL
	local flScaleInput = 1.0
	self.nNumPortals = 4

	for i=1,self.nNumPortals do
		local name = string.format( "portal_%i", i )

		self:AddPortalSpawner( CPortalSpawner( name, "dynamic_portal", 60 * hRoom:GetDepth(), flInitialPortalSpawnDelay, flInitialSummonTime, flPortalIntervalInput, flScaleInput,
			{
				{
					EntityName = "npc_dota_wraith_king_skeleton_warrior",
					Team = DOTA_TEAM_BADGUYS,
					Count = 10,
					PositionNoise = 0.0,
				},
		} ) )
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "destroy_spawning_portals", 0, self.nNumPortals )
end

--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:GetPreviewUnit()
	return "npc_dota_undead_woods_skeleton_king"
end

--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_UndeadWoods:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	-- if hSpawner:GetSpawnerName() ~= "spawner_sk" then
	-- 	local SkeletonKings = self:GetRoom():FindAllEntitiesInRoomByName( "npc_dota_undead_woods_skeleton_king" )
	-- 	if #SkeletonKings > 0 then
	-- 		local hAbility = SkeletonKings[1]:FindAbilityByName( "undead_woods_skeleton_king_mortal_strike" )
	-- 		if hAbility then
	-- 			for _,hUnit in pairs( hSpawnedUnits ) do
	-- 				hUnit:AddNewModifier( SkeletonKings[1], hAbility, "modifier_skeleton_king_mortal_strike_summon", {} )
	-- 			end
	-- 		end
	-- 	end 
	-- end

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

return CMapEncounter_UndeadWoods
