
require( "npx_scenario" )
require( "tasks/task_parallel" )
require( "tasks/task_sequence" )
require( "tasks/task_kill_units" )
require( "tasks/task_move_to_location" )
require( "tasks/task_move_to_trigger" )
require( "tasks/task_protect_units" )
require( "hero_ability_utils" )

--------------------------------------------------------------------------------

if CDotaNPXScenario_InitiationTeamfight == nil then
	CDotaNPXScenario_InitiationTeamfight = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_tidehunter",
		StartingHeroLevel	= 6,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_boots",
			"item_point_booster",
			"item_chainmail",
			--"item_blink",
		},
		StartingAbilities	= 
		{
			"tidehunter_ravage",
		}, 
		AbilityBuild = 
		{
			AbilityPriority = { "tidehunter_ravage" },
		},

		ScenarioTimeLimit = 0,
	}

	self.nCheckpoint = 0
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:SetHeroRespawnEnabled( false )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	GameRules:SetTimeOfDay( 0.251 )

	self.bPartTwoEarlyTriggerActivated = false

	if self.nCheckpoint == 0 then
		self.hRadiantMidTower = Entities:FindByName( nil, "dota_goodguys_tower1_mid" )
		ScriptAssert( self.hRadiantMidTower ~= nil, "self.hRadiantMidTower is nil!" )

		self.hRadiantMidTower:SetHealth( self.hRadiantMidTower:GetMaxHealth() * 0.2 )

		self.hDireMidTower = Entities:FindByName( nil, "dota_badguys_tower1_mid" )
		ScriptAssert( self.hDireMidTower ~= nil, "self.hDireMidTower is nil!" )

		self.hDireMidTower:SetHealth( self.hDireMidTower:GetMaxHealth() * 0.5 )

		self.hQueenOfPainSpawner = CDotaSpawner( "queenofpain_spawner", 
		{
			{
				EntityName = "npc_dota_hero_queenofpain",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Queen of Pain",
					EntityScript = "ai/initiation_teamfight/queenofpain.lua",
					StartingHeroLevel = 7,
					StartingItems = 
					{
						"item_power_treads",
						"item_null_talisman",
						"item_null_talisman",
					},
					StartingAbilities	= 
					{
						"queenofpain_scream_of_pain",
						"queenofpain_sonic_wave",
						"queenofpain_sonic_shadow_strike",
						"queenofpain_sonic_blink",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "queenofpain_scream_of_pain", "queenofpain_sonic_wave", "queenofpain_sonic_shadow_strike", "queenofpain_blink" },
					},
				},
			},
		}, self, true )
		ScriptAssert( self.hQueenOfPainSpawner ~= nil, "self.hQueenOfPainSpawner is nil!" )
	end

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_InitiationTeamfight, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:SetupTasks()
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

	local szInitialPlayerMoveLoc = "initial_player_move_loc"
	self.hInitialPlayerMoveLoc = Entities:FindByName( nil, szInitialPlayerMoveLoc )
	ScriptAssert( self.hInitialPlayerMoveLoc ~= nil, "Could not find entity named %s!", szInitialPlayerMoveLoc )

	local GoIntoTrees = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "go_into_trees",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hInitialPlayerMoveLoc:GetAbsOrigin(),
			GoalDistance = 64,
		},
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ), 1.5 )

	local WinTeamfight = rootTask:AddTask( CDotaNPXTask_Parallel( {
		TaskName = "win_teamfight",
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "go_into_trees" )
		end,
	}, self ), 0.5 )

	local RavageEnemies = WinTeamfight:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "ravage_and_kill_enemies",
		TaskType = "task_kill_units",
		Hidden = true,
		TaskParams =
		{
		},
		UseHints = true,
	}, self ), 1.5 )

	self.ProtectAllies = WinTeamfight:AddTask( CDotaNPXTask_ProtectUnits( {
		TaskName = "protect_allies",
		Hidden = true,
		TaskParams =
		{
			FailureString = "initiation_teamfight_failure_protect_units",
		},
	}, self ), 1.5 )

	local szP2PlayerMoveLoc = "p2_player_move_loc"
	local hP2PlayerMoveLoc = Entities:FindByName( nil, szP2PlayerMoveLoc )
	ScriptAssert( hP2PlayerMoveLoc ~= nil, "Could not find entity named %s!", szP2PlayerMoveLoc )

	local MoveToP2Loc = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_p2_loc",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = hP2PlayerMoveLoc:GetAbsOrigin(),
			GoalDistance = 64,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "win_teamfight" )
		end,
	}, self ), 2.0 )

	local WinSecondTeamfight = rootTask:AddTask( CDotaNPXTask_Parallel( {
		TaskName = "win_second_teamfight",
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_p2_loc" )
		end,
	}, self ), 0.5 )

	local EnterSecondTeamfightTrigger = WinSecondTeamfight:AddTask( CDotaNPXTask_MoveToTrigger( {
		TaskName = "enter_second_teamfight_trigger",
		TaskType = "task_move_to_trigger",
		Hidden = true,
		TaskParams =
		{
			TriggerName = "part_two_detect_player_movement",
		},
		UseHints = false,
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_p2_loc" )
		end,
	}, self ), 2.0 )

	local BlinkRavageEnemies = WinSecondTeamfight:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "blink_ravage_enemies",
		TaskType = "task_kill_units",
		Hidden = true,
		TaskParams =
		{				
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_p2_loc" )
		end,
	}, self ), 2.0 )

	local ProtectAlliesP2 = WinSecondTeamfight:AddTask( CDotaNPXTask_ProtectUnits( {
		TaskName = "protect_allies_p2",
		Hidden = true,
		TaskParams =
		{
			FailureString = "initiation_teamfight_failure_protect_units",
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_p2_loc" )
		end,
	}, self ), 2.0 )

	return true
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	--[[
	-- @note: I think checkpoint_skip needs to be hooked to TaskStarted for this to do anything
	if event.checkpoint_skip == 1 then
		printf( "OnTaskTarted - Checkpoint Skipping past the task completed logic for \"%s\"", Task:GetTaskName() )

		return
	end
	]]
	
	if Task:GetTaskName() == "go_into_trees" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2.0, function()
			self:ShowWizardTip( "initiation_teamfight_tip_ravage_primer", 5.0 )
		end )
	end

	if Task:GetTaskName() == "win_teamfight" then
		self:ShowWizardTip( "initiation_teamfight_tip_queenofpain_combo", 4.0 )
	end

	if Task:GetTaskName() == "move_to_p2_loc" then
		self:ShowWizardTip( "initiation_teamfight_tip_blink_gained", 6.0 )
	end

	if Task:GetTaskName() == "win_second_teamfight" then
		self:ShowWizardTip( "initiation_teamfight_tip_enigma_bkb", 6.0 )
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_to_p2_loc" then
		self.nCheckpoint = 1

		-- Spawn allied heroes (part 2)
		self.hLionP2Spawner = CDotaSpawner( "p2_lion_spawner", 
		{
			{
				EntityName = "npc_dota_hero_lion",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Lion",
					EntityScript = "ai/initiation_teamfight/lion_p2.lua",
					StartingHeroLevel = 7,
					StartingItems = 
					{
						"item_arcane_boots",
						"item_null_talisman",
						"item_blink",
					},
					StartingAbilities = 
					{
						"lion_finger_of_death",
						"lion_impale",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "lion_finger_of_death", "lion_impale" },
					},
				},
			},
		}, self, true )
		ScriptAssert( self.hLionP2Spawner ~= nil, "self.hLionP2Spawner is nil!" )

		self.hDragonKnightP2Spawner = CDotaSpawner( "p2_dragon_knight_spawner", 
		{
			{
				EntityName = "npc_dota_hero_dragon_knight",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Dragon Knight",
					EntityScript = "ai/initiation_teamfight/dragon_knight_p2.lua",
					StartingHeroLevel = 6,
					StartingItems =
					{
						"item_power_treads",
						"item_hyperstone",
						"item_lesser_crit",
						"item_blink",
					},
					StartingAbilities	=
					{
						"dragon_knight_elder_dragon_form",
					},
					AbilityBuild =
					{
						AbilityPriority = { "dragon_knight_elder_dragon_form" },
					},
				},
			},
		}, self, true )

		-- Spawn enemy heroes (part 2)
		self.hWraithKingP2Spawner = CDotaSpawner( "p2_wraith_king_spawner", 
		{
			{
				EntityName = "npc_dota_hero_skeleton_king",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Wraith King",
					EntityScript = "ai/initiation_teamfight/wraith_king_p2.lua",
					StartingHeroLevel = 5,
					StartingItems = 
					{
						"item_power_treads",
						"item_hyperstone",
						"item_desolator",
					},
					StartingAbilities	= 
					{
						"skeleton_king_hellfire_blast",
						"skeleton_king_vampiric_aura",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "skeleton_king_hellfire_blast", "skeleton_king_vampiric_aura" },
					},
				},
			},
		}, self, true )

		self.hSniperP2Spawner = CDotaSpawner( "p2_sniper_spawner", 
		{
			{
				EntityName = "npc_dota_hero_sniper",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Sniper",
					EntityScript = "ai/initiation_teamfight/sniper_p2.lua",
					StartingHeroLevel = 6,
					StartingItems =
					{
						"item_power_treads",
						"item_wraith_band",
						"item_wraith_band",
						"item_desolator",
					},
					StartingAbilities	= 
					{
						"sniper_assassinate",
						"sniper_take_aim",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "sniper_take_aim", "sniper_assassinate" },
					},
				},
			},
		}, self, true )

		self.hEnigmaP2Spawner = CDotaSpawner( "p2_enigma_spawner", 
		{
			{
				EntityName = "npc_dota_hero_enigma",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Enigma",
					EntityScript = "ai/initiation_teamfight/enigma_p2.lua",
					StartingHeroLevel = 7,
					StartingItems = 
					{
						"item_arcane_boots",
						"item_null_talisman",
						"item_black_king_bar",
						"item_blink",
					},
					StartingAbilities	= 
					{
						"enigma_black_hole",
						"enigma_midnight_pulse",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "enigma_black_hole", "enigma_midnight_pulse" },
					},
				},
			},
		}, self, true )
	elseif Task:GetTaskName() == "blink_ravage_enemies" then
		printf( "Completed task blink_ravage_enemies" )
		local hWinSecondTeamfightTask = GameRules.DotaNPX:GetTask( "win_second_teamfight" )
		if hWinSecondTeamfightTask ~= nil and hWinSecondTeamfightTask:IsCompleted() == false then
			hWinSecondTeamfightTask:CompleteTask( true )
		end
	elseif Task:GetTaskName() == "win_second_teamfight" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2.0, function()
			self:OnScenarioComplete( true )
		end )
	end

	if event.checkpoint_skip == 1 then
		printf( "Checkpoint Skipping past the task completed logic for \"%s\"", Task:GetTaskName() )

		-- If Tidehunter doesn't have a blink (because it's given out when completing a task that's prior to the checkpoint), then give it to him
		local hBlink = self:FindItemByName( self.hPlayerHero, "item_blink" )
		if hBlink == nil then
			local blink = CreateItem( "item_blink", self.hPlayerHero, self.hPlayerHero )
			blink:SetPurchaseTime( 0 )
			blink:SetPurchaser( self.hPlayerHero )
			self.hPlayerHero:AddItem( blink )

			RefreshHero( self.hPlayerHero )
		end

		return
	end

	if Task:GetTaskName() == "go_into_trees" then
		self.hPlayerHero:RemoveModifierByName( "modifier_disable_healing" )

		local hQueenOfPain = self.hQueenOfPainSpawner:GetSpawnedUnits()[ 1 ]
		hQueenOfPain:RemoveModifierByName( "modifier_disable_healing" )

		-- Spawn enemy heroes
		self.hWraithKingSpawner = CDotaSpawner( "wraith_king_spawner", 
		{
			{
				EntityName = "npc_dota_hero_skeleton_king",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Wraith King",
					EntityScript = "ai/initiation_teamfight/wraith_king.lua",
					StartingHeroLevel = 5,
					StartingItems = 
					{
						"item_power_treads",
						"item_platemail",
						"item_desolator",
					},
					StartingAbilities	= 
					{
						"skeleton_king_hellfire_blast",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "skeleton_king_hellfire_blast" },
					},
				},
			},
		}, self, true )

		self.hSniperSpawner = CDotaSpawner( "sniper_spawner", 
		{
			{
				EntityName = "npc_dota_hero_sniper",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Sniper",
					EntityScript = "ai/initiation_teamfight/sniper.lua",
					StartingHeroLevel = 6,
					StartingItems =
					{
						"item_power_treads",
						"item_wraith_band",
					},
					StartingAbilities	= 
					{
						"sniper_assassinate",
						"sniper_take_aim",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "sniper_take_aim", "sniper_assassinate" },
					},
				},
			},
		}, self, true )
	elseif Task:GetTaskName() == "win_teamfight" then
		-- Give Tidehunter a blink dagger
		local blink = CreateItem( "item_blink", self.hPlayerHero, self.hPlayerHero )
		blink:SetPurchaseTime( 0 )
		blink:SetPurchaser( self.hPlayerHero )
		self.hPlayerHero:AddItem( blink )

		RefreshHero( self.hPlayerHero )
	elseif Task:GetTaskName() == "ravage_and_kill_enemies" then
		-- If QoP and the tower are still alive, then that task is completed successfully
		local hQueenOfPain = self.hQueenOfPainSpawner:GetSpawnedUnits()[ 1 ]
		ScriptAssert( hQueenOfPain ~= nil, "Queen of Pain is nil" )
		ScriptAssert( self.hRadiantMidTower ~= nil, "Radiant mid tower is nil" )

		if hQueenOfPain ~= nil and hQueenOfPain:IsAlive() and self.hRadiantMidTower ~= nil and self.hRadiantMidTower:IsAlive() then
			local hProtectAlliesTask = GameRules.DotaNPX:GetTask( "protect_allies" )
			if hProtectAlliesTask ~= nil and hProtectAlliesTask:IsCompleted() == false then
				hProtectAlliesTask:CompleteTask( true )
			end
		end

		--Task:GetScenario():ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 2.0, function()
		self:ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 2.0, function()
			-- Remove all other heroes
			self.hQueenOfPainSpawner:RemoveSpawnedUnits()
			self.hWraithKingSpawner:RemoveSpawnedUnits()
			self.hSniperSpawner:RemoveSpawnedUnits()
		end )
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:OnTriggerStartTouch( event )
	printf( "CDotaNPXScenario_InitiationTeamfight:OnTriggerStartTouch" )

	local szPartTwoEarlyDetectTrigger = "p2_early_player_movement_detection_trigger"
	if self.hPlayerHero and event.trigger_name == szPartTwoEarlyDetectTrigger and event.activator_entindex == self.hPlayerHero:GetEntityIndex() then
		printf( "Player hero walked into trigger named %s", szPartTwoEarlyDetectTrigger )
		self.bPartTwoEarlyTriggerActivated = true
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	self.hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	self.hPlayerHero:SetAbilityPoints( 0 )

	if self.nCheckpoint == 1 then
		printf( "CHECKPOINT 1" )
		local bForceStart = true
		self:CheckpointSkipCompleteTask( "go_into_trees", true, bForceStart )
		self:CheckpointSkipCompleteTask( "win_teamfight", true )
		self:CheckpointSkipCompleteTask( "ravage_and_kill_enemies", true )
		self:CheckpointSkipCompleteTask( "protect_allies", true )

		self.bPartTwoEarlyTriggerActivated = false

		if self:GetPlayerHero() ~= nil then
			LearnHeroAbilities( self:GetPlayerHero(), {} )

			self:GetPlayerHero():SetGold( 0, true ) 
			self:GetPlayerHero():SetGold( 0, false ) 

			local hCheckpoints = Entities:FindAllByName( "checkpoint_1" )
			if hCheckpoints[ 1 ] ~= nil then
				FindClearSpaceForUnit( self:GetPlayerHero(), hCheckpoints[ 1 ]:GetAbsOrigin(), true )
				SendToConsole( "+dota_camera_center_on_hero" )
				SendToConsole( "-dota_camera_center_on_hero" )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )

	printf( "OnSpawnerFinished - event.spawner_name == %s", event.spawner_name )

	if event.spawner_name == "queenofpain_spawner" then
		if self.ProtectAllies and self.ProtectAllies.hUnitsToProtect == nil then
			printf( "Task protect_allies - Setting units to protect" )
			local hQueenOfPain = self.hQueenOfPainSpawner:GetSpawnedUnits()[ 1 ]
			hQueenOfPain:AddNewModifier( hQueenOfPain, nil, "modifier_disable_healing", { duration = -1 } )

			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )

			self.ProtectAllies.hUnitsToProtect = {}
			table.insert( self.ProtectAllies.hUnitsToProtect, hQueenOfPain )
			table.insert( self.ProtectAllies.hUnitsToProtect, hPlayerHero )
			table.insert( self.ProtectAllies.hUnitsToProtect, self.hRadiantMidTower )
			self.ProtectAllies:SetUnitsToProtect( self.ProtectAllies.hUnitsToProtect )
		end
	elseif event.spawner_name == "wraith_king_spawner" then
		local Task = self:GetTask( "ravage_and_kill_enemies" )
		if Task then
			local hWraithKing = self.hWraithKingSpawner:GetSpawnedUnits()[ 1 ]

			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hWraithKing )
			Task:AddUnitsToKill( hUnitsToKill )
		end
	elseif event.spawner_name == "sniper_spawner" then
		local Task = self:GetTask( "ravage_and_kill_enemies" )
		if Task then
			local hSniper = self.hSniperSpawner:GetSpawnedUnits()[ 1 ]
			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hSniper )
			Task:AddUnitsToKill( hUnitsToKill )
		end
	elseif event.spawner_name == "p2_wraith_king_spawner" then
		local Task = self:GetTask( "blink_ravage_enemies" )
		if Task then
			local hWraithKingP2 = self.hWraithKingP2Spawner:GetSpawnedUnits()[ 1 ]
			hWraithKingP2:AddNewModifier( hWraithKingP2, nil, "modifier_disable_healing", { duration = -1 } )

			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hWraithKingP2 )
			Task:AddUnitsToKill( hUnitsToKill )
		end
	elseif event.spawner_name == "p2_enigma_spawner" then
		local Task = self:GetTask( "blink_ravage_enemies" )
		if Task then
			local hEnigma = self.hEnigmaP2Spawner:GetSpawnedUnits()[ 1 ]
			hEnigma:AddNewModifier( hEnigma, nil, "modifier_disable_healing", { duration = -1 } )

			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hEnigma )
			Task:AddUnitsToKill( hUnitsToKill )
		end
	elseif event.spawner_name == "p2_sniper_spawner" then
		local Task = self:GetTask( "blink_ravage_enemies" )
		if Task then
			local hSniper = self.hSniperP2Spawner:GetSpawnedUnits()[ 1 ]
			hSniper:AddNewModifier( hSniper, nil, "modifier_disable_healing", { duration = -1 } )

			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hSniper )
			Task:AddUnitsToKill( hUnitsToKill )
		end
	elseif event.spawner_name == "p2_dragon_knight_spawner" then
		local Task = self:GetTask( "protect_allies_p2" )
		if Task then
			local hDragonKnight = self.hDragonKnightP2Spawner:GetSpawnedUnits()[ 1 ]
			local hUnitsToProtect = {}
			table.insert( hUnitsToProtect, hDragonKnight )
			Task:AddUnitsToProtect( hUnitsToProtect )
		end
	elseif event.spawner_name == "p2_lion_spawner" then
		local Task = self:GetTask( "protect_allies_p2" )
		if Task then
			local hLion = self.hLionP2Spawner:GetSpawnedUnits()[ 1 ]
			local hUnitsToProtect = {}
			table.insert( hUnitsToProtect, hLion )
			Task:AddUnitsToProtect( hUnitsToProtect )
		end
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:OnNPCSpawned( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )

	if hEnt ~= nil and hEnt:IsNull() == false and hEnt:GetUnitName() == "npc_dota_hero_tidehunter" then
		hEnt:SetHealth( hEnt:GetMaxHealth() * 0.6 )
		hEnt:AddNewModifier( hEnt, nil, "modifier_disable_healing", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:OnEntityKilled( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	

	if hEnt and ( hEnt:GetUnitName() == "npc_dota_hero_queenofpain" or hEnt:GetUnitName() == "dota_goodguys_tower1_mid" ) then
		local hProtectAlliesTask = GameRules.DotaNPX:GetTask( "protect_allies" )
		if hProtectAlliesTask ~= nil and hProtectAlliesTask:IsCompleted() == false then
			hProtectAlliesTask:CompleteTask( false )
		end
	end

	if hEnt and hEnt == self.hPlayerHero then
		local hProtectAlliesP2Task = GameRules.DotaNPX:GetTask( "protect_allies_p2" )
		if hProtectAlliesP2Task ~= nil and hProtectAlliesP2Task:IsCompleted() == false then
			hProtectAlliesP2Task:CompleteTask( false )
		end
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:GainLevels( hUnit, nLevels )
	local nCurrentXPTotal = GetXPNeededToReachNextLevel( hUnit:GetLevel() )
	local nXPToLevel = GetXPNeededToReachNextLevel( hUnit:GetLevel() + nLevels ) - nCurrentXPTotal
	hUnit:AddExperience( nXPToLevel, DOTA_ModifyXP_Unspecified, false, true )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_InitiationTeamfight:FindItemByName( hUnit, strItemName )
	for iSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_MAX do
		local hItem = hUnit:GetItemInSlot( iSlot )
		if hItem and hItem:GetAbilityName() == strItemName then
			return hItem
		end
	end
end

--------------------------------------------------------------------------------

return CDotaNPXScenario_InitiationTeamfight
