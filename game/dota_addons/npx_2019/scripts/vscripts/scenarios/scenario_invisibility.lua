require( "npx_scenario" )
require( "spawner" )
require( "tasks/task_modifier_added_to_enemy" )

--------------------------------------------------------------------

if CDotaNPXScenario_Invisibility == nil then
	CDotaNPXScenario_Invisibility = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:InitScenarioKeys()

	self.hSentryWardPos = Entities:FindByName( nil, "sentry_ward_pos" )	

	self.hScenario =
	{
		DaynightCycleDisabled = true,
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_lion",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel	= 12,
		StartingGold		= 0,
		bLetGoldThrough		= false,
		bLetXPThrough		= false,

		StartingItems 		=
		{
			"item_tranquil_boots",
			"item_energy_booster",
			--"item_aether_lens",
			--"item_arcane_boots",
			--"item_blade_of_alacrity",
			--"item_staff_of_wizardry",
			--"item_ogre_axe"
		},

		StartingAbilities	= 
		{
			"lion_finger_of_death",
			"lion_finger_of_death",
			"lion_impale",
			"lion_impale",
			"lion_impale",
			"lion_impale",
		}, 
		--AbilityBuild = 
		--{
		--	AbilityPriority =
		--	{
		--		"lion_finger_of_death",
		--		"lion_finger_of_death",
		--		"lion_impale",
		--		"lion_impale",
		--		"lion_impale",
		--		"lion_impale",
		--	},
		--},

		ScenarioTimeLimit = 600.0,

		Tasks =
		{
			{
				TaskName = "intro_delay",
				TaskType = "task_delay",
				Hidden = true,
				TaskParams =
				{
					Delay = 2.0,
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
				TaskName = "buy_sentry",
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
					return GameRules.DotaNPX:IsTaskComplete( "intro_delay" )
				end,
			},

			{
				TaskName = "place_sentry",
				TaskType = "task_place_ward_at_location",
				UseHints = true,
				TaskParams =
				{
					WardType = "sentry",
					GoalLocation = self.hSentryWardPos:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_sentry" )
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
					local task = self:GetTask( "place_sentry" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end

					return false
				end,
			},

			{
				TaskName = "do_not_die",
				TaskType = "task_fail_player_hero_death",
				Hidden = true,
				TaskParams = 
				{
					Count = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "destroy_enemy_ward" )
				end,
			},


			{
				TaskName = "kill_riki",
				TaskType = "task_kill_units",
				TaskParams = 
				{
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "destroy_enemy_ward" )
				end,
			},

			{
				TaskName = "move_to_shop",
				TaskType = "task_move_to_trigger",
				UseHints = true,
				TaskParams =
				{
					TriggerName = "move_to_shop",
				},
				CheckTaskStart = 
				function() 
					local task = self:GetTask( "kill_riki" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end

					return false
				end,
			},

			{
				TaskName = "buy_dust",
				TaskType = "task_buy_item",
				UseHints = true,
				TaskParams = 
				{
					ItemName = "item_dust",
					WhiteList = { "item_dust", },
					DisableWhitelistOnComplete = false,
				},
				CheckTaskStart =
				function()
					return GameRules.DotaNPX:IsTaskComplete( "move_to_shop" )
				end,
				OnCheckpoint =
				function()
					print( 'CHECKPOINT 1' )

					local Task
					Task = self:GetTask( "buy_sentry" )
					if Task then Task:SetTaskHidden( true ) end
					Task = self:GetTask( "place_sentry" )
					if Task then Task:SetTaskHidden( true ) end
					Task = self:GetTask( "destroy_enemy_ward" )
					if Task then Task:SetTaskHidden( true ) end
					Task = self:GetTask( "kill_riki" )
					if Task then Task:SetTaskHidden( true ) end
					Task = self:GetTask( "move_to_shop" )
					if Task then Task:SetTaskHidden( true ) end
					Task = self:GetTask( "buy_dust" )
					if Task then Task:SetTaskHidden( true ) end

					local bForceStart = true
					self:CheckpointSkipCompleteTask( "intro_delay", true, bForceStart )
					self:CheckpointSkipCompleteTask( "buy_sentry", true )
					self:CheckpointSkipCompleteTask( "place_sentry", true )
					self:CheckpointSkipCompleteTask( "destroy_enemy_ward", true )
					self:CheckpointSkipCompleteTask( "kill_riki", true )
					self:CheckpointSkipCompleteTask( "move_to_shop", true )
					self:CheckpointSkipCompleteTask( "buy_dust", true )

					if self:GetPlayerHero() ~= nil then
						LearnHeroAbilities( self:GetPlayerHero(), {} )
						self:GetPlayerHero():AddItemByName( "item_dust" )

						self:GetPlayerHero():SetGold( 0, true ) 
						self:GetPlayerHero():SetGold( 0, false ) 

						local hCheckpoints = Entities:FindAllByName( "checkpoint_1" )
						if hCheckpoints[1] ~= nil then
							FindClearSpaceForUnit( self:GetPlayerHero(), hCheckpoints[1]:GetAbsOrigin(), true )
							SendToConsole( "+dota_camera_center_on_hero" )
							SendToConsole( "-dota_camera_center_on_hero" )
						end
					end
				end,
			},

			{
				TaskName = "dust_bounty_hunter",
				TaskType = "task_modifier_added_after_ability_used",
				TaskParams =
				{
					AbilityName = "item_dust",
					ModifierName = "modifier_item_dustofappearance",
					FailureString = "scenario_invisibility_failure_missed_dust",
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_dust" )
				end,
			},

			{
				TaskName = "kill_bounty_hunter",
				TaskType = "task_kill_units",
				TaskParams = 
				{
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_dust" )
				end,
			},

			{
				TaskName = "pick_up_gem",
				TaskType = "task_pick_up_item",
				TaskParams =
				{
					ItemName = "item_gem",
				},
				CheckTaskStart = 
				function() 
					local task = self:GetTask( "kill_bounty_hunter" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end
					return false
				end,
			},

			{
				TaskName = "destroy_enemy_gem_wards",
				TaskType = "task_kill_units",
				UseHints = true,
				TaskParams =
				{
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "pick_up_gem" )
				end,
			},

		},

		Queries =
		{
		},
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end
	
	--[[
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
	GameRules:GetGameModeEntity():SetAllowNeutralItemDrops( false )
	GameRules:GetGameModeEntity():SetRecommendedItemsDisabled( true )
	GameRules:GetGameModeEntity():SetStickyItemDisabled( true )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 10.0 )
	]]--

	self.hTutorialBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	if #self.hTutorialBlockers == 0 then
		print( "WARNING - Found no blockers!" )

	else
		for i=#self.hTutorialBlockers,1,-1  do
			local hBlocker = self.hTutorialBlockers[ i ]
			print( "blocker name: " .. hBlocker:GetName() )
			if not string.find( hBlocker:GetName(), "blocker_shop" ) then 
				print( "removing blocker named " .. hBlocker:GetName() )
				table.remove( self.hTutorialBlockers, i )
			end
		end

	end

	return true
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	self:EndAllHintWorldText()

	GameRules:SetHeroRespawnEnabled( false )

	self:GetPlayerHero():SetAbilityPoints( 0 )

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "invisibility" )

	GameRules:SetItemStockCount( 5, DOTA_TEAM_GOODGUYS, "item_ward_sentry", -1 )

	self:SpawnEnemyWard( "enemy_ward_pos", "destroy_enemy_ward" )

	self:SpawnEnemyWard( "enemy_gem_ward_pos_1", "destroy_enemy_gem_wards" )
	self:SpawnEnemyWard( "enemy_gem_ward_pos_2", "destroy_enemy_gem_wards" )
	self:SpawnEnemyWard( "enemy_gem_ward_pos_3", "destroy_enemy_gem_wards" )

end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:OnNPCSpawned( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	

	if hEnt ~= nil and hEnt:IsNull() == false then
		if hEnt:GetUnitName() == "npc_dota_hero_riki" then

			self.hRiki = hEnt
			self.hRiki:ModifyHealth( 200, nil, false, 0 )

			local Task = self:GetTask( "kill_riki" )
			if Task then
				printf( "found task kill_riki, doing SetUnitsToKill" )
				local hUnitsToKill = {}
				table.insert( hUnitsToKill, self.hRiki )
				Task:SetUnitsToKill( hUnitsToKill )
			end

			local hRikiPos = Entities:FindByName( nil, "riki_spawner" )
			if hRikiPos ~= nil then
				AddFOWViewer( DOTA_TEAM_GOODGUYS, hRikiPos:GetAbsOrigin(), 400, 6, false )
				SendToConsole( "dota_camera_lerp_position " .. hRikiPos:GetAbsOrigin().x .. " " .. hRikiPos:GetAbsOrigin().y .. " " .. 1 )
			end
		
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
				SendToConsole( "dota_camera_lerp_position " .. self:GetPlayerHero():GetAbsOrigin().x .. " " .. self:GetPlayerHero():GetAbsOrigin().y .. " " .. 1 )
				--SendToConsole( "+dota_camera_center_on_hero" )
				--SendToConsole( "-dota_camera_center_on_hero" )
			end )

			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
				self.hRiki.Bot:GoToAttack()
			end )

			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3, function()
				self:ShowWizardTip( "scenario_invisibility_wizard_tip_kill_riki", 15.0, {}, { "npc_dota_hero_riki" } )
			end )

		elseif hEnt:GetUnitName() == "npc_dota_hero_bounty_hunter" then

			local Task = self:GetTask( "kill_bounty_hunter" )
			if Task then
				printf( "found task kill_bounty_hunter, doing SetUnitsToKill" )
				local hUnitsToKill = {}
				table.insert( hUnitsToKill, hEnt )
				Task:SetUnitsToKill( hUnitsToKill )
			end
		end
	end

end

--------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	print( 'Task Completed - ' .. Task:GetTaskName() )	

	if Task:GetTaskName() == "buy_dust" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:ShowWizardTip( "scenario_invisibility_wizard_tip_dust", 15.0, { "item_dust" } )
			self:ShowItemHint( "item_dust" )
		end )

		local hHintPosition = Entities:FindByName( nil, "bounty_hunter_hint_pos" )
		if hHintPosition ~= nil then
			self:HintLocation( hHintPosition:GetAbsOrigin(), true )
		end

		self.hBountyHunterSpawner = CDotaSpawner( "bounty_hunter_spawner", 
		{
			{
				EntityName = "npc_dota_hero_bounty_hunter",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "Bounty Hunter",
					EntityScript = "ai/invisibility/ai_bounty_hunter.lua",
					StartingHeroLevel = 5,
					StartingItems = 
					{
						"item_gem"
						--"item_power_treads",
						--"item_greater_crit",
						--"item_diffusal_blade",
					},
					StartingAbilities =
					{
						"bounty_hunter_wind_walk",
					},
					AbilityBuild = 
					{
						AbilityPriority =
						{
							"bounty_hunter_wind_walk",
						},
					},
				},
			},
		}, self, true )		

	elseif Task:GetTaskName() == "dust_bounty_hunter" then
		local hHintPosition = Entities:FindByName( nil, "bounty_hunter_hint_pos" )
		if hHintPosition ~= nil then
			self:HintLocation( hHintPosition:GetAbsOrigin(), false )
		end

		self:HideUIHint()

	elseif Task:GetTaskName() == "kill_riki" then
		-- disable the shop blocker wall after we kill riki
		for _,hBlocker in pairs ( self.hTutorialBlockers ) do
			hBlocker:SetEnabled( false )
		end

	end

	if event.checkpoint_skip == 1 then
		print( 'Checkpoint Skipping past the task completed logic for - ' .. Task:GetTaskName() )
		return
	end

	if Task:GetTaskName() == "destroy_enemy_ward" then
		self.hRikiSpawner = CDotaSpawner( "riki_spawner", 
		{
			{
				EntityName = "npc_dota_hero_riki",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "Riki",
					EntityScript = "ai/invisibility/ai_riki.lua",
					StartingHeroLevel = 12,
					StartingItems = 
					{
						"item_wraith_band",
						--"item_greater_crit",
						--"item_diffusal_blade",
						--"item_satanic",
					},
					StartingAbilities =
					{
						"riki_backstab",
						"riki_smoke_screen",
						"riki_blink_strike"
					},
					AbilityBuild = 
					{
						AbilityPriority =
						{
							"riki_backstab",
							"riki_smoke_screen",
							"riki_blink_strike"
						},
					},
				},
			},
		}, self, true )

	elseif Task:GetTaskName() == "move_to_shop" then
		local hPlayerHero = self:GetPlayerHero()

		local nCost = tonumber( GetCostOfItem( "item_dust" ) )
		print( 'Cost of item_dust = ' .. nCost )
		hPlayerHero:SetGold( nCost, true ) 
		hPlayerHero:SetGold( 0, false ) 

		self:ShowWizardTip( "scenario_invisibility_wizard_tip_dust_intro", 15.0, { "item_dust" } )
	end


	if Task:GetTaskName() == "kill_riki" then
		if event.success == 1 then
			local hPlayerHero = self:GetPlayerHero()

			RefreshHero( hPlayerHero )
		end
	elseif Task:GetTaskName() == "destroy_enemy_gem_wards" then
		if event.success == 1 then
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				
				self:OnScenarioRankAchieved( 1 )

			end )
		end
	end

	-- HINTS
	--[[
	if Task:GetTaskName() == "place_sentry" then
		local hHintLocation = Entities:FindByName( nil, "ward_hint_pos" )
		if hHintLocation ~= nil then
			self:EndHintWorldText( hHintLocation:GetAbsOrigin() )
		end

	elseif Task:GetTaskName() == "move_to_location_2" then
		local hHintLocation = Entities:FindByName( nil, "dust_hint_pos" )
		if hHintLocation ~= nil then
			self:EndHintWorldText( hHintLocation:GetAbsOrigin() )
		end
	end
	]]--

	-- WIZARD TIPS
	if Task:GetTaskName() == "buy_sentry" then

		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:ShowWizardTip( "scenario_invisibility_wizard_tip_sentry_wards", 15.0, { "item_ward_sentry" } )
			self:ShowItemHint( "item_ward_sentry" )
		end )
	
	elseif Task:GetTaskName() == "place_sentry" then
		self:HideUIHint()

	elseif Task:GetTaskName() == "kill_bounty_hunter" then
		if event.success == 1 then
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				self:ShowWizardTip( "scenario_invisibility_wizard_tip_pick_up_gem", 15.0, { "item_gem" } )
			end )
		end

	elseif Task:GetTaskName() == "pick_up_gem" then
		self:ShowWizardTip( "scenario_invisibility_wizard_tip_gem_care", 15.0, { "item_gem" } )

	end

end

--------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "buy_sentry" then
		local hPlayerHero = self:GetPlayerHero()

		local nCost = tonumber( GetCostOfItem( "item_ward_sentry" ) )
		print( 'Cost of item_ward_sentry = ' .. nCost )
		hPlayerHero:SetGold( nCost, true ) 
		hPlayerHero:SetGold( 0, false ) 

	--[[
	elseif Task:GetTaskName() == "place_sentry" then
		local hHintLocation = Entities:FindByName( nil, "ward_hint_pos" )
		if hHintLocation ~= nil then
			self:HintWorldText( hHintLocation:GetAbsOrigin(), "ward_hint_pos", 18, -1 )
		end

	elseif Task:GetTaskName() == "move_to_location_2" then
		local hHintLocation = Entities:FindByName( nil, "dust_hint_pos" )
		if hHintLocation ~= nil then
			self:HintWorldText( hHintLocation:GetAbsOrigin(), "dust_hint_pos", 18, -1 )
		end
	]]--
	end

	-- don't show these when checkpointing
	if self.szCheckpointTaskName == nil then
		if Task:GetTaskName() == "buy_sentry" then
			self:ShowWizardTip( "scenario_invisibility_wizard_tip_intro", 15.0 )
		elseif Task:GetTaskName() == "destroy_enemy_ward" then
			self:ShowWizardTip( "scenario_invisibility_wizard_tip_observer_wards", 15.0, { "item_ward_observer" } )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:OnThink()
	CDotaNPXScenario.OnThink( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:SpawnEnemyWard( szWardPositionName, szAssociatedTaskName )

	local hWardPos = Entities:FindByName( nil, szWardPositionName )
	if hWardPos == nil then
		print( 'ERROR - cannot find ward location ' .. szWardPositionName )
		return
	end

	local hEnemyWard = CreateUnitByName( "npc_dota_observer_wards", hWardPos:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
	if hEnemyWard == nil then
		print( 'ERROR - failed to spawn enemy ward at ' .. szWardPositionName )
		return
	end

	hEnemyWard:AddNewModifier( hEnemyWard, nil, "modifier_item_buff_ward", { duration = -1 } )

	local Task = self:GetTask( szAssociatedTaskName )
	if Task then
		local hUnitsToKill = {}
		table.insert( hUnitsToKill, hEnemyWard )
		Task:AddUnitsToKill( hUnitsToKill )
	end

end

--------------------------------------------------------------------

function CDotaNPXScenario_Invisibility:ShowItemHint( szItemName )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	local hItem = self.hPlayerHero:FindItemInInventory( szItemName )
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

return CDotaNPXScenario_Invisibility