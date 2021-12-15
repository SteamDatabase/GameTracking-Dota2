
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

LinkLuaModifier( "modifier_rooted_unpurgable", "modifiers/creatures/modifier_rooted_unpurgable", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CMapEncounter_PugnaNetherReaches == nil then
	CMapEncounter_PugnaNetherReaches = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/pugna_grandmaster/pugna_grandmaster_ward_attack_heavy.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.flReinforceInterval = 30.0
	self.flMinInterval = 20.0
	self.flIntervalStep = 0.5
	self.flNextSpawnTime = 99999.0

	--self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_pugna", "spawner_pugna",
		{
			{
				EntityName = "npc_dota_creature_pugna_grandmaster",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self.vecViperPortals = {}
	table.insert( self.vecViperPortals, self:AddSpawner( CDotaSpawner(	"spawner_viper", "spawner_viper",
		{
			{
				EntityName = "npc_dota_creature_viper_hatchling",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 75.0,
			},
		}
	) ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:GetMaxSpawnedUnitCount()
	return 50
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:GetPreviewUnit()
	return "npc_dota_creature_pugna_grandmaster"
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:Start()
	CMapEncounter.Start( self )

	local hUnits = self:GetSpawner( "spawner_pugna" ):SpawnUnits()
	self.hPugna = hUnits[ 1 ]
	if self.hPugna == nil then 
		print( "error, no pugna spawned!" )
	end

	local hPlayer0Hero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayer0Hero then 
		self.hPugna:AddNewModifier( hPlayer0Hero, nil, "modifier_provides_vision", { duration = -1 } )
	end

	local hBuff = self.hPugna:AddNewModifier( self.hPugna, nil, "modifier_rooted_unpurgable", { duration = -1 } )
	if hBuff == nil then
		print( "buff failed" ) 
	end 

	self.flNextSpawnTime = GameRules:GetGameTime() + 5.0
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_PugnaNetherReaches:OnThink()
	CMapEncounter.OnThink( self )

	if self.hPugna and self.hPugna:IsNull() == false and self.hPugna:IsAlive() and GameRules:GetGameTime() >= self.flNextSpawnTime then
		self.flNextSpawnTime = self.flNextSpawnTime + self.flReinforceInterval	
		self.flReinforceInterval = math.max( self.flMinInterval, self.flReinforceInterval - self.flIntervalStep )

		local vecThisIntervalSpawnedUnits = {}
		for _,hSpawners in pairs ( self.vecViperPortals ) do 
			local vecVipers = hSpawners:SpawnUnits()
			for _,hViper in pairs ( vecVipers ) do 
				table.insert( vecThisIntervalSpawnedUnits, hViper )
			end
		end

		local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), 5000.0 )
		if #heroes > 0 then 
			for _,hUnit in pairs ( vecThisIntervalSpawnedUnits ) do	
				local hero = heroes[ RandomInt( 1, #heroes ) ]
				if hero ~= nil then
					--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hEnemy:GetUnitName(), hero:GetUnitName() )
					hUnit:SetInitialGoalEntity( hero )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_PugnaNetherReaches
