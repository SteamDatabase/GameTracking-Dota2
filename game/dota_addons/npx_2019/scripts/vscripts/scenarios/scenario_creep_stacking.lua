require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )
require( "tasks/task_attack_stack_target" )
require( "tasks/task_stack_target" )

--------------------------------------------------------------------

if CDotaNPXScenario_CreepStacking == nil then
	CDotaNPXScenario_CreepStacking = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:InitScenarioKeys()
	self.hHeroSpawn = Entities:FindByName( nil, "hero_spawn_location" )
	self.hHeroLoc1 = Entities:FindByName( nil, "hero_location_1" )
	self.hHeroLoc2 = Entities:FindByName( nil, "hero_location_2" )
	self.hNeutralLoc1 = Entities:FindByName( nil, "neutral_location_1" )
	self.hNeutralLoc2 = Entities:FindByName( nil, "neutral_location_2" )
	self.hTimerLoc = Entities:FindByName( nil, "timer_location" )
	self.hEndLoc1 = Entities:FindByName( nil, "end_location_1" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_vengefulspirit",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_boots",
		},
		StartingAbilities   =
		{			
		},

		ScenarioTimeLimit = 0, -- Not Timed.
	}

	self.nCheckpoint = 0
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SetupScenario()
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

	self.bAttackCamp3IsActive = false

	self.AlchemistSpawner = CDotaSpawner( "teammate_spawner", 
	{
		{
			EntityName = "npc_dota_hero_alchemist",
			Team = DOTA_TEAM_GOODGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				PlayerID = 1,
				BotName = "Alchemist",
				EntityScript = "ai/creep_stacking/ai_creep_stacking_alchemist.lua",
				StartingHeroLevel = 8,
				StartingItems = 
				{
					"item_bfury",
					"item_power_treads",
				},
				AbilityBuild = 
				{
					AbilityPriority = { 
					"alchemist_acid_spray",
					},
				},
			},
		},
	}, self, false )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_TOP_TIMEOFDAY, false )

	if self.nCheckpoint == 1 then
		printf( "CHECKPOINT 1" )
		local bForceStart = true
		self:CheckpointSkipCompleteTask( "move_to_location_1", true, bForceStart )
		self:CheckpointSkipCompleteTask( "attack_neutral_creep_1", true )
		self:CheckpointSkipCompleteTask( "lead_neutral_creep_1", true )
		self:SetupStage3()
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
	self.hHero:SetAbilityPoints( 0 )
	self:ShowWizardTip( "scenario_creep_stacking_wizard_tip_intro", 15.0 )
	self:BlockPlayer( false )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SetupTasks()
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
			return GameRules.DotaNPX:IsTaskComplete( "lead_neutral_creep_1" )
		end,
	}, self ), 0.0 )

	local attackNeutralCreep1 = rootTask:AddTask( CDotaNPXTask_AttackStackTarget( {
		TaskName = "attack_neutral_creep_1",
		TaskType = "task_attack_stack_target",
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

	local leadNeutralCreep1 = rootTask:AddTask( CDotaNPXTask_StackTarget( {
		TaskName = "lead_neutral_creep_1",
		TaskType = "task_stack_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			CampTrigger = "camp_trigger",
			EnableRelay = "camp_trigger_enable_relay",
			DisableRelay = "camp_trigger_disable_relay",
			GoalLocation = self.hHeroLoc2:GetAbsOrigin(),
			GoalDistance = 200,
			TimeRequirement = false,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "attack_neutral_creep_1" )
		end,
	}, self ), 0.0 )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SetupStage2()
	print( "Stage 2" )
	self:Fade( 0 )
	local stage1Units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetPlayerHero():GetOrigin(), self:GetPlayerHero(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #stage1Units > 0 then
		for _,unit in pairs( stage1Units ) do
			if unit:GetUnitName() == "npc_dota_neutral_kobold" or unit:GetUnitName() == "npc_dota_neutral_ogre_mauler" or unit:GetUnitName() == "npc_dota_neutral_ogre_magi" then
				UTIL_Remove( unit )
			end
		end
	else
		print("No Stage 1 units found")
	end
	local vPlayerStartLoc = self.hHeroSpawn:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	self:BlockPlayer( true )
	local vLoc = self.hNeutralLoc1:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vLoc.x .. " " .. vLoc.y .. " " .. 1 )
	self:ShowStackTimer( 55, 8 )
	--self:SetupStage2Tasks()
	self:ShowWizardTip( "scenario_creep_stacking_wizard_tip_respawn", 15.0 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 4, function()
		self:SpawnNewNeutralCamp()
	end )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 9, function()
		self:Fade( 1 )
		self:SetupStage3()
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SetupStage3()
	print( "Stage 3" )
	self:Fade( 0 )
	local stage2Units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self:GetPlayerHero():GetOrigin(), self:GetPlayerHero(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #stage2Units > 0 then
		for _,unit in pairs( stage2Units ) do
			if unit:GetUnitName() == "npc_dota_neutral_kobold" or unit:GetUnitName() == "npc_dota_neutral_ogre_mauler" or unit:GetUnitName() == "npc_dota_neutral_ogre_magi" then
				UTIL_Remove( unit )
			end
		end
	else
		print("No Stage 2 units found")
	end
	local vPlayerStartLoc = self.hHeroSpawn:GetAbsOrigin()
	self:GetPlayerHero():Stop()
	FindClearSpaceForUnit( self:GetPlayerHero(), vPlayerStartLoc, true )
	self:BlockPlayer( false )
	--SendToConsole( "dota_camera_lerp_position " .. vPlayerStartLoc.x .. " " .. vPlayerStartLoc.y .. " " .. 1 )
	SendToConsole( "+dota_camera_center_on_hero" )
	SendToConsole( "-dota_camera_center_on_hero" )
	self:ShowWizardTip( "scenario_creep_stacking_wizard_tip_stacking_time", 15.0 )
	--self:HintWorldText( self.hTimerLoc:GetAbsOrigin(), "stacking_time", 89, 1 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
		self:SetupStage3Tasks()
	end )
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SetupStage3Tasks()
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
			--return GameRules.DotaNPX:IsTaskComplete( "lead_neutral_creep_2" )
			return true
		end,
	}, self ), 0.0 )

	local attackNeutralCreep3 = rootTask:AddTask( CDotaNPXTask_AttackStackTarget( {
		TaskName = "attack_neutral_creep_3",
		TaskType = "task_attack_stack_target",
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

	local leadNeutralCreep3 = rootTask:AddTask( CDotaNPXTask_StackTarget( {
		TaskName = "lead_neutral_creep_3",
		TaskType = "task_stack_target",
		UseHints = true,
		TaskParams =
		{
			EntityName = "npc_dota_neutral_kobold",
			CampTrigger = "camp_trigger",
			EnableRelay = "camp_trigger_enable_relay",
			DisableRelay = "camp_trigger_disable_relay",
			GoalLocation = self.hHeroLoc2:GetAbsOrigin(),
			GoalDistance = 200,
			TimeRequirement = true,
		},
		CheckTaskStart =
		function() 
			return GameRules.DotaNPX:IsTaskComplete( "attack_neutral_creep_3" )
		end,
	}, self ), 0.0 )

end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	if event.task_name == "move_to_location_1" then
		--self:HintWorldText( self.hTimerLoc:GetAbsOrigin(), "camp_borders", 89, -1 )
		self:ShowCampBoundingArea()
	elseif event.task_name == "attack_neutral_creep_3" then
		self.bAttackCamp3IsActive = true
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10.0, function()
			self:CheckCampStatus()
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if event.checkpoint_skip == 1 then
		printf( "Checkpoint Skipping past the task completed logic for \"%s\"", Task:GetTaskName() )
		return
	end

	if event.task_name == "move_to_location_1" then
		local vCampPos = self.hNeutralLoc1:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vCampPos.x .. " " .. vCampPos.y .. " " .. 1 )
		self:ShowWizardTip( "scenario_creep_stacking_wizard_tip_chase", 15.0 )
	elseif event.task_name == "attack_neutral_creep_1" then
		self:ShowWizardTip( "scenario_creep_stacking_wizard_tip_out", 15.0 )
	elseif event.task_name == "lead_neutral_creep_1" then
		if event.success == 1 then
			--self:EndHintWorldText( self.hTimerLoc:GetAbsOrigin() ) 
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				self:Fade( 1 )
			end )
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3, function()
				self:SetupStage2()
			end )
		end
	elseif event.task_name == "move_to_location_2" then
		local vCampPos = self.hNeutralLoc1:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vCampPos.x .. " " .. vCampPos.y .. " " .. 1 )
		self:SpawnNeutralCreeps()
	elseif event.task_name == "lead_neutral_creep_2" then
		self:SpawnNewNeutralCamp()
		local vCampPos = self.hNeutralLoc1:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vCampPos.x .. " " .. vCampPos.y .. " " .. 1 )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
			self:Fade( 1 )
		end )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3, function()
			self:SetupStage3()
		end )
	elseif event.task_name == "move_to_location_3" then
		self.nCheckpoint = 1
		local vCampPos = self.hNeutralLoc1:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vCampPos.x .. " " .. vCampPos.y .. " " .. 1 )
		self:SpawnNeutralCreeps()
		self:ShowStackTimer( 50, 10 )
	elseif event.task_name == "attack_neutral_creep_3" then
		self.bAttackCamp3IsActive = false
	elseif event.task_name == "lead_neutral_creep_3" then
		if event.success == 1 then
			--self:EndHintWorldText( self.hTimerLoc:GetAbsOrigin() ) 
			self:SpawnNewNeutralCamp()
			local vCampPos = self.hNeutralLoc1:GetAbsOrigin()
			SendToConsole( "dota_camera_lerp_position " .. vCampPos.x .. " " .. vCampPos.y .. " " .. 1 )
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
				self:SpawnTeammate()
			end )
			self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 10, function()
				self:SetupEnding()
				self:OnScenarioRankAchieved( 1 )
			end )
		end
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SetupEnding()
	print( "Ending" )
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
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:ShowStackTimer( nTimer, fDuration)
	FireGameEvent( "timer_set", { timer_header = "scenario_creep_stacking_timer_header", timer_value = nTimer } )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + fDuration, function()
		FireGameEvent( "timer_hide", {} )
	end )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:CheckCampStatus()
	print( "Failed to attack creep in time" )
	if self.bAttackCamp3IsActive == true then
		self:OnScenarioComplete( false, "scenario_creep_pulling_failure_did_not_attack_in_time" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SpawnNeutralCreeps()
	print( "Spawning Neutral Creep Camp" )
	-- Could not pull the wave if the team was set to DOTA_TEAM_NEUTRALS?
	for i = 1, 3 do
	    CreateUnitByName( "npc_dota_neutral_kobold", self.hNeutralLoc1:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	end
	--CreateUnitByName( "npc_dota_neutral_kobold_tunneler", self.hNeutralLoc1:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SpawnNewNeutralCamp()
	print( "Spawning New Neutral Camp" )
	for i = 1, 2 do
	    CreateUnitByName( "npc_dota_neutral_ogre_mauler", self.hNeutralLoc1:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	end
	local hOgreUnit = CreateUnitByName( "npc_dota_neutral_ogre_magi", self.hNeutralLoc1:GetAbsOrigin() + RandomVector( RandomFloat( 0, 100 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
	self.nRespawnParticle = ParticleManager:CreateParticle( "particles/neutral_fx/roshan_spawn.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.nRespawnParticle, 0, self.hNeutralLoc1:GetAbsOrigin() )
	EmitSoundOn( "NeutralLootDrop.Spawn", hOgreUnit )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:ShowCampBoundingArea()
	print( "Camp FX" )
	local hCampCorner1 = Entities:FindByName( nil, "camp_bounding_area_1" )
	local hCampCorner2 = Entities:FindByName( nil, "camp_bounding_area_2" )
	local hCampCorner3 = Entities:FindByName( nil, "camp_bounding_area_3" )
	local hCampCorner4 = Entities:FindByName( nil, "camp_bounding_area_4" )
	self.nCampParticle1 = ParticleManager:CreateParticle( "particles/ui_mouseactions/bounding_area_view.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.nCampParticle1, 0, hCampCorner1:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.nCampParticle1, 1, hCampCorner2:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.nCampParticle1, 2, hCampCorner3:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.nCampParticle1, 3, hCampCorner4:GetAbsOrigin() )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:SpawnTeammate()
	print( "Spawning Teammate" )
	self.AlchemistSpawner:SpawnUnits()
	local hTeammateLoc = Entities:FindByName( nil, "teammate_spawner" )
	local vTeammatePos = hTeammateLoc:GetAbsOrigin()
	SendToConsole( "dota_camera_lerp_position " .. vTeammatePos.x .. " " .. vTeammatePos.y .. " " .. 1 )
	self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 2, function()
		local vCampPos = self.hEndLoc1:GetAbsOrigin()
		SendToConsole( "dota_camera_lerp_position " .. vCampPos.x .. " " .. vCampPos.y .. " " .. 1 )
	end )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:Fade( nFade )
	-- Fade should be 1 to fade to black and 0 to fade in
	FireGameEvent("fade_to_black", {
		fade_down = nFade,
		} )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_CreepStacking:BlockPlayer( boolean )
	self.hStartBlockers = Entities:FindAllByClassname( "tutorial_npc_blocker" )
	for _,hBlocker in pairs ( self.hStartBlockers ) do
		hBlocker:SetEnabled( boolean )
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_CreepStacking
