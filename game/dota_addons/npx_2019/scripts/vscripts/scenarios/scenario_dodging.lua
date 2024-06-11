
require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_parallel" )
require( "tasks/task_disjoint_spell" )
require( "tasks/task_move_to_location" )
require( "tasks/task_fail_player_hero_take_damage" )


--------------------------------------------------------------------------------

if CDotaNPXScenario_Dodging == nil then
	CDotaNPXScenario_Dodging = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:InitScenarioKeys()
	
	self.hInitialPlayerMoveLoc = Entities:FindByName( nil, "initial_player_move_loc" )
	self.hEscapeLoc = Entities:FindByName( nil, "escape_location" )
	self.DodgeArrowTimeStart = GameRules:GetGameTime() + 600
	self.DodgeArrowTime = 9.5
	ScriptAssert( self.hInitialPlayerMoveLoc ~= nil, "Could not find entity named initial_player_move_loc!" )

	self.hScenario =
	{
		DaynightCycleDisabled = true,
		bLetGoldThrough		= false,
		bLetXPThrough		= false,
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_windrunner",
		StartingHeroLevel	= 1,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_boots"
		},
		StartingAbilities =
		{

		},
		
		ScenarioTimeLimit = 600.0,


		Tasks = 
		{
			
--[[
			{
				TaskName = "do_not_take_damage",
				TaskType = "task_fail_player_hero_take_damage",
				UseHints = false,
				Hidden = true,

				TaskParams =
				{
					Count = 1
				},
				CheckTaskStart = 
				function() 
					return true
				end,
			},
]]
			{
				TaskName = "move_to_location_1",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hInitialPlayerMoveLoc:GetAbsOrigin(),
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
			},
--[[
			{
				TaskName = "dodge_all_arrows",
				TaskType = "task_fail_player_hero_take_damage",
				UseHints = true,
				TaskParams =
				{
					Count = 1
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
]]
			
			{
				TaskName = "dodge_all_arrows",
				TaskType = "task_delay",
				UseHints = true,
				TaskParams =
				{
					Delay = 9999.0
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
					GoalLocation = self.hInitialPlayerMoveLoc:GetAbsOrigin(),
					GoalDistance = 64,
				},
				CheckTaskStart = 
				function() 
					return GameRules:GetGameTime() >= self.DodgeArrowTimeStart + self.DodgeArrowTime and GameRules.DotaNPX:IsTaskComplete( "task_fail_player_hero_take_damage" ) == false
				end,
			},

			{
				TaskName = "dodge_all_missiles_1",
				TaskType = "task_disjoint_spell",
				UseHints = true,
				TaskParams =
				{
					TimesToComplete = 3
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_2" )
				end,
			},

			{
				TaskName = "move_to_location_3",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hInitialPlayerMoveLoc:GetAbsOrigin(),
					GoalDistance = 64,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "dodge_all_missiles_1" )
				end,
			}, 

			{
				TaskName = "dodge_all_missiles_2",
				TaskType = "task_disjoint_spell",
				UseHints = true,
				TaskParams =
				{
					TimesToComplete = 3
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_3" )
				end,
			},

			{
				TaskName = "outro_delay",
				TaskType = "task_delay",
				UseHints = true,
				TaskParams =
				{
					Delay = 2.0
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "dodge_all_missiles_2" )
				end,
			},
		},

		Queries =
		{
		},
	}
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_QUICK_STATS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_KILLCAM, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_BAR, false )



	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Dodging, "OnTriggerStartTouch" ), self)
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:OnTriggerStartTouch( event )
	printf( "OnTriggerStartTouch" )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero and event.trigger_name == "start_trigger" and event.activator_entindex == hPlayerHero:GetEntityIndex() then

	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	self.hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	self.hPlayerHero:SetAbilityPoints( 0 )
		--[[


	-- Level up Puck's abilities
		local hAbility = self.hPlayerHero:FindAbilityByName( "puck_phase_shift" )
		ScriptAssert( hAbility ~= nil, "Ability named %s is nil, could not upgrade it!", hAbility:GetAbilityName() )
		if hAbility ~= nil then
			self.hPlayerHero:UpgradeAbility( hAbility )
		end
		]]
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "task_fail_player_hero_take_damage" then
		self:OnScenarioComplete(false)
	end

	if Task:GetTaskName() == "move_to_location_1" then
		self.DodgeArrowTimeStart = GameRules:GetGameTime()

		self.EnemySpawner = CDotaSpawner( "enemy_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_mirana",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Mirana",
						EntityScript = "ai/dodging/ai_dodging_mirana.lua",
						StartingHeroLevel = 3,
						StartingItems = 
						{
							"item_boots",
						},
						StartingAbilities	= 
						{
							"mirana_arrow",
							"mirana_leap",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "mirana_arrow" },
						},
					},
				},
			}, self, true )

	end
	if Task:GetTaskName() == "dodge_all_arrows" then
		local hPlayerHero = self:GetPlayerHero()
		RefreshHero( hPlayerHero )
		hPlayerHero:AddItemByName("item_blink")
	end

	if Task:GetTaskName() == "dodge_all_missiles_1" then
		local hPlayerHero = self:GetPlayerHero()
		RefreshHero( hPlayerHero )
		hPlayerHero:AddItemByName("item_manta")
		hPlayerHero:AddItemByName("item_cyclone")
	end



	if Task:GetTaskName() == "outro_delay" then
		self:OnScenarioComplete(true)
	end


	if Task:GetTaskName() == "move_to_location_2" then
			self.EnemySpawner = CDotaSpawner( "enemy_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_tinker",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Tinker",
						EntityScript = "ai/dodging/ai_dodging_tinker.lua",
						StartingHeroLevel = 6,
						StartingItems = 
						{
							"item_aether_lens",
							"item_aghanims_shard",
						},
						StartingAbilities	= 
						{
							"tinker_rearm",
							"tinker_heat_seeking_missiles",
							"tinker_warp_grenade",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "tinker_warp_grenade" },
						},
					},
				},
			}, self, true )

	end		

	if Task:GetTaskName() == "move_to_location_3" then
			self.EnemySpawner = CDotaSpawner( "enemy_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_tinker",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Tinker",
						EntityScript = "ai/dodging/ai_dodging_tinker_pt2.lua",
						StartingHeroLevel = 6,
						StartingItems = 
						{
							"item_aether_lens",
							"item_aghanims_shard",
						},
						StartingAbilities	= 
						{
							"tinker_rearm",
							"tinker_heat_seeking_missiles",
							"tinker_warp_grenade",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "tinker_warp_grenade" },
						},
					},
				},
			}, self, true )
		end
end	

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:Restart()
	CDotaNPXScenario.Restart( self )
	self.DodgeArrowTimeStart = GameRules:GetGameTime() + 600
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	
	if Task:GetTaskName() == "move_to_location_1" then
		self:ShowWizardTip( "scenario_dodging_wizard_tip_intro", 10.0 )
	end
	
	if Task:GetTaskName() == "dodge_all_arrows" then
		self:ShowWizardTip( "scenario_dodging_wizard_tip_dodge_all_arrows", 10.0 )
	end

	
	if Task:GetTaskName() == "move_to_location_2" then
		self:ShowWizardTip( "scenario_dodging_wizard_tip_move_to_location_2", 10.0 )
	end

	if Task:GetTaskName() == "dodge_all_missiles_1" then
		self:ShowWizardTip( "scenario_dodging_wizard_tip_dodge_all_missiles_1", 10.0 )
	end

	if Task:GetTaskName() == "move_to_location_3" then
		self:ShowWizardTip( "scenario_dodging_wizard_tip_move_to_location_3", 10.0 )
	end

	if Task:GetTaskName() == "dodge_all_missiles_2" then
		self:ShowWizardTip( "scenario_dodging_wizard_tip_dodge_all_missiles_2", 10.0 )
	end

	if Task:GetTaskName() == "dodge_all_bolts" then
		self:ShowWizardTip( "scenario_dodging_wizard_tip_dodge_all_bolts", 10.0 )
	end

end


--------------------------------------------------------------------------------

function CDotaNPXScenario_Dodging:OnThink()
	CDotaNPXScenario.OnThink( self )
	if GameRules:GetGameTime() >= self.DodgeArrowTimeStart + self.DodgeArrowTime and GameRules.DotaNPX:IsTaskComplete( "dodge_all_arrows" ) == false then
		self:CheckpointSkipCompleteTask( "dodge_all_arrows", true, false )
	end


	local hPlayerHero = self:GetPlayerHero()
	if hPlayerHero and hPlayerHero:GetHealth() < hPlayerHero:GetMaxHealth() then 

		RefreshHero( hPlayerHero )
		hPlayerHero:RemoveModifierByName("modifier_stunned")
		hPlayerHero:RemoveModifierByName("modifier_invulnerable")
		hPlayerHero:SetHealth(hPlayerHero:GetMaxHealth())

		if GameRules.DotaNPX:IsTaskComplete( "dodge_all_missiles_1" ) then 
			self:ShowWizardTip( "scenario_euls_setup_wizard_tip_dodge_all_missiles_2_hit", 5.0 )
			local Task = self:GetTask("dodge_all_missiles_2")
			if Task then
				Task:ResetProgress()
			end

		elseif GameRules.DotaNPX:IsTaskComplete( "dodge_all_arrows" ) then
			
			self:ShowWizardTip( "scenario_euls_setup_wizard_tip_dodge_all_missiles_1_hit", 5.0 )
			local Task = self:GetTask("dodge_all_missiles_1")
			if Task then
				Task:ResetProgress()
			end

		elseif GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" ) then
			self:ShowWizardTip( "scenario_euls_setup_wizard_tip_dodge_all_arrows_hit", 5.0 )
			self.DodgeArrowTimeStart = GameRules:GetGameTime()

		end
	end

end



return CDotaNPXScenario_Dodging
