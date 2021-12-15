require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Multiplicity == nil then
	CMapEncounter_Multiplicity = class( {}, {}, CMapEncounter )
end


--------------------------------------------------------------------------------

function CMapEncounter_Multiplicity:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_creature_phantom_lancer_illusion", context, -1 )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_phantom_lancer", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Multiplicity:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedCaptains =
		{
			SpawnerName = "spawner_preplaced_captains",
			Count = 4,
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
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedCaptains",
					KillPercent = 100,
				},
			},
		},

	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captains", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_phantom_lancer",
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
				EntityName = "npc_dota_creature_phantom_lancer_illusion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_phantom_lancer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule ) 
	self.nPhantomLancersCount = 999999
end

--------------------------------------------------------------------------------

function CMapEncounter_Multiplicity:GetPreviewUnit()
	return "npc_dota_creature_phantom_lancer"
end

--------------------------------------------------------------------------------

function CMapEncounter_Multiplicity:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Multiplicity:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	--self.nPhantomLancersCount = 6 -- 4 Preplaced and 2 Dynamic
	--self:AddEncounterObjective( "defeat_phantom_lancers", 0, self.nPhantomLancersCount )
end

--------------------------------------------------------------------------------

return CMapEncounter_Multiplicity
