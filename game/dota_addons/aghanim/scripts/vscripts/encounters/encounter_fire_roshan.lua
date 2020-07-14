
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_FireRoshan == nil then
	CMapEncounter_FireRoshan = class( {}, {}, CMapEncounter )
end


function CMapEncounter_FireRoshan:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_creature_baby_roshan", context, -1 )

	PrecacheResource( "particle", "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/mini_rosh_fire.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_slowed_cold.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_frost_lich.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_burn.vpcf", context  )
end

--------------------------------------------------------------------------------

function CMapEncounter_FireRoshan:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.nNumBabyRoshans = 3

	self:AddSpawner( CDotaSpawner( "spawner_fire_roshan", "spawner_fire_roshan",
		{
			{
				EntityName = "npc_dota_creature_fire_roshan",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_ice_roshan", "spawner_ice_roshan",
		{
			{
				EntityName = "npc_dota_creature_ice_roshan",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	local bInvulnerable = true
	self.vReinforcementSchedule =
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
			Time = 60,
			Count = 2,
		},
		{
			Time = 80,
			Count = 2,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_reinforcements", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_baby_roshan",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 225.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( "spawner_reinforcements", self.vReinforcementSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_FireRoshan:InitializeObjectives()
	self:AddEncounterObjective( "defeat_blazhan", 0, 0 )
	self:AddEncounterObjective( "defeat_frozhan", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_FireRoshan:GetPreviewUnit()
	return "npc_dota_creature_fire_roshan"
end

--------------------------------------------------------------------------------

function CMapEncounter_FireRoshan:Start()
	CMapEncounter.Start( self )
	
	self:CreateUnits()
	self:StartAllSpawnerSchedules( 0 )	
end

--------------------------------------------------------------------------------

function CMapEncounter_FireRoshan:CreateUnits()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		local vecUnits = Spawner:SpawnUnits()
		for _,hUnit in pairs ( vecUnits ) do
			if hUnit:GetUnitName() == "npc_dota_creature_ice_roshan" then
				hUnit:SetMaterialGroup( "3" )
			end
			if hUnit:GetUnitName() == "npc_dota_creature_fire_roshan" then
				hUnit:SetMaterialGroup( "2" )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_FireRoshan:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	print( "CMapEncounter_FireRoshan:OnSpawnerFinished" )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes > 0 then
		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
			local hero = heroes[RandomInt(1, #heroes)]
			if hero ~= nil then
				--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			else
				print( "CMapEncounter_FireRoshan:OnSpawnerFinished: WARNING: Can't find a living hero" )
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_FireRoshan
