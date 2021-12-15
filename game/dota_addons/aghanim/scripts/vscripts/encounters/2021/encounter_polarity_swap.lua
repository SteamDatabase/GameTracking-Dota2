
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

LinkLuaModifier( "modifier_polarity", "modifiers/creatures/modifier_polarity", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CMapEncounter_PolaritySwap == nil then
	CMapEncounter_PolaritySwap = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	local vRedPortalColor = Vector( 220, 20, 60 )
	local vGreenPortalColor = Vector( 115, 220, 115 )

	self.vMasterWaveSchedule =
	{
		PrePlacedGhostsPositive =
		{
			SpawnerName = "spawner_preplaced_ghosts",
			Count = 2,
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

		Wave1_Captain_Positive =
		{
			SpawnerName = "wave_1_positive",
			Count = 1,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 5.0,
				},
			},
		},
		Wave1_Captain_Negative =
		{
			SpawnerName = "wave_1_negative",
			Count = 1,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "Wave1_Captain_Positive",
					HealthPercent = 50,
				},
			},
		},
		Wave1_Fodder =
		{
			SpawnerName = "fodder",
			Count = 2,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave1_Captain_Negative",
					Time = 5,
				},
			},
		},

		-- WAVE 2
		Wave2_Captain_Negative =
		{
			SpawnerName = "wave_2_negative",
			Count = 1,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1_Captain_Negative",
					KillPercent = 100,
				},
			},
		},
		Wave2_Captain_Positive =
		{
			SpawnerName = "wave_2_positive",
			Count = 1,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave1_Captain_Negative",
					KillPercent = 100,
				},
			},
		},
		Wave2_Fodder =
		{
			SpawnerName = "fodder",
			Count = 3,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave2_Captain_Positive",
					Time = 5,
				},
			},
		},

		-- WAVE 3
		Wave3_Captain_Negative =
		{
			SpawnerName = "wave_3_negative",
			Count = 1,
			TriggerData =
			{
				KillPrecent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2_Captain_Positive",
					KillPercent = 100,
				},
			},
		},
		Wave3_Captain_Positive =
		{
			SpawnerName = "wave_3_positive",
			Count = 2,
			TriggerData =
			{
				KillPrecent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_KILL_PERCENT,
					TriggerAfterWave = "Wave2_Captain_Negative",
					KillPercent = 100,
				},
			},
		},
		Wave3_Fodder =
		{
			SpawnerName = "fodder",
			Count = 4,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_RELATIVE,
					TriggerAfterWave = "Wave3_Captain_Positive",
					Time = 5,
				},
			},
		},
	}

	local bInvulnerable = true

	-- preplaced ghosts
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_ghosts", "preplaced_ghosts", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_neutral",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable, vGreenPortalColor ) )

	-- portal enemies

	-- FODDER
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "fodder", "fodder", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_neutral",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable, vGreenPortalColor ) )

	-- WAVE 1 CAPTAINS
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_positive", "wave_1_positive", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_captain_positive",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_1_negative", "wave_1_negative", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_captain_negative",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable, vRedPortalColor ) )

	-- WAVE 2 CAPTAINS
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_positive", "wave_2_positive", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_captain_positive",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_2_negative", "wave_2_negative", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_captain_negative",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable, vRedPortalColor ) )

	-- WAVE 3 CAPTAINS
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3_positive", "wave_3_positive", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_captain_positive",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "wave_3_negative", "wave_3_negative", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_polarity_ghost_captain_negative",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable, vRedPortalColor ) )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/polarity/polarity_positive_shield.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_negative_shield.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:GetPreviewUnit()
	return "npc_dota_creature_polarity_ghost_captain_positive"
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:MustKillForEncounterCompletion( hEnemyCreature )
	if hEnemyCreature:GetUnitName() == "npc_dota_dummy_caster" then
		--print( '^^^DUMMY CASTER DOES NOT NEED TO DIE FOR COMPLETION' )
		return false
	end

	return CMapEncounter.MustKillForEncounterCompletion( self, hEnemyCreature )
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_PolaritySwap:Start()!' )

	local nPolarity = 1
	local nRand = RandomInt( 0, 1 )
	if nRand == 1 then
		nPolarity = -1
	end
	
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_polarity", { duration = -1, polarity = nPolarity } )
			nPolarity = nPolarity * -1
		end
	end
end

--------------------------------------------------------------------------------

--[[function CMapEncounter_PolaritySwap:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vMasterWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szLocatorName == "spawner_portal" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end
end]]--

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:OnMasterWaveUnitKilled( hVictim, szWaveName, nWaveUnitsRemaining )
	CMapEncounter.OnMasterWaveUnitKilled( self, hVictim, szWaveName, nWaveUnitsRemaining )

	--if szWaveName == 'Wave1' and nWaveUnitsRemaining == 0 then
	--	print( 'WAVE 1 COMPLETE! Swapping Player Polarities!' )
	--	self:SwapPlayerPolarities()
	--end
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:SwapPlayerPolarities()
	local nPolarity = 1
	local nRand = RandomInt( 0, 1 )
	if nRand == 1 then
		nPolarity = -1
	end

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then
			local hBuff = hPlayerHero:FindModifierByName( "modifier_polarity" )
			if hBuff then
				hBuff:SwapPolarity()
			else
				-- buff was missing???
				print( 'ERROR - player was missing a polarity buff!!!' )
				hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_polarity", { duration = -1, polarity = nPolarity } )
				nPolarity = nPolarity * -1
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PolaritySwap:OnComplete()
	CMapEncounter.OnComplete( self )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero and not hPlayerHero:IsNull() and hPlayerHero:IsRealHero() then 
			hPlayerHero:RemoveModifierByName( "modifier_polarity" )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_PolaritySwap
