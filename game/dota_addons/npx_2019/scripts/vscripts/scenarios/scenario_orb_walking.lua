require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )
require( "tasks/task_kill_units" )

--------------------------------------------------------------------

if CDotaNPXScenario_OrbWalking == nil then
	CDotaNPXScenario_OrbWalking = class( {}, {}, CDotaNPXScenario )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:PrecacheResources()
	PrecacheUnitByNameSync( "npc_dota_hero_undying", context )
    PrecacheModel( "npc_dota_hero_undying", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_undying", context )
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:InitScenarioKeys()
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hEnemyLocation = Entities:FindByName( nil, "enemy_location_1" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_drow_ranger",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_boots",
			"item_wraith_band",
		},
		StartingAbilities   =
		{
			"drow_ranger_frost_arrows",
		},

		ScenarioTimeLimit = 0, -- Timed.

		Tasks =
		{
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
					return self.bIntroComplete
				end,
			},
			{
				TaskName = "kill_enemy_hero",
				TaskType = "task_kill_units",
				UseHints = true,
				TaskParams =
				{
				},
				CheckTaskStart =
				function() 
					return self.bEnemyHeroHasSpawned
				end,
			},
		},

		Queries =
		{
		},
	}

	self.nCheckpoint = 0
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:SetupScenario()
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

	self.bIntroComplete = false
	self.bEnemyHeroHasSpawned = false

	self.UndyingSpawner = CDotaSpawner( "enemy_spawner", 
	{
		{
			EntityName = "npc_dota_hero_undying",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				PlayerID = 1,
				BotName = "Undying",
				EntityScript = "ai/orb_walking/ai_orb_walking_undying.lua",
				StartingHeroLevel = 1,
				StartingItems = 
				{
					"item_boots",
					"item_faerie_fire",
				},
				AbilityBuild = 
				{
				},
			},
		},
	}, self, false )

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_OrbWalking, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	if self.nCheckpoint == 0 then
		self:BlockPlayerStart( true )
		self:Intro()
	elseif self.nCheckpoint == 1 then
		self.bIntroComplete = true
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:Intro()
	self:ShowWizardTip( "scenario_orb_walking_wizard_tip_intro_1", 10.0 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:ShowWizardTip( "scenario_orb_walking_wizard_tip_intro_2", 10.0 )
	end )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 20, function()
		self.bIntroComplete = true
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:OnTaskStarted( event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	self:HideUIHint()
	if event.task_name == "move_to_location_1" then
		self:BlockPlayerStart( false )
		self.nCheckpoint = 1
	elseif event.task_name == "kill_enemy_hero" then

	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:OnTaskCompleted( event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if event.task_name == "move_to_location_1" then
		self:SpawnEnemy()
	elseif event.task_name == "kill_enemy_hero" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
			self:OnScenarioRankAchieved( 1 )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:SpawnEnemy()
	print("Spawning enemy")
	self.UndyingSpawner:SpawnUnits()
	self.hUndying = self.UndyingSpawner:GetSpawnedUnits()[1]
	self.hUndying:ModifyHealth( 500, nil, false, 0 )
	self:RegisterEnemyHero( self.hUndying )
	self.bEnemyHeroHasSpawned = true
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:RegisterEnemyHero( hHero )
	print("Registering Enemy Hero")
	local Task = self:GetTask( "kill_enemy_hero" )
	if Task then
		print( "Task registered" )
		local hUnitsToKill = {}
		table.insert( hUnitsToKill, hHero )
		Task:SetUnitsToKill( hUnitsToKill )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:OnEntityKilled( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	
	if hEnt == self.hPlayerHero then
		self:OnScenarioComplete( false, "task_fail_player_hero_death_fail" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:OnTriggerStartTouch( sTriggerName, sActivator)
	if sTriggerName == "enemy_trigger" then
		print( "Enemy escaped" )
		self:OnScenarioComplete( false, "scenario_orb_walking_failure_enemy_escaped" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_OrbWalking:BlockPlayerStart( boolean )
	local hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hStartBlockers ) do
		if string.find( hBlocker:GetName(), "intro_blocker_1_start" ) or string.find( hBlocker:GetName(), "intro_blocker_1_end" ) or
		string.find( hBlocker:GetName(), "intro_blocker_2_start" ) or string.find( hBlocker:GetName(), "intro_blocker_2_end" ) or
		string.find( hBlocker:GetName(), "intro_blocker_3_start" ) or string.find( hBlocker:GetName(), "intro_blocker_3_end" ) or
		string.find( hBlocker:GetName(), "intro_blocker_4_start" ) or string.find( hBlocker:GetName(), "intro_blocker_4_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_OrbWalking
