require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )

--------------------------------------------------------------------

if CDotaNPXScenario_Navigation == nil then
	CDotaNPXScenario_Navigation = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Navigation:InitScenarioKeys()
	self.hTargetLoc1 = Entities:FindByName( nil, "target_location_1" )
	self.hTargetLoc2 = Entities:FindByName( nil, "target_location_2" )
	self.hTargetLoc3 = Entities:FindByName( nil, "target_location_3" )
	self.hTargetLoc4 = Entities:FindByName( nil, "target_location_4" )
	self.hTargetLoc5 = Entities:FindByName( nil, "target_location_5" )
	self.hTargetLoc6 = Entities:FindByName( nil, "target_location_6" )
	self.hTargetLoc7 = Entities:FindByName( nil, "target_location_7" )
	self.hTargetLoc8 = Entities:FindByName( nil, "target_location_8" )

	self.hHintLoc0 = Entities:FindByName( nil, "hint_location_0" )
	self.hHintLoc1 = Entities:FindByName( nil, "hint_location_1" )
	self.hHintLoc2 = Entities:FindByName( nil, "hint_location_2" )
	self.hHintLoc3 = Entities:FindByName( nil, "hint_location_3" )
	self.hHintLoc4 = Entities:FindByName( nil, "hint_location_4" )
	self.hHintLoc5 = Entities:FindByName( nil, "hint_location_5" )
	self.hHintLoc6 = Entities:FindByName( nil, "hint_location_6" )

	self.hCreepSpawnLoc1 = Entities:FindByName( nil, "radiant_creep_spawn_1" )
	self.hCreepSpawnLoc2 = Entities:FindByName( nil, "radiant_creep_spawn_2" )

	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_mirana",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_phase_boots",
		},
		StartingAbilities   =
		{			
		},

		ScenarioTimeLimit = 0, -- Not Timed.

		Tasks =
		{
			{
				TaskName = "move_to_location_1",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc1:GetAbsOrigin(),
					GoalDistance = 128,
				},
				CheckTaskStart = 
				function() 
					if GameRules:GetDOTATime( false, false ) >= 0.0 then 
						return true 
					else 
						return false 
					end
				end,
			},
			{
				TaskName = "move_to_location_2",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc2:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
			{
				TaskName = "move_to_location_3",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc3:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_2" )
				end,
			},
			{
				TaskName = "move_to_location_4",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc4:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_3" )
				end,
			},
			{
				TaskName = "move_to_location_5",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc5:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_4" )
				end,
			},
			{
				TaskName = "move_to_location_6",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc6:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_5" )
				end,
			},
			{
				TaskName = "learn_mirana_leap",
				TaskType = "task_learn_ability",
				TaskParams = 
				{
					AbilityName = "mirana_leap",
					WhiteList = true,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_6" )
				end,
			},
			{
				TaskName = "move_to_location_7",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc7:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "learn_mirana_leap" )
				end,
			},
			{
				TaskName = "move_to_location_end",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hTargetLoc8:GetAbsOrigin(),
					GoalDistance = 200,
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_7" )
				end,
			},
		},

		Queries =
		{
		},
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_Navigation:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	self.bHasCompleted = false

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:SetTimeOfDay( 0.75 ) -- Daytime
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true ) -- Always daytime
	GameRules:SetHeroRespawnEnabled( false ) -- No respawn
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , false ) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, true ) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, false ) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, false ) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, false ) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, false ) --Arcane
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, false ) --Bounty

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_Navigation, "OnTriggerStartTouch" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Navigation:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Navigation:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	self.hHero = hHero
	self.hHero:SetAbilityPoints( 0 )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Navigation:OnTaskStarted( event )
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	self:HideUIHint()
	if event.task_name == "move_to_location_1" then
		--self:HintWorldText( self.hHintLoc0:GetAbsOrigin(), "move", 89, -1 )
	elseif event.task_name == "move_to_location_2" then
		--self:HintWorldText( self.hHintLoc0:GetAbsOrigin(), "camera", 89, -1 )
		self:ShowUIHint( "PortraitGroup" )
		self:ShowWizardTip( "scenario_navigation_wizard_tip_center_camera", 15.0 )
	elseif event.task_name == "move_to_location_3" then
		-- Phase Boots for speed
		self:EndHintWorldText( self.hHintLoc0:GetAbsOrigin() ) 
		self:ShowItemHint( "item_phase_boots" )
		--self:HintWorldText( self.hHintLoc1:GetAbsOrigin(), "use_boots", 89, -1 )
		self:ShowWizardTip( "scenario_navigation_wizard_tip_phase", 15.0 )
	elseif event.task_name == "move_to_location_4" then
		-- Get Blink Dagger
		self.hHero:AddItemByName( "item_blink" )
		--self:EndHintWorldText( self.hHintLoc1:GetAbsOrigin() ) 
		self:ShowItemHint( "item_blink" )
		--self:HintWorldText( self.hHintLoc2:GetAbsOrigin(), "use_blink", 89, -1 )
		self:ShowWizardTip( "scenario_navigation_wizard_tip_blink", 15.0 )
	elseif event.task_name == "move_to_location_5" then
		-- Phase through units
		self:SpawnCreeps( self.hCreepSpawnLoc1 )
		--self:EndHintWorldText( self.hHintLoc2:GetAbsOrigin() ) 
		self:ShowItemHint( "item_phase_boots" )
		--self:HintWorldText( self.hHintLoc3:GetAbsOrigin(), "use_phase", 89, -1 )
		self:ShowWizardTip( "scenario_navigation_wizard_tip_block", 15.0 )
	elseif event.task_name == "move_to_location_6" then
		-- Haste Rune
		--self:EndHintWorldText( self.hHintLoc3:GetAbsOrigin() ) 
		--self:HintWorldText( self.hHintLoc4:GetAbsOrigin(), "use_haste", 89, -1 )
	elseif event.task_name == "learn_mirana_leap" then
		-- Learn Leap
		self.hHero:SetAbilityPoints( 1 )
		self.hHero:AddNewModifier( self.hHero, nil, "modifier_hero_muted", nil )
		--self:EndHintWorldText( self.hHintLoc4:GetAbsOrigin() ) 
	elseif event.task_name == "move_to_location_7" then
		-- Use Leap
		--self:ShowUIHint( "AbilityButton", "scenario_navigation_ui_tip_use_leap", 0.0, nil)
		--self:HintWorldText( self.hHintLoc5:GetAbsOrigin(), "use_leap", 89, -1 )
		self:ShowWizardTip( "scenario_navigation_wizard_tip_leap", 15.0 )
	elseif event.task_name == "move_to_location_end" then
		-- Get Force Staff
		self.hHero:AddItemByName( "item_force_staff" )
		self.hHero:RemoveModifierByName( "modifier_hero_muted" )
		self:SpawnCreeps( self.hCreepSpawnLoc2 )
		--self:EndHintWorldText( self.hHintLoc5:GetAbsOrigin() ) 
		self:ShowItemHint( "item_force_staff" )
		--self:HintWorldText( self.hHintLoc6:GetAbsOrigin(), "use_force", 89, -1 )
		self:ShowWizardTip( "scenario_navigation_wizard_tip_force", 15.0 )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Navigation:OnTaskCompleted( event )
	if event.task_name == "move_to_location_end" then
		self:OnScenarioRankAchieved( 1 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Navigation:SpawnCreeps( hlocation )
	if hlocation ~= nil then
		for i = 1, 4 do
		    local meleeCreep = CreateUnitByName( "npc_dota_creep_goodguys_melee_upgraded_mega", hlocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
			meleeCreep:AddNewModifier( nil, nil, "modifier_creep_slow", { duration = 10 } )
			FindClearSpaceForUnit( meleeCreep, hlocation:GetAbsOrigin(), true )
		end
		local rangeCreep = CreateUnitByName( "npc_dota_creep_goodguys_ranged_upgraded_mega", hlocation:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
		rangeCreep:AddNewModifier( nil, nil, "modifier_creep_slow", { duration = 10 } )
		FindClearSpaceForUnit( rangeCreep, hlocation:GetAbsOrigin(), true )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Navigation:ShowItemHint( szItemName )
	local hItem = self.hHero:FindItemInInventory( szItemName )
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

return CDotaNPXScenario_Navigation
