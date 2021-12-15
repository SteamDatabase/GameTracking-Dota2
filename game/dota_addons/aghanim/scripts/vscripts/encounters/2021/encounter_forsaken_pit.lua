
require( "map_encounter" )
require( "aghanim_utility_functions" )

require( "spawner" )
require( "portalspawnerv2" )
require( "utility_functions" )

--------------------------------------------------------------------------------

if CMapEncounter_ForsakenPit == nil then
	CMapEncounter_ForsakenPit = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_ForsakenPit:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_centaur", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_ForsakenPit:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.nAxesRemaining = 2

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
		{
			SpawnerName = "preplaced_peon",
			Count = 5,
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
			SpawnerName = "preplaced_captain",
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

		Wave1 =
		{
			SpawnerName = "wave_1",
			Count = 2,
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
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1",
					KillPercent = 50,
				},
				TimeRelative = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave1",
					Time = 40.0,
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
		Wave4 =
		{
			SpawnerName = "wave_4",
			Count = 1,
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
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "preplaced_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_naked_axe",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "preplaced_captain", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_centaur_warrunner",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_naked_axe",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_centaur_warrunner",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2", "spawner_boss", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_huge_axe",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3", "spawner_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_naked_axe",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_centaur_warrunner",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_4", "spawner_boss", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_huge_axe",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )

end

--------------------------------------------------------------------------------

function CMapEncounter_ForsakenPit:GetPreviewUnit()
	return "npc_dota_creature_huge_axe"
end

--------------------------------------------------------------------------------

function CMapEncounter_ForsakenPit:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_ForsakenPit:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_huge_axe" then
		self.nAxesRemaining = self.nAxesRemaining - 1
		if self.nAxesRemaining == 0 then
			self:WakeUpRoom()
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_ForsakenPit:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

end

--------------------------------------------------------------------------------

function CMapEncounter_ForsakenPit:WakeUpRoom()
	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	local stragglers = self:GetSpawnedUnitsOfType( "npc_dota_creature_centaur_warrunner" )
	print( 'Waking up ' .. #stragglers .. " stragglers")
	if #stragglers > 0 then
		for _,hUnit in pairs ( stragglers ) do
			if #heroes > 0 then
				local hero = heroes[RandomInt(1, #heroes)]
				if hero ~= nil then
					--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
					hUnit:SetInitialGoalEntity( hero )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_ForsakenPit
