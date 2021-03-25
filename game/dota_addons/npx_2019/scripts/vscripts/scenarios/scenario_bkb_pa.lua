require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_kill_units" )
require( "tasks/task_move_to_location" )

--------------------------------------------------------------------

if CDotaNPXScenario_BKB_PA == nil then
	CDotaNPXScenario_BKB_PA = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_phantom_assassin",
		StartingHeroLevel	= 12,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_black_king_bar",
			"item_hyperstone",
			"item_desolator",
			--"item_assault",
		},

		ScenarioTimeLimit = 60.0,
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:SetHeroRespawnEnabled( false )

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_KILLCAM, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_BAR, false )
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	GameRules:SetTimeOfDay( 0.251 )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )

	local hBountyLoc = Entities:FindByName( nil, "bounty_rune_location" )
	self.hRune = CreateRune( hBountyLoc:GetAbsOrigin(), DOTA_RUNE_BOUNTY )

	self.hSpawnedUnits = {}
	self.LinaSpawner = CDotaSpawner( "lina_spawn_location", 
	{
		{
			EntityName = "npc_dota_hero_lina",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				BotName = "Lina",
				EntityScript = "ai/ai_bkb_pa_lina.lua",
				StartingHeroLevel = 6,
				StartingItems = 
				{
					--[["item_ultimate_scepter",
					"item_ethereal_blade",
					"item_dagon_5",--]]
				},
				AbilityBuild = 
				{
					AbilityPriority = { "lina_laguna_blade", "lina_dragon_slave", "lina_light_strike_array" },
				},
			},
		},
	}, self, true )

	self.LionSpawner = CDotaSpawner( "lion_spawn_location", 
	{
		{
			EntityName = "npc_dota_hero_lion",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				BotName = "Lion",
				EntityScript = "ai/ai_bkb_pa_lion.lua",
				StartingHeroLevel = 6,
				StartingItems = 
				{
				},
				AbilityBuild = 
				{
					AbilityPriority = { "lion_voodoo", "lion_impale", "lion_finger_of_death" },
				},
			},
		},
	}, self, true )

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_BKB_PA, "OnTriggerStartTouch" ), self )
end

function CDotaNPXScenario_BKB_PA:SetupTasks()
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end
	if self.Tasks == nil then
		self.Tasks = {}
	end

	self.hInitialPlayerMoveLoc = Entities:FindByName( nil, "initial_player_move_loc" )
	ScriptAssert( self.hInitialPlayerMoveLoc ~= nil, "Could not find entity named initial_player_move_loc!" )

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	local FIRST_TASK_START_DELAY = 1.0

	local MoveNearRune = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_near_rune",
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
	}, self ), FIRST_TASK_START_DELAY )

	local KillEnemies = rootTask:AddTask( CDotaNPXTask_KillUnits( {
		TaskName = "kill_enemies",
		TaskType = "task_kill_units",
		TaskParams = 
		{				
		},
		UseHints = true,
		CheckTaskStart = 
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_near_rune" )
		end,
	}, self ), 0.02 )

	KillEnemies.StartTask = function( task )
		local hUnitsToKill = {}
		table.insert( hUnitsToKill, self.LinaSpawner:GetSpawnedUnits()[ 1 ] )
		table.insert( hUnitsToKill, self.LionSpawner:GetSpawnedUnits()[ 1 ] )
		task:SetUnitsToKill( hUnitsToKill )
		CDotaNPXTask_KillUnits.StartTask( task )
		task:GetScenario():ShowWizardTip( "scenario_bkb_pa_wizard_tip_bkb", 15.0 )
		self:ShowItemHint( "item_black_king_bar" )
	end

	return true
end

function CDotaNPXScenario_BKB_PA:OnTriggerStartTouch( event )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero and event.trigger_name == "start_trigger" and event.activator_entindex == hPlayerHero:GetEntityIndex() then
		print(" ********** Hit trigger! *******" )
		local hLina = self.LinaSpawner:GetSpawnedUnits()[ 1 ]
		--hLina.Bot:SetScriptedAttackTarget( hPlayerHero )
		hLina.Bot:StartAI()
		local hLion = self.LionSpawner:GetSpawnedUnits()[ 1 ]
		--hLion.Bot:SetScriptedAttackTarget( hPlayerHero )
		hLion.Bot:StartAI()

		local Task = self:GetTask( "move_near_rune" )
		if Task then
			Task:CompleteTask( true )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero ~= nil and hPlayerHero:IsNull() == false then
		for i = 1, 2 do
			if self.hPlayerHero:GetAbilityPoints() > 0 then
				local hAbilityBlink = self.hPlayerHero:FindAbilityByName( "phantom_assassin_phantom_strike" )
				ScriptAssert( hAbilityBlink ~= nil, "Ability named %s is nil, could not upgrade it!", hAbilityBlink:GetAbilityName() )
				if hAbilityBlink ~= nil then
					self.hPlayerHero:UpgradeAbility( hAbilityBlink )
				end
			end
			if self.hPlayerHero:GetAbilityPoints() > 0 then
				local hAbilityCoup = self.hPlayerHero:FindAbilityByName( "phantom_assassin_coup_de_grace" )
				ScriptAssert( hAbilityCoup ~= nil, "Ability named %s is nil, could not upgrade it!", hAbilityCoup:GetAbilityName() )
				if hAbilityCoup ~= nil then
					self.hPlayerHero:UpgradeAbility( hAbilityCoup )
				end
			end
		end

		hPlayerHero:SetAbilityPoints( 0 )
		--LearnHeroAbilities( hPlayerHero )
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:OnNPCSpawned( hEnt )
	if hEnt == nil or hEnt:IsNull() == false then
		return
	end

	CDotaNPXScenario:OnNPCSpawned( hEnt )	
	--[[if hEnt:GetUnitName() == "npc_dota_hero_lina" or hEnt:GetUnitName() == "npc_dota_hero_lion" then
		table.insert( self.hSpawnedUnits, hEnt )
		if hEnt.Bot ~= nil then
			hEnt.Bot:StartAI()
		end
	end

	if #self.hSpawnedUnits == 2 then
		local Task = self:GetTask( "kill_enemies" )
		if Task then
			printf( "found task kill_enemies, doing SetUnitsToKill" )
			local hUnitsToKill = {}
			table.insert( hUnitsToKill, self.LinaSpawner:GetSpawnedUnits()[ 1 ] )
			table.insert( hUnitsToKill, self.LionSpawner:GetSpawnedUnits()[ 1 ] )
			Task:SetUnitsToKill( hUnitsToKill )
			--Task:SetUnitsToKill( self.hSpawnedUnits )
		end
	end--]]
end

----------------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:OnEntityKilled( hVictim, hKiller, hInflictor )
	CDotaNPXScenario:OnEntityKilled( hVictim, hKiller, hInflictor )

	if hVictim == PlayerResource:GetSelectedHeroEntity( 0 ) then
		self:OnScenarioComplete( false )
	end	
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:Restart()
	UTIL_RemoveImmediate( self.hRune )
	if self.hSpawnedUnits ~= nil then
		for _,v in pairs( self.hSpawnedUnits ) do
			UTIL_RemoveImmediate( v )
		end
	end
	self.hSpawnedUnits = {}

	CDotaNPXScenario.Restart( self )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_near_rune" then
		return
	
	elseif Task:GetTaskName() == "kill_enemies" then
		self:OnScenarioRankAchieved( 1 )
		self:OnScenarioComplete( true )
	end


end	

----------------------------------------------------------------------------

function CDotaNPXScenario_BKB_PA:ShowItemHint( szItemName )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	local hItem = self.hPlayerHero:FindItemInInventory( szItemName )
	if hItem then
		local nItemSlot = hItem:GetItemSlot()
		if nItemSlot >= 0 then
			self:ShowUIHint( "inventory_slot_" .. nItemSlot )
			return
		end
	end
	self:HideUIHint()
end

--------------------------------------------------------------------

return CDotaNPXScenario_BKB_PA