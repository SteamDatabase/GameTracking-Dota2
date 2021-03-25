require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_parallel" )
require( "tasks/task_kill_units" )
require( "tasks/task_chase_units" )
require( "tasks/task_move_to_trigger" )
require( "tasks/task_move_to_location" )
require( "tasks/task_learn_ability" )
require( "tasks/task_pickup_rune" )
require( "tasks/task_buy_item" )

--------------------------------------------------------------------

if CDotaNPXScenario1 == nil then
	CDotaNPXScenario1 = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario1:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_sniper",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
		},
		StartingAbilities	= 
		{
			"sniper_take_aim",
		}, 
		ScenarioTimeLimit = 0, -- Not timed.

		Spawners =
		{
		{
				SpawnerName = "first_creep_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_creature_scenario1_gnoll",
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
				SpawnerName = "second_creep_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_slow_centaur",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						PositionNoise = 0.0,						
						
					},
				},
			},
			{
				SpawnerName = "third_creep_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_lycan_wolf4",
						Team = DOTA_TEAM_BADGUYS,
						Count = 3,
						PositionNoise = 50.0,						
					},
				},
			},
			{
				SpawnerName = "boss_spawn",
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
			{
				SpawnerName = "mirana_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_hero_mirana",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						PositionNoise = 0,
						BotPlayer =
						{
							BotName = "Mirana",
							EntityScript = "ai/scenario1/ai_mirana.lua",
							StartingHeroLevel = 6,
							StartingItems = 
							{	
								"item_travel_boots",
								"item_witless_shako",
								"item_vitality_booster",
								"item_void_stone",
								"item_void_stone",
								"item_void_stone",
							},
							AbilityBuild = 
							{
								AbilityPriority = { 
								"mirana_arrow",
								"mirana_arrow",
								"mirana_arrow",
								},
							},
						},
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseDamageMin( -20 )
							hNPC:SetBaseDamageMax( -20 )
							
						end,
					},
				},
			},
			{
				SpawnerName = "underlord_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_hero_abyssal_underlord",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						PositionNoise = 0,
						BotPlayer =
						{
							BotName = "Underlord",
							EntityScript = "ai/scenario1/ai_underlord.lua",
							StartingHeroLevel = 5,							
							AbilityBuild = 
							{
								AbilityPriority = { 
								"abyssal_underlord_firestorm",
								"abyssal_underlord_firestorm",
								"abyssal_underlord_firestorm",
								},
							},
							StartingItems = 
							{	
								"item_travel_boots",
								"item_witless_shako",
							}
						},
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseDamageMin( -20 )
							hNPC:SetBaseDamageMax( -20 )							
						end,
					},
				},			
			},	
			{
				SpawnerName = "beastmaster_spawner",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_hero_beastmaster",
						Team = DOTA_TEAM_GOODGUYS,
						Count = 1,
						PositionNoise = 0,
						BotPlayer =
						{
							BotName = "Yaphets",
							EntityScript = "ai/scenario1/ai_bm_open_door.lua",
							StartingHeroLevel = 5,							
							AbilityBuild = 
							{
								AbilityPriority = { 
								"beastmaster_wild_axes",
								},
							},
						},
					},
				},			
			},
			{
				SpawnerName = "broodbabies_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_broodmother_spiderling_weak",
						Team = DOTA_TEAM_BADGUYS,
						Count = 10,
						PositionNoise = 500,

					},
				},
			},
			{
				SpawnerName = "broodmother_spawn",
				SpawnOnPrecacheComplete = false,
				NPCs = 
				{
					{
						EntityName = "npc_dota_hero_broodmother",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						PositionNoise = 0,
						BotPlayer =
						{
							BotName = "Broodmother",
							EntityScript = "ai/scenario1/ai_broodmother.lua",
							StartingHeroLevel = 5,
							AbilityBuild = 
							{
								AbilityPriority	= 
								{
									"broodmother_incapacitating_bite",
									"broodmother_incapacitating_bite",
									"broodmother_incapacitating_bite"
								}, 
							},
						},
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseDamageMin( 0 )
							hNPC:SetBaseDamageMax( 0 )								
						end,
					},
				},			
			},	
		},
	}
	self.bShouldUpdateHints = true
	ListenToGameEvent( "spawn_spiderling", Dynamic_Wrap(CDotaNPXScenario1, 'OnSpawnSpiderlings'), self )

end

function CDotaNPXScenario1:OnSpawnSpiderlings()
	local hBabies = Entities:FindAllByClassname( "npc_dota_broodmother_spiderling")
	print ( #hBabies .. " babies")
	if #hBabies >= 50 then
		return
	end
	local Spawner = self:GetSpawner("broodbabies_spawn")
	Spawner:SpawnUnits()
end

function CDotaNPXScenario1:SetupTasks()
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

	-- Ok, task order:
	-- 12) Assassinate the final boss from afar, win scenario
	local FIRST_TASK_START_DELAY = 2
	-- 1) Go look at the bad boss that you'll be beating in the end. He deals infinite right click damage
	local SeeTheBoss = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "see_the_boss",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = Vector( 1409, -1344, 292 ),
			GoalDistance = 64,
		},
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ), FIRST_TASK_START_DELAY )
	

	-- 2) Fight gnolls to leran how to autoattack things	
	local KillGnolls = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_gnolls",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "see_the_boss" )
		end,
	}, self ), 0.02 )
	-- 3) Fight centaurs (which you need to kite)
	local KillCentaurs = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_centaur",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "kill_gnolls" )
		end,
	}, self ), 0.02 )
	-- 4) Level up! Need to choose the right skill though because you’ll need shrapnel here.
	local LevelUp = rootTask:AddTask( CDotaNPXTask_LearnAbility( {
		TaskName = "level_up",
		TaskType = "task_learn_ability",
		TaskParams = 
		{	
			AbilityName = "sniper_shrapnel"
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "kill_centaur" )
		end,
	}, self ), 0.02 )
	-- 5) Clear the enemies at the top of the hill (using shrapnel to get vision).
	local KillWolves = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_wolves",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "level_up" )
		end,
	}, self ), 0.02 )
	-- 6) Go to the tower, but oh no! You can't go past it! Look at the tower and see how much damage it does and its range.
	local SeeTheTower = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "see_the_tower",
		TaskType = "task_move_to_location",
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "kill_wolves" )
		end,
		TaskParams =
		{
			GoalLocation = Vector( -3583, 1664, 420 ),
			GoalDistance = 64,
		},
	}, self ), 0.02 )
	-- 7) There's probably another path, let's go find it (Should force you to move across the map)
	local SeeTheNewPath = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "see_the_new_path",
		TaskType = "task_move_to_location",
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "see_the_tower" )
		end,
		TaskParams =
		{
			GoalLocation = Vector( -2687, -1664, 292 ),
			GoalDistance = 64,
		},
	}, self ), 0.02 )
	-- 8) Find our tower.
	local SeeYourTower = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "see_your_tower",
		TaskType = "task_move_to_location",
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "see_the_new_path" )
		end,
		TaskParams =
		{
			GoalLocation = Vector( -5631, -1792, 292 ),
			GoalDistance = 64,
		},
	}, self ), 0.02 )
	-- 9) Push with your creeps, destroy the enemy tower.
	self.KillTower = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_tower",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 			
			return GameRules.DotaNPX:IsTaskComplete( "see_your_tower" )			
		end,
	}, self ), 0.02 )

	--]]
	-- 10) Advance to the boss, probably you shouldn't fight him because he's too strong.
	local SeeTheBossUpClose = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "see_the_boss_up_close",
		TaskType = "task_move_to_location",
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "kill_tower" )
		end,
		TaskParams =
		{
			GoalLocation = Vector( 2625, -704, 164 ),
			GoalDistance = 64,
		},
	}, self ), 0.02 )

	
	-- 11) Fight 3 minibosses and hit lv6. Each miniboss drops a salve and a clarity (that regens faster than normal clarities)
	local FightMiniBosses = rootTask:AddTask( CDotaNPXTask_Parallel( {
		TaskName = "mini_bosses",		
		}, self ), 0.5 )
	
		
	-- 11.a) Mirana (Dodge the arrow gal)
	local KillMirana =  FightMiniBosses:AddTask(CDotaNPXTask_KillUnits( {
		TaskName = "kill_mirana",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ), 0.02 )

	-- 11.b) Underlord (don't stand in the poop guy)
	local KillUnderlord =  FightMiniBosses:AddTask(CDotaNPXTask_KillUnits( {
		TaskName = "kill_underlord",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ), 0.02 )

	-- 11.c) Broodmother (kill the adds gal).
	local KillBroodmother =  FightMiniBosses:AddTask(CDotaNPXTask_KillUnits( {
		TaskName = "kill_broodmother",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return true
		end,
	}, self ), 0.02 )

	-- 12) Learn assassinate!
	local LevelUp = rootTask:AddTask( CDotaNPXTask_LearnAbility( {
		TaskName = "learn_assassinate",
		TaskType = "task_learn_ability",
		TaskParams = 
		{	
			AbilityName = "sniper_assassinate"
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "mini_bosses" )
		end,
	}, self ), 0.02 )

	-- 5) Clear the enemies at the top of the hill (using shrapnel to get vision).
	local KillBoss = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_the_boss",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "learn_assassinate" )
		end,
	}, self ), 0.02 )
	return true
end
--------------------------------------------------------------------

function CDotaNPXScenario1:OnSetupComplete()
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
	SendToConsole( "dota_creeps_no_spawning 1" )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	
	self.hPlayerHero:FindAbilityByName("sniper_headshot"):SetHidden(true)
	self.hPlayerHero:FindAbilityByName("sniper_assassinate"):SetHidden(true)
	self.hPlayerHero:FindAbilityByName("sniper_shrapnel"):SetHidden(true)
end


--------------------------------------------------------------------

function CDotaNPXScenario1:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	
	
end

--------------------------------------------------------------------

function CDotaNPXScenario1:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "see_the_boss" then
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_PANEL, true )
		local Spawner = self:GetSpawner("first_creep_spawn")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		end
		Spawner:SpawnUnits()
		--Shadow Fiend's position`
		
		SendToConsole( "dota_camera_lerp_position 2561 -1536 2.0" )
	end
	
	if Task:GetTaskName() == "kill_gnolls" then
		local Spawner = self:GetSpawner("second_creep_spawn")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		endturn
		end
		Spawner:SpawnUnits()
	end

	if Task:GetTaskName() == "kill_centaur" then
		local Spawner = self:GetSpawner("third_creep_spawn")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		end
		Spawner:SpawnUnits()
		self.hPlayerHero:FindAbilityByName("sniper_shrapnel"):SetHidden(false)
		self.hPlayerHero:AddNewModifier(self.hPlayerHero, nil, "modifier_no_xp",{})
	end

	if Task:GetTaskName() == "see_the_tower" then
		SendToConsole( "dota_creeps_no_spawning 0" )
		local Spawner = self:GetSpawner("beastmaster_spawner")
		print ("Spawning beastmaster!")
		if Spawner == nil then
			print("couldn't find spawner")
			return
		end
		Spawner:SpawnUnits()
		
		local hTowers = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )		
		local hGoodTowers = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )		
		self.KillTower:SetUnitsToKill( hTowers )
		hTowers[1]:AddNewModifier(hTowers[1], nil, "modifier_tank_creep_damage", {})
		hGoodTowers[1]:AddNewModifier(hGoodTowers[1], nil, "modifier_tank_creep_damage", {})

		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_MINIMAP, true )
	end

	if Task:GetTaskName() == "kill_tower" then
		SendToConsole( "dota_creeps_no_spawning 1" )
		self.hPlayerHero:RemoveModifierByName("modifier_no_xp")
		self.hPlayerHero:HeroLevelUp(true)
		self.hPlayerHero:FindAbilityByName("sniper_headshot"):SetHidden(false)
		self.hPlayerHero:FindAbilityByName("sniper_assassinate"):SetHidden(false)

	end
	
	if Task:GetTaskName() == "kill_mirana" then
		self.hPlayerHero:HeroLevelUp(true)
	end

	if Task:GetTaskName() == "kill_underlord" then
		self.hPlayerHero:HeroLevelUp(true)
	end

	if Task:GetTaskName() == "kill_broodmother" then
		self.hPlayerHero:HeroLevelUp(true)
	end

	if Task:GetTaskName() == "see_the_boss_up_close" then
		local BroodMotherSpawner = self:GetSpawner("broodmother_spawn")
		if BroodMotherSpawner  == nil then
			print("couldn't find spawner")
			return
		end
		BroodMotherSpawner:SpawnUnits()

		local MiranaSpawner = self:GetSpawner("mirana_spawn")
		if MiranaSpawner  == nil then
			print("couldn't find spawner")
			return
		end
		MiranaSpawner:SpawnUnits()

		local UnderlordSpawner = self:GetSpawner("underlord_spawn")
		if UnderlordSpawner  == nil then
			print("couldn't find spawner")
			return
		end
		UnderlordSpawner:SpawnUnits()
	end

end

--------------------------------------------------------------------

function CDotaNPXScenario1:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )
	
	local Spawner = self:GetSpawner( event.spawner_name )
	if Spawner == nil then
		return
	end

	if event.spawner_name == "first_creep_spawn" then
		local Task = self:GetTask( "kill_gnolls" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end

	if event.spawner_name == "second_creep_spawn" then
		local Task = self:GetTask( "kill_centaur" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end

	if event.spawner_name == "third_creep_spawn" then
		local Task = self:GetTask( "kill_wolves" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end
	
	if event.spawner_name == "mirana_spawn" then
		local Task = self:GetTask( "kill_mirana" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end

	if event.spawner_name == "underlord_spawn" then
		local Task = self:GetTask( "kill_underlord" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end

	if event.spawner_name == "broodmother_spawn" then
		local Task = self:GetTask( "kill_broodmother" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
			Spawner:GetSpawnedUnits()
		end
	end

	if event.spawner_name == "boss_spawn" then
		local Task = self:GetTask( "kill_the_boss" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end
end
----------------------------------------------------------------------------

function CDotaNPXScenario1:OnTakeDamage( hVictim, hKiller, hInflictor )	
	CDotaNPXScenario:OnTakeDamage( hVictim, hKiller, hInflictor )	
	if hVictim:GetUnitName() == "npc_dota_hero_nevermore" and hInflictor ~= nil and hInflictor:GetAbilityName() == "sniper_assassinate" then
		hVictim:ForceKill( false )
	end
end
----------------------------------------------------------------------------
function CDotaNPXScenario1:OnEntityKilled( hVictim, hKiller, hInflictor )
	CDotaNPXScenario:OnEntityKilled( hVictim, hKiller, hInflictor )	
	if hVictim:GetUnitName() == "npc_dota_hero_mirana" or  hVictim:GetUnitName() == "npc_dota_hero_broodmother"  or hVictim:GetUnitName() == "npc_dota_hero_underlord" then
		local newItem = CreateItem( "item_cheese", nil, nil )
		local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
		newItem:LaunchLoot( false, 300, 0.75, hVictim:GetAbsOrigin() + RandomVector( RandomFloat( 50, 100 ) ) )
	end	

end

----------------------------------------------------------------------------
function CDotaNPXScenario1:OnItemPickedUp(  itemname, PlayerID, ItemEntityIndex, HeroEntityIndex  )
	hHero = EntIndexToHScript( HeroEntityIndex )
	hItem = EntIndexToHScript( ItemEntityIndex )
	if hHero ~=nil and hItem ~=nil then
			ExecuteOrderFromTable( {
			UnitIndex = HeroEntityIndex,
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = ItemEntityIndex,
		} )
	end

end


--------------------------------------------------------------------
function CDotaNPXScenario1:HideHint()
	CustomGameEventManager:Send_ServerToAllClients( "hide_hint", {} )
end

--------------------------------------------------------------------
function CDotaNPXScenario1:ShowHint( strText )
	if self.bShouldUpdateHints then
		CustomGameEventManager:Send_ServerToAllClients( "display_hint", { hint_text =strText, duration = 0 } )
	end
end
--------------------------------------------------------------------
return CDotaNPXScenario1