
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_EggsHoldout == nil then
	CMapEncounter_EggsHoldout = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		Wave1 =
		{
			SpawnerName = "wave_1",
			Count = 1,
			AggroHeroes = false,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 0.0,
				},
			},
		},

		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 2,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1",
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave1",
					Time = 30.0,
				},
			},
		},

		Wave3 =
		{
			SpawnerName = "wave_3",
			Count = 2,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2",
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave2",
					Time = 30.0,
				},
			},
		},

		Wave4 =
		{
			SpawnerName = "wave_4",
			Count = 3,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave3",
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave3",
					Time = 30.0,
				},
			},
		},

	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "dynamic_portal_initial", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dragon_knight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_omniknight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dragon_knight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_omniknight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dragon_knight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_omniknight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dragon_knight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 300.0,
			},
			{
				EntityName = "npc_dota_creature_omniknight_egg_smasher",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_dragon_knight", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_omniknight", context )

	PrecacheResource( "particle", "particles/econ/events/league_teleport_2014/teleport_start_league.vpcf", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context )

	PrecacheUnitByNameSync( "npc_dota_creature_baby_dragon", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_ice_boss_egg", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:GetPreviewUnit()
	return "npc_dota_creature_dragon_knight_egg_smasher"
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	local vecEggSpawnLocs = self:GetRoom():FindAllEntitiesInRoomByName( "egg_spawner", true )

	if #vecEggSpawnLocs == 0 then
		printf( "No eggs found on encounter load" )
	end

	for _,hEggSpawnLoc in pairs( vecEggSpawnLocs ) do 
		local hEgg = CreateUnitByName( "npc_dota_creature_dragon_egg", hEggSpawnLoc:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "protect_eggs", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name

	if self.bCreatureSpawnsActivated == nil and szTriggerName == "trigger_spawn_creatures" then
		self.bCreatureSpawnsActivated = true

		self:StartAllSpawnerSchedules( 0 )	
   		EmitGlobalSound( "RoundStart" )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_EggsHoldout:OnComplete()
	CMapEncounter.OnComplete( self )

	local hSpawner = nil
	local szSpawnerName = "reward_spawner"
	local vecEntities = self:GetRoom():FindAllEntitiesInRoomByName( szSpawnerName )
	if #vecEntities > 0 then
		hSpawner = vecEntities[1]
	else
		printf( "Couldn't find reward spawner" )
		return
	end

	-- If eggs are still alive, give dragon potion
	local nSurvivingEggs = 0
	local vecUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetRoom():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _, hUnit in pairs( vecUnits ) do
		if hUnit:IsAlive() and hUnit:GetUnitName() == "npc_dota_creature_dragon_egg" then
			nSurvivingEggs = nSurvivingEggs + 1
			hUnit:ForceKill( false )
			hDragon = CreateUnitByName( "npc_dota_creature_baby_dragon", hUnit:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
			if hDragon ~= nil then
				hDragon.bStartRescue = true
				hDragon.nRescueGoldAmount = 25
				hDragon.bRescueOnlyOne = true
				hDragon.szGoalEntity = "reward_spawner"
			end
		end
	end

	--printf( "Found %d dragon eggs", nSurvivingEggs )

	if nSurvivingEggs > 0 then

		local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "altar_relay", false )
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
		end

	end
end

--------------------------------------------------------------------------------

return CMapEncounter_EggsHoldout
