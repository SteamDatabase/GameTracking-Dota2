require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )
require( "tasks/task_attack_pull_target" )
require( "tasks/task_pull_target" )

--------------------------------------------------------------------

if CDotaNPXScenario_CreepPulling == nil then
	CDotaNPXScenario_CreepPulling = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:InitScenarioKeys()
	self.hHeroSpawn = Entities:FindByName( nil, "hero_spawn_location" )
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hHeroLoc2 = Entities:FindByName( nil, "hero_location_2" )
	self.hNeutralLoc1 = Entities:FindByName( nil, "neutral_location_1" )
	self.hLaneCreepSpawner = Entities:FindByName( nil, "creep_location_1" )
	self.hHintLoc1 = Entities:FindByName( nil, "hint_location_1" )
	self.hHintLoc2 = Entities:FindByName( nil, "hint_location_2" )
	self.hDemoHintLoc1 = Entities:FindByName( nil, "demo_hint_good" )
	self.hDemoHintLoc2 = Entities:FindByName( nil, "demo_hint_bad" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_witch_doctor",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_boots",
		},
		StartingAbilities   =
		{			
		},

		ScenarioTimeLimit = 0, -- Timed.
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:SetTimeOfDay( 0.75 ) -- Daytime
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true ) -- Always daytime
	GameRules:SetHeroRespawnEnabled( false ) -- No respawn

	self.bTriggerIsActive = false

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_CreepPulling, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
	self.hHero:SetAbilityPoints( 0 )
	self:ShowWizardTip( "scenario_creep_pulling_wizard_tip_intro1", 5.0 )
	--self:BlockPlayer( true )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 5, function()
		self:ShowWizardTip( "scenario_creep_pulling_wizard_tip_intro2", 5.0 )
	end )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:SetupDemoGood()
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupDemoGood()
	--print("Setting up first Demo")
	self:SpawnDemoCreepWaves( 1 )
	--self:HintWorldText( self.hDemoHintLoc1:GetAbsOrigin(), "good", 89, -1 )
	self:ShowWizardTip( "scenario_creep_pulling_wizard_tip_intro_radiant", 10.0 )
	local hGoodLoc = Entities:FindByName( nil, "radiant_melee_spawner_good" )
	local vDemo1Pos = hGoodLoc:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vDemo1Pos.x .. " " .. vDemo1Pos.y .. " " .. 1 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		self:Fade( 1 )
		self:RemoveDemoCreepWaves()
		--self:EndHintWorldText( self.hDemoHintLoc1:GetAbsOrigin() ) 
		self:SetupDemoBad()
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupDemoBad()
	--print("Setting up second Demo")
	self:Fade( 0 )
	self:SpawnDemoCreepWaves( 2 )
	--self:HintWorldText( self.hDemoHintLoc2:GetAbsOrigin(), "bad", 89, -1 )
	self:ShowWizardTip( "scenario_creep_pulling_wizard_tip_intro_dire", 10.0 )
	local hBadLoc = Entities:FindByName( nil, "radiant_melee_spawner_bad" )
	local vDemo2Pos = hBadLoc:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vDemo2Pos.x .. " " .. vDemo2Pos.y .. " " .. 1 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
		local vPlayerStartLoc = self.hHeroSpawn:GetAbsOrigin()
		self:GetPlayerHero():Stop()
		FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
		SendToConsole( "dota_camera_lerp_position " .. vPlayerStartLoc.x .. " " .. vPlayerStartLoc.y .. " " .. 1 )
		self:RemoveDemoCreepWaves()
		--self:EndHintWorldText( self.hDemoHintLoc2:GetAbsOrigin() ) 
		self:SetupStage1Tasks()
		--self:BlockPlayer( false )
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SpawnDemoCreepWaves( nState )
	print( "Spawning Demo Creep Waves" )
	local hRadiantMeleeSpawner = Entities:FindByName( nil, "radiant_melee_spawner_good" )
	local hRadiantRangeSpawner = Entities:FindByName( nil, "radiant_range_spawner_good" )
	if nState == 2 then
		hRadiantMeleeSpawner = Entities:FindByName( nil, "radiant_melee_spawner_bad" )
		hRadiantRangeSpawner = Entities:FindByName( nil, "radiant_range_spawner_bad" )
	end

	local hDireMeleeSpawner = Entities:FindByName( nil, "dire_melee_spawner_good" )
	local hDireRangeSpawner = Entities:FindByName( nil, "dire_range_spawner_good" )
	if nState == 2 then
		hDireMeleeSpawner = Entities:FindByName( nil, "dire_melee_spawner_bad" )
		hDireRangeSpawner = Entities:FindByName( nil, "dire_range_spawner_bad" )
	end

	for i = 1, 3 do
	    local radiantMelee = CreateUnitByName( "npc_dota_creep_goodguys_melee_pullable", hRadiantMeleeSpawner:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
	end
	local radiantRanged = CreateUnitByName( "npc_dota_creep_goodguys_ranged_pullable", hRadiantRangeSpawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )

	for i = 1, 3 do
	    local direMelee = CreateUnitByName( "npc_dota_creep_badguys_melee_pullable", hDireMeleeSpawner:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	end
	local direRanged = CreateUnitByName( "npc_dota_creep_badguys_ranged_pullable", hDireRangeSpawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )

end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:RemoveDemoCreepWaves()
	local demoUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetPlayerHero():GetOrigin(), self:GetPlayerHero(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #demoUnits > 0 then
		for _,unit in pairs( demoUnits ) do
			if unit:GetUnitName() == "npc_dota_creep_goodguys_melee_pullable" or unit:GetUnitName() == "npc_dota_creep_goodguys_ranged_pullable" or 
				unit:GetUnitName() == "npc_dota_creep_badguys_melee_pullable" or unit:GetUnitName() == "npc_dota_creep_badguys_ranged_pullable" then
				UTIL_Remove( unit )
			end
		end
	else
		print("No Demo units found")
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupStage1Tasks()
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

	local attackNeutralCreep1 = rootTask:AddTask( CDotaNPXTask_AttackPullTarget( {
		TaskName = "attack_neutral_creep_1",
		TaskType = "task_attack_pull_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			SpawnPos = self.hNeutralLoc1:GetAbsOrigin(),
			SpawnAngles = { 0, 315, 0 },
			--Team = "DOTA_TEAM_NEUTRALS", -- Could not pass enum
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
		end,
	}, self ), 0.0 )

	local leadNeutralCreep1 = rootTask:AddTask( CDotaNPXTask_PullTarget( {
		TaskName = "lead_neutral_creep_1",
		TaskType = "task_pull_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			CompanionEntityName = "npc_dota_creep_goodguys_ranged_pullable",
			EntityDistance = 500, -- AttackAcquisitionRange for unit is 500
			GoalLocation = self.hHeroLoc2:GetAbsOrigin(),
			GoalDistance = 500,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "attack_neutral_creep_1" )
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SpawnSingleCreep()
	print( "Spawning single creep" )
	CreateUnitByName( "npc_dota_creep_goodguys_ranged_pullable", self.hLaneCreepSpawner:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupStage2()
	print( "Stage 2" )
	self:Fade( 0 )
	local stage1Units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetPlayerHero():GetOrigin(), self:GetPlayerHero(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #stage1Units > 0 then
		for _,unit in pairs( stage1Units ) do
			if unit:GetUnitName() == "npc_dota_neutral_kobold" or unit:GetUnitName() == "npc_dota_creep_goodguys_melee_pullable" or unit:GetUnitName() == "npc_dota_creep_goodguys_ranged_pullable" then
				UTIL_Remove( unit )
			end
		end
	else
		print("No Stage 1 units found")
	end
	local vPlayerStartLoc = self.hHeroSpawn:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	--SendToConsole( "dota_camera_lerp_position " .. vPlayerStartLoc.x .. " " .. vPlayerStartLoc.y .. " " .. 1 )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	--self:HintWorldText( self.hHintLoc1:GetAbsOrigin(), "pulling_time", 89, -1 )
	self:SetupStage2Tasks()
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupStage2Tasks()
	--print("Setting up Stage 2 tasks")

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 2
	local moveToLocation2 = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_2",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hHeroLoc1:GetAbsOrigin(),
			GoalDistance = 64,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "lead_neutral_creep_1" )
		end,
	}, self ), 0.0 )

	local attackNeutralCreep2 = rootTask:AddTask( CDotaNPXTask_AttackPullTarget( {
		TaskName = "attack_neutral_creep_2",
		TaskType = "task_attack_pull_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			SpawnPos = self.hNeutralLoc1:GetAbsOrigin(),
			SpawnAngles = { 0, 315, 0 },
			--Team = "DOTA_TEAM_NEUTRALS", -- Could not pass enum
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_location_2" )
		end,
	}, self ), 0.0 )

	local leadNeutralCreep2 = rootTask:AddTask( CDotaNPXTask_PullTarget( {
		TaskName = "lead_neutral_creep_2",
		TaskType = "task_pull_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			CompanionEntityName = "npc_dota_creep_goodguys_ranged_pullable",
			EntityDistance = 500, -- AttackAcquisitionRange for unit is 500
			GoalLocation = self.hHeroLoc2:GetAbsOrigin(),
			GoalDistance = 500,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "attack_neutral_creep_2" )
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SpawnSingleCreepMoving()
	print( "Spawning single creep moving" )
	local hLaneCreepMovingSpawner = Entities:FindByName( nil, "lane_creep_moving_spawner" )
	local hLaneCreepPath = Entities:FindByName( nil, "lane_creep_moving_path_1" )
	local hLaneCreepMoving = CreateUnitByName( "npc_dota_creep_goodguys_ranged_pullable", hLaneCreepMovingSpawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
	hLaneCreepMoving:SetInitialGoalEntity( hLaneCreepPath )
	local laneHintArrowRelay = Entities:FindAllByName( "lane_hint_arrow_on_relay" )
	if laneHintArrowRelay ~= nil then
		for _, rRelay in pairs( laneHintArrowRelay ) do
			rRelay:Trigger( nil, nil )
		end
	end
	self.bTriggerIsActive = true

	local hHintPath = Entities:FindByName( nil, "lane_creep_moving_path_2" )
	local vHintPos = hHintPath:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vHintPos.x .. " " .. vHintPos.y .. " " .. 1 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3, function()
		local vPlayerPos = self:GetPlayerHero():GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vPlayerPos.x .. " " .. vPlayerPos.y .. " " .. 1 )
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupStage3()
	print( "Stage 3" )
	self:Fade( 0 )
	local stage2Units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetPlayerHero():GetOrigin(), self:GetPlayerHero(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #stage2Units > 0 then
		for _,unit in pairs( stage2Units ) do
			if unit:GetUnitName() == "npc_dota_neutral_kobold" or unit:GetUnitName() == "npc_dota_creep_goodguys_melee_pullable" or unit:GetUnitName() == "npc_dota_creep_goodguys_ranged_pullable" then
				UTIL_Remove( unit )
			end
		end
	else
		print("No Stage 2 units found")
	end
	local vPlayerStartLoc = self.hHeroSpawn:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	--SendToConsole( "dota_camera_lerp_position " .. vPlayerStartLoc.x .. " " .. vPlayerStartLoc.y .. " " .. 1 )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	self.bTriggerIsActive = false
	self:SetupStage3Tasks()
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupStage3Tasks()
	--print("Setting up Stage 3 tasks")

	local rootTask = CDotaNPXTask_Sequence( {
		TaskName = "root",
		Hidden = true,
	}, self )
	table.insert( self.Tasks, rootTask )
	rootTask.CheckTaskStart = function() return true end

	-- Stage 3
	local moveToLocation3 = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_3",
		TaskType = "task_move_to_location",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = self.hHeroLoc1:GetAbsOrigin(),
			GoalDistance = 64,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "lead_neutral_creep_2" )
		end,
	}, self ), 0.0 )

	local attackNeutralCreep3 = rootTask:AddTask( CDotaNPXTask_AttackPullTarget( {
		TaskName = "attack_neutral_creep_3",
		TaskType = "task_attack_pull_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			SpawnPos = self.hNeutralLoc1:GetAbsOrigin(),
			SpawnAngles = { 0, 315, 0 },
			--Team = "DOTA_TEAM_NEUTRALS", -- Could not pass enum
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "move_to_location_3" )
		end,
	}, self ), 0.0 )

	local leadNeutralCreep3 = rootTask:AddTask( CDotaNPXTask_PullTarget( {
		TaskName = "lead_neutral_creep_3",
		TaskType = "task_pull_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			CompanionEntityName = "npc_dota_creep_goodguys_ranged_pullable",
			EntityDistance = 500, -- AttackAcquisitionRange for unit is 500
			GoalLocation = self.hHeroLoc2:GetAbsOrigin(),
			GoalDistance = 500,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "attack_neutral_creep_3" )
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SpawnCreepWaveMoving()
	print( "Spawning creep wave moving" )
	local hLaneCreepMovingSpawner = Entities:FindByName( nil, "lane_creep_moving_spawner" )
	local hLaneCreepPath = Entities:FindByName( nil, "lane_creep_moving_path_1" )

	for i = 1, 3 do
	    local radiantMelee = CreateUnitByName( "npc_dota_creep_goodguys_melee_pullable", hLaneCreepMovingSpawner:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
		radiantMelee:SetInitialGoalEntity( hLaneCreepPath )
	end
	local radiantRanged = CreateUnitByName( "npc_dota_creep_goodguys_ranged_pullable", hLaneCreepMovingSpawner:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_GOODGUYS )
	radiantRanged:SetInitialGoalEntity( hLaneCreepPath )
	self.bTriggerIsActive = true

	local hHintPath = Entities:FindByName( nil, "lane_creep_moving_path_2" )
	local vHintPos = hHintPath:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vHintPos.x .. " " .. vHintPos.y .. " " .. 1 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3, function()
		local vPlayerPos = self:GetPlayerHero():GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vPlayerPos.x .. " " .. vPlayerPos.y .. " " .. 1 )
	end )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SpawnNeutralCreeps()
	print( "Spawning Neutral Creep Camp" )
	-- Could not pull the wave if the team was set to DOTA_TEAM_NEUTRALS?
	for i = 1, 3 do
	    CreateUnitByName( "npc_dota_neutral_kobold", self.hNeutralLoc1:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	end
	--CreateUnitByName( "npc_dota_neutral_kobold_tunneler", self.hNeutralLoc1:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:SetupEnding()
	print( "Stage 3" )
	local stage3Units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetPlayerHero():GetOrigin(), self:GetPlayerHero(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #stage3Units > 0 then
		for _,unit in pairs( stage3Units ) do
			if unit:GetUnitName() == "npc_dota_neutral_kobold" or unit:GetUnitName() == "npc_dota_creep_goodguys_melee_pullable" or unit:GetUnitName() == "npc_dota_creep_goodguys_ranged_pullable" then
				UTIL_Remove( unit )
			end
		end
	else
		print("No Stage 3 units found")
	end
	self.bTriggerIsActive = false
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	if event.task_name == "move_to_location_1" then
		self:ShowWizardTip( "scenario_creep_pulling_wizard_tip_reason", 15.0 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )
	if event.task_name == "move_to_location_1" then
		self:SpawnSingleCreep()
	elseif event.task_name == "lead_neutral_creep_1" then
		if event.success == 1 then
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
				self:Fade( 1 )
			end )
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				self:SetupStage2()
			end )
		end
	elseif event.task_name == "move_to_location_2" then
		self:SpawnSingleCreepMoving()
		self:ShowWizardTip( "scenario_creep_pulling_wizard_tip_negative", 15.0 )
		--self:HintWorldText( self.hHintLoc2:GetAbsOrigin(), "pulling_time", 89, -1 )
	elseif event.task_name == "lead_neutral_creep_2" then
		if event.success == 1 then
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
				self:Fade( 1 )
			end )
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				self:SetupStage3()
			end )
		end
	elseif event.task_name == "move_to_location_3" then
		self:SpawnNeutralCreeps()
		self:SpawnCreepWaveMoving()
	elseif event.task_name == "lead_neutral_creep_3" then
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 1, function()
			self:SetupEnding()
			self:OnScenarioRankAchieved( 1 )
		end )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:BlockPlayer( boolean )
	self.hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( self.hStartBlockers ) do
		hBlocker:SetEnabled( boolean )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:Fade( nFade )
	-- Fade should be 1 to fade to black and 0 to fade in
	FireGameEvent("fade_to_black", {
		fade_down = nFade,
		} )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepPulling:OnTriggerStartTouch( sTriggerName, sActivator)
	if sTriggerName == "creep_trigger" then
		if self.bTriggerIsActive == true then
			print( "Creeps did not get pulled" )
			self:OnScenarioComplete( false, "scenario_creep_pulling_failure_creeps_did_not_get_pulled" )
		end
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_CreepPulling
