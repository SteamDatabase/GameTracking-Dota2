require( "npx_scenario" )
require( "tasks/task_parallel" )
require( "tasks/task_last_hits" )
require( "tasks/task_denies" )
require( "tasks/task_fail_player_hero_death" )

--------------------------------------------------------------------

if CDotaNPXScenario_Mid1v1 == nil then
	CDotaNPXScenario_Mid1v1 = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:InitScenarioKeys()
	self.hHeroSpawn = Entities:FindByName( nil, "radiant_hero_spawn_location" )
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hRadiantAncientLoc = Entities:FindByName( nil, "radiant_ancient_location" )
	self.hShopLoc = Entities:FindByName( nil, "shop_location" )
	self.hRadiantMidTier3Loc = Entities:FindByName( nil, "radiant_mid_location_3" )
	self.hRadiantMidTier2Loc = Entities:FindByName( nil, "radiant_mid_location_2" )
	self.hRadiantMidTier1Loc = Entities:FindByName( nil, "radiant_mid_location_1" )
	self.hDireMidTier3Loc = Entities:FindByName( nil, "dire_mid_location_3" )
	self.hDireMidTier2Loc = Entities:FindByName( nil, "dire_mid_location_2" )
	self.hDireMidTier1Loc = Entities:FindByName( nil, "dire_mid_location_1" )
	self.hMidLaneLoc = Entities:FindByName( nil, "mid_location" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_windrunner",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_tango",
			"item_faerie_fire",
			"item_null_talisman",
			"item_branch",
			"item_branch",
			"item_branch",
		},
		StartingAbilities   =
		{			
			"windrunner_powershot",
		},

		ScenarioTimeLimit = 0.0,
	}

	self.nCheckpoint = 0
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:SetTimeOfDay( 0.75 ) -- Daytime
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true ) -- Always daytime
	GameRules:SetHeroRespawnEnabled( false ) -- No respawn
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "mid_1v1" )
	Tutorial:SetTutorialConvar( "dota_disable_top_lane", "1" )
	Tutorial:SetTutorialConvar( "dota_disable_bot_lane", "1" )
	Tutorial:EnableCreepAggroViz( true )

	self.bEnemyTipShown = false
	self.bTowerTipShown = false
	self.bEnemyHeroHasDied = false

	local SfSpawner = CDotaSpawner( "dire_mid_location_1", 
	{
		{
			EntityName = "npc_dota_hero_nevermore",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				PlayerID = 1,
				BotName = "Shadow Fiend",
				EntityScript = "ai/ai_sf_mid_1v1.lua",
				StartingItems = 
				{
					"item_tango",
					"item_wraith_band",
					"item_faerie_fire",
					"item_branch",
					"item_branch",
					"item_branch",
				},
				StartingAbilities =
				{
				},
			},
		},
	}, self, true )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	if self.nCheckpoint == 0 then
		self:SetupStart()
	elseif self.nCheckpoint == 1 then
		self:SetupStartTasks()
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )

	self.hHero = hHero
	FindClearSpaceForUnit( self.hHero, self.hRadiantMidTier1Loc:GetAbsOrigin(), true )
	self.hCourier = hPlayer:SpawnCourierAtPosition( self.hShopLoc:GetAbsOrigin() )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:SetupStart()
	self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_intro_1", 10.0 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_intro_2", 10.0 )
		self:BlockPlayerStart( false )
	end )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 20, function()
		self:SetupStartTasks()
		self.nCheckpoint = 1
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:SetupStartTasks()
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Parallel( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	local getLastHits = rootTask:AddTask( CDotaNPXTask_LastHits( {
		TaskName = "get_last_hits",
		TaskType = "task_last_hits",
		UseHints = true,
		TaskParams =
		{
			Count = 25,
		},
		CheckTaskStart =
		function() return true end,
	}, self ), 0.0 )

	local getDenies = rootTask:AddTask( CDotaNPXTask_Denies( {
		TaskName = "get_denies",
		TaskType = "task_denies",
		UseHints = true,
		TaskParams =
		{
			Count = 10,
		},
		CheckTaskStart =
		function() return true end,
	}, self ), 0.0 )

	local doNotDie = rootTask:AddTask( CDotaNPXTask_Fail_PlayerHeroDeath( {
		TaskName = "do_not_die",
		TaskType = "task_fail_player_hero_death",
		TaskParams = 
		{
			Count = 1,
		},
		Hidden = true,
		CheckTaskStart = 
		function() return true end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	if event.task_name == "get_last_hits" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 20, function()
			self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_powershot", 20.0 )
			--self:ShowUIHint( "Ability1", "scenario_mid_1v1_ui_tip_powershot", 10.0, nil)
		end )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 80, function()
			self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_items", 20.0 )
		end )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 140, function()
			self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_runes", 20.0 )
		end )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 200, function()
			self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_bottle", 20.0 )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )
	if event.task_name == "get_last_hits" then
		if GameRules.DotaNPX:IsTaskComplete( "get_denies" ) then
			self:EndScenario()
		end
	elseif event.task_name == "get_denies" then
		if GameRules.DotaNPX:IsTaskComplete( "get_last_hits" ) then
			self:EndScenario()
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnGameRulesStateChange( nOldState, nNewState )
	CDotaNPXScenario.OnGameRulesStateChange( self, nOldState, nNewState )
	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameRules:SpawnAndReleaseCreeps()
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnTakeDamage( hVictim, hKiller, hInflictor )
	CDotaNPXScenario.OnTakeDamage( self, hVictim, hKiller, hInflictor )
	if hVictim == self.hHero then
		--print( "Taking damage" )
		if hKiller ~= nil and hKiller:GetUnitName() == "npc_dota_hero_nevermore" then
			if self.bEnemyTipShown == false then
				if self.hHero:GetHealthPercent() < 70 then
					self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_hero_damage", 10.0 )
					self.bEnemyTipShown = true
				end
			end
		elseif hKiller ~= nil and hKiller:GetUnitName() == "npc_dota_badguys_tower1_mid" then
			if self.bTowerTipShown == false then
				self:ShowWizardTip( "scenario_mid_1v1_wizard_tip_tower_damage", 10.0 )
				self.bTowerTipShown = true
			end
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnEntityKilled( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	
	if hEnt:GetUnitName() == "npc_dota_hero_nevermore" then
		print( "Shadow Fiend died" )
		self.bEnemyHeroHasDied = true
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:BlockPlayerStart( boolean )
	local hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hStartBlockers ) do
		if string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_1_start" ) or string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_1_end" ) or
		string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_2_start" ) or string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_2_end" ) or
		string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_3_start" ) or string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_3_end" ) or
		string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_4_start" ) or string.find( hBlocker:GetName(), "radiant_mid_t1_blocker_4_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:EndScenario()
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
		self:OnScenarioRankAchieved( 1 )
	end )
end

--------------------------------------------------------------------

return CDotaNPXScenario_Mid1v1