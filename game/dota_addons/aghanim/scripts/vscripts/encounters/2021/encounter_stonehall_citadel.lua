
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

LinkLuaModifier( "modifier_rooted_unpurgable", "modifiers/creatures/modifier_rooted_unpurgable", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CMapEncounter_StonehallCitadel == nil then
	CMapEncounter_StonehallCitadel = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_StonehallCitadel:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_StonehallCitadel:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )
	--self.nNumSpawnedUnits = 0
	self.flBarracksReinforceInterval = 55.0
	self.flMinInterval = 45.0
	self.flIntervalStep = 0.5
	self.flNextSpawnTime = 99999.0

	self:AddSpawner( CDotaSpawner( "spawner_legion", "spawner_legion",
		{
			{
				EntityName = "npc_dota_creature_stonehall_general",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "preplaced_peon_melee", "preplaced_peon_melee",
		{
			{
				EntityName = "npc_dota_creature_stonehall_melee_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 75.0,
			},
		}
	) )

	self:AddSpawner( CDotaSpawner( "preplaced_peon_ranged", "preplaced_peon_ranged",
		{
			{
				EntityName = "npc_dota_creature_stonehall_ranged_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self.vecBarracksPortals = {}
	table.insert( self.vecBarracksPortals, self:AddSpawner( CDotaSpawner(	"spawner_peon_melee", "spawner_peon_melee",
		{
			{
				EntityName = "npc_dota_creature_stonehall_melee_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 75.0,
			},
		}
	) ) )

	table.insert( self.vecBarracksPortals, self:AddSpawner( CDotaSpawner( "spawner_peon_ranged", "spawner_peon_ranged", 
		{
			{
				EntityName = "npc_dota_creature_stonehall_ranged_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 50.0,
			},
		}
	) ) )

	self.nNumSpawnedUnits = 44 --hack
	self:SetCalculateRewardsFromUnitCount( true )
end
--------------------------------------------------------------------------------

function CMapEncounter_StonehallCitadel:GetMaxSpawnedUnitCount()
	return self.nNumSpawnedUnits
end

--------------------------------------------------------------------------------

function CMapEncounter_StonehallCitadel:GetPreviewUnit()
	return "npc_dota_creature_stonehall_general"
end

--------------------------------------------------------------------------------

function CMapEncounter_StonehallCitadel:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	if hUnit == nil or hUnit:IsRealHero() == false then 
		return 
	end

	if self.hLegion == nil or self.hLegion:IsNull() or self.hLegion:IsAlive() == false then 
		return 
	end

	if self.hLegion.bTriggerBreached then 
		return
	end

	self.hLegion.bTriggerBreached = true 
	self.hLegion:RemoveModifierByName( "modifier_rooted_unpurgable" )
end

--------------------------------------------------------------------------------

function CMapEncounter_StonehallCitadel:Start()
	CMapEncounter.Start( self )

	local vecBarracks = self:GetRoom():FindAllEntitiesInRoomByName( "good_rax_melee_top", false )
	for _,hBuilding in pairs( vecBarracks ) do 
		hBuilding:ChangeTeam( DOTA_TEAM_BADGUYS )
		local hAbility = hBuilding:AddAbility( "ability_unselectable" )
		if hAbility then 
			hAbility:UpgradeAbility( true )
		end
	end

	local vecRangedBarracks = self:GetRoom():FindAllEntitiesInRoomByName( "good_rax_range_top", false )
	for _,hBuilding in pairs( vecRangedBarracks ) do 
		hBuilding:ChangeTeam( DOTA_TEAM_BADGUYS )
		local hAbility = hBuilding:AddAbility( "ability_unselectable" )
		if hAbility then 
			hAbility:UpgradeAbility( true )
		end
	end

	local hUnits = self:GetSpawner( "spawner_legion" ):SpawnUnits()
	self.hLegion = hUnits[ 1 ]
	if self.hLegion == nil then 
		print( "error, no legion spawned!" )
	end

	self.nNumSpawnedUnits = 1

	local hPlayer0Hero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayer0Hero then 
		self.hLegion:AddNewModifier( hPlayer0Hero, nil, "modifier_provides_vision", { duration = -1 } )
	end

	local hBuff = self.hLegion:AddNewModifier( self.hLegion, nil, "modifier_rooted_unpurgable", { duration = -1 } )
	if hBuff == nil then
		print( "buff failed" ) 
	end 

	local hMeleeUnits = self:GetSpawner( "preplaced_peon_melee" ):SpawnUnits()
	if #hMeleeUnits > 0 then 
		self.nNumSpawnedUnits = self.nNumSpawnedUnits + #hMeleeUnits 
	end

	local hRangedUnits = self:GetSpawner( "preplaced_peon_ranged" ):SpawnUnits()
	if #hRangedUnits > 0 then 
		self.nNumSpawnedUnits = self.nNumSpawnedUnits + #hRangedUnits 
	end

	self.flNextSpawnTime = GameRules:GetGameTime() + self.flBarracksReinforceInterval
end

--------------------------------------------------------------------------------

function CMapEncounter_StonehallCitadel:OnThink()
	CMapEncounter.OnThink( self )
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), 5000.0 )
		
	if self.hLegion and self.hLegion:IsNull() == false and self.hLegion:IsAlive() and GameRules:GetGameTime() >= self.flNextSpawnTime and #heroes > 1 then
		self.flNextSpawnTime = self.flNextSpawnTime + self.flBarracksReinforceInterval	
		self.flBarracksReinforceInterval = math.max( self.flMinInterval, self.flBarracksReinforceInterval - self.flIntervalStep )

		local vecThisIntervalSpawnedUnits = {}
		for _,hBarracks in pairs ( self.vecBarracksPortals ) do 
			local vecBarracksUnits = hBarracks:SpawnUnits()
			for _,hBarracksUnit in pairs ( vecBarracksUnits ) do 
				table.insert( vecThisIntervalSpawnedUnits, hBarracksUnit )
				self.nNumSpawnedUnits = self.nNumSpawnedUnits + 1
			end
		end

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

return CMapEncounter_StonehallCitadel
