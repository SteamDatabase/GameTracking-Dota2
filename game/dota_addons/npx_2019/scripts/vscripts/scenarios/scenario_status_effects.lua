
require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_parallel" )
require( "tasks/task_modifier_removed_from_enemy" )
require( "tasks/task_kill_units" )


--------------------------------------------------------------------------------

if CDotaNPXScenario_Status_Effects == nil then
	CDotaNPXScenario_Status_Effects = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:InitScenarioKeys()
	
	self.hInitialPlayerMoveLoc = Entities:FindByName( nil, "initial_player_move_loc" )
	ScriptAssert( self.hInitialPlayerMoveLoc ~= nil, "Could not find entity named initial_player_move_loc!" )

	self.hScenario =
	{
		DaynightCycleDisabled = true,
		bLetGoldThrough		= false,
		bLetXPThrough		= false,
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_ogre_magi",
		StartingHeroLevel	= 1,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,

		StartingItems 		=
		{
		
		},
		StartingAbilities =
		{

		},
		
		ScenarioTimeLimit = 0.0,


		Tasks = 
		{
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
				TaskName = "stun_enemy_hero",
				TaskType = "task_modifier_removed_from_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_bashed",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
			]]
			{
				TaskName = "stun_enemy_hero",
				TaskType = "task_kill_units",
				--Hidden = true,
				TaskParams = 
				{
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
					return GameRules.DotaNPX:IsTaskComplete( "stun_enemy_hero" )
				end,
			},
--[[
			{
				TaskName = "silence_enemy_hero",
				TaskType = "task_modifier_removed_from_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_orchid_malevolence_debuff",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_2" )
				end,
			},
]]
			{
				TaskName = "silence_enemy_hero",
				TaskType = "task_kill_units",
				--Hidden = true,
				TaskParams = 
				{
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
					return GameRules.DotaNPX:IsTaskComplete( "silence_enemy_hero" )
				end,
			},
--[[			
			{
				TaskName = "root_enemy_hero",
				TaskType = "task_modifier_removed_from_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_rod_of_atos_debuff",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_3" )
				end,
			},
]]

			{
				TaskName = "root_enemy_hero",
				TaskType = "task_kill_units",
				--Hidden = true,
				TaskParams = 
				{
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_3" )
				end,
			},

			{
				TaskName = "move_to_location_4",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hInitialPlayerMoveLoc:GetAbsOrigin(),
					GoalDistance = 64,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "root_enemy_hero" )
				end,
			},

			{
				TaskName = "disarm_enemy_hero",
				TaskType = "task_kill_units",
				--Hidden = true,
				TaskParams = 
				{
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_4" )
				end,
			},
			--[[
			{
				TaskName = "disarm_enemy_hero",
				TaskType = "task_modifier_removed_from_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_heavens_halberd_debuff",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_4" )
				end,
			},
			]]
--[[
			{
				TaskName = "break_enemy_hero",
				TaskType = "task_modifier_removed_from_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_silver_edge_debuff",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "disarm_enemy_hero" )
				end,
			}, 
]]--
		},

		Queries =
		{
		},
	}
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_QUICK_STATS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_KILLCAM, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_BAR, false )



	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Status_Effects, "OnTriggerStartTouch" ), self)
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:OnTriggerStartTouch( event )
	printf( "OnTriggerStartTouch" )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero and event.trigger_name == "start_trigger" and event.activator_entindex == hPlayerHero:GetEntityIndex() then

	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	self.hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )

	self.hPlayerHero:SetAbilityPoints( 0 )

	---- Level up Puck's abilities
	--	local hAbility = self.hPlayerHero:FindAbilityByName( "ogre_magi_bloodlust" )
	--	ScriptAssert( hAbility ~= nil, "Ability named %s is nil, could not upgrade it!", hAbility:GetAbilityName() )
	--	if hAbility ~= nil then
	--		self.hPlayerHero:UpgradeAbility( hAbility )
	--	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_to_location_1" then

		self:GetPlayerHero():AddItemByName("item_abyssal_blade")

		self.EnemySpawner = CDotaSpawner( "enemy_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_shadow_shaman",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Shadow Shaman",
						EntityScript = "ai/status_effects/ai_status_effects_shadow_shaman.lua",
						StartingHeroLevel = 5,
						StartingItems = 
						{
							"item_boots",
						},
						StartingAbilities	= 
						{
							"shadow_shaman_shackles",
							"shadow_shaman_voodoo",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "shadow_shaman_shackles" },
						},
					},
				},
			}, self, true )

		self.AllySpawner = CDotaSpawner( "ally_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_lina",
					Team = DOTA_TEAM_GOODGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Lina",
						EntityScript = "ai/status_effects/ai_status_effects_lina",
						StartingHeroLevel = 14,
						StartingItems = 
						{
							"item_boots",
							"item_ultimate_scepter",
						},
						StartingAbilities	= 
						{
							"lina_light_strike_array",
							"lina_dragon_slave",
							"lina_laguna_blade",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "lina_laguna_blade" },
						},
					},
				},
			}, self, true )

	elseif Task:GetTaskName() == "move_to_location_2" then
		local hAbyssalBlade = self:GetPlayerHero():FindItemInInventory("item_abyssal_blade")
		if hAbyssalBlade ~= nil then
			self:GetPlayerHero():RemoveItem(hAbyssalBlade)
		end
		self:GetPlayerHero():AddItemByName("item_orchid")

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
						EntityScript = "ai/status_effects/ai_status_effects_tinker.lua",
						StartingHeroLevel = 12,
						StartingItems = 
						{
							"item_travel_boots",
							"item_kaya",
						},
						StartingAbilities	= 
						{
							"tinker_laser",
							"tinker_rearm",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "tinker_laser" },
						},
					},
				},
			}, self, true )

		self.AllySpawner = CDotaSpawner( "ally_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_drow_ranger",
					Team = DOTA_TEAM_GOODGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Drow Ranger",
						EntityScript = "ai/status_effects/ai_status_effects_drow",
						StartingHeroLevel = 14,
						StartingItems = 
						{
							"item_power_treads",
							"item_butterfly",
							"item_greater_crit",
							"item_heart",
						},
						StartingAbilities	= 
						{
						--	"drow_frost_arrows",
						}, 
						AbilityBuild = 
						{
						--	AbilityPriority = { "drow_frost_arrows" },
						},
					},
				},
			}, self, true )
	elseif Task:GetTaskName() == "move_to_location_3" then
		local hOrchid = self:GetPlayerHero():FindItemInInventory("item_orchid")
		if hOrchid ~= nil then
			self:GetPlayerHero():RemoveItem(hOrchid)
		end
		self:GetPlayerHero():AddItemByName("item_rod_of_atos")

		self.EnemySpawner = CDotaSpawner( "enemy_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_dark_seer",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Dark Seer",
						EntityScript = "ai/status_effects/ai_status_effects_dark_seer.lua",
						StartingHeroLevel = 6,
						StartingItems = 
						{
							"item_boots",
							"item_hood_of_defiance",
						},
						StartingAbilities	= 
						{
							"dark_seer_surge",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "dark_seer_surge" },
						},
					},
				},
			}, self, true )

		self.AllySpawner = CDotaSpawner( "ally_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_sven",
					Team = DOTA_TEAM_GOODGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Sven",
						EntityScript = "ai/status_effects/ai_status_effects_sven",
						StartingHeroLevel = 14,
						StartingItems = 
						{
							"item_boots",
							"item_sange",
							"item_heart",
						},
						StartingAbilities	= 
						{
						}, 
						AbilityBuild = 
						{
						},
					},
				},
			}, self, true )

	elseif Task:GetTaskName() == "move_to_location_4" then
		local hOrchid = self:GetPlayerHero():FindItemInInventory("item_rod_of_atos")
		if hOrchid ~= nil then
			self:GetPlayerHero():RemoveItem(hOrchid)
		end
		self:GetPlayerHero():AddItemByName("item_heavens_halberd")

		self.EnemySpawner = CDotaSpawner( "enemy_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_troll_warlord",
					Team = DOTA_TEAM_BADGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Troll Warlord",
						EntityScript = "ai/status_effects/ai_status_effects_troll.lua",
						StartingHeroLevel = 5,
						StartingItems = 
						{
							"item_boots",
							"item_basher",
							"item_moon_shard",
						},
						StartingAbilities	= 
						{
							"troll_warlord_fervor",
							"troll_warlord_berserkers_rage",
						}, 
						AbilityBuild = 
						{
							AbilityPriority = { "troll_warlord_fervor" },
						},
					},
				},
			}, self, true )

		self.AllySpawner = CDotaSpawner( "ally_spawn_location",
			{
				{
					EntityName = "npc_dota_hero_storm_spirit",
					Team = DOTA_TEAM_GOODGUYS,
					Count = 1,
					PositionNoise = 0,
					BotPlayer =
					{
						BotName = "Storm SPirit",
						EntityScript = "ai/status_effects/ai_status_effects_storm_spirit",
						StartingHeroLevel = 14,
						StartingItems = 
						{
							"item_power_treads",
							"item_yasha_and_kaya",
							"item_bloodstone",
						},
						StartingAbilities	= 
						{
							"storm_spirit_electric_vortex",
							"storm_spirit_overload",
							"storm_spirit_static_remnant",
							"storm_spirit_ball_lightning",

						}, 
						AbilityBuild = 
						{
						--	AbilityPriority = { "drow_frost_arrows" },
						},
					},
				},
			}, self, true )		
	elseif Task:GetTaskName() == "disarm_enemy_hero" then
		self:OnScenarioComplete(true)
	end
end	

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:Restart()
	CDotaNPXScenario.Restart( self )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	
	if Task:GetTaskName() == "move_to_location_1" then
		self:ShowWizardTip( "scenario_status_effects_wizard_tip_intro", 10.0 )
	end
	
	if Task:GetTaskName() == "stun_enemy_hero" then
		self:ShowWizardTip( "scenario_status_effects_wizard_tip_stun_enemy_hero", 10.0 )
	end

	if Task:GetTaskName() == "silence_enemy_hero" then
		self:ShowWizardTip( "scenario_status_effects_wizard_tip_silence_enemy_hero", 10.0 )
	end

	if Task:GetTaskName() == "root_enemy_hero" then
		self:ShowWizardTip( "scenario_status_effects_wizard_tip_root_enemy_hero", 10.0 )
	end

	if Task:GetTaskName() == "disarm_enemy_hero" then
		self:ShowWizardTip( "scenario_status_effects_wizard_tip_disarm_enemy_hero", 10.0 )
	end

end
--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:OnNPCSpawned( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	

	if hEnt ~= nil and hEnt:IsNull() == false then
		if hEnt:GetUnitName() == "npc_dota_hero_troll_warlord" then
			local Task = self:GetTask( "disarm_enemy_hero" )
			if Task then
				printf( "found task kill_troll, doing SetUnitsToKill" )
				local hUnitsToKill = {}
				table.insert( hUnitsToKill, hEnt )
				Task:SetUnitsToKill( hUnitsToKill )
			end
		elseif hEnt:GetUnitName() == "npc_dota_hero_dark_seer" then
			local Task = self:GetTask( "root_enemy_hero" )
			if Task then
				printf( "found task kill_dark_seer, doing SetUnitsToKill" )
				local hUnitsToKill = {}
				table.insert( hUnitsToKill, hEnt )
				Task:SetUnitsToKill( hUnitsToKill )
			end
		elseif hEnt:GetUnitName() == "npc_dota_hero_tinker" then
			local Task = self:GetTask( "silence_enemy_hero" )
			if Task then
				local hUnitsToKill = {}
				table.insert( hUnitsToKill, hEnt )
				Task:SetUnitsToKill( hUnitsToKill )
			end
		elseif hEnt:GetUnitName() == "npc_dota_hero_shadow_shaman" then
			local Task = self:GetTask( "stun_enemy_hero" )
			if Task then
				printf( "found task kill_shaman, doing SetUnitsToKill" )
				local hUnitsToKill = {}
				table.insert( hUnitsToKill, hEnt )
				Task:SetUnitsToKill( hUnitsToKill )
			end
		end
	end

end

--------------------------------------------------------------------------------

function CDotaNPXScenario_Status_Effects:OnThink()
	CDotaNPXScenario.OnThink( self )
end



return CDotaNPXScenario_Status_Effects
