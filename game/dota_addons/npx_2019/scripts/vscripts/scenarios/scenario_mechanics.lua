require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )
require( "tasks/task_buy_item" )
require( "tasks/task_attack_enemy_creep" )
require( "tasks/task_last_hits" )
require( "tasks/task_hero_gained_level" )
require( "tasks/task_learn_ability" )
require( "tasks/task_use_ability" )
require( "tasks/task_destroy_enemy_tower" )

--------------------------------------------------------------------

if CDotaNPXScenario_Mechanics == nil then
	CDotaNPXScenario_Mechanics = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:InitScenarioKeys()
	self.hHeroSpawn = Entities:FindByName( nil, "radiant_hero_spawn_location" )
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hRadiantAncientLoc = Entities:FindByName( nil, "radiant_ancient_location" )
	self.hShopLoc = Entities:FindByName( nil, "shop_location" )
	self.hRadiantMidTier3Loc = Entities:FindByName( nil, "radiant_mid_location_3" )
	self.hRadiantMidTier2Loc = Entities:FindByName( nil, "radiant_mid_location_2" )
	self.hRadiantMidTier1Loc = Entities:FindByName( nil, "radiant_mid_location_1" )
	self.hDireMidTier3Loc = Entities:FindByName( nil, "dire_mid_location_3" )
	self.hDireMidTier2Loc = Entities:FindByName( nil, "dire_mid_location_2" )
	self.hDireMidTier1Loc = Entities:FindByName( nil, "dire_mid_location_1" )
	self.hTargetTower = Entities:FindByName( nil, "dota_badguys_tower1_mid" )
	self.hTopLaneLoc = Entities:FindByName( nil, "top_location" )
	self.hMidLaneLoc = Entities:FindByName( nil, "mid_location" )
	self.hBotLaneLoc = Entities:FindByName( nil, "bot_location" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_luna",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
		},
		StartingAbilities   =
		{			
			"luna_lunar_blessing",
		},

		ScenarioTimeLimit = 0, -- Not Timed.
	}

	self.nCheckpoint = 0

end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	self.bHasCompleted = false
	self.bTowerCanBeDamaged = false
	self.bHeroCanHeal = false
	self.bHealingHintShown = false
	self.bSalveInInventory = false
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
	Tutorial:SetItemGuide( "mechanics" )
	Tutorial:SetTutorialConvar( "dota_disable_top_lane", "1" )
	Tutorial:SetTutorialConvar( "dota_disable_mid_lane", "0" )
	Tutorial:SetTutorialConvar( "dota_disable_bot_lane", "1" )
	Tutorial:EnableCreepAggroViz( true )

	self.hScenario.bLetXPThrough = false -- Disallow Experience Gain

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Mechanics, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
	if self.nCheckpoint == 0 then
		self:StartIntro()
	elseif self.nCheckpoint == 1 then
		local bForceStart = true
		self:CheckpointSkipCompleteTask( "move_to_ancient", true, bForceStart )
		self:CheckpointSkipCompleteTask( "move_to_shop", true )
		self:CheckpointSkipCompleteTask( "buy_tango", true )
		self:CheckpointSkipCompleteTask( "buy_salve", true )
		self:CheckpointSkipCompleteTask( "buy_clarity", true )
		self:CheckpointSkipCompleteTask( "buy_circlet", true )
		self:CheckpointSkipCompleteTask( "buy_slippers", true )
		self:CheckpointSkipCompleteTask( "move_to_mid_lane", true )
		self:SetupStage3()
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
	self.hHero:SetAbilityPoints( 0 )
	FindClearSpaceForUnit( self.hHero, self.hHeroSpawn:GetAbsOrigin(), true )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:SetupStage1Tasks()
	--print("Setting up tasks")
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

	-- Stage 1 - Movement
	local moveToLocation1 = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_ancient",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hHeroLoc1:GetAbsOrigin(),
			GoalDistance = 64,
		},
		CheckTaskStart =
		function() return true end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:SetupStage2Tasks()
	--print("Setting up tasks")

	local vHeroPos = self.hHero:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vHeroPos.x .. " " .. vHeroPos.y .. " " .. 1 )

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

	-- Stage 2 - Shopping
	local moveToLocation2 = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_shop",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hHeroSpawn:GetAbsOrigin(),
			GoalDistance = 128,
		},
		CheckTaskStart =
		function() return true end,
	}, self ), 0.0 )

	local buyTango = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_tango",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_tango",
			WhiteList = { "item_tango", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_shop" )
		end,
	}, self ), 0.0 )

	local buySalve = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_salve",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_flask",
			WhiteList = { "item_flask", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_tango" )
		end,
	}, self ), 0.0 )

	local buyClarity = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_clarity",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_clarity",
			WhiteList = { "item_clarity", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_salve" )
		end,
	}, self ), 0.0 )

	local buyCirclet = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_circlet",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_circlet",
			WhiteList = { "item_circlet", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_clarity" )
		end,
	}, self ), 0.0 )

	local buyCirclet = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_slippers",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_slippers",
			WhiteList = { "item_slippers", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_circlet" )
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:SetupStage3()
	--print("Setting up Stage 3")
	self.hHero:AddItemByName( "item_tango" )
	self.hHero:AddItemByName( "item_flask" )
	self.hHero:AddItemByName( "item_clarity" )
	self.hHero:AddItemByName( "item_circlet" )
	self.hHero:AddItemByName( "item_slippers" )
	self.hHero:SetGold( 0, true ) 

	FindClearSpaceForUnit( self.hHero, self.hRadiantMidTier3Loc:GetAbsOrigin(), true )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	self:SetupStage3Tasks()
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:SetupStage3Tasks()
	--print("Setting up tasks")

	local vHeroPos = self.hHero:GetAbsOrigin()
	local vMidCreepSpawnPos = self.hRadiantMidTier3Loc:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vMidCreepSpawnPos.x .. " " .. vMidCreepSpawnPos.y .. " " .. 4 )

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

	-- Stage 2 - Shopping
	local moveToMidLane = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_mid_lane",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hRadiantMidTier3Loc:GetAbsOrigin(),
			GoalDistance = 128,
		},
		CheckTaskStart =
		function() return true end,
	}, self ), 0.0 )

	local followCreeps = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "follow_your_creeps",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hRadiantMidTier1Loc:GetAbsOrigin(),
			GoalDistance = 256,
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_mid_lane" )
		end,
	}, self ), 0.0 )

	local attackEnemy = rootTask:AddTask( CDotaNPXTask_AttackEnemyCreep( {
		TaskName = "attack_enemy",
		TaskType = "task_attack_enemy_creep",
		UseHints = true,
		TaskParams =
		{
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "follow_your_creeps" )
		end,
	}, self ), 0.0 )

	local earnLastHit = rootTask:AddTask( CDotaNPXTask_LastHits( {
		TaskName = "earn_last_hit",
		TaskType = "task_last_hits",
		UseHints = true,
		TaskParams =
		{
			Count = 1,
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "attack_enemy" )
		end,
	}, self ), 0.0 )

	local gainLevel = rootTask:AddTask( CDotaNPXTask_HeroGainedLevel( {
		TaskName = "gain_level",
		TaskType = "task_hero_gained_level",
		UseHints = true,
		TaskParams =
		{
			Level = 2,
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "earn_last_hit" )
		end,
	}, self ), 0.0 )

	local learnLucentBeam = rootTask:AddTask( CDotaNPXTask_LearnAbility( {
		TaskName = "learn_lucent_beam",
		TaskType = "task_learn_ability",
		UseHints = true,
		TaskParams =
		{
			AbilityName = "luna_lucent_beam",
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "gain_level" )
		end,
	}, self ), 0.0 )

	local useLucentBeam = rootTask:AddTask( CDotaNPXTask_UseAbility( {
		TaskName = "use_lucent_beam",
		TaskType = "task_use_ability",
		UseHints = true,
		TaskParams =
		{
			AbilityName = "luna_lucent_beam",
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "learn_lucent_beam" )
		end,
	}, self ), 0.0 )

	local destroyTower = rootTask:AddTask( CDotaNPXTask_DestroyEnemyTower( {
		TaskName = "destroy_tower",
		TaskType = "task_destroy_enemy_tower",
		UseHints = true,
		TaskParams =
		{
			TowerName = "npc_dota_badguys_tower1_mid",
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "use_lucent_beam" )
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	self:HideUIHint()
	if event.task_name == "move_to_ancient" then
		self:BlockPlayerFountain( false )
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_movement", 25.0 )
	elseif event.task_name == "move_to_shop" then
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_gold", 25.0 )
	elseif event.task_name == "buy_tango" then
		self:BlockPlayerFountain( true )
		self:ShowUIHint( "ShopButton", "scenario_mechanics_ui_tip_shop", 0.0, nil)
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_items", 25.0 )
		self.hHero:SetGold( GetCostOfItem( "item_tango" ), true )
	elseif event.task_name == "buy_salve" then
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_consume_pt1", 15.0 )
		self.hHero:SetGold( GetCostOfItem( "item_flask" ), true )
	elseif event.task_name == "buy_clarity" then
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_consume_pt2", 25.0 )
		self.hHero:SetGold( GetCostOfItem( "item_clarity" ), true )
	elseif event.task_name == "buy_circlet" then
		self.hHero:SetGold( GetCostOfItem( "item_circlet" ), true )
	elseif event.task_name == "buy_slippers" then
		self.hHero:SetGold( GetCostOfItem( "item_slippers" ), true )
	elseif event.task_name == "move_to_mid_lane" then
		self:BlockPlayerFountain( false )
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_creeps", 25.0 )
	elseif event.task_name == "follow_your_creeps" then
		self.bHeroCanHeal = true
		self:BlockPlayerMid( false )
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_waves", 25.0 )
	elseif event.task_name == "attack_enemy" then
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_attacking", 25.0 )
	elseif event.task_name == "earn_last_hit" then
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_last_hitting", 25.0 )
	elseif event.task_name == "gain_level" then
		-- Allow Experience Gain
		self.hScenario.bLetXPThrough = true
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_experience", 25.0 )
	elseif event.task_name == "learn_lucent_beam" then
		self:ShowUIHint( "Ability0 LevelUpButton", "scenario_mechanics_ui_tip_learn_lucent_beam", 0.0, nil )
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_abilities", 25.0 )
	elseif event.task_name == "use_lucent_beam" then
		self:ShowUIHint( "Ability0 AbilityButton", "scenario_mechanics_ui_tip_use_lucent_beam", 0.0, nil )
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_casting", 25.0 )
	elseif event.task_name == "destroy_tower" then
		-- Allow the tower to be damaged
		self.bTowerCanBeDamaged = true
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_towers", 25.0 )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )
	if event.task_name == "move_to_ancient" then
		local vAncientPos = self.hRadiantAncientLoc:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vAncientPos.x .. " " .. vAncientPos.y .. " " .. 1 )
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_ancient", 10.0 )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
			self:SetupStage2Tasks()
		end )
	elseif event.task_name == "buy_salve" then
		self.bSalveInInventory = true
	elseif event.task_name == "buy_slippers" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:ShowLanes()
		end )
	elseif event.task_name == "move_to_mid_lane" then
		self.nCheckpoint = 1
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
			GameRules:SetCreepSpawningEnabled( true )
			GameRules:SpawnAndReleaseCreeps()
		end )
	elseif event.task_name == "follow_your_creeps" then
		
	elseif event.task_name == "destroy_tower" then
		self.bScenarioComplete = true
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:OnScenarioRankAchieved( 1 )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:OnThink()
	CDotaNPXScenario.OnThink( self )
	--print( "Thinking" )
	if self.bTowerCanBeDamaged == false then
		-- Don't allow the tower to be destroyed before the task
		self.hTargetTower:ModifyHealth( 500, nil, false, 0 )
	end
	if self.hHero then
		if self.bHeroCanHeal then
			if self.bHealingHintShown == false and self.bScenarioComplete == false then
				local nHeroHealth = self.hHero:GetHealth()
				if nHeroHealth < self.hHero:GetMaxHealth() * 0.5 and self.hHero:FindItemInInventory( "item_flask" ) then
					print( "Hero health = " .. nHeroHealth )
					self:ShowItemHint( "item_flask" )
					self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_healing", 15.0 )
					self.bHealingHintShown = true
				end
			else
				if self.bSalveInInventory and self.hHero:FindItemInInventory( "item_flask" ) == nil then
					self:HideUIHint()
					self.bSalveInInventory = false
				end
			end
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:OnEntityKilled( hVictim, hKiller, hInflictor )
	CDotaNPXScenario:OnEntityKilled( hVictim, hKiller, hInflictor )

	if hVictim == self.hHero and self.bScenarioComplete == false then
		self:OnScenarioComplete( false )
	end	
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:StartIntro()
	--print("Starting Intro")
	self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_hero", 10.0 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_fountain", 10.0 )
	end )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 20, function()
		self:SetupStage1Tasks()
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:ShowLanes()
	--print("Show Lanes")
	Tutorial:SetShopOpen( false )
	self:ShowWizardTip( "scenario_mechanics_wizard_tip_intro_lanes", 15.0 )
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1600 )
	AddFOWViewer( DOTA_TEAM_GOODGUYS, self.hTopLaneLoc:GetAbsOrigin(), 3000, 10, false )
	local vTopPos = self.hTopLaneLoc:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vTopPos.x .. " " .. vTopPos.y .. " " .. 4 )

	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
		AddFOWViewer( DOTA_TEAM_GOODGUYS, self.hMidLaneLoc:GetAbsOrigin(), 3000, 10, false )
		local vMidPos = self.hMidLaneLoc:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vMidPos.x .. " " .. vMidPos.y .. " " .. 4 )
	end )

	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		AddFOWViewer( DOTA_TEAM_GOODGUYS, self.hBotLaneLoc:GetAbsOrigin(), 3000, 10, false )
		local vBotPos = self.hBotLaneLoc:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vBotPos.x .. " " .. vBotPos.y .. " " .. 4 )
	end )
	
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 15, function()
		GameRules:GetGameModeEntity():SetCameraDistanceOverride( 1200 )
		self:SetupStage3Tasks()
	end )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:BlockPlayerFountain( boolean )
	local hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hStartBlockers ) do
		if string.find( hBlocker:GetName(), "radiant_fountain_blocker_start" ) or string.find( hBlocker:GetName(), "radiant_fountain_blocker_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:BlockPlayerMid( boolean )
	local hMidBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hMidBlockers ) do
		if string.find( hBlocker:GetName(), "radiant_mid_blocker_start" ) or string.find( hBlocker:GetName(), "radiant_mid_blocker_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Mechanics:ShowItemHint( szItemName )
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

function CDotaNPXScenario_Mechanics:ShowClock( nTimer, fDuration)
	FireGameEvent( "timer_set", { timer_header = "scenario_creep_stacking_timer_header", timer_value = nTimer } )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + fDuration, function()
		FireGameEvent( "timer_hide", {} )
	end )
end

--------------------------------------------------------------------

return CDotaNPXScenario_Mechanics
