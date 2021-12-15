
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Catacombs == nil then
	CMapEncounter_Catacombs = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_cast_ink_swell.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_ink_swell_tick_damage.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedGrimstroke =
		{
			SpawnerName = "spawner_preplaced_grimstroke",
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
		PrePlacedLifestealer =
		{
			SpawnerName = "spawner_preplaced_lifestealer",
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

		Wave1 =
		{
			SpawnerName = "spawner_a",
			Count = 3,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedLifestealer",
					KillPercent = 100,
				},
			},
		},
		Wave2 =
		{
			SpawnerName = "spawner_b",
			Count = 2,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "PrePlacedLifestealer",
					KillPercent = 100,
				},
			},
		},
		Wave3 =
		{
			SpawnerName = "spawner_c",
			Count = 2,
			AggroHeroes = false,
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
		Wave4 =
		{
			SpawnerName = "spawner_d",
			Count = 2,
			AggroHeroes = false,
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
	}

	local bInvulnerable = true

	-- preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_grimstroke", "spawner_grimstroke", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_grimstroke",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_lifestealer", "spawner_lifestealer", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_life_stealer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )	

	-- portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_a", "spawner_lifestealer_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_life_stealer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_b", "spawner_grimstroke_wave_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_grimstroke",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_c", "spawner_lifestealer_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_life_stealer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_d", "spawner_grimstroke_wave_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_grimstroke",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )

end


--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:GetPreviewUnit()
	return "npc_dota_creature_life_stealer"
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:CheckForCompletion()
	if not self:HasRemainingEnemies() and not self:HasAnyPortals() then

		-- Disable any traps in the map
		local hRelays = Entities:FindAllByName( "disable_traps_relay" )
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
		end

		return true
	end

	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Catacombs:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_Catacombs
