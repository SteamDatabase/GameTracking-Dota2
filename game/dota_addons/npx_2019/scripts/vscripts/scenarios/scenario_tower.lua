require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )
require( "tasks/task_attack_enemy_tower" )
require( "tasks/task_drop_tower_aggro" )

--------------------------------------------------------------------

if CDotaNPXScenario_Tower == nil then
	CDotaNPXScenario_Tower = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:InitScenarioKeys()
	self.hHeroSpawn = Entities:FindByName( nil, "hero_spawn_location" )
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hHeroLoc2 = Entities:FindByName( nil, "hero_location_2" )
	self.hTowerLoc = Entities:FindByName( nil, "tower_location" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_juggernaut",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_power_treads",
			"item_bracer",
			"item_bracer",
			"item_ocean_heart",
		},
		StartingAbilities   =
		{			
		},

		ScenarioTimeLimit = 0, -- Timed.
	}

	self.nCheckpoint = 0
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:SetupScenario()
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

	Tutorial:EnableCreepAggroViz( true )

	self.bNoDamage = false
	self.bScenarioCompleted = false

	self.nTaskListener = ListenToGameEvent( "dota_player_take_tower_damage", Dynamic_Wrap( CDotaNPXScenario_Tower, "OnTakeTowerDamage" ), self )
	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Tower, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	if self.nCheckpoint == 0 then
		self:ShowIntro()
	elseif self.nCheckpoint == 1 then
		self:SetupStage1()
	elseif self.nCheckpoint == 2 then
		self:SetupStage2Tasks()
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
	self.hHero:SetAbilityPoints( 0 )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:SpawnCreepWaves()
	print( "Spawning Demo Creep Waves" )
	local hRadiantMeleeSpawner = Entities:FindByName( nil, "radiant_melee_spawner_good" )
	local hRadiantRangeSpawner = Entities:FindByName( nil, "radiant_range_spawner_good" )
	local hRadiantCreepPath = Entities:FindByName( nil, "radiant_creep_path1" )
	local hDireMeleeSpawner = Entities:FindByName( nil, "dire_melee_spawner_good" )
	local hDireRangeSpawner = Entities:FindByName( nil, "dire_range_spawner_good" )
	local hDireCreepPath = Entities:FindByName( nil, "dire_creep_path1" )

	for i = 1, 3 do
	    local radiantMelee = CreateUnitByName( "npc_dota_creep_goodguys_melee", hRadiantMeleeSpawner:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
	    radiantMelee:SetInitialGoalEntity( hRadiantCreepPath )
	end
	local radiantRanged = CreateUnitByName( "npc_dota_creep_goodguys_ranged", hRadiantRangeSpawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
	radiantRanged:SetInitialGoalEntity( hRadiantCreepPath )

	for i = 1, 3 do
	    local direMelee = CreateUnitByName( "npc_dota_creep_badguys_melee", hDireMeleeSpawner:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	    direMelee:SetInitialGoalEntity( hDireCreepPath )
	end
	local direRanged = CreateUnitByName( "npc_dota_creep_badguys_ranged", hDireRangeSpawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
	direRanged:SetInitialGoalEntity( hDireCreepPath )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:RemoveCreepWaves()
	local demoUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetPlayerHero():GetOrigin(), self:GetPlayerHero(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #demoUnits > 0 then
		for _,unit in pairs( demoUnits ) do
			if unit:GetUnitName() == "npc_dota_creep_goodguys_melee" or unit:GetUnitName() == "npc_dota_creep_goodguys_ranged" or 
				unit:GetUnitName() == "npc_dota_creep_badguys_melee" or unit:GetUnitName() == "npc_dota_creep_badguys_ranged" then
				UTIL_Remove( unit )
			end
		end
	else
		print("No Demo units found")
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:ShowIntro()
	self:BlockPlayerStart( true )
	self:ShowWizardTip( "scenario_tower_wizard_tip_intro", 10.0 )
	local vIntroPos = self.hTowerLoc:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vIntroPos.x .. " " .. vIntroPos.y .. " " .. 2 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:SetupStage1()
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:SetupStage1()
	--print("Setting up first Demo")
	FindClearSpaceForUnit( self.hHero, self.hHeroSpawn:GetAbsOrigin(), true )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	self:BlockPlayerStart( false )
	self:SetupStage1Tasks()
	self.nCheckpoint = 1
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:SetupStage1Tasks()
	--print("Setting up tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 1
	local moveToLocation1 = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_1",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hHeroLoc1:GetAbsOrigin(),
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
	}, self ), 0.0 )

	local moveToLocation2 = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_2",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hHeroLoc2:GetAbsOrigin(),
			GoalDistance = 64,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
		end,
	}, self ), 0.0 )
	
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:SetupStage2()
	print( "Stage 2" )
	self:Fade( 0 )
	self:RemoveCreepWaves()
	local vPlayerStartLoc = self.hHeroSpawn:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	--SendToConsole( "dota_camera_lerp_position " .. vPlayerStartLoc.x .. " " .. vPlayerStartLoc.y .. " " .. 1 )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	self:SetupStage2Tasks()
	self.nCheckpoint = 2
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:SetupStage2Tasks()
	--print("Setting up tasks")
	if not CDotaNPXScenario.SetupTasks( self ) then
		return false
	end

	if self.Tasks == nil then
		self.Tasks = {}
	end

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 2
	local attackEnemyTower = rootTask:AddTask( CDotaNPXTask_AttackEnemyTower( {
		TaskName = "attack_enemy_tower",
		TaskType = "task_attack_enemy_tower",
		UseHints = true,
		TaskParams =
		{
			TowerName = "npc_dota_badguys_tower1_mid",
			AttackPos = self.hTowerLoc:GetAbsOrigin(),
		},
		CheckTaskStart =
		function() 
			return true 
		end,
	}, self ), 0.0 )

	local dropTowerAggro = rootTask:AddTask( CDotaNPXTask_DropTowerAggro( {
		TaskName = "drop_tower_aggro",
		TaskType = "task_drop_tower_aggro",
		UseHints = true,
		TaskParams =
		{
			TowerName = "npc_dota_badguys_tower1_mid",
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "attack_enemy_tower" )
		end,
	}, self ), 0.0 )
	
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	if event.task_name == "move_to_location_1" then
		self:ShowWizardTip( "scenario_tower_wizard_tip_aggro", 25.0 )
	elseif event.task_name == "move_to_location_2" then
		self.bNoDamage = true
		self:SpawnCreepWaves()
	elseif event.task_name == "attack_enemy_tower" then
		self:ShowWizardTip( "scenario_tower_wizard_tip_drop_aggro", 25.0 )
	elseif event.task_name == "drop_tower_aggro" then
		self:SpawnCreepWaves()
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if event.task_name == "move_to_location_1" then

	elseif event.task_name == "move_to_location_2" then
		if event.success == 1 then
			self.bNoDamage = false
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
				self:Fade( 1 )
			end )
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				self:SetupStage2()
			end )
		end
	elseif event.task_name == "attack_enemy_tower" then
		self:BlockTowerCircle( true )
	elseif event.task_name == "drop_tower_aggro" then
		if event.success == 1 then
			self.bScenarioCompleted = true
			local nHealth = self.hHero:GetMaxHealth()
			self.hHero:SetHealth( nHealth )
			self.hHero:AddNewModifier( self.hHero, nil, "modifier_no_damage", nil )
			self:BlockTowerCircle( false )
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				self:OnScenarioRankAchieved( 1 )
			end )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Tower:OnTakeTowerDamage( event )	
	if self.bNoDamage then
		print( "Player taking tower damage" )
		self:OnScenarioComplete( false, "scenario_tower_failure_hero_taking_damage" )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Tower:OnEntityKilled( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	
	if hEnt == self.hPlayerHero then
		if self.bScenarioCompleted == false then
			self:OnScenarioComplete( false, "task_fail_player_hero_death_fail" )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Tower:Fade( nFade )
	-- Fade should be 1 to fade to black and 0 to fade in
	FireGameEvent("fade_to_black", {
		fade_down = nFade,
		} )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Tower:BlockPlayerStart( boolean )
	local hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hStartBlockers ) do
		if string.find( hBlocker:GetName(), "player_start_blocker_1_start" ) or string.find( hBlocker:GetName(), "player_start_blocker_1_end" ) or
			string.find( hBlocker:GetName(), "player_start_blocker_2_start" ) or string.find( hBlocker:GetName(), "player_start_blocker_2_end" ) or
			string.find( hBlocker:GetName(), "player_start_blocker_3_start" ) or string.find( hBlocker:GetName(), "player_start_blocker_3_end" ) or
			string.find( hBlocker:GetName(), "player_start_blocker_4_start" ) or string.find( hBlocker:GetName(), "player_start_blocker_4_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Tower:BlockTowerCircle( boolean )
	local hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( hStartBlockers ) do
		if string.find( hBlocker:GetName(), "tower_blocker_radiant_start" ) or string.find( hBlocker:GetName(), "tower_blocker_radiant_end" ) or
			string.find( hBlocker:GetName(), "tower_blocker_dire_start" ) or string.find( hBlocker:GetName(), "tower_blocker_dire_end" ) then
			hBlocker:SetEnabled( boolean )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Tower:DestroyEnemyTower()
	local targetUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.hHero:GetAbsOrigin(), self.hUnit, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #targetUnits > 0 then
		for _,target in pairs( targetUnits ) do
			if target:GetUnitName() == "npc_dota_badguys_tower1_mid" then
				UTIL_Remove( target )
			end
		end
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_Tower
