require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Splitsville == nil then
	CMapEncounter_Splitsville = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Splitsville:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_brewmaster", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Splitsville:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedCaptain =
		{
			SpawnerName = "spawner_preplaced_captain",
			Count = 1,
			UsePortals = false,
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

		-- WAVE 1
		Wave1 =
		{
			SpawnerName = "wave_1",
			Count = 3,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					KillPercent = 100,
				},
			},
		},

		-- WAVE 2
		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 3,
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

		-- WAVE 3
		Wave3 =
		{
			SpawnerName = "wave_3",
			Count = 3,
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
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_brewmaster_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- portal enemies
	-- wave 1
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_brewmaster_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 2
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_brewmaster_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 3
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_brewmaster_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule ) 

	local bInvulnerable = true
end

function CMapEncounter_Splitsville:GetPreviewUnit()
	return "npc_dota_creature_brewmaster_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_Splitsville:ShouldAutoStartGlobalAscensionAbilities()
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_Splitsville:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Splitsville:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

return CMapEncounter_Splitsville
