require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_attack_target" )
require( "tasks/task_move_to_location" )
require( "tasks/task_select_unit" )

--------------------------------------------------------------------

if CDotaNPXScenario_Intro == nil then
	CDotaNPXScenario_Intro = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Intro:InitScenarioKeys()
	self.heroStartPosition = Vector( -3000, -2350, 256 )

	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 5 )
	GameRules:SetCreepSpawningEnabled( false )
	SendToConsole( "dota_camera_set_position " .. self.heroStartPosition.x .. " " .. self.heroStartPosition.y )

	local CAMERA_LERP_TIME = 0.25
	local FIRST_TASK_START_DELAY = 1.5
	local TASK_START_DELAY = 0.5
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_phantom_assassin",
		Team 				= DOTA_TEAM_GOODGUYS,
		ScenarioTimeLimit 	= 0, -- Not timed.
		StartingItems 		= {}, -- No items.
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_Intro:SetupTasks()
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
	local learnMovementTask = rootTask:AddTask( self:SetupTasks_Movement(), FIRST_TASK_START_DELAY )
	local attackTargetTask = rootTask:AddTask( CDotaNPXTask_AttackTarget( {
		TaskName = "attack_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_custom_target_dummy",
			SpawnPos = Vector( -320, -1530, 256 ),
			SpawnAngles = { 0, -135, 0 },
		},
	}, self ), 0.25 )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Intro:SetupTasks_Movement()
	local CAMERA_LERP_TIME = 0.25
	local TASK_START_DELAY = 0.5

	local movementTask = CDotaNPXTask_Sequence( {
		TaskName = "move_to_location_segment"
	}, self )

	-- Move 1
	local moveToLocation_1 = movementTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_1",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = Vector( -2230, -1865, 256 ),
			GoalDistance = 64,
		},
	}, self ), 0 )

	moveToLocation_1.StartTask = function( task )
		CDotaNPXTask_MoveToLocation.StartTask( task )
		SendToConsole( "+dota_camera_center_on_hero" )
		SendToConsole( "-dota_camera_center_on_hero" )
		task:GetScenario():HintWorldText( task.hTaskInfo.TaskParams.GoalLocation, "how_to_move", -1, -1 )
		CustomGameEventManager:Send_ServerToAllClients( "display_hint", { hint_text = "narration_move", duration = 0 } )
	end

	moveToLocation_1.CompleteTask = function( task, bSuccess )
		if bSuccess then
			SendToConsole( "dota_camera_lerp_position " .. task.hTaskInfo.TaskParams.GoalLocation.x .. " " .. task.hTaskInfo.TaskParams.GoalLocation.y .. " " .. CAMERA_LERP_TIME )
		end
		CDotaNPXTask_MoveToLocation.CompleteTask( task, bSuccess )
	end
		
	moveToLocation_1.UnregisterTaskEvent = function( task )
		task:GetScenario():EndHintWorldText( task.hTaskInfo.TaskParams.GoalLocation )
		CustomGameEventManager:Send_ServerToAllClients( "hide_hint", {} )
		CDotaNPXTask_MoveToLocation.UnregisterTaskEvent( task )
	end


	-- Move 2
	local moveToLocation_2 = movementTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_2",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = Vector( -1660, -2160, 256 ),
			GoalDistance = 64,
		},
	}, self ), TASK_START_DELAY )

	moveToLocation_2.StartTask = function( task )
		CDotaNPXTask_MoveToLocation.StartTask( task )
		task:GetScenario():HintWorldText( task.hTaskInfo.TaskParams.GoalLocation, "how_to_move", -1, -1 )
	end
	
	moveToLocation_2.CompleteTask = function( task, bSuccess )
		if bSuccess then
			SendToConsole( "dota_camera_lerp_position " .. task.hTaskInfo.TaskParams.GoalLocation.x .. " " .. task.hTaskInfo.TaskParams.GoalLocation.y .. " " .. CAMERA_LERP_TIME )
		end
		CDotaNPXTask_MoveToLocation.CompleteTask( task, bSuccess )
	end

	moveToLocation_2.UnregisterTaskEvent = function( task )
		task:GetScenario():EndHintWorldText( task.hTaskInfo.TaskParams.GoalLocation )
		CDotaNPXTask_MoveToLocation.UnregisterTaskEvent( task )
	end


	-- Move 3
	local moveToLocation_3 = movementTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_3",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = Vector( -610, -1980, 256 ),
			GoalDistance = 64,
		},
	}, self ), TASK_START_DELAY )

	moveToLocation_3.StartTask = function( task )
		CDotaNPXTask_MoveToLocation.StartTask( task )
		task:GetScenario():HintWorldText( task.hTaskInfo.TaskParams.GoalLocation, "how_to_move", -1, -1 )
		CustomGameEventManager:Send_ServerToAllClients( "display_hint", { hint_text = "narration_fow", duration = 0 } )
	end
	
	moveToLocation_3.CompleteTask = function( task, bSuccess )
		if bSuccess then
			SendToConsole( "dota_camera_lerp_position " .. task.hTaskInfo.TaskParams.GoalLocation.x .. " " .. task.hTaskInfo.TaskParams.GoalLocation.y .. " " .. CAMERA_LERP_TIME )
		end
		CDotaNPXTask_MoveToLocation.CompleteTask( task, bSuccess )
	end

	moveToLocation_3.UnregisterTaskEvent = function( task )
		task:GetScenario():EndHintWorldText( task.hTaskInfo.TaskParams.GoalLocation )
		CustomGameEventManager:Send_ServerToAllClients( "hide_hint", {} )
		CDotaNPXTask_MoveToLocation.UnregisterTaskEvent( task )
	end


	return movementTask
end

--------------------------------------------------------------------

function CDotaNPXScenario_Intro:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Intro:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )

	FindClearSpaceForUnit( hHero, self.heroStartPosition, true )
	local nAbilityCount = self.hPlayerHero:GetAbilityCount()
	for i = 0, nAbilityCount-1 do
		if self.hPlayerHero:GetAbilityPoints() > 0 then
			local hAbility = self.hPlayerHero:GetAbilityByIndex( i )
			if hAbility ~= nil then
				if hAbility:CanAbilityBeUpgraded() then
					self.hPlayerHero:UpgradeAbility( hAbility )
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Intro:Start()
	CDotaNPXScenario.Start( self )

	FindClearSpaceForUnit( self.hPlayerHero, self.heroStartPosition, true )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
end


--------------------------------------------------------------------

function CDotaNPXScenario_Intro:OnThink()
	CDotaNPXScenario.OnThink( self )
	if self.hPlayerHero ~= nil then
		Msg( "Hero is at:" .. tostring( self.hPlayerHero:GetAbsOrigin() ) .. "\n" )
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_Intro