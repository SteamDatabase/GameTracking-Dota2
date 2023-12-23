require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_buy_item" )
require( "tasks/task_disassemble_item" )
require( "tasks/task_sell_item" )
require( "tasks/task_unlock_item" )
require( "tasks/task_share_item" )
require( "tasks/task_move_to_location" )

--------------------------------------------------------------------

if CDotaNPXScenario_Items == nil then
	CDotaNPXScenario_Items = class( {}, {}, CDotaNPXScenario )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Items:Precache( context )
	PrecacheUnitByNameSync( "npc_dota_hero_windrunner", context )
    PrecacheModel( "npc_dota_hero_windrunner", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_windrunner", context )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_rubick",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel	= 1,
		StartingGold		= GetCostOfItem( "item_tango" ),
		StartingItems 		=
		{
		},
		StartingAbilities   =
		{			
			"rubick_fade_bolt",
		},

		ScenarioTimeLimit = 0, -- Not Timed.
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:SetTimeOfDay( 0.75 ) -- Daytime
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true ) -- Always daytime
	GameRules:SetHeroRespawnEnabled( false ) -- No respawn
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "items" )

	self.hHintShopLoc = Entities:FindByName( nil, "hint_location_1" )
	self.bStage1Complete = false
	self.nStage = 0 
	-- Stage 1 - Needs Tango, 
	-- Stage 2 - Needs Vanguard or Vitality Booster, 
	-- Stage 3 - Needs Rod of Atos or Vitality Booster

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Items, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:SetupTasks()
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

	-- Stage 1
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
			return true
		end,
	}, self ), 0.0 )

	self.WindrangerSpawner = CDotaSpawner( "teammate_1_spawner", 
	{
		{
			EntityName = "npc_dota_hero_windrunner",
			Team = DOTA_TEAM_GOODGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				PlayerID = 1,
				BotName = "Windranger",
				EntityScript = "ai/items/ai_items_windranger.lua",
				StartingHeroLevel = 1,
				StartingItems = 
				{
					"item_circlet",
					"item_branches",
					"item_branches",
				},
				AbilityBuild = 
				{
					AbilityPriority = { 
					"windrunner_powershot",
					},
				},
			},
		},
	}, self, false )

	self.WindrangerSpawner:SpawnUnits()
	self.hTeammate = self.WindrangerSpawner:GetSpawnedUnits()[1]

	local shareTango = rootTask:AddTask( CDotaNPXTask_ShareItem( {
		TaskName = "share_tango",
		TaskType = "task_share_item",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_tango_single",
			ReceivingHero = "npc_dota_hero_windrunner",
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "buy_tango" )
		end,
	}, self ), 0.0 )

	local sellTango = rootTask:AddTask( CDotaNPXTask_SellItem( {
		TaskName = "sell_tango",
		TaskType = "task_sell_item",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_tango",
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "share_tango" )
		end,
	}, self ), 0.0 )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:SetupStage2Tasks()
	--print("Setting up Stage 2 tasks")

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end
	-- Stage 2
	local disassembleVanguard = rootTask:AddTask( CDotaNPXTask_DisassembleItem( {
		TaskName = "disassemble_vanguard",
		TaskType = "task_disassemble_item",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_vitality_booster",
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "sell_tango" )
			--return true
		end,
	}, self ), 0.0 )

	local unlockVitalityBooster = rootTask:AddTask( CDotaNPXTask_UnlockItem( {
		TaskName = "unlock_vitality_booster",
		TaskType = "task_unlock_item",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_vitality_booster",
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "disassemble_vanguard" )
		end,
	}, self ), 0.0 )

	local buyRodOfAtos = rootTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_rod_of_atos",
		TaskType = "task_buy_item",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_recipe_rod_of_atos",
			WhiteList = { "item_recipe_rod_of_atos", "item_rod_of_atos" },
		},
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "unlock_vitality_booster" )
		end,
	}, self ), 0.0 )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:OnTaskStarted( event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	self:HideUIHint()
	if event.task_name == "buy_tango" then
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "open_shop", 89, -1 )
		self:ShowWizardTip( "scenario_items_wizard_tip_share_tango", 15.0 )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function ()
			self:ShowUIHint( "ShopButton", "scenario_items_ui_tip_click_to_open_shop", 0.0, nil)
		end )
	elseif event.task_name == "share_tango" then
		self.nStage = 1
		self:ShowItemHint( "item_tango" )
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "share_tango", 89, -1 )
		self:ShowWizardTip( "scenario_items_wizard_tip_support", 15.0 )
	elseif event.task_name == "sell_tango" then
		self.nStage = 0
		self:ShowItemHint( "item_tango" )
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "sell", 89, -1 )
	elseif event.task_name == "disassemble_vanguard" then
		self.nStage = 2
		self:ShowItemHint( "item_vanguard" )
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "disassemble", 89, -1 )
		self:ShowWizardTip( "scenario_items_wizard_tip_disassemble", 15.0 )
	elseif event.task_name == "unlock_booster" then
		self:ShowItemHint( "item_ring_of_health" )
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "unlock_booster", 89, -1 )
		--self:ShowWizardTip( "scenario_items_wizard_tip_unlock", 15.0 )
	elseif event.task_name == "unlock_vitality_booster" then
		self.nStage = 3
		self:ShowItemHint( "item_vitality_booster" )
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "unlock_boots", 89, -1 )
	elseif event.task_name == "buy_rod_of_atos" then
		self.hHero:SetGold( GetCostOfItem( "item_recipe_rod_of_atos" ), true )
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "recipe_travel", 89, -1 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:OnTaskCompleted( event )
	if event.task_name == "sell_tango" then
		self:Fade( 1 )
		--self:EndHintWorldText( self.hHintShopLoc:GetAbsOrigin() ) 
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
			self:SetupStage2()
		end )
	elseif event.task_name == "buy_rod_of_atos" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:OnScenarioRankAchieved( 1 )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:SetupStage2()
	print( "Stage 2" )
	self:Fade( 0 )
	-- Show tip for combining items here
	--self:StartDialog( "get_aether_lens", false, self.hHero:GetEntityIndex(), 5 )

	RefreshHero( self.hHero )
	self.hHero:HeroLevelUp( true )
	self.hHero:HeroLevelUp( false )
	self.hHero:HeroLevelUp( false )
	self.hHero:HeroLevelUp( false )
	self.hHero:HeroLevelUp( false )
	self.hHero:HeroLevelUp( false )
	self.hHero:HeroLevelUp( false )
	self.hHero:HeroLevelUp( false )
	self.hHero:HeroLevelUp( false )
	LearnHeroAbilities( self.hHero, {} )

	self.hHero:AddItemByName("item_vanguard")
	self.hHero:AddItemByName("item_staff_of_wizardry")
	self.bHeroRefreshed = true
	self:GetPlayerHero():Stop()
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )

	self:SetupStage2Tasks()
	self.bStage1Complete = true
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Items:ShowItemHint( szItemName )
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

function CDotaNPXScenario_Items:Fade( nFade )
	-- Fade should be 1 to fade to black and 0 to fade in
	FireGameEvent("fade_to_black", {
		fade_down = nFade,
		} )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Items:OnThink()
	CDotaNPXScenario.OnThink( self )
	--print( "Thinking" )
	if self.nStage == 1 then
		if self.hHero:FindItemInInventory( "item_tango" ) == nil then
			print( "No more tango" )
			self:OnScenarioComplete( false, "scenario_items_failure_item_lost" )
			self.nStage = 0
		end
	elseif self.nStage == 2 then
		if self.hHero:FindItemInInventory( "item_vanguard" ) == nil and self.hHero:FindItemInInventory( "item_vitality_booster" ) == nil then
			print( "Sold Vanguard instead of Disassembled" )
			self:OnScenarioComplete( false, "scenario_items_failure_item_lost" )
			self.nStage = 0
		end
	elseif self.nStage == 3 then
		if self.hHero:FindItemInInventory( "item_vitality_booster" ) == nil and
			self.hHero:FindItemInInventory( "item_rod_of_atos" ) == nil then
			print( "Sold Vitality Booster instead of Unlocked" )
			self:OnScenarioComplete( false, "scenario_items_failure_item_lost" )
			self.nStage = 0
		end
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_Items
