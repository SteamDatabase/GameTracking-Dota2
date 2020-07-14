
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Gauntlet == nil then
	CMapEncounter_Gauntlet = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_cast_ink_swell.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_tick_damage.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_lifestealer", "spawner_lifestealer",
		{ 
			{
				EntityName = "npc_dota_creature_life_stealer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:AddSpawner( CDotaSpawner( "spawner_grimstroke", "spawner_grimstroke",
		{ 
			{
				EntityName = "npc_dota_creature_grimstroke",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	--[[
	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_gauntlet_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 0.0,
			},
		}
	) )
	]]
end


--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:GetPreviewUnit()
	return "npc_dota_creature_life_stealer"
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:CheckForCompletion()
	if not self:HasRemainingEnemies() and not self:HasAnyPortals() then

		-- Disable any traps in the map
		local hRelays = Entities:FindAllByName( "disable_traps_relay" )
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
		end

		return true
	end

	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Gauntlet:OnSpawnerFinished( hSpawner, hSpawnedUnits )
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

return CMapEncounter_Gauntlet
