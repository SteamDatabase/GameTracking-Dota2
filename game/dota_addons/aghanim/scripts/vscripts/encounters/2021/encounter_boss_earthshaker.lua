
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_boss_base" )

--------------------------------------------------------------------------------

if CMapEncounter_BossEarthshaker == nil then
	CMapEncounter_BossEarthshaker = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:constructor( hRoom, szEncounterName )

	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	self.szBossSpawner = "spawner_boss"

	self:AddSpawner( CDotaSpawner( self.szBossSpawner, self.szBossSpawner,
		{ 
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	local nAscLevel = GameRules.Aghanim:GetAscensionLevel()
	local nPreplacedMounds = 7 + ( 2 * nAscLevel )

	self.vDirtMoundSchedule =
	{
		{
			Time = 0,
			Count = nPreplacedMounds,
		},
	}

	self:AddSpawner( CDotaSpawner( "dirt_mound_position", "dirt_mound_position",
		{ 
			{
				EntityName = "npc_dota_earthshaker_dirt_mound",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:SetSpawnerSchedule( "dirt_mound_position", self.vDirtMoundSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetPreviewUnit()
	return "npc_dota_boss_earthshaker"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroGesture()
	return ACT_DOTA_CAPTURE
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroCameraPitch()
	return 30
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroCameraDistance()
	return 800
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroCameraHeight()
	return 85
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroCameraYawRotateSpeed()
	return 0.1
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroCameraInitialYaw()
	return 120
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroDuration()
	return 5.0
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:IntroduceBoss( hEncounteredBoss )
	CMapEncounter_BossBase.IntroduceBoss( self, hEncounteredBoss )

	--EmitGlobalSound( "Boss.Intro" )

	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "entrance_bridge_relay", false )
	for _, hRelay in pairs( hRelays ) do
		print( 'FOUND RELAY! Triggering!' )
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:Start()
	CMapEncounter_BossBase.Start( self )

	self:CreateOtherUnits()
	--self:GetSpawner( "dirt_mound_position" ):SpawnUnits()
end

--------------------------------------------------------------------------------

function CMapEncounter_BossBase:CreateOtherUnits()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		if Spawner.szSpawnerName ~= "spawner_boss" then
			Spawner:SpawnUnits()
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_earthshaker_minion" then
    	return false
    end

    return true
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
end

---------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )

	local vecMinions = self:GetRoom():FindAllEntitiesInRoomByName( "npc_dota_creature_earthshaker_minion", false )
	if #vecMinions > 0 then
		for _, hMinion in pairs ( vecMinions ) do
			hMinion:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:OnComplete()
	CMapEncounter_BossBase.OnComplete( self )

	print( 'COMPLETE! Attempting to open completion door!' )
	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "completion_door_relay", false )
	for _, hRelay in pairs( hRelays ) do
		print( 'FOUND RELAY! Triggering!' )
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:OnTriggerStartTouch( event )
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	-- Teleport hero to location inside the arena
	if szTriggerName == "trigger_entrance" then
		--print( "Player has left the arena!" )
		local hTeleportTargetEntrance = Entities:FindByName( nil, "teleport_players" )
		local vTeleportPosEntrance = hTeleportTargetEntrance:GetAbsOrigin()
		FindClearSpaceForUnit( hUnit, vTeleportPosEntrance, true )
	elseif szTriggerName == "trigger_exit" then
		--print( "Player has left the arena!" )
		local hTeleportTargetExit = Entities:FindByName( nil, "teleport_players_exit" )
		local vTeleportPosExit = hTeleportTargetExit:GetAbsOrigin()
		FindClearSpaceForUnit( hUnit, vTeleportPosExit, true )
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetBossIntroVoiceLine()
	local nLine = RandomInt( 0, 3 )

	if nLine == 0 then
		return "earthshaker_earth_arcana_battlebegins_01"
	end

	if nLine == 1 then
		return "earthshaker_earth_arcana_spawn_09_03"
	end

	if nLine == 2 then
		return "earthshaker_earth_arcana_rare_05_02"
	end

	if nLine == 3 then
		return "earthshaker_earth_arcana_spawn_08_02"
	end

	return "earthshaker_earth_arcana_spawn_09_03"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetLaughLine()
	local szLines = 
	{
		"earthshaker_earth_arcana_laugh_02",
		"earthshaker_earth_arcana_laugh_04",
		"earthshaker_earth_arcana_laugh_05",
		"earthshaker_earth_arcana_laugh_06",
		"earthshaker_earth_arcana_laugh_07",
		"earthshaker_earth_arcana_laugh_08",
		"earthshaker_earth_arcana_laugh_09",
		"earthshaker_earth_arcana_laugh_10",
		"earthshaker_earth_arcana_laugh_12",
		"earthshaker_earth_arcana_laugh_13",
		"earthshaker_earth_arcana_laugh_14",
		"earthshaker_earth_arcana_laugh_15",
		"earthshaker_earth_arcana_laugh_16",
		"earthshaker_earth_arcana_laugh_17",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetKillTauntLine()
	local szLines = 
	{
		"earthshaker_earth_arcana_spawn_06_04",
		"earthshaker_earth_arcana_kill_01",
		"earthshaker_earth_arcana_kill_02",
		"earthshaker_earth_arcana_kill_03",
		"earthshaker_earth_arcana_kill_04_01",
		"earthshaker_earth_arcana_kill_04_02",
		"earthshaker_earth_arcana_kill_05",
		"earthshaker_earth_arcana_kill_06",
		"earthshaker_earth_arcana_kill_08",
		"earthshaker_earth_arcana_kill_13",
		"earthshaker_earth_arcana_kill_15",
		"earthshaker_earth_arcana_kill_16",
		"earthshaker_earth_arcana_wheel_all_08",
		"earthshaker_earth_arcana_wheel_all_10",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossEarthshaker:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()
	if szAbilityName == "boss_earthshaker_smash" then
		local szLines = 
		{
			"earthshaker_earth_arcana_ability_effort_02",
			"earthshaker_earth_arcana_ability_effort_03",
			"earthshaker_earth_arcana_ability_effort_04",
			"earthshaker_earth_arcana_ability_effort_05",
			"earthshaker_earth_arcana_ability_effort_06",
			"earthshaker_earth_arcana_ability_effort_07",
			"earthshaker_earth_arcana_ability_effort_08",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_boss_earthshaker_enchant_totem" then
		local szLines = 
		{
			"earthshaker_earth_arcana_ability_aghs_fly_01_01",
			"earthshaker_earth_arcana_ability_aghs_fly_02_02",
			"earthshaker_earth_arcana_ability_aghs_fly_03",
			"earthshaker_earth_arcana_ability_aghs_fly_07_01",
			"earthshaker_earth_arcana_ability_aghs_fly_08_03",
			"earthshaker_earth_arcana_ability_aghs_fly_10_01",
			"earthshaker_earth_arcana_ability_enchant_01",
			"earthshaker_earth_arcana_ability_enchant_02_02",
			"earthshaker_earth_arcana_ability_enchant_03",
			"earthshaker_earth_arcana_ability_enchant_05",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_earthshaker_fissure" then
		local szLines = 
		{
			"earthshaker_earth_arcana_ability_fissure_01",
			"earthshaker_earth_arcana_ability_fissure_02",
			"earthshaker_earth_arcana_ability_fissure_04",
			"earthshaker_earth_arcana_ability_fissure_05",
			"earthshaker_earth_arcana_ability_fissure_06",
			"earthshaker_earth_arcana_ability_fissure_07",
			"earthshaker_earth_arcana_ability_fissure_08",
			"earthshaker_earth_arcana_ability_fissure_09",
			"earthshaker_earth_arcana_ability_fissure_10",
			"earthshaker_earth_arcana_ability_fissure_11",
			"earthshaker_earth_arcana_ability_fissure_12_01",
			"earthshaker_earth_arcana_ability_fissure_12_02",
			"earthshaker_earth_arcana_ability_fissure_13_01",
			"earthshaker_earth_arcana_ability_fissure_13_02",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_earthshaker_quake" then
		local szLines = 
		{
			"earthshaker_earth_arcana_spawn_03_04",
			"earthshaker_earth_arcana_spawn_07_02",
			"earthshaker_earth_arcana_ability_enchant_21",
			"earthshaker_earth_arcana_ability_enchant_22",
			"earthshaker_earth_arcana_nod_01_02",
			"earthshaker_earth_arcana_nod_02",
			"earthshaker_earth_arcana_nod_05",
			"earthshaker_earth_arcana_wheel_all_01_02",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end
	
	return szLineToUse
end

--------------------------------------------------------------------------------

return CMapEncounter_BossEarthshaker
