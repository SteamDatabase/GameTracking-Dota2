
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_LegionCommander == nil then
	CMapEncounter_LegionCommander = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bInitialSpawn = true
	self.bTrapsEnabled = false
	self.nTrapTimer = 0
	self:SetCalculateRewardsFromUnitCount( true )

	local bInvulnerable = true
	
	-- bespoke version:
	self.vPeonSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
		{
			Time = 20,
			Count = 2,
		},
		{
			Time = 40,
			Count = 3,
		},
		{
			Time = 60,
			Count = 3,
		},
	}

	--DeepPrintTable( self.vPeonSchedule )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_gladiator_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 100.0,
			},
			{
				EntityName = "npc_dota_creature_skywrath_mage",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 100.0,
			},
			
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_peon", self.vPeonSchedule )

	-- Captain:
	self.vCaptainSchedule =
	{
		{
			Time = 0,
			Count = 1,
		},
		{
			Time = 20,
			Count = 1,
		},
		{
			Time = 40,
			Count = 2,
		},
		{
			Time = 60,
			Count = 2,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_legion_commander",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_captain", self.vCaptainSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_gladiator_creep", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_skywrath_mage", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_legion_commander", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context )
	PrecacheResource( "particle", "particles/econ/events/ti10/emblem/ti10_emblem_effect_gem_ring.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:GetPreviewUnit()
	return "npc_dota_creature_legion_commander"
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vPeonSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:ShouldAutoStartGlobalAscensionAbilities()
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	if self.bInitialSpawn == true then
		--self:SpawnTowers()
		self.bInitialSpawn = false
	end

	if hSpawner.szSpawnerName == "spawner_peon" then
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

function CMapEncounter_LegionCommander:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	printf( "szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

	if self.bCreatureSpawnsActivated == nil and szTriggerName == "trigger_spawn_creatures" then
		self.bCreatureSpawnsActivated = true

		self:StartGlobalAscensionAbilities()
		self:StartAllSpawnerSchedules( 0 )	
		self.bTrapsEnabled = true

		printf( "Unit \"%s\" triggered creature spawning!", hUnit:GetUnitName() )
		EmitGlobalSound( "RoundStart" )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:OnThink()
	CMapEncounter.OnThink( self )
	if self.bTrapsEnabled == true then
		self.nTrapTimer = self.nTrapTimer + 1
	end
	if self.nTrapTimer == 1 then
		self:FireArrowTrap1()
	elseif self.nTrapTimer == 2 then
		self:FireArrowTrap2()
	elseif self.nTrapTimer == 3 then
		self:FireArrowTrap3()
	elseif self.nTrapTimer == 4 then
		self:FireArrowTrap4()
		self.nTrapTimer = 0
	end

end

function CMapEncounter_LegionCommander:FireArrowTrap1()
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "arrow_trap_01_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

function CMapEncounter_LegionCommander:FireArrowTrap2()
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "arrow_trap_02_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

function CMapEncounter_LegionCommander:FireArrowTrap3()
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "arrow_trap_03_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

function CMapEncounter_LegionCommander:FireArrowTrap4()
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "arrow_trap_04_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:CheckForCompletion()
	if self.bInitialSpawn == false then
		if not self:HasRemainingEnemies() and self:AreScheduledSpawnsComplete() and not self:HasAnyPortals() then
			self.bTrapsEnabled = false
			local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "disable_traps_relay", false )
			for _, hRelay in pairs( hRelays ) do
				hRelay:Trigger( nil, nil )
			end

			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_LegionCommander:OnComplete()
	CMapEncounter.OnComplete( self )
	
	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and not hHero:IsNull() and hHero:IsRealHero() then
			hHero:RemoveModifierByName( "modifier_legion_commander_duel_damage_boost" )
		end
	end
end



--------------------------------------------------------------------------------

return CMapEncounter_LegionCommander

--------------------------------------------------------------------------------
