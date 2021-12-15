
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Bloodbound == nil then
	CMapEncounter_Bloodbound = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bloodbound:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		--[[
		PrePlacedWarlocks =
		{
			SpawnerName = "spawner_peon",
			Count = 6,
			UsePortals = false,
			AggroHeroes = true,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 0.0,
				},
			},
		},
		]]

		--[[
		PrePlacedOgre1 =
		{
			SpawnerName = "spawner_ogre_1",
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
		PrePlacedOgre2 =
		{
			SpawnerName = "spawner_ogre_2",
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
		]]
		PrePlacedBloodseeker =
		{
			SpawnerName = "spawner_bloodseeker",
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
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedBloodseeker",
					HealthPercent = 80,
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
					TriggerAfterWave = "PrePlacedBloodseeker",
					HealthPercent = 60,
				},
			},
		},

		-- WAVE 3
		Wave3 =
		{
			SpawnerName = "wave_3",
			Count = 4,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedBloodseeker",
					HealthPercent = 35,
				},
			},
		},

	}

	local bInvulnerable = true

	-- preplaced enemies
	--[[
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bloodbound_warlock_baby",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )
	]]

	--[[
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_ogre_1", "spawner_ogre_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bloodbound_ogre_magi",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_ogre_2", "spawner_ogre_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bloodbound_ogre_magi",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )
	]]

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_bloodseeker", "spawner_bloodseeker", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bloodbound_bloodseeker",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal enemies
	-- wave 1
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bloodbound_ogre_magi",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- wave 2
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_bloodbound_ogre_magi",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )
	
	-- wave 3
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_wave_3", 8, 5, 1.0,
		{
			--[[
			{
				EntityName = "npc_dota_creature_bloodbound_warlock_baby",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 200.0,
			},
			]]
			{
				EntityName = "npc_dota_creature_bloodbound_ogre_magi",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bloodbound:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bloodbound:GetPreviewUnit()
	return "npc_dota_creature_bloodbound_bloodseeker"
end

--------------------------------------------------------------------------------

function CMapEncounter_Bloodbound:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	--self.szObjectiveEnts = "objective"
	--self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	--if #self.hObjectiveEnts == 0 then
	--	printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
	--end

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bloodbound:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_Bloodbound:Start()!' )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bloodbound:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bloodbound:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szLocatorName == "spawner_portal" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	--[[
	if hSpawner.szLocatorName == "spawner_bloodseeker" then
		if hSpawnedUnits[ 1 ] then
			self.hBloodseeker = hSpawnedUnits[ 1 ]
		end
	end
	]]
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_Bloodbound:GetBloodseeker()
	return self.hBloodseeker
end
]]

--------------------------------------------------------------------------------

return CMapEncounter_Bloodbound
