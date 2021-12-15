
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Mole_Cave == nil then
	CMapEncounter_Mole_Cave = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Mole_Cave:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
		{
			SpawnerName = "spawner_preplaced_peons",
			Count = 3,
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

		Wave1_Peons =
		{
			SpawnerName = "pordlers_a_peons",
			Count = 1,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					HealthPercent = 25,
				},
				TimeRelative =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "PrePlacedCaptain",
					Time = 28.0,
				},
			},
		},
		Wave1_Captains =
		{
			SpawnerName = "pordlers_a_captains",
			Count = 2,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					HealthPercent = 25,
				},
				TimeRelative =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "PrePlacedCaptain",
					Time = 28.0,
				},
			},
		},

		Wave2_Peons =
		{
			SpawnerName = "pordlers_b_peons",
			Count = 2,
			TriggerData =
			{
				TriggerHealthPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1_Captains",
					HealthPercent = 20,
				},
				TimeRelative =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave1_Captains",
					Time = 45.0,
				},
			},
		},
		Wave2_Captains =
		{
			SpawnerName = "pordlers_b_captains",
			Count = 2,
			TriggerData =
			{
				TriggerHealthPercent =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1_Captains",
					HealthPercent = 20,
				},
				TimeRelative =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave1_Captains",
					Time = 45.0,
				},
			},
		},

		Wave3_Peons =
		{
			SpawnerName = "pordlers_c_peons",
			Count = 3,
			TriggerData =
			{
				TriggerHealthPercent =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave2_Captains",
					HealthPercent = 20,
				},
				TimeRelative =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave2_Captains",
					Time = 45.0,
				},
			},
		},
		Wave3_Captains =
		{
			SpawnerName = "pordlers_c_captains",
			Count = 3,
			TriggerData =
			{
				TriggerHealthPercent =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave2_Captains",
					HealthPercent = 20,
				},
				TimeRelative =
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave2_Captains",
					Time = 45.0,
				},
			},
		},
	}

	local bInvulnerable = true

	-- Preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peons", "preplaced_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "preplaced_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- Portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_a_peons", "portal_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_a_captains", "portal_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_small_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_b_peons", "portal_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_b_captains", "portal_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_small_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_c_peons", "portal_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_c_captains", "portal_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_small_eimermole",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self.PortalNames = {}

	local spawners = self:GetSpawners()
	for _, v in pairs( spawners ) do
		if v and v.UsePortals == true then
			table.insert( self.PortalNames, v:GetSpawnerName() )
			printf( "Found a portal named \"%s\" to add to self.PortalNames", v:GetSpawnerName() )
		end
	end

	printf( "self.PortalNames:" )
	PrintTable( self.PortalNames, " -- " )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Mole_Cave:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Mole_Cave:GetPreviewUnit()
	return "npc_dota_creature_large_eimermole"
end

--------------------------------------------------------------------------------

function CMapEncounter_Mole_Cave:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	--self.szObjectiveEnts = "objective"
	--self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	--if #self.hObjectiveEnts == 0 then
	--	printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	--end

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Mole_Cave:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_Mole_Cave:Start()!' )
end

--------------------------------------------------------------------------------

return CMapEncounter_Mole_Cave
