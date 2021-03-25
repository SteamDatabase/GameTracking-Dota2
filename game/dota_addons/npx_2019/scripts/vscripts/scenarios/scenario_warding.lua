require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_buy_item" )
require( "tasks/task_move_to_location" )
require( "tasks/task_place_ward_at_location" )
require( "tasks/task_kill_units" )

--------------------------------------------------------------------

if CDotaNPXScenario_Warding == nil then
	CDotaNPXScenario_Warding = class( {}, {}, CDotaNPXScenario )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Warding:PrecacheResources()
	PrecacheUnitByNameSync( "npc_dota_hero_pudge", context )
    PrecacheModel( "npc_dota_hero_pudge", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_pudge", context )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:InitScenarioKeys()
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hHeroLoc2 = Entities:FindByName( nil, "hero_location_2" )
	self.hWardLoc1 = Entities:FindByName( nil, "ward_location_1" )
	self.hWardLoc2 = Entities:FindByName( nil, "ward_location_2" )
	self.hEnemyWardLoc = Entities:FindByName( nil, "enemy_ward_location" )
	self.hHintShopLoc = Entities:FindByName( nil, "shop_hint_location" )
	self.hHintWardLoc = Entities:FindByName( nil, "ward_hint_location" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_lich",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 75,
		StartingItems 		=
		{
			"item_boots",
		},
		StartingAbilities   =
		{			
		},

		ScenarioTimeLimit = 0, -- Timed.

		Tasks =
		{
			{
				TaskName = "buy_observer_ward",
				TaskType = "task_buy_item",
				UseHints = true,
				TaskParams =
				{
					ItemName = "item_ward_observer",
					WhiteList = { "item_ward_observer", },
					DisableWhitelistOnComplete = false,
				},
				CheckTaskStart = 
				function() 
					if GameRules:GetDOTATime( false, false ) >= 0.0 then 
						return true 
					else 
						return false 
					end
				end,
			},
			{
				TaskName = "buy_sentry_ward",
				TaskType = "task_buy_item",
				UseHints = true,
				TaskParams =
				{
					ItemName = "item_ward_sentry",
					WhiteList = { "item_ward_sentry", },
					DisableWhitelistOnComplete = false,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_observer_ward" )
				end,
			},
			{
				TaskName = "move_to_location_1",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hHeroLoc1:GetAbsOrigin(),
					GoalDistance = 96,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_sentry_ward" )
				end,
			},
			{
				TaskName = "place_obs_ward_1",
				TaskType = "task_place_ward_at_location",
				UseHints = true,
				TaskParams =
				{
					WardType = "observer",
					GoalLocation = self.hWardLoc1:GetAbsOrigin(),
					GoalDistance = 96,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
			{
				TaskName = "move_to_location_2",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hHeroLoc2:GetAbsOrigin(),
					GoalDistance = 96,
				},
				CheckTaskStart =
				function()
					local task = self:GetTask( "place_obs_ward_1" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end
					return false
				end,
				OnCheckpoint =
				function()
					print( 'CHECKPOINT 1' )
					local bForceStart = true
					self:CheckpointSkipCompleteTask( "buy_observer_ward", true, bForceStart )
					self:CheckpointSkipCompleteTask( "buy_sentry_ward", true )
					self:CheckpointSkipCompleteTask( "move_to_location_1", true )

					if self:GetPlayerHero() ~= nil then
						LearnHeroAbilities( self:GetPlayerHero(), {} )
						self:GetPlayerHero():AddItemByName( "item_boots" )
						self:GetPlayerHero():AddItemByName( "item_ward_sentry" )

						local hCheckpoints = Entities:FindAllByName( "hero_location_1" )
						if hCheckpoints[1] ~= nil then
							FindClearSpaceForUnit( self:GetPlayerHero(), hCheckpoints[1]:GetAbsOrigin(), true )
							SendToConsole( "+dota_camera_center_on_hero" )
							SendToConsole( "-dota_camera_center_on_hero" )
							self:SpawnEnemy()
						end
					end
				end,
			},
			{
				TaskName = "place_sentry_ward_1",
				TaskType = "task_place_ward_at_location",
				UseHints = true,
				TaskParams =
				{
					WardType = "sentry",
					GoalLocation = self.hWardLoc2:GetAbsOrigin(),
					GoalDistance = 96,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_2" )
				end,
			},
			{
				TaskName = "destroy_enemy_ward",
				TaskType = "task_kill_units",
				UseHints = true,
				TaskParams =
				{
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "place_sentry_ward_1" )
				end,
			},
		},

		Queries =
		{
		},
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:SetTimeOfDay( 0.75 ) -- Daytime
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true ) -- Always daytime
	GameRules:SetHeroRespawnEnabled( false ) -- No respawn
	GameRules:SetUseUniversalShopMode( true ) -- Universal Shop
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:SetItemStockCount( 1, DOTA_TEAM_GOODGUYS, "item_ward_observer", -1 ) -- Always have 1 Observer Ward in the Shop
	GameRules:SetItemStockCount( 1, DOTA_TEAM_GOODGUYS, "item_ward_sentry", -1 ) -- Always have 1 Sentry Ward in the Shop

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "warding" )

	self.bEnemyWardSpawned = false
	self.bFirstWardPlaced = false
	self.bCanPlaceObserver = false
	self.bCanPlaceSentry = false

	self.PudgeSpawner = CDotaSpawner( "enemy_spawner", 
	{
		{
			EntityName = "npc_dota_hero_pudge",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				PlayerID = 1,
				BotName = "Pudge",
				EntityScript = "ai/warding/ai_warding_pudge.lua",
				StartingHeroLevel = 10,
				StartingItems = 
				{
					"item_tranquil_boots",
					"item_magic_wand",
					"item_urn_of_shadows",
				},
				AbilityBuild = 
				{
					AbilityPriority = { 
					"pudge_meat_hook",
					},
				},
			},
		},
	}, self, false )

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Warding, "OnTriggerStartTouch" ), self )
	self.nTaskListener = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDotaNPXScenario_Warding, "OnWardSpawned" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
	self.hHero:SetAbilityPoints( 0 )
	--self.hHero:SetHealth( 100 )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:OnTaskStarted( event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	self:HideUIHint()
	if event.task_name == "buy_observer_ward" then
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "open_shop", 89, -1 )
		-- Show UI Hint for Shop Button here
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function ()
			self:ShowUIHint( "ShopButton", "scenario_warding_ui_tip_click_to_open_shop", 0.0, nil)
		end )
	elseif event.task_name == "buy_sentry_ward" then
		--self:HintWorldText( self.hHintShopLoc:GetAbsOrigin(), "buy_sentry", 89, -1 )
	elseif event.task_name == "move_to_location_1" then
		self:ShowWizardTip( "scenario_warding_wizard_tip_ward_slot", 15.0 )
		--self:EndHintWorldText( self.hHintShopLoc:GetAbsOrigin() )
	elseif event.task_name == "place_obs_ward_1" then
		self.bCanPlaceObserver = true
		self:ShowItemHint( "item_ward_observer" )
		--self:HintWorldText( self.hHintWardLoc:GetAbsOrigin(), "place_ward", 89, -1 )
	elseif event.task_name == "move_to_location_2" then
		self:SpawnEnemy()
		self:ShowWizardTip( "scenario_warding_wizard_tip_vision", 15.0 )
		--self:EndHintWorldText( self.hHintWardLoc:GetAbsOrigin() ) 
	elseif event.task_name == "place_sentry_ward_1" then
		self.bCanPlaceSentry = true
		self:ShowItemHint( "item_ward_sentry" )
	elseif event.task_name == "destroy_enemy_ward" then
		self:ShowWizardTip( "scenario_warding_wizard_tip_sentry", 15.0 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:OnTaskCompleted( event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if event.checkpoint_skip == 1 then
		print( 'Checkpoint Skipping past the task completed logic for - ' .. Task:GetTaskName() )
		return
	end

	if event.task_name == "place_sentry_ward_1" then
		self.bEnemyWardSpawned = true
		self:SpawnEnemyWard()
		AddFOWViewer( DOTA_TEAM_GOODGUYS, self.hWardLoc2:GetAbsOrigin(), 100, 480, false )
	elseif event.task_name == "destroy_enemy_ward" then
		self:OnScenarioRankAchieved( 1 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:SpawnEnemyWard()
	print("Spawning enemy ward")
	local hEnemyWard = CreateUnitByName( "npc_dota_observer_wards", self.hEnemyWardLoc:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
	local Task = self:GetTask( "destroy_enemy_ward" )
	if Task then
		local hUnitsToKill = {}
		table.insert( hUnitsToKill, hEnemyWard )
		Task:SetUnitsToKill( hUnitsToKill )
	end

end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:SpawnEnemy()
	print("Spawning enemy")
	self.PudgeSpawner:SpawnUnits()
	self.hEnemyPudge = self.PudgeSpawner:GetSpawnedUnits()[1]

	--self:StartDialog( "enemy_spotted", false, self.hPlayerHero:entindex(), 5 )
	local hEnemyLocation = Entities:FindByName( nil, "enemy_location_1" )
	local vPos = hEnemyLocation:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vPos.x .. " " .. vPos.y .. " " .. 1 )

	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3, function()
			local vHeroPos = self.hHero:GetAbsOrigin()
			SendToConsole( "dota_camera_lerp_position " .. vHeroPos.x .. " " .. vHeroPos.y .. " " .. 1 )
			--SendToConsole( "+dota_camera_center_on_hero" )
			--SendToConsole( "-dota_camera_center_on_hero" )
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:OnEntityKilled( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	
	if hEnt == self.hPlayerHero then
		self:OnScenarioComplete( false, "task_fail_player_hero_death_fail" )
	end
	if hEnt:GetUnitName() == "npc_dota_sentry_wards" then
		self:OnScenarioComplete( false, "scenario_warding_failure_sentry_ward_destroyed" )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Warding:OnWardSpawned( event )
	local hUnit = EntIndexToHScript( event.entindex )
	if hUnit:GetUnitName() == "npc_dota_observer_wards" then
		print("Observer Ward Placed")
		if self.bCanPlaceObserver == false then
			self:OnScenarioComplete( false, "scenario_warding_failure_observer_placed_at_wrong_time" )
		end
	elseif hUnit:GetUnitName() == "npc_dota_sentry_wards" then
		print("Sentry Ward Placed")
		if self.bCanPlaceSentry == false then
			self:OnScenarioComplete( false, "scenario_warding_failure_sentry_placed_at_wrong_time" )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Warding:ShowItemHint( szItemName )
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

--------------------------------------------------------------------

return CDotaNPXScenario_Warding
