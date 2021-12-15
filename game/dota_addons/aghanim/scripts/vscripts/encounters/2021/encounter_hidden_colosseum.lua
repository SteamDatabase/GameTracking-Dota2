
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_HiddenColosseum == nil then
	CMapEncounter_HiddenColosseum = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_HiddenColosseum:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_mars", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_HiddenColosseum:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.vMasterWaveSchedule =
	{
		PeonWave1 =
		{
			SpawnerName = "peon_portal",
			Count = 2,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 7.0,
				},
			},
		},

		CaptainWave1 =
		{
			SpawnerName = "captain_portal",
			Count = 1,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 7.0,
				},
			},
		},

		PeonWave2 =
		{
			SpawnerName = "peon_portal_wave1",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PeonWave1",
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "PeonWave1",
					Time = 30.0,
				},
			},
		},

		PeonWave3 =
		{
			SpawnerName = "peon_portal_wave2",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PeonWave2",
					KillPercent = 75,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "PeonWave2",
					Time = 30.0,
				},
			},
		},
	}

	local bInvulnerable = true

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "peon_portal", "peon_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_mars_soldier",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "captain_portal", "captain_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_mars",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "peon_portal_wave1", "peon_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_mars_soldier",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "peon_portal_wave2", "peon_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_mars_soldier",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )

end

--------------------------------------------------------------------------------

function CMapEncounter_HiddenColosseum:GetPreviewUnit()
	return "npc_dota_creature_mars"
end

--------------------------------------------------------------------------------

function CMapEncounter_HiddenColosseum:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

return CMapEncounter_HiddenColosseum
