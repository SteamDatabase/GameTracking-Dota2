require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_parallel" )
require( "tasks/task_move_to_location" )
require( "tasks/task_buy_item" )
require( "tasks/task_last_hits" )
require( "tasks/task_denies" )
require( "tasks/task_teleport_to_unit" )
require( "tasks/task_kill_units" )
require( "tasks/task_courier_retrieve_item" )
require( "tasks/task_courier_deliver_item" )
require( "tasks/task_earn_gold" )
require( "tasks/task_learn_ability" )
require( "tasks/task_hero_gained_level" )
require( "tasks/task_kill_neutral_camps" )
require( "tasks/task_protect_units" )
require( "tasks/task_send_item_to_neutral_stash" )
require( "tasks/task_pick_up_item" )
require( "tasks/task_add_item_to_quick_buy" )
require( "hero_ability_utils" )


--------------------------------------------------------------------

if CDOTANPXScenario_Economy == nil then
	CDOTANPXScenario_Economy = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_sven",
		StartingHeroLevel	= 8,
		StartingXP 			= ( GetXPNeededToReachNextLevel( 8 ) - GetXPNeededToReachNextLevel( 7 ) ) * 0.7,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= ( GetCostOfItem( "item_tpscroll" ) * 2 ) + GetCostOfItem( "item_sobi_mask" ) + GetCostOfItem( "item_quarterstaff" ) + ( GetCostOfItem( "item_robe" ) / 2 ),
		StartingItems 		=
		{
			"item_bracer",
			"item_power_treads",
			"item_ogre_axe",
			"item_vladmir",
			"item_bracer",
		},
		StartingAbilities   =
		{			
			"sven_storm_bolt",
			"sven_storm_bolt",
			"sven_storm_bolt",
			"sven_storm_bolt",
			"sven_warcry",
			"sven_warcry",
			"sven_warcry",
			"sven_gods_strength",
		},

		ScenarioTimeLimit = 0,
	}
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	self.flTimeToIntroduceTask = 9999999999
	GameRules:SpawnAndReleaseCreeps()
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_PANEL, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_MINIMAP, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_PANEL, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_SHOP, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_ITEMS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_COURIER, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_PROTECT, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_GOLD, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_QUICK_STATS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_KILLCAM, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_BAR, false )

	SendToConsole( "dota_enable_new_player_shop 1" )
	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "economy" )
	GameRules:SetWhiteListEnabled( true )

	self.hRuneLoc = Entities:FindByName( nil, "bounty_rune_location" )
	self.hRune = CreateRune( self.hRuneLoc:GetAbsOrigin(), DOTA_RUNE_ARCANE )


	GameRules:GetGameModeEntity():SetAllowNeutralItemDrops( false )
	GameRules:GetGameModeEntity():SetStickyItemDisabled( true )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 10.0 )

	ListenToGameEvent( "spawner_finished", Dynamic_Wrap( CDOTANPXScenario_Economy, "OnSpawnerFinished" ), self )

	self.hAllBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	self.hJungleBlockers = {}

	if #self.hAllBlockers == 0 then
		print( "WARNING - Found no blockers!" )
	else
		for i=#self.hAllBlockers,1,-1  do
			local hBlocker = self.hAllBlockers[ i ]
			--print( "blocker name: " .. hBlocker:GetName() )
			if string.find( hBlocker:GetName(), "jungle_blocker" ) then 
				--print( "removing blocker named " .. hBlocker:GetName() )
				table.insert( self.hJungleBlockers, hBlocker )
			end
		end
	end
	return true

end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	
	if hHero and hHero == self.hPlayerHero then
		local hTP = hHero:FindItemInInventory( "item_tpscroll" )
		if hTP then
			hTP:EndCooldown()
			UTIL_Remove( hTP )
		end

		local hIntroEnt = Entities:FindByName( nil, "sven_spawner" )
		if hIntroEnt ~= nil then
			FindClearSpaceForUnit( hHero, hIntroEnt:GetAbsOrigin(), true )
		end
	end
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:SetupTasks()
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	local rootTask = self:SetupTask_RootSequence()
	return true
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:SetupTask_RootSequence()
	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return GameRules:GetGameTime() > self.flTimeToIntroduceTask end

	local farmEchoAndLevels = rootTask:AddTask( CDotaNPXTask_Parallel( {
		TaskName = "echo_and_levels",
		Hidden = true,
	}, self, 0.5 ), 2.0 )

	local completeEchoSabreTask = farmEchoAndLevels:AddTask( self:SetupTask_CompleteEchoSabre(), 2.0 )
	local levelsAndExperienceTask = farmEchoAndLevels:AddTask( self:SetupTask_EarnLevelsAndExperience(), 2.0 )

	local neutralCreepsAndItemsTask = farmEchoAndLevels:AddTask( self:SetupTask_NeutralCreepsAndItems(), 2.0 )
	neutralCreepsAndItemsTask.CheckTaskStart = function( task ) 
		return task:GetScenario():IsTaskComplete( "buy_echo_sabre" ) 
	end

	local defendTowerAndKillSFTask = rootTask:AddTask( self:SetupTask_DefendTowerAndKillSF(), 2.0 )

	return rootTask
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:SetupTask_CompleteEchoSabre()
	local tCheckpointTaskNames = {}

	local buyInitialItemsTask = CDotaNPXTask_Sequence( {
		TaskName = "buy_echo_sabre",
		TaskParams = 
		{
			ItemName = "item_echo_sabre",
		},
		Hidden = true,

	}, self , 0.5 )


	local nOpenShopUIHintID = -1
	buyInitialItemsTask.StartTask = function( task )
		CDotaNPXTask_Sequence.StartTask( task )
		
		nOpenShopUIHintID = task:GetScenario():ShowUIHint( "ShopButton", "scenario_economy_ui_tip_click_to_open_shop", 12.0, "DOTAHUDShopOpened" )
	end

	buyInitialItemsTask.OnUIHintAdvanced = function( task, nUIHintID )
		CDotaNPXTask_Sequence.OnUIHintAdvanced( task, nUIHintID )
		if nUIHintID == nOpenShopUIHintID then
			task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 0.5, function()
				task:GetScenario():ShowUIHint( "NewShopItem1 NewShopItem", "scenario_economy_ui_tip_item_guide", 0.0 )
			end )
		end
	end

	local addEchoSabreToQuickBuy = buyInitialItemsTask:AddTask( CDotaNPXTask_AddItemToQuickBuy( {
		TaskName = "add_echo_sabre_to_quick_buy",
		TaskParams =
		{
			ItemName = "item_echo_sabre",
		}
	}, self ), 2 )

	addEchoSabreToQuickBuy.CompleteTask = function( task )
		CDotaNPXTask_AddItemToQuickBuy.CompleteTask( task )
		task:GetScenario():HideUIHint()
		GameRules:SetWhiteListEnabled( true )
	end

	local buyQuarterStaffTask = buyInitialItemsTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_quarter_staff",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_quarterstaff",
			WhiteList = { "item_quarterstaff", },
		},

	}, self ), 2 )

	buyQuarterStaffTask.StartTask = function( task )
		CDotaNPXTask_BuyItem.StartTask( task )
		task:GetScenario():ShowUIHint( "QuickBuySlot0" )
	end


	buyQuarterStaffTask.CompleteTask = function( task )
		CDotaNPXTask_BuyItem.CompleteTask( task )
		GameRules:SetWhiteListEnabled( true )
		task:GetScenario():HideUIHint()
	end

	local buySobiMaskTask = buyInitialItemsTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_sobi_mask",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_sobi_mask",
			WhiteList = { "item_sobi_mask", },
		},

	}, self ), 2 )


	buySobiMaskTask.StartTask = function( task )
		CDotaNPXTask_BuyItem.StartTask( task )
		task:GetScenario():ShowUIHint( "QuickBuySlot0" )
	end

	buySobiMaskTask.CompleteTask = function( task )
		CDotaNPXTask_BuyItem.CompleteTask( task )

		task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_last_hit_enemy_creeps", 12.0 )
		GameRules:SetWhiteListEnabled( true )
		task:GetScenario():HideUIHint()
	end


	local buyTPTask = buyInitialItemsTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_tp_scroll",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_tpscroll",
			ItemAmount = 2,
			WhiteList = { "item_tpscroll", },
		},

	}, self ), 2 )

	buyTPTask.StartTask = function( task )
		CDotaNPXTask_BuyItem.StartTask( task )
		task:GetScenario():ShowUIHint( "QuickBuySlot8" )
	end

	buyTPTask.CompleteTask = function( task )
		CDotaNPXTask_BuyItem.CompleteTask( task )
		task:GetScenario():HideUIHint()
		GameRules:SetWhiteListEnabled( true )
	end


	local teleportToBotLaneTask = buyInitialItemsTask:AddTask( CDotaNPXTask_TeleportToUnit( { 
		TaskName = "teleport_to_bot_t1",
		TaskParams =
		{
			NoFailure = true,
		},
	}, self ), 2 )

	local hT1BotTower = Entities:FindByName( nil, "dota_goodguys_tower1_bot" )
	if hT1BotTower == nil then
		print( "ERROR! Unable to find t1 tower?" )
		return
	end

	local hSpawnEnt = FindSpawnEntityForTeam( DOTA_TEAM_GOODGUYS )
	local vToHero = ( hSpawnEnt:GetAbsOrigin() - hT1BotTower:GetAbsOrigin() ):Normalized()
	local vPos = hT1BotTower:GetAbsOrigin() + vToHero * 300

	teleportToBotLaneTask:SetTeleportUnit( hT1BotTower )
	teleportToBotLaneTask.StartTask = function( task )
		local hTP = self.hPlayerHero:FindItemInInventory( "item_tpscroll" )
		if hTP then
			hTP:SetCurrentCharges( 2 )
			hTP:EndCooldown()
		end

		CDotaNPXTask_TeleportToUnit.StartTask( task )

		local tLaneCreeps = Entities:FindAllByClassname( "npc_dota_creep_lane" )
		for _,hCreep in pairs ( tLaneCreeps ) do
			hCreep:RemoveModifierByName( "modifier_no_damage" )
		end

		SendToConsole( "dota_creeps_no_spawning 0" )
		GameRules:SetWhiteListEnabled( true )
		SendToConsole( "dota_camera_lerp_position " .. hT1BotTower:GetAbsOrigin().x .. " " .. hT1BotTower:GetAbsOrigin().y .. " " .. 1 )
		task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 0.5, function()
			task:GetScenario():ShowUIHint( "inventory_tpscroll_slot" )
			task:GetScenario():HintLocation( vPos, true )
		end )
	end

	teleportToBotLaneTask.CompleteTask = function( task )
		CDotaNPXTask_TeleportToUnit.CompleteTask( task )
		GridNav:DestroyTreesAroundPoint( self.hPlayerHero:GetAbsOrigin(), 250.0, false )

		task:GetScenario():HintLocation( vPos, false )
		task:GetScenario():HideUIHint()
		task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 15.0, function() 
			GameRules:SpawnAndReleaseCreeps()
		end )
	end 

	local earnGoldTask = buyInitialItemsTask:AddTask( CDotaNPXTask_EarnGold( {
		TaskName = "earn_gold_for_robe",
		TaskParams =
		{
			Gold = GetCostOfItem( "item_robe" ) / 2,
		},
	}, self ), 0 )


	earnGoldTask.StartTask = function( task )
		CDotaNPXTask_EarnGold.StartTask( task )

		local hCreeps = FindUnitsInRadius( task:GetScenario().hPlayerHero:GetTeamNumber(), task:GetScenario().hPlayerHero:GetOrigin(), task:GetScenario().hPlayerHero, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,hCreep in pairs ( hCreeps ) do
			task:GetScenario():HintNPC( hCreep )
		end
	end

	local buyRobeTask = buyInitialItemsTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_robe",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_robe",
			WhiteList = { "item_robe", },
		},

	}, self ), 2 )

	buyRobeTask.StartTask = function( task )
		CDotaNPXTask_BuyItem.StartTask( task )
		task:GetScenario():ShowUIHint( "QuickBuySlot0" )
	end

	buyRobeTask.CompleteTask = function( task )
		CDotaNPXTask_BuyItem.CompleteTask( task )
		task:GetScenario():HideUIHint()
	end

	local retrieveRobeTask = buyInitialItemsTask:AddTask( CDotaNPXTask_CourierRetrieveItem( {
		TaskName = "retrieve_robe_with_courier",
		TaskParams =
		{
			ItemNames = { "item_robe", },
		},
	}, self ), 2 )


	retrieveRobeTask.StartTask = function( task )
		CDotaNPXTask_CourierRetrieveItem.StartTask( task )
		local hPlayer = PlayerResource:GetPlayer( 0 )
		if hPlayer and hSpawnEnt then
			local hCourier = hPlayer:SpawnCourierAtPosition( hSpawnEnt:GetAbsOrigin() )
			hCourier:UpgradeCourier( 12 )

			SendToConsole( "dota_camera_lerp_position " .. hSpawnEnt:GetAbsOrigin().x .. " " .. hSpawnEnt:GetAbsOrigin().y .. " " .. 1 )
			task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_use_the_courier", 12.0 )
			task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 0.5, function()	
				task:GetScenario():ShowUIHint( "DeliverItemsButton" )
			end )
			
		end
	end

	retrieveRobeTask.CompleteTask = function( task )
		CDotaNPXTask_CourierRetrieveItem.CompleteTask( task, true )
		task:GetScenario():HintLocation( vPos, true )
		task:GetScenario():HideUIHint()

		SendToConsole( "dota_camera_lerp_position " .. vPos.x .. " " .. vPos.y .. " " .. 1 )
		task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_safe_courier_usage", 15.0 )
	end

	local deliverRobeTask = buyInitialItemsTask:AddTask( CDotaNPXTask_CourierDeliverItem( {
		TaskName = "deliver_robe_with_courier",
		TaskParams =
		{
			ItemNames = { "item_robe", },
		},
	}, self ), 2 )

	deliverRobeTask.CompleteTask = function( task )
		CDotaNPXTask_CourierDeliverItem.CompleteTask( task, true )
		task:GetScenario():HintLocation( vPos, false )

		for _,hBlocker in pairs ( task:GetScenario().hJungleBlockers ) do
			hBlocker:SetEnabled( false )
		end
		
	end

	return buyInitialItemsTask 
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:SetupTask_EarnLevelsAndExperience()

	local levelUpTaskSequence =  CDotaNPXTask_Sequence( {
		TaskName = "level_up_sequence",
		Hidden = true,
	}, self )

	levelUpTaskSequence.CheckTaskStart = function( task )
			return task:GetScenario():IsTaskComplete( "teleport_to_bot_t1" )
	end


	local gainLevel9Task = levelUpTaskSequence:AddTask( CDotaNPXTask_HeroGainedLevel( {
		TaskName = "gain_level_9",
		TaskParams =
		{
			Level = 9,
		},
	}, self ), 2 )

	gainLevel9Task.StartTask = function( task )
		CDotaNPXTask_HeroGainedLevel.StartTask( task )
		GameRules:GetGameModeEntity():EnableAbilityUpgradeWhitelist( true )
	end


	local learnCleave = levelUpTaskSequence:AddTask( CDotaNPXTask_LearnAbility( {
		TaskName = "learn_great_cleave",
		TaskParams = 
		{
			AbilityName = "sven_great_cleave",
			WhiteList = true,
		},
	}, self ), 2 )

	learnCleave.StartTask = function( task )
		CDotaNPXTask_LearnAbility.StartTask( task )
		task:GetScenario():ShowUIHint( "Ability1 LevelUpTab" )
	end

	learnCleave.CompleteTask = function( task )
		CDotaNPXTask_LearnAbility.CompleteTask( task )
		task:GetScenario():HideUIHint()
	end


	local gainLevel10Task = levelUpTaskSequence:AddTask( CDotaNPXTask_HeroGainedLevel( {
		TaskName = "gain_level_10",
		TaskParams =
		{
			Level = 10,
		},
	}, self ), 2 )

	gainLevel10Task.StartTask = function( task )
		CDotaNPXTask_HeroGainedLevel.StartTask( task )
		GameRules:GetGameModeEntity():EnableAbilityUpgradeWhitelist( true )
	end
 

	local learnTalentTask = levelUpTaskSequence:AddTask( CDotaNPXTask_LearnAbility( {
		TaskName = "learn_a_talent",
		TaskParams = 
		{
			AbilityName = "special_bonus_attack_speed_15",
			WhiteList = true,
		},
	}, self ), 2 )

	learnTalentTask.StartTask = function( task )
		CDotaNPXTask_LearnAbility.StartTask( task )
		task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_talents", 12.0 )
		task:GetScenario():ShowUIHint( "level_stats_frame LevelUpTab" )
	end

	learnTalentTask.CompleteTask = function( task )
		CDotaNPXTask_LearnAbility.CompleteTask( task )
		task:GetScenario():HideUIHint()
	end


	return levelUpTaskSequence
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:SetupTask_NeutralCreepsAndItems()
	local rootNeutralCreepsTask = CDotaNPXTask_Parallel( {
		TaskName = "neutral_creeps_and_items",
		Hidden = true,
	}, self, 3 )

	local szCampSpawnerNames = 
	{
		"easy_camp_1",
		"medium1_camp",
		"hard_camp_1",
		"ancient_camp_1",
		"hard_camp_2",
	}

	rootNeutralCreepsTask.StartTask = function( task )
		CDotaNPXTask_Parallel.StartTask( task )

		for _,szName in pairs ( szCampSpawnerNames ) do
			local hNeutralSpawner = Entities:FindByName( nil, szName )
			if hNeutralSpawner then
				hNeutralSpawner:SelectSpawnType()
				hNeutralSpawner:CreatePendingUnits()
				hNeutralSpawner:CreatePendingUnits()
				hNeutralSpawner:CreatePendingUnits()
				hNeutralSpawner:CreatePendingUnits()
				hNeutralSpawner:CreatePendingUnits()
				hNeutralSpawner:CreatePendingUnits()
				hNeutralSpawner:SpawnNextBatch( true )
				if hNeutralSpawner:GetName() == "easy_camp_1" then
					SendToConsole( "dota_camera_lerp_position " .. hNeutralSpawner:GetAbsOrigin().x .. " " .. hNeutralSpawner:GetAbsOrigin().y .. " " .. 1 )
			
					task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 0.5, function()	
						task:GetScenario():HintLocation( hNeutralSpawner:GetAbsOrigin(), true )
					end )

					task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 3, function()
						SendToConsole( "+dota_camera_center_on_hero" )
						SendToConsole( "-dota_camera_center_on_hero" )
					end )
				end
			end
		end
		
		task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_farm_the_jungle", 12.0 )
	end

	rootNeutralCreepsTask.CompleteTask = function( task )
		CDotaNPXTask_Parallel.CompleteTask( task )
		for _,szName in pairs ( szCampSpawnerNames ) do
			local hNeutralSpawner = Entities:FindByName( nil, szName )
			if hNeutralSpawner then
				task:GetScenario():HintLocation( hNeutralSpawner:GetAbsOrigin(), false )
			end
		end
	end

	local clearTheJungleTask = rootNeutralCreepsTask:AddTask( CDotaNPXTask_KillNeutralCamps( {
		TaskName = "clear_the_jungle",
		TaskParams = 
		{
			CampNames = deepcopy( szCampSpawnerNames ),
		},
	}, self ), 3 )

	clearTheJungleTask.OnTaskProgress = function( task )
		CDotaNPXTask_KillNeutralCamps.OnTaskProgress( task )
		for _,szName in pairs ( szCampSpawnerNames ) do
			local hNeutralSpawner = Entities:FindByName( nil, szName )
			if hNeutralSpawner then
				task:GetScenario():HintLocation( hNeutralSpawner:GetAbsOrigin(), false )
			end
		end

		local hClosestCamp = nil
		local flClosestDist = 999999
		for _,szName in pairs ( task.szCamps ) do
			local hNeutralSpawner = Entities:FindByName( nil, szName )
			if hNeutralSpawner then
				local flDist = ( hNeutralSpawner:GetAbsOrigin() - self.hPlayerHero:GetAbsOrigin() ):Length2D()
				if flDist < flClosestDist then
					flClosestDist = flDist
					hClosestCamp = hNeutralSpawner
				end
			end
		end

		if hClosestCamp ~= nil then
			task:GetScenario():HintLocation( hClosestCamp:GetAbsOrigin(), true )
		end

		if task:GetTaskProgress() == 1 then
			task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 8.0, function()
			
				task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_neutral_creep_camps", 12.0 )	
			end )
		end
	end

	local pickupImpClawTask = rootNeutralCreepsTask:AddTask( CDotaNPXTask_PickUpItem( {
		TaskName = "pick_up_imp_claw",
		TaskParams = 
		{
			ItemName = "item_imp_claw",
		},

	}, self ), 3 )

	pickupImpClawTask.CheckTaskStart = function( task )
		return task:GetScenario():GetTask( "clear_the_jungle" ):GetTaskProgress() >= 3
	end

	pickupImpClawTask.StartTask = function( task )
		CDotaNPXTask_PickUpItem.StartTask( task )
		self.vItemPos = self.hPlayerHero:GetAbsOrigin() + self.hPlayerHero:GetForwardVector() * 75
		DropNeutralItemAtPositionForHero( "item_imp_claw", self.vItemPos, self.hPlayerHero, 2, true )
		task:GetScenario():ShowUIHint( "inventory_neutral_slot" )
	end

	pickupImpClawTask.CompleteTask = function( task )
		CDotaNPXTask_PickUpItem.CompleteTask( task, true )
		task:GetScenario():HideUIHint()

		task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 3.0, function()
			
			task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_imp_claw", 12.0 )
		end )
		
	end

	local pickupGroveBowTask = rootNeutralCreepsTask:AddTask( CDotaNPXTask_PickUpItem( {
		TaskName = "pick_up_grove_bow",
		TaskParams = 
		{
			ItemName = "item_grove_bow",
		},

	}, self ), 3 )

	pickupGroveBowTask.CheckTaskStart = function( task )
		return task:GetScenario():GetTask( "clear_the_jungle" ):GetTaskProgress() >= 5
	end

	pickupGroveBowTask.StartTask = function( task )
		CDotaNPXTask_PickUpItem.StartTask( task )
		self.vItemPos = self.hPlayerHero:GetAbsOrigin() + self.hPlayerHero:GetForwardVector() * 75
		DropNeutralItemAtPositionForHero( "item_grove_bow", self.vItemPos, self.hPlayerHero, 2, true )
		task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 3.0, function()
			task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_grove_bow", 12.0 )
		end )
	end

	pickupGroveBowTask.CompleteTask = function( task )
		CDotaNPXTask_PickUpItem.CompleteTask( task, true )
		task:GetScenario():ShowUIHint( "inventory_slot_6", "scenario_economy_ui_tip_right_click_neutral_item", 12.0, nil )
		task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 3.0, function()
			task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_backpack", 12.0 )
		end )
	end

	local sendItemToNeutralStashTask = rootNeutralCreepsTask:AddTask( CDotaNPXTask_SendItemToNeutralStash( { 
		TaskName = "send_grove_bow_to_stash",
		TaskParams =
		{
			ItemNames = { "item_grove_bow", },
			ItemName = "item_grove_bow",
		},

	}, self ), 3 )

	sendItemToNeutralStashTask.CheckTaskStart = function( task ) 
		return task:GetScenario():IsTaskComplete( "pick_up_grove_bow" ) 
	end

	sendItemToNeutralStashTask.CompleteTask = function( task )
		CDotaNPXTask_SendItemToNeutralStash.CompleteTask( task )
		task:GetScenario():HideUIHint()
	end

	return rootNeutralCreepsTask
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:SetupTask_DefendTowerAndKillSF()
	local hT1BotTower = Entities:FindByName( nil, "dota_goodguys_tower1_bot" )
	if hT1BotTower == nil then
		print( "ERROR! Unable to find t1 tower?" )
		return
	end

	local rootDefendTowerAndKillSFTask = CDotaNPXTask_Parallel( {
		TaskName = "defend_tower_and_kill_sf",
		Hidden = true,
	}, self, 3 )

	local teleportToBotLaneTask = rootDefendTowerAndKillSFTask:AddTask( CDotaNPXTask_TeleportToUnit( { 
		TaskName = "teleport_to_bot_t1_again",
		TaskParams =
		{
			NoFailure = true,
		},
	}, self ), 3 )

	
	local hSpawnEnt = FindSpawnEntityForTeam( DOTA_TEAM_GOODGUYS )
	local vToHero = ( hSpawnEnt:GetAbsOrigin() - hT1BotTower:GetAbsOrigin() ):Normalized()
	local vPos = hT1BotTower:GetAbsOrigin() + vToHero * 300

	teleportToBotLaneTask:SetTeleportUnit( hT1BotTower )

	teleportToBotLaneTask.StartTask = function( task )
		CDotaNPXTask_TeleportToUnit.StartTask( task )
		local hTP = self.hPlayerHero:FindItemInInventory( "item_tpscroll" )
		if hTP then
			hTP:SetCurrentCharges( 1 )
			hTP:EndCooldown()
		else
			hTP = self.hPlayerHero:AddItemByName( "item_tpscroll" )
			if hTP then
				hTP:SetCurrentCharges( 1 )
				hTP:EndCooldown()
			end
		end

		for _,hBlocker in pairs ( task:GetScenario().hAllBlockers ) do
			hBlocker:SetEnabled( false )
		end

		self.SfSpawner:GetSpawnedUnits()[1].bAttackTower = true
		SendToConsole( "dota_camera_lerp_position " .. hT1BotTower:GetAbsOrigin().x .. " " .. hT1BotTower:GetAbsOrigin().y .. " " .. 1 )
		task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 0.5, function()	
			task:GetScenario():HintLocation( vPos, true )
		end )
	end

	teleportToBotLaneTask.CompleteTask = function( task )
		CDotaNPXTask_TeleportToUnit.CompleteTask( task, true )
		GridNav:DestroyTreesAroundPoint( self.hPlayerHero:GetAbsOrigin(), 250.0, false )
		
		task:GetScenario():HintLocation( vPos, false )
		task:GetScenario():ShowWizardTip( "scenario_economy_wizard_tip_fight_near_tower", 12.0 )
	end 

	self.killSFTask = rootDefendTowerAndKillSFTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_sf",
		TaskParams = {},
	}, self ), 3 )


	self.killSFTask.CompleteTask = function( task )
		CDotaNPXTask_KillUnits.CompleteTask( task, true )

	end

	rootDefendTowerAndKillSFTask.CompleteTask = function( task )
		CDotaNPXTask_Parallel.CompleteTask( task, true )

		task:GetScenario():OnScenarioComplete( true )
	end
	
	return rootDefendTowerAndKillSFTask
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:OnGameRulesStateChange( nOldState, nNewState )
	CDotaNPXScenario.OnGameRulesStateChange( self, nOldState, nNewState )
	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self.SfSpawner = CDotaSpawner( "sf_spawner", 
		{
			{
				EntityName = "npc_dota_hero_nevermore",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "Shadow Fiend",
					EntityScript = "ai/ai_sf_economy.lua",
					StartingHeroLevel = 18,
					StartingItems = 
					{
						"item_power_treads",
						"item_ancient_janggo",
						"item_hurricane_pike",
						"item_kaya",
					},
					AbilityBuild = 
					{
						AbilityPriority = { 
						"nevermore_requiem",
						"nevermore_shadowraze1",
						"nevermore_necromastery",
						"nevermore_dark_lord",
						"special_bonus_attack_speed_20",
						},
					},
				},
			},
		}, self, false )

	end 
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:IntroduceScenario()
	self.SfSpawner:SpawnUnits()
	AddFOWViewer( DOTA_TEAM_GOODGUYS, self.SfSpawner:GetSpawnedUnits()[1]:GetAbsOrigin(), 500, 8.0, false )
	
	if self.SfSpawner:GetSpawnedUnits()[1] ~= nil then
		self.killSFTask:SetUnitsToKill( self.SfSpawner:GetSpawnedUnits() )

		self.hPlayerHero:SetForceAttackTarget( self.SfSpawner:GetSpawnedUnits()[1] )
		self.hPlayerHero:SetHealth( self.hPlayerHero:GetMaxHealth() / 2 )
		self.hPlayerHero:AddNewModifier( self.hPlayerHero, nil, "modifier_command_restricted", { duration = 5 } )
		self.hPlayerHero:AddNewModifier( self.hPlayerHero, nil, "modifier_kill", { duration = 5 } )
		self:IntroduceUnit( self.SfSpawner:GetSpawnedUnits()[1], 10.0, 30, 90, 600, 0.1, 120 )
	end	

	self:ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 10.0, function()
		self:IntroduceUnit( self.hPlayerHero, 3.0, 30, 90, 600, 0.1, 120 )
	end )

	self:ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 14.0, function()
		self:EndIntroduceScenario()
		self.hPlayerHero:SetForceAttackTarget( nil )
		self.flTimeToIntroduceTask = GameRules:GetGameTime() + 5.0

		local tLaneCreeps = Entities:FindAllByClassname( "npc_dota_creep_lane" )
		for _,hCreep in pairs ( tLaneCreeps ) do
			hCreep:AddNewModifier( hCreep, nil, "modifier_no_damage", { duration = -1 } )
		end

		local tTowers = Entities:FindAllByClassname( "npc_dota_tower" )
		for _,hTower in pairs ( tTowers ) do
			hTower:AddNewModifier( hTower, nil, "modifier_no_damage", { duration = -1 } )
		end

		SendToConsole( "dota_creeps_no_spawning 1" )

		self:ShowWizardTip( "scenario_economy_wizard_tip_echo_sabre", 12.0, { "item_echo_sabre" } )

		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_PANEL, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_MINIMAP, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_PANEL, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_SHOP, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_ITEMS, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_COURIER, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_PROTECT, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_GOLD, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_QUICK_STATS, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_KILLCAM, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_BAR, false )
	end )
end

--------------------------------------------------------------------

function CDOTANPXScenario_Economy:OnThink()
	if self.bIntroductionComplete == false and self.hPlayerHero ~= nil and self.SfSpawner:GetSpawnedUnits()[1] ~= nil then
		-- if self.hPlayerHero:IsAlive() then
		-- 	self.hPlayerHero:SetForceAttackTarget( self.SfSpawner:GetSpawnedUnits()[1] )
		-- else
		-- 	print( "sven died")
		-- 	self.hPlayerHero:SetForceAttackTarget( nil )
		-- 	self.hPlayerHero:Interrupt()
		-- end
	end

	CDotaNPXScenario.OnThink( self )
end

--------------------------------------------------------------------

return CDOTANPXScenario_Economy