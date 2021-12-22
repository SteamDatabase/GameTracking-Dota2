
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_SmashyAndBashy == nil then
	CMapEncounter_SmashyAndBashy = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------


function CMapEncounter_SmashyAndBashy:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_SmashyAndBashy:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.hSmashy = nil 
	self.hBashy = nil

	self.vReinforcementSchedule =
	{
		Bashy =
		{
			SpawnerName = "spawner_bashy",
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
			Count = 1,
		},

		Smashy =
		{
			SpawnerName = "spawner_smashy",
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
			Count = 1,
		},

		Peons1 =
		{
			SpawnerName = "spawner_peon",
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 10.0,
				},
			},
			Count = 2,
		},
		Peons2 =
		{
			SpawnerName = "spawner_peon",
			TriggerData = 
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Smashy",
					HealthPercent = 50,
				},
			},
			Count = 3,
		},
		Peons3 =
		{
			SpawnerName = "spawner_peon",
			TriggerData = 
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Bashy",
					HealthPercent = 50,
				},
			},
			Count = 3,
		},
		Peons4 =
		{
			SpawnerName = "spawner_peon",
			TriggerData = 
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Smashy",
					HealthPercent = 5,
				},
			},
			Count = 4,
		},
		Peons5 =
		{
			SpawnerName = "spawner_peon",
			TriggerData = 
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Bashy",
					HealthPercent = 5,
				},
			},
			Count = 4,
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_smashy", "spawner_smashy", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_slardar_smashy",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_bashy", "spawner_bashy", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_slardar_bashy",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true ) )


	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_fortress_crab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 225.0,
			},
		}, true ) )

	self:SetMasterSpawnSchedule( self.vReinforcementSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_SmashyAndBashy:InitializeObjectives()
	self:AddEncounterObjective( "defeat_smashy", 0, 0 )
	self:AddEncounterObjective( "defeat_bashy", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_SmashyAndBashy:GetPreviewUnit()
	return "npc_dota_creature_slardar_smashy"
end

--------------------------------------------------------------------------------

function CMapEncounter_SmashyAndBashy:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_SmashyAndBashy:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	if #hSpawnedUnits > 0 then 
		for _,hUnit in pairs ( hSpawnedUnits ) do
			if hUnit and hUnit:GetUnitName() == "npc_dota_creature_slardar_smashy" then 
				self.hSmashy = hUnit 
				break 
			end

			if hUnit and hUnit:GetUnitName() == "npc_dota_creature_slardar_bashy" then 
				self.hBashy = hUnit 
				break 
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_SmashyAndBashy:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )
	if hVictim == nil then 
		return 
	end

	if hVictim == self.hSmashy then 
		if self.hBashy and self.hBashy:IsNull() == false and self.hBashy:IsAlive() then 
			local hBashyPassiveBuff = self.hBashy:FindModifierByName( "modifier_bashy_passive" )
			if hBashyPassiveBuff then 
				print( "Bashy is angry!" )
				hBashyPassiveBuff:SetStackCount( 200 )
			end
		end
	end

	if hVictim == self.hBashy then 
		if self.hSmashy and self.hSmashy:IsNull() == false and self.hSmashy:IsAlive() then 
			local hSmashyPassiveBuff = self.hSmashy:FindModifierByName( "modifier_smashy_passive" )
			if hSmashyPassiveBuff then 
				print( "Smashy is angry!" )
				hSmashyPassiveBuff:SetStackCount( 100 )
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_SmashyAndBashy
