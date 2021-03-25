require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_parallel" )
require( "tasks/task_move_to_location" )
require( "tasks/task_earn_gold" )
require( "tasks/task_buy_item" )
require( "tasks/task_courier_move_to_location" )
require( "tasks/task_courier_deliver_item" )
require( "tasks/task_courier_retrieve_item" )

--------------------------------------------------------------------

if CDotaNPXScenario_Courier == nil then
	CDotaNPXScenario_Courier = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_night_stalker",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel	= 8,
		StartingGold		= 1000,
		StartingItems 		=
		{
			"item_phase_boots",
			"item_urn_of_shadows",
			"item_blade_of_alacrity",
			"item_quelling_blade",
		},
		StartingAbilities   =
		{			
		},
		ScenarioTimeLimit = 0, -- Timed.
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:SetupTasks()
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

	self.hSecretShopLocation = Entities:FindByName( nil, "secret_shop_location" )
	self.hShopHint = Entities:FindByName( nil, "shop_hint_location" )
	self.hSecretShopHint = Entities:FindByName( nil, "secret_shop_hint_location" )
	self.hHeroHint = Entities:FindByName( nil, "hero_hint_location" )
	self.bCourierHasBeenUsed = false
	self.nGoldForStaff = 1000
	self.nGoldForBooster = 1200
	self.bCheckForCompletion = false

	local buyOgreClub = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_ogre_club",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_ogre_axe",
			WhiteList = { "item_ogre_axe", },
			DisableWhitelistOnComplete = false,
		},
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ), 0.0 )

	local deliverOgreClub = rootTask:AddTask( CDotaNPXTask_CourierDeliverItem( {
		TaskName = "deliver_ogre_club_with_courier",
		TaskType = "task_courier_deliver_item",
		UseHints = true,
		TaskParams = 
		{
			ItemNames = { "item_ogre_axe", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_ogre_club" )
		end,
	}, self ), 0.0 )

	local buyStaffOfWizardry = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_staff_of_wizardry",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_staff_of_wizardry",
			WhiteList = { "item_staff_of_wizardry", },
			DisableWhitelistOnComplete = false,
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "deliver_ogre_club_with_courier" )
		end,
	}, self ), 0.0 )
	
	local retrieveStaffOfWizardry = rootTask:AddTask( CDotaNPXTask_CourierRetrieveItem( {
		TaskName = "retrieve_staff_of_wizardry",
		TaskType = "task_courier_retrieve_item",
		UseHints = true,
		TaskParams =
		{
			ItemNames = { "item_staff_of_wizardry", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_staff_of_wizardry" )
		end,
	}, self ), 1.0 )
	
	local sendCourierToSecretShop = rootTask:AddTask( CDotaNPXTask_CourierMoveToLocation( {
		TaskName = "send_courier_to_secret_shop",
		TaskType = "task_courier_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hSecretShopLocation:GetAbsOrigin(),
			GoalDistance = 256,
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "retrieve_staff_of_wizardry" )
		end,
	}, self ), 0.0 )

	local buyPointBooster = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_point_booster",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_point_booster",
			WhiteList = { "item_point_booster", },
			DisableWhitelistOnComplete = false,
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "send_courier_to_secret_shop" )
		end,
	}, self ), 0.0 )

	local deliverAghs = rootTask:AddTask( CDotaNPXTask_CourierDeliverItem( {
		TaskName = "deliver_aghs_with_courier",
		TaskType = "task_courier_deliver_item",
		UseHints = true,
		TaskParams = 
		{
			ItemNames = { "item_point_booster", },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_point_booster" )
		end,
	}, self ), 0.0 )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:SetTimeOfDay( 0.75 ) -- Daytime
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true ) -- Always daytime
	GameRules:SetHeroRespawnEnabled( false ) -- No respawn

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "courier" )

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Courier, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )

	self.hHero = hHero
	self.hHero:SetAbilityPoints( 0 )
	self.hCourierSpawn = Entities:FindByName( nil, "courier_spawn_radiant" )
	self.hCourier = hPlayer:SpawnCourierAtPosition( self.hCourierSpawn:GetAbsOrigin() )
	self:ShowWizardTip( "scenario_courier_wizard_tip_buying", 15.0 )
	self.hCourier:UpgradeCourier( 10 )
	self:CenterHero()

	local hTPScroll = hHero:FindItemInInventory( "item_tpscroll" )
	if hTPScroll then
		UTIL_Remove( hTPScroll )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:OnTaskStarted( event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	self:HideUIHint()
	if event.task_name == "buy_ogre_club" then
		-- Show UI Hint for Shop Button here
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function ()
			self:ShowUIHint( "ShopButton", "scenario_courier_ui_tip_click_to_open_shop", 0.0, nil)
		end )
		--self:HintWorldText( self.hHeroHint:GetAbsOrigin(), "open_shop", 89, -1 )
	elseif event.task_name == "deliver_ogre_club_with_courier" then
		-- Show UI Hint for Deliver Items Button here
		self:ShowUIHint( "DeliverItemsButton", "scenario_courier_ui_tip_click_to_deliver_items", 0.0, nil )
		self:CenterCourier()
		self:ShowWizardTip( "scenario_courier_wizard_tip_deliver_items", 15.0 )
		--self:HintWorldText( self.hShopHint:GetAbsOrigin(), "deliver_items", 89, -1 )
	elseif event.task_name == "buy_staff_of_wizardry" then
		self:GrantGold( self.nGoldForStaff )
		self:ShowUIHint( "ShopButton", "scenario_courier_ui_tip_click_to_open_shop", 0.0, nil)
		self:CenterHero()
		self:ShowWizardTip( "scenario_courier_wizard_tip_speed_burst", 15.0 )
		--self:HintWorldText( self.hHeroHint:GetAbsOrigin(), "staff_of_wizardry", 89, -1 )
	elseif event.task_name == "retrieve_staff_of_wizardry" then
		-- Show UI Hint for Select Courier Button here
		self:ShowUIHint( "SelectCourierButton", "scenario_courier_ui_tip_click_to_select_courier", 0.0, nil )
		-- Show UI Hint for Retrieve Items Button here
		--self:ShowUIHint( "Ability0", "scenario_courier_ui_tip_click_to_retrieve_items", 0.0, nil )
		self:CenterCourier()
		self:ShowWizardTip( "scenario_courier_wizard_tip_select", 15.0 )
		--self:HintWorldText( self.hShopHint:GetAbsOrigin(), "select_courier", 89, -1 )
	elseif event.task_name == "send_courier_to_secret_shop" then
		-- Show UI Hint for Go to Secret Shop Button here
		self:ShowUIHint( "Ability1 AbilityButton", "scenario_courier_ui_tip_click_to_go_to_secret_shop", 0.0, nil )
		self:CenterCourier()
		self:ShowWizardTip( "scenario_courier_wizard_tip_secret_shop", 15.0 )
		--self:HintWorldText( self.hShopHint:GetAbsOrigin(), "secret_shop", 89, -1 )
	elseif event.task_name == "buy_point_booster" then
		self:ShowUIHint( "ShopButton", "scenario_courier_ui_tip_click_to_open_shop", 0.0, nil)
		self:CenterSecretShop()
		self:GrantGold( self.nGoldForBooster )
		--self:HintWorldText( self.hSecretShopHint:GetAbsOrigin(), "point_booster", 89, -1 )
	elseif event.task_name == "deliver_aghs_with_courier" then
		-- Show UI Hint for Transfer Items Button here
		self:ShowUIHint( "Ability4 AbilityButton", "scenario_courier_ui_tip_click_to_transfer_items", 0.0, nil )
		--self:HintWorldText( self.hSecretShopHint:GetAbsOrigin(), "transfer", 89, -1 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:GrantGold( nGold )
	print( "Granting Gold"  )
	self.hHero:SetGold( nGold, true )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:OnTaskCompleted( event )
	if event.task_name == "deliver_aghs_with_courier" then
		self:CenterHero()
		self.bCheckForCompletion = true
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:OnThink()
	CDotaNPXScenario.OnThink( self )
	--print( "Thinking" )
	if self.bCheckForCompletion == true then
		if self.hHero:HasItemInInventory( "item_ultimate_scepter" ) then
			self.bCheckForCompletion = false
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
				self:OnScenarioRankAchieved( 1 )
			end )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:SendCourierHome()
	local vPos = self.hCourierSpawn:GetAbsOrigin()
	self.hCourier:SetAbsOrigin( vPos )
	self.hCourier:Stop()
	ExecuteOrderFromTable( {
		UnitIndex = self.hCourierSpawn:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = true,
	} )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:CenterCourier()
	local vPos = self.hCourier:GetAbsOrigin()
	local PlayerID = self.hHero:GetPlayerID()
	if self.bCourierHasBeenUsed == false then
		PlayerResource:SetCameraTarget( PlayerID , nil )
		SendToConsole( "dota_camera_lerp_position " .. vPos.x .. " " .. vPos.y .. " " .. 2 )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self.bCourierHasBeenUsed = true
			PlayerResource:SetCameraTarget( PlayerID , self.hCourier )
		end )
	else
		PlayerResource:SetCameraTarget( PlayerID , self.hCourier )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:CenterSecretShop()
	local vPos = self.hSecretShopLocation:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vPos.x .. " " .. vPos.y .. " " .. 2 )
	AddFOWViewer( DOTA_TEAM_GOODGUYS, self.hSecretShopHint:GetAbsOrigin(), 1000, 60, false )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:CenterHero()
	local PlayerID = self.hHero:GetPlayerID()
	PlayerResource:SetCameraTarget( PlayerID , self.hHero )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Courier:LerpToHero()
	local vPos = self.hHero:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vPos.x .. " " .. vPos.y .. " " .. 2 )
end

--------------------------------------------------------------------

return CDotaNPXScenario_Courier