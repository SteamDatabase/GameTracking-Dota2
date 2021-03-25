require( "npx_scenario" )
require( "spawner" )

--------------------------------------------------------------------

if CDotaNPXScenario_SupportSurvival == nil then
	CDotaNPXScenario_SupportSurvival = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_SupportSurvival:InitScenarioKeys()
	self.fSurviveForTime1 = 20
	self.fSurviveForTime2 = 20
	self.fSurviveForTime3 = 20

	self.hScenario =
	{
		DaynightCycleDisabled = true,
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_crystal_maiden",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel	= 1,
		StartingGold		= 0,

		StartingItems 		=
		{
			--"item_glimmer_cape",
			--"item_arcane_boots",
			--"item_blade_of_alacrity",
			--"item_staff_of_wizardry",
			--"item_ogre_axe"
		},

		ScenarioTimeLimit = 600.0,

		Tasks =
		{
			{
				TaskName = "learn_frostbite",
				TaskType = "task_learn_ability",
				TaskParams = 
				{
					AbilityName = "crystal_maiden_frostbite",
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
				TaskName = "move_to_location_1",
				TaskType = "task_move_to_trigger",
				UseHints = true,
				TaskParams =
				{
					TriggerName = "move_to_location_1",
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "learn_frostbite" )
				end,
			},
			{
				TaskName = "do_not_die",
				TaskType = "task_fail_player_hero_death",
				TaskParams = 
				{
					Count = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
			{
				TaskName = "kill_sven_1",
				TaskType = "task_kill_units",
				TaskParams = 
				{
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
			{
				TaskName = "buy_glimmer_cape",
				TaskType = "task_buy_item",
				UseHints = true,
				TaskParams = 
				{
					ItemName = "item_glimmer_cape",
					WhiteList = { "item_glimmer_cape", },
				},
				CheckTaskStart =
				function()
					local task = self:GetTask( "kill_sven_1" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end
					return false
				end,
				OnCheckpoint =
				function()
					print( 'CHECKPOINT 1' )
					local bForceStart = true
					self:CheckpointSkipCompleteTask( "learn_frostbite", true, bForceStart )
					self:CheckpointSkipCompleteTask( "move_to_location_1", true )
					self:CheckpointSkipCompleteTask( "kill_sven_1", true )
					self:CheckpointSkipCompleteTask( "buy_glimmer_cape", true )

					if self:GetPlayerHero() ~= nil then
						LearnHeroAbilities( self:GetPlayerHero(), {} )
						self:GetPlayerHero():AddItemByName( "item_glimmer_cape" )

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
				TaskName = "move_to_location_2",
				TaskType = "task_move_to_trigger",
				UseHints = true,
				TaskParams =
				{
					TriggerName = "move_to_location_2",
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_glimmer_cape" )
				end,
			},
			{
				TaskName = "kill_sven_2",
				TaskType = "task_kill_units",
				TaskParams = 
				{
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_2" )
				end,
			},
			{
				TaskName = "buy_force_staff",
				TaskType = "task_buy_item",
				UseHints = true,
				TaskParams = 
				{
					ItemName = "item_force_staff",
					WhiteList = { "item_force_staff", },
				},
				CheckTaskStart =
				function() 
					local task = self:GetTask( "kill_sven_2" )
					if task and task:IsCompleted() == true and task:CheckSuccess() == true then
						return true
					end
					return false
				end,
				OnCheckpoint =
				function()
					print( 'CHECKPOINT 2' )
					local bForceStart = true
					self:CheckpointSkipCompleteTask( "learn_frostbite", true, bForceStart )
					self:CheckpointSkipCompleteTask( "move_to_location_1", true )
					self:CheckpointSkipCompleteTask( "kill_sven_1", true )
					self:CheckpointSkipCompleteTask( "buy_glimmer_cape", true )
					self:CheckpointSkipCompleteTask( "move_to_location_2", true )
					self:CheckpointSkipCompleteTask( "kill_sven_2", true )
					self:CheckpointSkipCompleteTask( "buy_force_staff", true )
					-- teleport
					if self:GetPlayerHero() ~= nil then
						LearnHeroAbilities( self:GetPlayerHero(), {} )
						self:GetPlayerHero():AddItemByName( "item_glimmer_cape" )
						self:GetPlayerHero():AddItemByName( "item_force_staff" )

						local hCheckpoints = Entities:FindAllByName( "checkpoint_2" )
						if hCheckpoints[1] ~= nil then
							FindClearSpaceForUnit( self:GetPlayerHero(), hCheckpoints[1]:GetAbsOrigin(), true )
							SendToConsole( "+dota_camera_center_on_hero" )
							SendToConsole( "-dota_camera_center_on_hero" )
						end
					end
				end,
			},
			{
				TaskName = "move_to_location_3",
				TaskType = "task_move_to_trigger",
				UseHints = true,
				TaskParams =
				{
					TriggerName = "move_to_location_3",
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_force_staff" )
				end,
			},
			{
				TaskName = "kill_sven_3",
				TaskType = "task_kill_units",
				TaskParams = 
				{
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_3" )
				end,
			},

		},

		Queries =
		{
		},
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_SupportSurvival:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:SetHeroRespawnEnabled( false )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_SupportSurvival:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )

	print( 'OnHeroFinishSpawn' )

	--[[if hPlayer:GetPlayerID() == 0 then
		--
	elseif hPlayer:GetPlayerID() == 1 then
		print( 'Spawning Sven!' )
		self.hSven = hHero

		LearnHeroAbilities( self.hSven, {} )
		self.hSven:SetInitialGoalEntity( spawnData.entWaypoint )
	end]]--
end

--------------------------------------------------------------------

--[[
function CDotaNPXScenario_SupportSurvival:OnSpawnerFinished( event )
	print( 'OnSpawnerFinished! - ' .. event.spawner_name )
	CDotaNPXScenario.OnSpawnerFinished( self, event )
	
	if event.spawner_name == "sven_spawner_1" or
	   event.spawner_name == "sven_spawner_2" or
	   event.spawner_name == "sven_spawner_3" then
		print( 'Spawning Sven!' )
		self.hSven = self.hSvenSpawner:GetSpawnedUnits()[1]
		LearnHeroAbilities( self.hSven, {} )
		--self.hSven:SetInitialGoalEntity( spawnData.entWaypoint )
	end
end
]]--

--------------------------------------------------------------------------------

function CDotaNPXScenario_SupportSurvival:OnNPCSpawned( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	

	if hEnt ~= nil and hEnt:IsNull() == false and hEnt:GetUnitName() == "npc_dota_hero_sven" then
		local Task1 = self:GetTask( "kill_sven_1" )
		if Task1 then
			printf( "found task kill_sven_1, doing SetUnitsToKill" )
			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hEnt )
			Task1:SetUnitsToKill( hUnitsToKill )
		end

		local Task2 = self:GetTask( "kill_sven_2" )
		if Task2 then
			printf( "found task kill_sven_2, doing SetUnitsToKill" )
			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hEnt )
			Task2:SetUnitsToKill( hUnitsToKill )
		end

		local Task3 = self:GetTask( "kill_sven_3" )
		if Task3 then
			printf( "found task kill_sven_3, doing SetUnitsToKill" )
			local hUnitsToKill = {}
			table.insert( hUnitsToKill, hEnt )
			Task3:SetUnitsToKill( hUnitsToKill )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_SupportSurvival:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	print( 'Task Completed - ' .. Task:GetTaskName() )	

	if 	Task:GetTaskName() == "kill_sven_1" or
		Task:GetTaskName() == "kill_sven_2" then
		if event.success == 1 then
			local hPlayerHero = self:GetPlayerHero()

			RefreshHero( hPlayerHero )

			hPlayerHero:HeroLevelUp( true )
			hPlayerHero:HeroLevelUp( false )
			hPlayerHero:HeroLevelUp( false )
			hPlayerHero:HeroLevelUp( false )

			LearnHeroAbilities( hPlayerHero, {} )

			return
		end
	elseif Task:GetTaskName() == "kill_sven_3" then
		if event.success == 1 then
			self:OnScenarioRankAchieved( 1 )

			return
		end
	end

	if event.checkpoint_skip == 1 then
		print( 'Checkpoint Skipping past the task completed logic for - ' .. Task:GetTaskName() )
		return
	end

	if Task:GetTaskName() == "move_to_location_1" then
		self.hSvenSpawner = CDotaSpawner( "sven_spawner_1", 
		{
			{
				EntityName = "npc_dota_hero_sven",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "The Rogue Knight",
					EntityScript = "ai/support_survival/ai_sven.lua",
					StartingHeroLevel = 3,
					StartingItems = 
					{
						--"item_power_treads",
						"item_boots",
						"item_wind_lace",
						"item_broadsword",
						"item_broadsword",
						"item_broadsword",
						"item_broadsword"
					},
					StartingAbilities =
					{
						"sven_storm_bolt",
						"sven_storm_bolt",
						"sven_warcry",
					},
				},
			},
		}, self, true )

	elseif Task:GetTaskName() == "move_to_location_2" then
		self.hSvenSpawner = CDotaSpawner( "sven_spawner_2", 
		{
			{
				EntityName = "npc_dota_hero_sven",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "The Rogue Knight",
					EntityScript = "ai/support_survival/ai_sven.lua",
					StartingHeroLevel = 8,
					StartingItems = 
					{
						"item_power_treads",
						"item_echo_sabre",
					},
					StartingAbilities =
					{
					},
				},
			},
		}, self, true )

	elseif Task:GetTaskName() == "move_to_location_3" then
		self.hSvenSpawner = CDotaSpawner( "sven_spawner_3", 
		{
			{
				EntityName = "npc_dota_hero_sven",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					PlayerID = 1,
					BotName = "The Rogue Knight",
					EntityScript = "ai/support_survival/ai_sven.lua",
					StartingHeroLevel = 16,
					StartingItems = 
					{
						"item_power_treads",
						"item_echo_sabre",
						"item_black_king_bar",
						"item_greater_crit",
					},
					StartingAbilities =
					{
					},
				},
			},
		}, self, true )
	end

end

--------------------------------------------------------------------

function CDotaNPXScenario_SupportSurvival:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	
	if Task:GetTaskName() == "buy_glimmer_cape" then
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
		local nCost = tonumber( GetCostOfItem( "item_glimmer_cape" ) )
		print( 'Cost of item_glimmer_cape = ' .. nCost )
		hPlayerHero:SetGold( nCost, true ) 

	elseif Task:GetTaskName() == "buy_force_staff" then
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
		local nCost = tonumber( GetCostOfItem( "item_force_staff" ) )
		print( 'Cost of item_force_staff = ' .. nCost )
		hPlayerHero:SetGold( nCost, true )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_SupportSurvival:OnThink()
	CDotaNPXScenario.OnThink( self )
end

--------------------------------------------------------------------

return CDotaNPXScenario_SupportSurvival