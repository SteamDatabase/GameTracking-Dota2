require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_parallel" )
require( "tasks/task_move_to_location" )
require( "tasks/task_unit_showcase" )
require( "tasks/task_delay" )
require( "tasks/task_pickup_rune" )
require( "tasks/task_buy_item" )
require( "tasks/task_find_enemy_with_scan" )
require( "tasks/task_kill_units" )
require( "tasks/task_acquire_item" )
require( "hero_ability_utils" )

--------------------------------------------------------------------

if CDOTANPXScenario_Objectives == nil then
	CDOTANPXScenario_Objectives = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDOTANPXScenario_Objectives:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_earthshaker",
		StartingHeroLevel	= 12,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 1500,
		StartingItems 		=
		{
			"item_blink",
			"item_arcane_boots",
			"item_blade_of_alacrity",
			"item_staff_of_wizardry",
			"item_ogre_axe"
		},

		ScenarioTimeLimit = 600.0,
	}
end

--------------------------------------------------------------------

function CDOTANPXScenario_Objectives:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	-- Outpost needs to be capturable immediately
	SendToServerConsole( "dota_force_outpost_ready 1" )
	self.hOutpost = Entities:FindByName( nil, "npc_dota_watch_tower_top" );
	self.hOutpost:SetTeam( DOTA_TEAM_GOODGUYS )

	GameRules:GetGameModeEntity():SetCustomScanCooldown( 5.0 )

	self.RoshanSpawner = CDotaSpawner( "roshan_spawn_location",
	{
		{
			EntityName = "npc_dota_roshan",
			Team = DOTA_TEAM_NEUTRALS,
			Count = 1
		}
	}, self, true )

	self.SniperSpawner = CDotaSpawner( "sniper_spawn_location",
	{
		{
			EntityName = "npc_dota_hero_sniper",
			Team = DOTA_TEAM_GOODGUYS,
			Count = 1,
			BotPlayer =
			{
				BotName = "Davy Crockett",
				EntityScript = "ai/objectives/ai_objectives_sniper.lua",
				StartingHeroLevel = 6,
				StartingItems = 
				{
				},
			},
		}
	}, self, true )
	
	self.AncientApparitionSpawner = CDotaSpawner( "sniper_spawn_location",
	{
		{
			EntityName = "npc_dota_hero_ancient_apparition",
			Team = DOTA_TEAM_GOODGUYS,
			Count = 1,
			BotPlayer =
			{
				BotName = "Ice Cream Cone",
				EntityScript = "ai/objectives/ai_objectives_ancient_apparition.lua",
				StartingHeroLevel = 6,
				StartingItems = 
				{
				},
			},
		}
	}, self, true )

	self.BaneSpawner = CDotaSpawner( "bane_spawn_location", 
	{
		{
			EntityName = "npc_dota_hero_bane",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			BotPlayer =
			{
				BotName = "Tom Hardy",
				EntityScript = "ai/objectives/ai_objectives_bane.lua",
				StartingHeroLevel = 6,
				StartingItems = 
				{
				},
			},
		},
	}, self, true )

	self.FurionSpawner = CDotaSpawner( "bane_spawn_location", 
	{
		{
			EntityName = "npc_dota_hero_furion",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			BotPlayer =
			{
				BotName = "Nature's Profit",
				EntityScript = "ai/objectives/ai_objectives_furion.lua",
				StartingHeroLevel = 11,
				StartingItems = 
				{
				},
			},
		},
	}, self, true )

	self.PhantomLancerSpawner = CDotaSpawner( "bane_spawn_location", 
	{
		{
			EntityName = "npc_dota_hero_phantom_lancer",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			BotPlayer =
			{
				BotName = "The Phantom Menace",
				EntityScript = "ai/objectives/ai_objectives_phantom_lancer.lua",
				StartingHeroLevel = 15,
				StartingItems = 
				{
					"item_power_treads",
					"item_diffusal_blade",
					"item_manta"
				},
			},
		},
	}, self, true )

	return true
end


function CDOTANPXScenario_Objectives:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )

	if hPlayer:GetPlayerID() == 0 then
		LearnHeroAbilities( hHero, {} )
	end
end

function CDOTANPXScenario_Objectives:SetupTasks()
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

	rootTask:AddTask( CDotaNPXTask_Delay( {
		TaskName = "initial_delay",
		Delay = 1.0
	}, self ) )
	
	rootTask:AddTask( CDotaNPXTask_UnitShowcase( {
		TaskName = "unit_showcase",
		Unit = self.hPlayerHero
	}, self ) )

	rootTask:AddTask( CDotaNPXTask_Delay( { TaskName = "delay", Delay = 2.0 }, self ) )

	rootTask:AddTask( self:SetupTask_SniperAttackRoshan() )

	rootTask:AddTask( CDotaNPXTask_Delay( { TaskName = "delay", Delay = 2.0 }, self ) )

	rootTask:AddTask( self:SetupTask_PrepareForFight() )

	rootTask:AddTask( CDotaNPXTask_Delay( { TaskName = "delay", Delay = 2.0 }, self ) )

	rootTask:AddTask( self:SetupTask_InterruptBane() )

	rootTask:AddTask( CDotaNPXTask_Delay( { TaskName = "delay", Delay = 2.0 }, self ) )

	rootTask:AddTask( self:SetupTask_ScanForEnemies() )

	rootTask:AddTask( CDotaNPXTask_Delay( { TaskName = "delay", Delay = 2.0 }, self ) )

	rootTask:AddTask( self:SetupTask_DefeatEnemyHeroes() )

	return true
end


function CDOTANPXScenario_Objectives:SetupTask_SniperAttackRoshan()
	local sniperTask = CDotaNPXTask( {
		TaskName = "sniper_suicide"
	}, self )
	sniperTask.bActive = false

	sniperTask.StartTask = function ( task )
		CDotaNPXTask.StartTask( task )
		task.bActive = true
		task.hSniper = task.hScenario.SniperSpawner:GetSpawnedUnits()[1]
		task.hSniper:SetHealth( 150 )
		task.hSniper.Bot:StartAttackingRoshan()

		SendToConsole( "dota_camera_center_on_entity " .. tostring( task.hSniper:entindex() ) )
	end

	sniperTask.IsActive = function ( task )
		return task.bActive
	end

	sniperTask.OnThink = function ( task )
		if task.hSniper.Bot:IsFinished() then
			task:CompleteTask( true )
		end
	end

	return sniperTask
end

--------------------------------------------------------------------

function CDOTANPXScenario_Objectives:SetupTask_InterruptBane()
	local interruptBaneTask = CDotaNPXTask( {
		TaskName = "interrupt_bane"
	}, self )
	interruptBaneTask.bActive = false

	interruptBaneTask.StartTask = function ( task )
		CDotaNPXTask.StartTask( task )
		task.bActive = true
		task.hBane = task.hScenario.BaneSpawner:GetSpawnedUnits()[1]
		task.hBane:SetHealth( 250 )
		task.hBane.Bot:StartCapturingOutpost()
	end

	interruptBaneTask.IsActive = function ( task )
		return task.bActive
	end

	interruptBaneTask.OnThink = function ( task )
		
		if task.hBane.Bot:IsFinished() then
			task:CompleteTask( not task.hBane.Bot:DidCaptureOutpost() )
		end

	end

	return interruptBaneTask
end

--------------------------------------------------------------------

function CDOTANPXScenario_Objectives:SetupTask_PrepareForFight()
	local prepareTask = CDotaNPXTask_Parallel( {
		TaskName ="prepare_for_fight"
	}, self )

	prepareTask.StartTask = function( task )
		CDotaNPXTask_Parallel.StartTask( task )

		local hBountyLoc = Entities:FindByName( nil, "bounty_rune_location" )
		CreateRune( hBountyLoc:GetAbsOrigin(), DOTA_RUNE_BOUNTY )

		local hRegenLoc = Entities:FindByName( nil, "regen_rune_location" )
		CreateRune( hRegenLoc:GetAbsOrigin(), DOTA_RUNE_REGENERATION )

	end

	prepareTask:AddTask( CDotaNPXTask_PickupRune( {
		TaskName = "pickup_bounty_rune",
		RuneType = DOTA_RUNE_BOUNTY
	}, self ) )

	prepareTask:AddTask( CDotaNPXTask_PickupRune( {
		TaskName = "pickup_regen_rune",
		RuneType = DOTA_RUNE_REGENERATION
	}, self ) )

	prepareTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "finish_aghs",
		UseHints = true,
		TaskParams = 
		{
			ItemName = "item_point_booster",
			WhiteList = { "item_point_booster", },
		},
	}, self ), 0 )

	return prepareTask
end

--------------------------------------------------------------------

function CDOTANPXScenario_Objectives:SetupTask_ScanForEnemies()
	local scanForEnemiesTask = CDotaNPXTask_FindEnemyWithScan( {
		TaskName = "scan_for_enemies"
	}, self )

	return scanForEnemiesTask
end

--------------------------------------------------------------------

function CDOTANPXScenario_Objectives:SetupTask_DefeatEnemyHeroes()
	local defeatTask = CDotaNPXTask_Parallel( {
		TaskName ="defeat_enemies"
	}, self )

	-- Kill enemies
	local killEnemiesTask = CDotaNPXTask_KillUnits( {
		TaskName = "kill_enemy_heroes",
	}, self )
	-- todo(ericl): 
	-- killEnemiesTask:SetUnitsToKill( )
	defeatTask:AddTask( killEnemiesTask )

	-- Kill Roshan
	local killRoshanTask = CDotaNPXTask_KillUnits( {
		TaskName = "kill_roshan",
	}, self )
	-- todo(ericl): 
	-- killEnemiesTask:SetUnitsToKill( )
	defeatTask:AddTask( killRoshanTask )

	-- Pickup Aegis of the Immortal
	local pickupAegisTask = CDotaNPXTask_AcquireItem( {
		TaskName = "pickup_aegis",
	}, self )
	defeatTask:AddTask( pickupAegisTask )

	return defeatTask
end
--------------------------------------------------------------------

return CDOTANPXScenario_Objectives