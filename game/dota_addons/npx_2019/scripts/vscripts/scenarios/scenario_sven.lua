require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_parallel" )
require( "tasks/task_kill_units" )
require( "tasks/task_chase_units" )
require( "tasks/task_move_to_trigger" )
require( "tasks/task_pickup_rune" )
require( "tasks/task_buy_item" )
--------------------------------------------------------------------

if CDotaNPXScenario_Sven == nil then
	CDotaNPXScenario_Sven = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Sven:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_sven",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingItems 		=
		{
		},
		StartingAbilities	= 
		{
			"sven_storm_bolt",
		}, 
		ScenarioTimeLimit = 0, -- Not timed.

		Spawners =
		{
		{
				SpawnerName = "creeps_spawn_0",
				SpawnOnPrecacheComplete = true,
				NPCs = 
				{
					{
						EntityName = "npc_dota_creature_cowardly_gnoll",
						Team = DOTA_TEAM_BADGUYS,
						Count = 3,
						PositionNoise = 225.0,
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseMaxHealth( 30 )
							hNPC:SetMaxHealth( 30 )
						end,
						
					},
				},
			},
			{
				SpawnerName = "creeps_spawn_1",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_creature_cowardly_gnoll",
						Team = DOTA_TEAM_BADGUYS,
						Count = 2,
						PositionNoise = 0.0,
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseMaxHealth( 30 )
							hNPC:SetMaxHealth( 30 )
						end,
						
					},
				},
			},
			{
				SpawnerName = "centaur_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_big_centaur",
						Team = DOTA_TEAM_GOODGUYS,
						Count = 1,
					},
				},
			},
			{
				SpawnerName = "small_creep_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_creature_cowardly_gnoll",
						Team = DOTA_TEAM_BADGUYS,
						Count = 4,
						PositionNoise = 225.0,
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseMaxHealth( 180 )
							hNPC:SetMaxHealth( 180 )
							hNPC:SetHealth( 180 )
							hNPC:SetBaseDamageMin(55)
							hNPC:SetBaseDamageMax(55)
						end,
					},
					{
						EntityName = "npc_dota_creature_pinata_gnoll",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						PositionNoise = 225.0,
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseMaxHealth( 200 )
							hNPC:SetMaxHealth( 200 )
							hNPC:SetHealth( 200 )
							hNPC:SetBaseDamageMin(55)
							hNPC:SetBaseDamageMax(55)
						end,
					},
				},
			},
			{
				SpawnerName = "big_creep_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_creature_cowardly_gnoll",
						Team = DOTA_TEAM_BADGUYS,
						Count = 15,
						PositionNoise = 225.0,
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseMaxHealth( 120 )
							hNPC:SetMaxHealth( 120 )
							hNPC:SetHealth( 120 )
							hNPC:SetBaseDamageMin(20)
							hNPC:SetBaseDamageMax(25)
						end,
					},
				},
			},
			{
				SpawnerName = "sf_spawn_location",
				SpawnOnPrecacheComplete = true,
				NPCs = 
				{
					{
						EntityName = "npc_dota_hero_nevermore",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						PositionNoise = 0,
						BotPlayer =
						{
							BotName = "Yaphets",
							EntityScript = "ai/sven/ai_shadow_fiend.lua",
							StartingHeroLevel = 6,
							StartingItems = 
							{	
								"item_travel_boots",
								"item_wraith_band"
							},
							AbilityBuild = 
							{
								AbilityPriority = { 
								"nevermore_requiem",
								"nevermore_necromastery"
								},
							},
						},
					},
				},
			},
		},

		Queries =
		{
		},
	}
	self.bShouldUpdateHints = true
end


function CDotaNPXScenario_Sven:SetupTasks()
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end
	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root"
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	local FIRST_TASK_START_DELAY = 2
	local FightIntroCreeps = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_creeps_first",
		TaskType = "task_kill_units",
		TaskParams = 
		{
			RequiredKills = 3,
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ), FIRST_TASK_START_DELAY )

	

	local ChaseIntroCreeps = rootTask:AddTask( CDotaNPXTask_ChaseUnits( {
		TaskName = "chase_creeps",
		TaskType = "task_chase_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "kill_creeps_first" )
		end,
	}, self ), 0.02 )

	local DodgeTower = rootTask:AddTask( CDotaNPXTask_MoveToTrigger( {
		TaskName = "cross_the_road",
		TaskType = "task_move_to_trigger",
		TaskParams =
		{
			TriggerName = "cross_the_road",
		},
		UseHints = false,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "chase_creeps" )
		end,
	}, self ), 3 )

	local FightMoreCreeps = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_more_creeps",
		TaskType = "task_kill_units",
		TaskParams = 
		{
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "cross_the_road" )
		end,
	}, self ), 0.5 )

	local FightALotOfCreeps = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_a_lot_of_creeps",
		TaskType = "task_kill_units",
		TaskParams = 
		{
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "kill_more_creeps" )
		end,
	}, self ), 0.5 )

	local FreshenUp = rootTask:AddTask( CDotaNPXTask_Parallel( {
		TaskName = "freshen_up",		
		}, self ), 0.5 )
	
	local PickRune =  FreshenUp:AddTask(CDotaNPXTask_PickupRune( {
		TaskName = "pickup_rune",
		TaskType = "task_pickup_rune",
		TaskParams =
		{
		},
		UseHints = false,
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ))
	
	local BuyItem =  FreshenUp:AddTask(CDotaNPXTask_BuyItem( {
		TaskName = "buy_item",
		TaskType = "task_buy_item",
		TaskParams =
		{
			Items = 
			{
				"item_mekansm",
				"item_blade_mail",
			},
			ItemAmount = 1
		},
		UseHints = false,
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ))
	
	return true
end
--------------------------------------------------------------------

function CDotaNPXScenario_Sven:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

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
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_SHOP_COMMONITEMS, false )
	
end


--------------------------------------------------------------------

function CDotaNPXScenario_Sven:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	self.nTaskCounter = 1
	if Task:GetTaskName() == "kill_creeps_first" then
		self.hPlayerHero:SetBaseManaRegen(-0.8)
		self:ShowHint( "narration_sven1_" .. self.nTaskCounter)		
	end
	if Task:GetTaskName() == "chase_creeps" then		
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_PANEL, true )		
	end

	if Task:GetTaskName() == "cross_the_road" then
		
	end
	if Task:GetTaskName() == "pickup_rune" then
		CreateRune(Vector( 1658, 768, 164 ), DOTA_RUNE_REGENERATION )
	end
	
end

--------------------------------------------------------------------

function CDotaNPXScenario_Sven:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "kill_creeps_first" then
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_PANEL, true )
		local Spawner = self:GetSpawner("creeps_spawn_1")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		end
		Spawner:SpawnUnits()
	end
	
	if Task:GetTaskName() == "chase_creeps" then
		self:ShowHint( "narration_sven2_" .. self.nTaskCounter)		
		local Spawner = self:GetSpawner("centaur_spawn")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		end
		Spawner:SpawnUnits()
	end

	if Task:GetTaskName() == "cross_the_road" then
		local Spawner = self:GetSpawner("small_creep_spawn")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		end
		Spawner:SpawnUnits()
	end

	if Task:GetTaskName() == "kill_more_creeps" then
		local Spawner = self:GetSpawner("big_creep_spawn")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		end
		Spawner:SpawnUnits()		
		self:ShowHint( "narration_sven4" )		
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_PANEL, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_ITEMS, true )
	end

	if Task:GetTaskName() == "kill_a_lot_of_creeps" then
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_GOLD, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_SHOP, true )
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, true )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Sven:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )
	
	local Spawner = self:GetSpawner( event.spawner_name )
	if Spawner == nil then
		return
	end

	if event.spawner_name == "creeps_spawn_0" then
		local Task = self:GetTask( "kill_creeps_first" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end

	

	if event.spawner_name == "creeps_spawn_1" then
		local Task = self:GetTask( "chase_creeps" )
		if Task then
			Task:SetUnitsToChase( Spawner:GetSpawnedUnits() )
		end
	end

	if event.spawner_name == "small_creep_spawn" then
		local Task = self:GetTask( "kill_more_creeps" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end

	if event.spawner_name == "big_creep_spawn" then
		local Task = self:GetTask( "kill_a_lot_of_creeps" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end

end
----------------------------------------------------------------------------

function CDotaNPXScenario_Sven:OnTakeDamage( hVictim, hKiller, hInflictor )	
	local Task = self:GetTask( "cross_the_road" )
	if Task and not Task:IsCompleted() then
		if hVictim:GetUnitName() == "npc_dota_big_centaur" then 
			self.nTaskCounter = self.nTaskCounter + 1
			self:ShowHint( "narration_sven2_" .. self.nTaskCounter)
		end
		return
	end

	local TaskMore = self:GetTask( "kill_more_creeps" )
	if TaskMore and not TaskMore:IsCompleted() then
		if hVictim:GetUnitName() == "npc_dota_hero_sven" and self.bStunned == nil then 
			if hVictim:GetHealthPercent() > 40 then
				self:ShowHint("narration_sven3_gnolls_1")
			else
				self:ShowHint("narration_sven3_gnolls_2")
			end
		end
		if hInflictor and hInflictor:GetAbilityName() == "sven_storm_bolt" then
			self.bStunned = true
			self:ShowHint("narration_sven3_gnolls_stun")
		end
	end
end
----------------------------------------------------------------------------
function CDotaNPXScenario_Sven:OnEntityKilled( hVictim, hKiller, hInflictor )
	if hVictim:GetUnitName() == "npc_dota_creature_pinata_gnoll" then
		local newItem = CreateItem( "item_flask", nil, nil )
		local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
		newItem:LaunchLoot( false, 300, 0.75, hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 50, 100 ) ) )
	end	

	if hVictim:GetUnitName() == "npc_dota_big_centaur" then
		self:ShowHint("narration_sven2_centaur_dead")
	end	

	if hVictim:GetUnitName() == "npc_dota_hero_sven" then
		if hKiller:GetUnitName() == "npc_dota_badguys_tower1_shot" then
			self:ShowHint("narration_sven_death_tower")
		else
			self:ShowHint("narration_sven_death_gnoll")
		end
		self.bShouldUpdateHints = false
	end	

	local Task = self:GetTask( "kill_creeps_first" )
	if Task and not Task:IsCompleted() then
		self.nTaskCounter = self.nTaskCounter + 1
		self:ShowHint("narration_sven1_" .. self.nTaskCounter)
	end

end

--------------------------------------------------------------------
function CDotaNPXScenario_Sven:HideHint()
	CustomGameEventManager:Send_ServerToAllClients( "hide_hint", {} )
end

--------------------------------------------------------------------
function CDotaNPXScenario_Sven:ShowHint( strText )
	if self.bShouldUpdateHints then
		CustomGameEventManager:Send_ServerToAllClients( "display_hint", { hint_text =strText, duration = 0 } )
	end
end
--------------------------------------------------------------------
return CDotaNPXScenario_Sven