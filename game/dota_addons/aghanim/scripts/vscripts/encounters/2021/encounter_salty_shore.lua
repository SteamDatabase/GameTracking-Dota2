
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_SaltyShore == nil then
	CMapEncounter_SaltyShore = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedMines =
		{
			SpawnerName = "spawner_preplaced_mines",
			Count = 10,
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

		PrePlacedCaptain1 =
		{
			SpawnerName = "spawner_captain_1",
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
		PrePlacedCaptain2 =
		{
			SpawnerName = "spawner_captain_2",
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
			Count = 2,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedMines",
					KillPercent = 50,
				},
			},
		},

		-- WAVE 2
		Wave2 =
		{
			SpawnerName = "wave_2",
			Count = 2,
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
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_mines", "spawner_mine", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_shore_mine",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peons", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_diregull_small",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain_1", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_diregull",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain_2", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_diregull",
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
				EntityName = "npc_dota_creature_diregull_small",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_diregull",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 2
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_diregull_small",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_diregull",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 3
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_diregull_small",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_diregull",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
	self.nEnemyCount = 999999
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/creatures/diregull/diregull_death_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/diregull/diregull_fish_attack.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/diregull/diregull_fish_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:GetPreviewUnit()
	return "npc_dota_creature_diregull"
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:Start()
	CMapEncounter.Start( self )

end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	self.nEnemyCount = self:GetMaxSpawnedUnitCount()
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:GetMaxSpawnedUnitCount()
	local nCount = 0
	-- Preplaced Spawners
	nCount = nCount + ( 3 * 3 )
	nCount = nCount + ( 2 )

	-- Dynamic Spawners
	nCount = nCount + ( 4 * 2 )
	nCount = nCount + ( 4 * 2 )
	nCount = nCount + ( 4 * 3 )

	print( "Number of spawned enemies = " .. nCount )
	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:OnRequiredEnemyKilled( hAttacker, hVictim )
	--CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )
	if hVictim:GetUnitName() == "npc_dota_creature_diregull" or 
		hVictim:GetUnitName() == "npc_dota_creature_diregull_small" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
		self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:CheckForCompletion()
	local nEnemiesProgress = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	if nEnemiesProgress >= self.nEnemyCount then 
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
		if hSpawnedUnit:GetUnitName() =="npc_dota_creature_diregull_small" then
			hSpawnedUnit:SetRenderColor(240,190,140)
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SaltyShore:OnComplete()
	CMapEncounter.OnComplete( self )

	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "wall_1_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "wall_2_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "wall_3_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "wall_4_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "wall_5_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_SaltyShore
