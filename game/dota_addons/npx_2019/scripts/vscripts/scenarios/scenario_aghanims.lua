require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )
require( "tasks/task_buy_item" )
require( "tasks/task_kill_units" )
require( "tasks/task_place_unit_at_location" )
require( "tasks/task_use_ability" )

--------------------------------------------------------------------

if CDotaNPXScenario_Aghanims == nil then
	CDotaNPXScenario_Aghanims = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:InitScenarioKeys()
	self.hHeroSpawn = Entities:FindByName( nil, "radiant_hero_spawn_location" )
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hRadiantAncientLoc = Entities:FindByName( nil, "radiant_ancient_location" )
	self.hShopLoc = Entities:FindByName( nil, "shop_location" )
	self.hRadiantMidTier3Loc = Entities:FindByName( nil, "radiant_mid_location_3" )
	self.hRadiantMidTier2Loc = Entities:FindByName( nil, "radiant_mid_location_2" )
	self.hRadiantMidTier1Loc = Entities:FindByName( nil, "radiant_mid_location_1" )
	self.hRadiantTopTier3Loc = Entities:FindByName( nil, "radiant_top_location_3" )
	self.hRadiantTopTier2Loc = Entities:FindByName( nil, "radiant_top_location_2" )
	self.hRadiantTopTier1Loc = Entities:FindByName( nil, "radiant_top_location_1" )
	self.hRadiantBotTier3Loc = Entities:FindByName( nil, "radiant_bot_location_3" )
	self.hRadiantBotTier2Loc = Entities:FindByName( nil, "radiant_bot_location_2" )
	self.hRadiantBotTier1Loc = Entities:FindByName( nil, "radiant_bot_location_1" )
	self.hDireMidTier3Loc = Entities:FindByName( nil, "dire_mid_location_3" )
	self.hDireMidTier2Loc = Entities:FindByName( nil, "dire_mid_location_2" )
	self.hDireMidTier1Loc = Entities:FindByName( nil, "dire_mid_location_1" )
	self.hTopLaneLoc = Entities:FindByName( nil, "top_location" )
	self.hMidLaneLoc = Entities:FindByName( nil, "mid_location" )
	self.hBotLaneLoc = Entities:FindByName( nil, "bot_location" )
	self.hRadiantMidNimbusLoc = Entities:FindByName( nil, "radiant_mid_highground_location" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_zuus",
		StartingHeroLevel	= 12,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_arcane_boots",
			"item_null_talisman",
			"item_aether_lens",
		},
		StartingAbilities   =
		{			
			"zuus_arc_lightning",
			"zuus_arc_lightning",
			"zuus_arc_lightning",
			"zuus_arc_lightning",
			"zuus_lightning_bolt",
			"zuus_lightning_bolt",
			"zuus_lightning_bolt",
			"zuus_lightning_bolt",
			"zuus_static_field",
			"zuus_static_field",
			"zuus_thundergods_wrath",
			"zuus_thundergods_wrath",
		},

		ScenarioTimeLimit = 0, -- Not Timed.
	}

	self.nCheckpoint = 0

end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	self.hUnitsToKill1 = {}
	self.hUnitsToKill2 = {}
	self.hUnitsToKill3 = {}
	self.bCreepWaveHasSpawned = false
	self.bScenarioComplete = false

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:SetTimeOfDay( 0.75 ) -- Daytime
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true ) -- Always daytime
	GameRules:SetHeroRespawnEnabled( false ) -- No respawn
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:SetCreepSpawningEnabled( false )

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "aghanims" )
	Tutorial:SetTutorialConvar( "dota_disable_top_lane", "1" )
	Tutorial:SetTutorialConvar( "dota_disable_mid_lane", "1" )
	Tutorial:SetTutorialConvar( "dota_disable_bot_lane", "1" )
	Tutorial:EnableCreepAggroViz( true )

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Aghanims, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
	
	if self.nCheckpoint == 0 then
		self:SetupStage1()
	elseif self.nCheckpoint == 1 then
		self:SetupStage1Tasks()
	elseif self.nCheckpoint == 2 then
		self:SetupStage2()
	elseif self.nCheckpoint == 3 then
		self:SetupStage3()
	elseif self.nCheckpoint == 4 then
		self:SetupStage4()
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
	--self.hHero:SetAbilityPoints( 0 )
	FindClearSpaceForUnit( self.hHero, self.hRadiantMidTier3Loc:GetAbsOrigin(), true )
	self:BlockPlayerFountain( false )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupTowers()
	local hTowers = Entities:FindAllByClassname( "npc_dota_tower" )
	if #hTowers > 0 then
		for _,hTower in pairs ( hTowers ) do
			if string.find( hTower:GetName(), "dota_goodguys_tower1_mid" ) or 
				string.find( hTower:GetName(), "dota_goodguys_tower2_mid" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower3_mid" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower1_top" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower2_top" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower3_top" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower1_bot" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower2_bot" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower3_bot" ) or
				string.find( hTower:GetName(), "dota_goodguys_tower4" ) then
				UTIL_Remove( hTower )
			end
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage1()
	--print("Stage 1")
	self:SetupTowers()
	self:ShowWizardTip( "scenario_aghanims_wizard_tip_intro_1", 10.0 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:ShowWizardTip( "scenario_aghanims_wizard_tip_intro_2", 10.0 )
		self:ShowUIHint( "AghsStatusScepter", "scenario_aghanims_ui_tip_description", 10.0, nil)
	end )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 20, function()
		self:SetupStage1Tasks()
		self.nCheckpoint = 1
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage1Tasks()
	--print("Setting up Stage 1 tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 1
	local moveToLocation1 = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_1",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hRadiantMidNimbusLoc:GetAbsOrigin(),
			GoalDistance = 64,
		},
		CheckTaskStart =
		function() 
			if GameRules:GetDOTATime( false, false ) >= 0.0 then 
				return true 
			else 
				return false 
			end
		end,
	}, self ), 0.0 )

	local killCreepWave1 = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_creep_wave_1",
		TaskType = "task_kill_units",
		UseHints = true,
		TaskParams =
		{
		},
		CheckTaskStart =
		function() 
			return self.bCreepWaveHasSpawned 
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage2()
	--print( "Stage 2" )
	self:Fade( 0 )
	self:BlockPlayerMid( true )
	self:RemoveCreepWaves()
	local vPlayerStartLoc = self.hRadiantMidTier3Loc:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	local nHeroHealth = self.hHero:GetMaxHealth()
	self.hHero:SetHealth( nHeroHealth )
	local nHeroMana = self.hHero:GetMaxMana()
	self.hHero:SetMana( nHeroMana )
	self.hHero:AddItemByName( "item_ultimate_scepter" )
	self:ShowItemHint( "item_ultimate_scepter" )
	self:ShowWizardTip( "scenario_aghanims_wizard_tip_scepter", 10.0 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:SetupStage2Tasks()
		self.nCheckpoint = 2
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage2Tasks()
	--print("Setting up Stage 2 tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 2
	local placeNimbus = rootTask:AddTask( CDotaNPXTask_PlaceUnit( {
		TaskName = "place_nimbus",
		TaskType = "task_place_unit_at_location",
		UseHints = true,
		TaskParams =
		{
			UnitName = "npc_dota_zeus_cloud",
			GoalLocation = self.hRadiantMidNimbusLoc:GetAbsOrigin(),
			GoalDistance = 256,
		},
		CheckTaskStart =
		function() 
			return true
		end,
	}, self ), 0.0 )

	local killCreepWave2 = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_creep_wave_2",
		TaskType = "task_kill_units",
		UseHints = true,
		TaskParams =
		{
		},
		CheckTaskStart =
		function() 
			return self.bCreepWaveHasSpawned
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage3()
	--print( "Stage 3" )
	self:Fade( 0 )
	self:BlockPlayerMid( true )
	self:RemoveCreepWaves()
	self:RemoveNimbus()
	local hAbilityNimbus = self.hHero:FindAbilityByName( "zuus_cloud" )
	hAbilityNimbus:EndCooldown()
	local vPlayerStartLoc = self.hRadiantMidTier3Loc:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	local nHeroHealth = self.hHero:GetMaxHealth()
	self.hHero:SetHealth( nHeroHealth )
	local nHeroMana = self.hHero:GetMaxMana()
	self.hHero:SetMana( nHeroMana )
	self:ShowWizardTip( "scenario_aghanims_wizard_tip_global", 10.0 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:SetupStage3aTasks()
		self.nCheckpoint = 3
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage3aTasks()
	--print("Setting up Stage 3a tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 3a
	local placeGlobalNimbus1 = rootTask:AddTask( CDotaNPXTask_PlaceUnit( {
		TaskName = "place_global_nimbus_1",
		TaskType = "task_place_unit_at_location",
		UseHints = true,
		TaskParams =
		{
			UnitName = "npc_dota_zeus_cloud",
			GoalLocation = self.hRadiantTopTier2Loc:GetAbsOrigin(),
			GoalDistance = 256,
		},
		CheckTaskStart =
		function() 
			return true
		end,
	}, self ), 0.0 )

end
--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage3bTasks()
	--print("Setting up Stage 3b tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 3b
	local placeGlobalNimbus2 = rootTask:AddTask( CDotaNPXTask_PlaceUnit( {
		TaskName = "place_global_nimbus_2",
		TaskType = "task_place_unit_at_location",
		UseHints = true,
		TaskParams =
		{
			UnitName = "npc_dota_zeus_cloud",
			GoalLocation = self.hRadiantMidTier1Loc:GetAbsOrigin(),
			GoalDistance = 256,
		},
		CheckTaskStart =
		function() 
			return true
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage3cTasks()
	--print("Setting up Stage 3c tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 3c
	local placeGlobalNimbus3 = rootTask:AddTask( CDotaNPXTask_PlaceUnit( {
		TaskName = "place_global_nimbus_3",
		TaskType = "task_place_unit_at_location",
		UseHints = true,
		TaskParams =
		{
			UnitName = "npc_dota_zeus_cloud",
			GoalLocation = self.hRadiantBotTier2Loc:GetAbsOrigin(),
			GoalDistance = 256,
		},
		CheckTaskStart =
		function() 
			return true
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage4()
	--print( "Stage 4" )
	self:Fade( 0 )
	self:BlockPlayerMid( true )
	self:RemoveCreepWaves()
	self:RemoveNimbus()
	local hAbilityNimbus = self.hHero:FindAbilityByName( "zuus_cloud" )
	hAbilityNimbus:EndCooldown()
	local vPlayerStartLoc = self.hRadiantMidTier3Loc:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	local nHeroHealth = self.hHero:GetMaxHealth()
	self.hHero:SetHealth( nHeroHealth )
	local nHeroMana = self.hHero:GetMaxMana()
	self.hHero:SetMana( nHeroMana )
	self.hHero:AddItemByName( "item_aghanims_shard" )
	self:ShowWizardTip( "scenario_aghanims_wizard_tip_shard", 10.0 )
	self:ShowUIHint( "AghsStatusScepter", "scenario_aghanims_ui_tip_description", 10.0, nil)
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:SetupStage4Tasks()
		self.nCheckpoint = 4
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SetupStage4Tasks()
	--print("Setting up Stage 4 tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 4
	local useHeavenlyJump = rootTask:AddTask( CDotaNPXTask_UseAbility( {
		TaskName = "use_heavenly_jump",
		TaskType = "task_use_ability",
		UseHints = true,
		TaskParams =
		{
			AbilityName = "zuus_static_field",
			WhiteList = true,
		},
		CheckTaskStart =
		function() 
			return true
		end,
	}, self ), 0.0 )

	local killCreepWave3 = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_creep_wave_3",
		TaskType = "task_kill_units",
		UseHints = true,
		TaskParams =
		{
		},
		CheckTaskStart =
		function() 
			return self.bCreepWaveHasSpawned
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	self:HideUIHint()
	if event.task_name == "kill_creep_wave_1" then
		self:BlockPlayerMid( false )
	elseif event.task_name == "place_nimbus" then
		self:RemoveNimbus()
		local hAbilityNimbus = self.hHero:FindAbilityByName( "zuus_cloud" )
		hAbilityNimbus:EndCooldown()
		self:ShowUIHint( "Ability3", "scenario_aghanims_ui_tip_nimbus", 10.0, nil)
	elseif event.task_name == "place_global_nimbus_1" then
		local vNimbusPos = self.hRadiantTopTier2Loc:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vNimbusPos.x .. " " .. vNimbusPos.y .. " " .. 2 )
		self:SpawnCreepWaves( 1, self.hRadiantTopTier2Loc, true )
		self:RemoveNimbus()
		local hAbilityNimbus = self.hHero:FindAbilityByName( "zuus_cloud" )
		hAbilityNimbus:EndCooldown()
		self:ShowUIHint( "Ability3", "scenario_aghanims_ui_tip_nimbus", 10.0, nil)
	elseif event.task_name == "place_global_nimbus_2" then
		local vNimbusPos = self.hRadiantMidTier1Loc:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vNimbusPos.x .. " " .. vNimbusPos.y .. " " .. 2 )
		self:RemoveCreepWaves()
		self:RemoveNimbus()
		self:SpawnCreepWaves( 1, self.hRadiantMidTier1Loc, true )
		local hAbilityNimbus = self.hHero:FindAbilityByName( "zuus_cloud" )
		hAbilityNimbus:EndCooldown()
		self:ShowUIHint( "Ability3", "scenario_aghanims_ui_tip_nimbus", 10.0, nil)
	elseif event.task_name == "place_global_nimbus_3" then
		local vNimbusPos = self.hRadiantBotTier2Loc:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vNimbusPos.x .. " " .. vNimbusPos.y .. " " .. 2 )
		self:RemoveCreepWaves()
		self:RemoveNimbus()
		self:SpawnCreepWaves( 1, self.hRadiantBotTier2Loc, true )
		local hAbilityNimbus = self.hHero:FindAbilityByName( "zuus_cloud" )
		hAbilityNimbus:EndCooldown()
		self:ShowUIHint( "Ability3", "scenario_aghanims_ui_tip_nimbus", 10.0, nil)
	elseif event.task_name == "kill_creep_wave_2" then
		self:BlockPlayerMid( false )
	elseif event.task_name == "use_heavenly_jump" then
		local hAbilityJump = self.hHero:FindAbilityByName( "zuus_static_field" )
		hAbilityJump:EndCooldown()
		self:ShowUIHint( "Ability2", "scenario_aghanims_ui_tip_heavenly_jump", 10.0, nil)
	elseif event.task_name == "kill_creep_wave_3" then
		self:BlockPlayerMid( false )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )
	if event.task_name == "move_to_location_1" then
		self:SpawnCreepWaves( 1, self.hRadiantMidTier2Loc, false )
	elseif event.task_name == "kill_creep_wave_1" then
		self.bCreepWaveHasSpawned = false
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
			self:Fade( 1 )
		end )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:SetupStage2()
		end )
	elseif event.task_name == "place_nimbus" then
		self:SpawnCreepWaves( 2, self.hRadiantMidTier2Loc, false )
	elseif event.task_name == "kill_creep_wave_2" then
		self.bCreepWaveHasSpawned = false
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
			self:Fade( 1 )
		end )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:SetupStage3()
		end )
	elseif event.task_name == "place_global_nimbus_1" then
		self.bCreepWaveHasSpawned = false
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
			self:SetupStage3bTasks()
		end )
	elseif event.task_name == "place_global_nimbus_2" then
		self.bCreepWaveHasSpawned = false
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
			self:SetupStage3cTasks()
		end )
	elseif event.task_name == "place_global_nimbus_3" then
		self.bCreepWaveHasSpawned = false
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
			self:Fade( 1 )
		end )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 6, function()
			self:SetupStage4()
		end )
	elseif event.task_name == "use_heavenly_jump" then
		self:SpawnCreepWaves( 3, self.hRadiantMidTier2Loc, false )
		local hAbilityJump = self.hHero:FindAbilityByName( "zuus_static_field" )
		hAbilityJump:EndCooldown()
	elseif event.task_name == "kill_creep_wave_3" then
		self.bScenarioComplete = true
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:OnScenarioRankAchieved( 1 )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:OnEntityKilled( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	
	if hEnt == self.hPlayerHero then
		if self.bScenarioCompleted == false then
			self:OnScenarioComplete( false, "task_fail_player_hero_death_fail" )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:SpawnCreepWaves( nWave, hLocation, bRadiant )
	print( "Spawning Creep Waves" )
	local vLocation = hLocation:GetAbsOrigin()
	if bRadiant then
		local hRadiantSpawner = Entities:FindByName( nil, "npc_dota_spawner_good_mid_staging" )
		local hRadiantCreepPath = Entities:FindByName( nil, "lane_mid_pathcorner_goodguys_1" )
		
		for i = 1, 3 do
		    local radiantMelee = CreateUnitByName( "npc_dota_creep_goodguys_melee", vLocation + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
		    --radiantMelee:SetInitialGoalEntity( hRadiantCreepPath )
		end
		local radiantRanged = CreateUnitByName( "npc_dota_creep_goodguys_ranged", vLocation, true, nil, nil, DOTA_TEAM_GOODGUYS )
		--radiantRanged:SetInitialGoalEntity( hRadiantCreepPath )
	end
	
	local nMeleeCreeps = 3 * nWave
	local hDireCreepPath = Entities:FindByName( nil, "lane_mid_pathcorner_badguys_6" )
	for i = 1, nMeleeCreeps do
	    local direMelee = CreateUnitByName( "npc_dota_creep_badguys_melee", vLocation + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	    if bRadiant == false then
	    	direMelee:SetInitialGoalEntity( hDireCreepPath )
	    	self:RegisterUnits( direMelee )
	    end
	end
	local nRangedCreeps = 1 * nWave
	for i = 1, nRangedCreeps do
		local direRanged = CreateUnitByName( "npc_dota_creep_badguys_ranged", vLocation, true, nil, nil, DOTA_TEAM_BADGUYS )
		if bRadiant == false then
			direRanged:SetInitialGoalEntity( hDireCreepPath )
			self:RegisterUnits( direRanged )
		end
	end

	self.bCreepWaveHasSpawned = true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:RemoveCreepWaves()
	local creepUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.hHero:GetOrigin(), self.hHero, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #creepUnits > 0 then
		for _,unit in pairs( creepUnits ) do
			if unit:GetUnitName() == "npc_dota_creep_goodguys_melee" or unit:GetUnitName() == "npc_dota_creep_goodguys_ranged" or 
				unit:GetUnitName() == "npc_dota_creep_badguys_melee" or unit:GetUnitName() == "npc_dota_creep_badguys_ranged" then
				UTIL_Remove( unit )
			end
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:RegisterUnits( unit )
	print( "Registering Creep Unit" )
	if unit ~= nil and unit:IsNull() == false then
		local Task1 = self:GetTask( "kill_creep_wave_1" )
		if Task1 then
			table.insert( self.hUnitsToKill1, unit )
			Task1:SetUnitsToKill( self.hUnitsToKill1 )
		end
		local Task2 = self:GetTask( "kill_creep_wave_2" )
		if Task2 then
			table.insert( self.hUnitsToKill2, unit )
			Task2:SetUnitsToKill( self.hUnitsToKill2 )
		end
		local Task3 = self:GetTask( "kill_creep_wave_3" )
		if Task3 then
			table.insert( self.hUnitsToKill3, unit )
			Task3:SetUnitsToKill( self.hUnitsToKill3 )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:BlockPlayerFountain( boolean )
	local hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hStartBlockers ) do
		if string.find( hBlocker:GetName(), "radiant_fountain_blocker_start" ) or string.find( hBlocker:GetName(), "radiant_fountain_blocker_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:BlockPlayerMid( boolean )
	local hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hStartBlockers ) do
		if string.find( hBlocker:GetName(), "radiant_mid_blocker_start" ) or string.find( hBlocker:GetName(), "radiant_mid_blocker_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:RemoveNimbus()
	local nimbusUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.hHero:GetOrigin(), self.hHero, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #nimbusUnits > 0 then
		for _,unit in pairs( nimbusUnits ) do
			if unit:GetUnitName() == "npc_dota_zeus_cloud" then
				UTIL_Remove( unit )
			end
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:Fade( nFade )
	-- Fade should be 1 to fade to black and 0 to fade in
	FireGameEvent("fade_to_black", {
		fade_down = nFade,
		} )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:ShowItemHint( szItemName )
	local hItem = self.hHero:FindItemInInventory( szItemName )
	if hItem then
		local nItemSlot = hItem:GetItemSlot()
		if nItemSlot >= 0 then
			self:ShowUIHint( "inventory_slot_" .. nItemSlot )
			return
		end
	end
	self:HideUIHint()
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Aghanims:ShowClock( nTimer, fDuration)
	FireGameEvent( "timer_set", { timer_header = "scenario_creep_stacking_timer_header", timer_value = nTimer } )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + fDuration, function()
		FireGameEvent( "timer_hide", {} )
	end )
end

--------------------------------------------------------------------

return CDotaNPXScenario_Aghanims
