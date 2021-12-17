
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_PushPull == nil then
	CMapEncounter_PushPull = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- urns are standing trash
	self.szUrnSpawner = "spawner_urn"
	self:AddSpawner( CDotaSpawner( self.szUrnSpawner, self.szUrnSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_pull_urn",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
		{
			SpawnerName = "spawner_preplaced_peon",
			Count = 4,
			--UsePortals = false,
			--AggroHeroes = false,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 0.0,
				},
			},
		},
		PrePlacedCaptain =
		{
			SpawnerName = "spawner_preplaced_captain",
			Count = 2,
			--UsePortals = false,
			--AggroHeroes = false,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 0.0,
				},
			},
		},

		Wave1 =
		{
			SpawnerName = "wave_1",
			Count = 2,
			--AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedPeons",
					KillPercent = 100,
				},
			},
		},

		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 1,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1",
					HealthPercent = 50,
				},
			},
		},

		Wave3 =
		{
			SpawnerName = "wave_3",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave2",
					HealthPercent = 50,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_eidolon",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magnus_push",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_eidolon",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_magnus_push",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_miniboss", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_magnus",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_eidolon",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_magnus_push",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( self.szUrnSpawner, nil )	-- means spawn once when triggered 
	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_magnataur", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_enigma", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:GetPreviewUnit()
	return "npc_dota_creature_magnus"
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	--self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:InitializeObjectives()
	local nUrnSpawners = 4
	self:AddEncounterObjective( "defeat_all_enemies", 0, ( self:GetMaxSpawnedUnitCount() - nUrnSpawners ) )
end

--------------------------------------------------------------------------------

-- don't count urns as units that must be destroyed
function CMapEncounter_PushPull:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_pull_urn" then
    	return false
    end

    return true
end

--------------------------------------------------------------------------------

-- only count the v2 portals for our max unit count - we don't want to count the urns since they're indestructible
function CMapEncounter_PushPull:GetMaxSpawnedUnitCount()
	return CMapEncounter.GetMaxSpawnedUnitCount( self ) - 4
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	--print( "CMapEncounter_Pinecones:OnSpawnerFinished" )

	if hSpawner:GetSpawnerType() == "CPortalSpawnerV2" then
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
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	printf( "szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

	if self.bCreatureSpawnsActivated == nil and szTriggerName == "trigger_spawn_creatures" then
		self.bCreatureSpawnsActivated = true

		self:StartAllSpawnerSchedules( 0 )	

		printf( "Unit \"%s\" triggered creature spawning!", hUnit:GetUnitName() )
   		EmitGlobalSound( "RoundStart" )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PushPull:OnComplete()

	CMapEncounter.OnComplete( self )
	printf('PUSH PULL ON COMPLETE')
	local szThinkerName = "npc_dota_thinker"
	local vecEntities = Entities:FindAllByName( szThinkerName )
	for k, hThinker in pairs ( vecEntities ) do
		UTIL_Remove( hThinker )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_PushPull
