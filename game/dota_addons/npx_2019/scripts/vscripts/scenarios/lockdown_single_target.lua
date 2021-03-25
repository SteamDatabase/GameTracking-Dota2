
require( "npx_scenario" )
require( "tasks/task_parallel" )
require( "tasks/task_sequence" )
require( "tasks/task_kill_units" )
require( "tasks/task_move_to_location" )
require( "tasks/task_move_to_trigger" )
require( "tasks/task_protect_units" )

--------------------------------------------------------------------------------

if CDotaNPXScenario_LockdownSingleTarget == nil then
	CDotaNPXScenario_LockdownSingleTarget = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_shadow_shaman",
		StartingHeroLevel	= 5,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_boots",
			"item_point_booster",
		},

		ScenarioTimeLimit = 0,
	}

	self.nCheckpoint = 0
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:SetHeroRespawnEnabled( false )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	GameRules:SetTimeOfDay( 0.251 )

	if self.nCheckpoint == 0 then
		-- Create Lina
		self.hLinaSpawner = CDotaSpawner( "lina_spawner", 
		{
			{
				EntityName = "npc_dota_hero_lina",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Lina",
					EntityScript = "ai/lockdown_single_target/lina.lua",
					StartingHeroLevel = 6,
					StartingItems = 
					{
						"item_power_treads",
					},
					StartingAbilities	= 
					{
						"lina_laguna_blade",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "lina_laguna_blade" },
					},
				},
			}
		}, self, true )
	end

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_LockdownSingleTarget, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:SetupTasks()
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local szPlayerToDrowMoveLoc = "player_to_drow_move_loc"
	self.hPlayerToDrowMoveLoc = Entities:FindByName( nil, szPlayerToDrowMoveLoc )
	ScriptAssert( self.hPlayerToDrowMoveLoc ~= nil, "Could not find entity named %s!", szPlayerToDrowMoveLoc )

	local szPlayerToLinaMoveLoc = "player_to_lina_move_loc"
	self.hPlayerToLinaMoveLoc = Entities:FindByName( nil, szPlayerToLinaMoveLoc )
	ScriptAssert( self.hPlayerToLinaMoveLoc ~= nil, "Could not find entity named %s!", szPlayerToLinaMoveLoc )

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	local MoveToLina = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_lina",
		TaskType = "task_move_to_location",
		TaskParams = 
		{				
			GoalLocation = self.hPlayerToLinaMoveLoc:GetAbsOrigin(),
			GoalDistance = 64,
		},
		UseHints = true,
	}, self ), 1.0 )

	local ProtectLinaParallelTask = rootTask:AddTask( CDotaNPXTask_Parallel( {
		TaskName = "protect_lina_parallel",
		Hidden = true,
	}, self ), 0.25 )

	local ProtectLinaTask = ProtectLinaParallelTask:AddTask( CDotaNPXTask_ProtectUnits( {
		TaskName = "protect_lina",
		TaskParams =
		{
			FailureString = "lockdown_single_target_failure_protect_units",
		},
	}, self ), 0.25 )

	local MovingPastLinaTrigger = ProtectLinaParallelTask:AddTask( CDotaNPXTask_MoveToTrigger( {
		TaskName = "moving_past_lina_trigger",
		TaskType = "task_move_to_trigger",
		Hidden = true,
		TaskParams =
		{
			TriggerName = "player_moving_past_lina_trigger",
		},
		UseHints = false,
	}, self ), 0.25 )

	local GroupUpWithDrow = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_drow_ranger",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hPlayerToDrowMoveLoc:GetAbsOrigin(),
			GoalDistance = 64,
		},
	}, self ), 3.0 )

	local KillQueenOfPainParallel = rootTask:AddTask( CDotaNPXTask_Parallel( {
		TaskName = "kill_queenofpain_parallel",
		Hidden = true,
	}, self ), 0.5 )

	local MovingPastDrowTrigger = KillQueenOfPainParallel:AddTask( CDotaNPXTask_MoveToTrigger( {
		TaskName = "moving_past_drow",
		TaskType = "task_move_to_trigger",
		Hidden = true,
		TaskParams =
		{
			TriggerName = "player_moving_past_drow_trigger",
		},
		UseHints = false,
	}, self ), 1.0 )

	local KillQueenOfPain = KillQueenOfPainParallel:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_queenofpain",
		TaskType = "task_kill_units",
		TaskParams =
		{
		},
	}, self ), 1.0 )

	return true
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:OnTriggerStartTouch( event )
	--printf( "OnTriggerStartTouch" )

	--[[
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero and event.trigger_name == "start_trigger" and event.activator_entindex == hPlayerHero:GetEntityIndex() then
		--
	end
	]]
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	self.hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )

	-- Level up Shadow Shaman's abilities
	for i = 1, 3 do
		if self.hPlayerHero:GetAbilityPoints() > 0 then
			local hShacklesAbility = self.hPlayerHero:FindAbilityByName( "shadow_shaman_shackles" )
			ScriptAssert( hShacklesAbility ~= nil, "Ability named %s is nil, could not upgrade it!", hShacklesAbility:GetAbilityName() )
			if hShacklesAbility ~= nil then
				self.hPlayerHero:UpgradeAbility( hShacklesAbility )
			end
		end
	end

	self.hPlayerHero:SetAbilityPoints( 0 )

	if self.nCheckpoint == 1 then
		printf( "CHECKPOINT 1" )
		local bForceStart = true
		self:CheckpointSkipCompleteTask( "move_to_lina", true, bForceStart )
		self:CheckpointSkipCompleteTask( "protect_lina_parallel", true )
		self:CheckpointSkipCompleteTask( "protect_lina", true )
		self:CheckpointSkipCompleteTask( "moving_past_lina_trigger", true )
		self:CheckpointSkipCompleteTask( "move_to_drow_ranger", true )

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

function CDotaNPXScenario_LockdownSingleTarget:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_to_lina" then
		self:ShowWizardTip( "lockdown_single_target_tip_channeled_spells", 8.0 )
		self:ShowUIHint( "Ability2 AbilityButton" )
	end

	if Task:GetTaskName() == "move_to_drow_ranger" then
		if self.hLinaSpawner then
			self.hLinaSpawner:RemoveSpawnedUnits()
		end

		self:ShowWizardTip( "lockdown_single_target_tip_hex_gained", 8.0 )
		self:ShowUIHint( "Ability1 AbilityButton" )
	end

	if Task:GetTaskName() == "kill_queenofpain" then
		local hBountyLoc = Entities:FindByName( nil, "bounty_rune_location" )
		self.hRune = CreateRune( hBountyLoc:GetAbsOrigin(), DOTA_RUNE_BOUNTY )

		self:ShowWizardTip( "lockdown_single_target_tip_queenofpain_blink", 8.0 )
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "protect_lina" then
		local hPlayerHero = self:GetPlayerHero()
		if hPlayerHero then
			self.hPlayerHero:SetAbilityPoints( 2 )

			for i = 1, 2 do
				if self.hPlayerHero:GetAbilityPoints() > 0 then
					local hVoodooAbility = self.hPlayerHero:FindAbilityByName( "shadow_shaman_voodoo" )
					ScriptAssert( hVoodooAbility ~= nil, "Ability named %s is nil, could not upgrade it!", hVoodooAbility:GetAbilityName() )
					if hVoodooAbility ~= nil then
						self.hPlayerHero:UpgradeAbility( hVoodooAbility )
					end
				end
			end

			RefreshHero( hPlayerHero )
		end

		-- Create Drow
		self.hDrowSpawner = CDotaSpawner( "drow_spawner", 
		{
			{
				EntityName = "npc_dota_hero_drow_ranger",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Drow Ranger",
					EntityScript = "ai/lockdown_single_target/drow_ranger.lua",
					StartingHeroLevel = 5,
					StartingItems = 
					{
						"item_boots",
						"item_gloves",
						"item_wraith_band",
						"item_wraith_band",
						"item_yasha",
					},
					StartingAbilities	= 
					{
						"drow_ranger_trueshot",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "drow_ranger_trueshot" },
					},
				},
			},
		}, self, true )
	elseif Task:GetTaskName() == "move_to_drow_ranger" then
		self:HideUIHint()

		if self.hBaneSpawner then
			self.hBaneSpawner:RemoveSpawnedUnits()
		end

		self.nCheckpoint = 1

		-- Make QoP
		self.hQueenOfPainSpawner = CDotaSpawner( "queenofpain_spawner", 
		{
			{
				EntityName = "npc_dota_hero_queenofpain",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Queen of Pain",
					EntityScript = "ai/lockdown_single_target/queenofpain.lua",
					StartingHeroLevel = 5,
					StartingItems = 
					{
						"item_power_treads",
					},
					StartingAbilities	= 
					{
						"queenofpain_blink",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "queenofpain_blink" },
					},
				},
			}
		}, self, true )
	elseif Task:GetTaskName() == "kill_queenofpain" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2.0, function()
			self:OnScenarioComplete( true )
		end )
	end	



	if event.checkpoint_skip == 1 then
		printf( "Checkpoint Skipping past the task completed logic for \"%s\"", Task:GetTaskName() )
		return
	end



	if Task:GetTaskName() == "move_to_lina" then
		-- Create Bane
		self.hBaneSpawner = CDotaSpawner( "bane_spawner", 
		{
			{
				EntityName = "npc_dota_hero_bane",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Bane",
					EntityScript = "ai/lockdown_single_target/bane.lua",
					StartingHeroLevel = 6,
					StartingItems = 
					{
						"item_power_treads",
					},
					StartingAbilities	= 
					{
						"bane_brain_sap",
						"bane_fiends_grip",
					}, 
					AbilityBuild = 
					{
						AbilityPriority = { "bane_brain_sap", "bane_fiends_grip" },
					},
				},
			}
		}, self, true )
	elseif Task:GetTaskName() == "moving_past_lina_trigger" then
		self:HideUIHint()
	end
end	

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )

	printf( "OnSpawnerFinished - event.spawner_name == %s", event.spawner_name )

	if event.spawner_name == "queenofpain_spawner" then
		local Task = self:GetTask( "kill_queenofpain" )
		if Task then
			local hQueenOfPain = self.hQueenOfPainSpawner:GetSpawnedUnits()[ 1 ]
			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hQueenOfPain )
			Task:SetUnitsToKill( hUnitsToKill )
		end
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:OnNPCSpawned( hEnt )
	CDotaNPXScenario:OnNPCSpawned( hEnt )	

	if hEnt ~= nil and hEnt:IsNull() == false and hEnt:GetUnitName() == "npc_dota_hero_lina" then
		local ProtectLinaTask = self:GetTask( "protect_lina" )
		if ProtectLinaTask and ProtectLinaTask.hUnitsToProtect == nil then
			printf( "Task protect_lina - Setting units to protect" )
			ProtectLinaTask.hUnitsToProtect = {}
			table.insert( ProtectLinaTask.hUnitsToProtect, self.hPlayerHero )
			table.insert( ProtectLinaTask.hUnitsToProtect, hEnt )

			ProtectLinaTask:SetUnitsToProtect( ProtectLinaTask.hUnitsToProtect )
		end
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:OnEntityKilled( hVictim, hKiller, hInflictor )
	CDotaNPXScenario:OnEntityKilled( hVictim, hKiller, hInflictor )	
	--[[
	if hVictim:GetUnitName() == "npc_dota_hero_queenofpain" then
		-- empty
	end	
	]]
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:OnTriggerStartTouch( sTriggerName, hActivator, hCaller )
	printf( "CDotaNPXScenario_LockdownSingleTarget:OnTriggerStartTouch" )

	if self.hQueenOfPainSpawner then
		local hQueenOfPain = self.hQueenOfPainSpawner:GetSpawnedUnits()[ 1 ]
		if sTriggerName == "queenofpain_escape_trigger" and hActivator and hActivator == hQueenOfPain then
			-- This is probably a hack
			printf( "QoP touched escape trigger; scenario failed" )
			self:OnScenarioComplete( false, "lockdown_single_target_failure_queenofpain_escaped" )
		end
	end

	if self.hLinaSpawner then
		local hLina = self.hLinaSpawner:GetSpawnedUnits()[ 1 ]
		if sTriggerName == "home_trigger" and hActivator and hActivator == hLina then
			printf( "Lina touched home trigger; task completed" )
			local hTask = GameRules.DotaNPX:GetTask( "protect_lina" )
			if hTask ~= nil and hTask:IsCompleted() == false then
				hTask:CompleteTask( true )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_LockdownSingleTarget:Restart()
	UTIL_RemoveImmediate( self.hRune )

	CDotaNPXScenario.Restart( self )
end

--------------------------------------------------------------------------------

return CDotaNPXScenario_LockdownSingleTarget
