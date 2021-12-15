
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_ThunderMountain == nil then
	CMapEncounter_ThunderMountain = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )
	self.bPlayerSkipAttempted = false 

	self.vMasterWaveSchedule =
	{
		PrePlacedSmallGuardian =
		{
			SpawnerName = "spawner_guardian_1",
			Count = SPAWN_ALL_POSITIONS,
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
		PrePlacedZeus =
		{
			SpawnerName = "spawner_zeus",
			Count = SPAWN_ALL_POSITIONS,
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
		Round2_SmallGuardian =
		{
			SpawnerName = "spawner_guardian_2",
			Count = SPAWN_ALL_POSITIONS,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedSmallGuardian",
					KillPercent = 100,
				},
			},
		},

		Round2_LargeGuardian =
		{
			SpawnerName = "spawner_large_guardian_2",
			Count = SPAWN_ALL_POSITIONS,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedSmallGuardian",
					KillPercent = 100,
				},
			},
		},

		Round3_SmallGuardian =
		{
			SpawnerName = "spawner_guardian_3",
			Count = SPAWN_ALL_POSITIONS,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Round2_LargeGuardian",
					KillPercent = 50,
				},
			},
		},

		Round3_LargeGuardian =
		{
			SpawnerName = "spawner_large_guardian_3",
			Count = SPAWN_ALL_POSITIONS,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Round2_LargeGuardian",
					KillPercent = 50,
				},
			},
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_guardian_1", "spawner_guardian_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_thunder_mountain_guardian",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_zeus", "spawner_zeus", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_thundergod_zeus",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )	


	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_guardian_2", "spawner_guardian_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_thunder_mountain_guardian",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_large_guardian_2", "spawner_large_guardian_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_thunder_mountain_guardian",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_guardian_3", "spawner_guardian_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_small_thunder_mountain_guardian",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_large_guardian_3", "spawner_large_guardian_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_large_thunder_mountain_guardian",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
	
end


--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:GetPreviewUnit()
	return "npc_dota_creature_thundergod_zeus"
end

--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:Start()
	CMapEncounter.Start( self )

	self.nEntityHurtListener = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( getclass( self ), "OnEntityHurt" ), self )
end

--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - int    // ugh, yes. it's called killed even if it's just damage
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------
function CMapEncounter_ThunderMountain:OnEntityHurt( event )
	if self.bPlayerSkipAttempted == true then 
		return 
	end

	if event.entindex_killed == nil then 
		return
	end

	local hUnit = EntIndexToHScript( event.entindex_killed )
	if hUnit == nil then 
		return 
	end

	if hUnit:GetUnitName() == "npc_dota_creature_thundergod_zeus" then 
		self.bPlayerSkipAttempted = true 
		print( "Wrath is triggered" )
		if self.masterWaveSchedule ~= nil then
			for WaveKey,Wave in pairs ( self.masterWaveSchedule ) do
				if Wave.SpawnStatus == nil then 
					Wave.AggroHeroes = true
					self:SpawnMasterWave( Wave, WaveKey )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:OnThink()
	CMapEncounter.OnThink( self )
end


--------------------------------------------------------------------------------

function CMapEncounter_ThunderMountain:OnComplete()
	CMapEncounter.OnComplete( self )

	StopListeningToGameEvent( self.nEntityHurtListener )
end

--------------------------------------------------------------------------------

return CMapEncounter_ThunderMountain
