
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Blob_Dungeon == nil then
	CMapEncounter_Blob_Dungeon = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedBlob1 =
		{
			SpawnerName = "spawner_preplaced_blob_1",
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
		PrePlacedBlob2 =
		{
			SpawnerName = "spawner_preplaced_blob_2",
			Count = 1,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal1_Wave1",
					KillPercent = 100,
				},
			},
		},
		PrePlacedBlob3 =
		{
			SpawnerName = "spawner_preplaced_blob_3",
			Count = 2,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal2_Wave3",
					KillPercent = 100,
				},
			},
		},
		PrePlacedBlob4 =
		{
			SpawnerName = "spawner_preplaced_blob_4",
			Count = 3,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal3_Wave3",
					KillPercent = 100,
				},
			},
		},

		-- PORTAL 1
		Portal1_Wave1 =
		{
			SpawnerName = "spawner_portal_blob_1",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob1",
					KillPercent = 100,
				},
			},
		},

		-- bats 1
		Bat_Portal1_Wave1 =
		{
			SpawnerName = "spawner_portal_bat_1",
			Count = 2,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob1",
					KillPercent = 100,
				},
			},
		},


		-- PORTAL 2
		Portal2_Wave1 =
		{
			SpawnerName = "spawner_portal_blob_2",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob2",
					KillPercent = 100,
				},
			},
		},
		Portal2_Wave2 =
		{
			SpawnerName = "spawner_portal_blob_2",
			Count = 2,
			TriggerData =
			{
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Portal2_Wave1",
					Time = 5.0,
				},
			},
		},
		Portal2_Wave3 =
		{
			SpawnerName = "spawner_portal_blob_2",
			Count = 2,
			TriggerData =
			{
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Portal2_Wave2",
					Time = 5.0,
				},
			},
		},

		-- bats 2
		Bat_Portal2_Wave1 =
		{
			SpawnerName = "spawner_portal_bat_2",
			Count = 3,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob2",
					KillPercent = 100,
				},
			},
		},
		Bat_Portal2_Wave2 =
		{
			SpawnerName = "spawner_portal_bat_2",
			Count = 3,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal2_Wave1",
					KillPercent = 100,
				},
			},
		},
		Bat_Portal2_Wave3 =
		{
			SpawnerName = "spawner_portal_bat_2",
			Count = 4,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal2_Wave2",
					KillPercent = 100,
				},
			},
		},
		
		-- PORTAL 3
		Portal3_Wave1 =
		{
			SpawnerName = "spawner_portal_blob_3",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob3",
					KillPercent = 40,
				},
			},
		},
		Portal3_Wave2 =
		{
			SpawnerName = "spawner_portal_blob_3",
			Count = 2,
			TriggerData =
			{
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Portal3_Wave1",
					Time = 5.0,
				},
			},
		},
		Portal3_Wave3 =
		{
			SpawnerName = "spawner_portal_blob_3",
			Count = 3,
			TriggerData =
			{
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Portal3_Wave2",
					Time = 5.0,
				},
			},
		},

		-- bats 3
		Bat_Portal3_Wave1 =
		{
			SpawnerName = "spawner_portal_bat_3",
			Count = 2,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob3",
					KillPercent = 100,
				},
			},
		},
		Bat_Portal3_Wave2 =
		{
			SpawnerName = "spawner_portal_bat_3",
			Count = 2,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal3_Wave1",
					KillPercent = 100,
				},
			},
		},
		Bat_Portal3_Wave3 =
		{
			SpawnerName = "spawner_portal_bat_3",
			Count = 2,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal3_Wave2",
					KillPercent = 100,
				},
			},
		},

		-- PORTAL 4
		Portal4_Wave1 =
		{
			SpawnerName = "spawner_portal_blob_4",
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob4",
					KillPercent = 30,
				},
			},
		},
		Portal4_Wave2 =
		{
			SpawnerName = "spawner_portal_blob_4",
			Count = 3,
			TriggerData =
			{
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Portal4_Wave1",
					Time = 5.0,
				},
			},
		},
		Portal4_Wave3 =
		{
			SpawnerName = "spawner_portal_blob_4",
			Count = 3,
			TriggerData =
			{
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Portal4_Wave2",
					Time = 5.0,
				},
			},
		},
		Portal4_Wave4 =
		{
			SpawnerName = "spawner_portal_blob_4",
			Count = 4,
			TriggerData =
			{
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Portal4_Wave3",
					Time = 5.0,
				},
			},
		},

		-- bats 4
		Bat_Portal4_Wave1 =
		{
			SpawnerName = "spawner_portal_bat_4",
			Count = 3,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedBlob4",
					KillPercent = 100,
				},
			},
		},
		Bat_Portal4_Wave2 =
		{
			SpawnerName = "spawner_portal_bat_4",
			Count = 3,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal4_Wave1",
					KillPercent = 100,
				},
			},
		},
		Bat_Portal4_Wave3 =
		{
			SpawnerName = "spawner_portal_bat_4",
			Count = 4,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal4_Wave2",
					KillPercent = 100,
				},
			},
		},
		Bat_Portal4_Wave4 =
		{
			SpawnerName = "spawner_portal_bat_4",
			Count = 4,
			UsePortals = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Portal4_Wave3",
					KillPercent = 100,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced blobs
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_blob_1", "spawner_preplaced_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_blob_2", "spawner_preplaced_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_blob_3", "spawner_preplaced_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_blob_4", "spawner_preplaced_4", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal blobs
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_blob_1", "portal_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_blob_2", "portal_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_blob_3", "portal_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_blob_4", "portal_4", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_acid_blob",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- portal bats
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_bat_1", "bat_portal_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dungeon_bat",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_bat_2", "bat_portal_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dungeon_bat",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_bat_3", "bat_portal_3", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dungeon_bat",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_portal_bat_4", "bat_portal_4", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_dungeon_bat",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:GetPreviewUnit()
	return "npc_dota_creature_acid_blob_effigy"
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:MustKillForEncounterCompletion( hEnemyCreature )
	if hEnemyCreature:GetUnitName() == "npc_dota_dummy_caster" then
		--print( '^^^DUMMY CASTER DOES NOT NEED TO DIE FOR COMPLETION' )
		return false
	end

	return CMapEncounter.MustKillForEncounterCompletion( self, hEnemyCreature )
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:Start()
	CMapEncounter.Start( self )

	--print( '^^^CMapEncounter_Blob_Dungeon:Start()!' )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:OnComplete()
	CMapEncounter.OnComplete( self )

	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "dungeon_door_relay_1", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "dungeon_door_relay_2", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "dungeon_door_relay_3", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:OnMasterWaveUnitKilled( hVictim, szWaveName, nWaveUnitsRemaining )
	CMapEncounter.OnMasterWaveUnitKilled( self, hVictim, szWaveName, nWaveUnitsRemaining )

	if szWaveName == 'Portal1_Wave1' and nWaveUnitsRemaining == 0 then
		print( 'Last enemy killed for Portal1_Wave1! Searching and destroying the door to the next area!' )
		local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "dungeon_door_relay_1", false )
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
			EmitGlobalSound( "Dungeon.StoneGate" )
		end
	elseif szWaveName == 'Portal2_Wave3' and nWaveUnitsRemaining == 0 then
		print( 'Last enemy killed for Portal2_Wave3! Searching and destroying the door to the next area!' )
		local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "dungeon_door_relay_2", false )
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
			EmitGlobalSound( "Dungeon.StoneGate" )
		end
	elseif szWaveName == 'Portal3_Wave3' and nWaveUnitsRemaining == 0 then
		print( 'Last enemy killed for Portal3_Wave3! Searching and destroying the door to the next area!' )
		local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "dungeon_door_relay_3", false )
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
			EmitGlobalSound( "Dungeon.StoneGate" )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Blob_Dungeon:OnEnemyCreatureSpawned( hEnemyCreature )
	CMapEncounter.OnEnemyCreatureSpawned( self, hEnemyCreature )

	if hEnemyCreature ~= nil and hEnemyCreature:GetUnitName() == 'npc_dota_creature_acid_blob' then
		local hAbility = hEnemyCreature:FindAbilityByName( 'acid_blob_jump' )
		RandomizeAbilityCooldown( hAbility )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Blob_Dungeon
