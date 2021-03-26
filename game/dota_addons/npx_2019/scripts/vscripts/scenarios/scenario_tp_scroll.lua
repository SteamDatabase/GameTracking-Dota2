require( "npx_scenario" )

--------------------------------------------------------------------

if CDotaNPXScenario_TP_Scroll == nil then
	CDotaNPXScenario_TP_Scroll = class( {}, {}, CDotaNPXScenario )
end

----------------------------------------------------------------------------

function CDotaNPXScenario_TP_Scroll:PrecacheResources()
end

--------------------------------------------------------------------

function CDotaNPXScenario_TP_Scroll:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 			= 0,
		HeroSelectionTime 		= 0.0,
		StrategyTime 			= 0.0,
		DayNightCycleDisabled	= true,
		ScenarioTimeLimit		= 0,
		ForceHero 				= "npc_dota_hero_skeleton_king",
		Team 					= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel		= 5,
		StartingGold			= 1000,
		StartingItems 			=
		{
			"item_power_treads",
			"item_bracer",
		},
		StartingAbilities =
		{
			"skeleton_king_hellfire_blast",
			"skeleton_king_mortal_strike",
			"skeleton_king_hellfire_blast",
			"skeleton_king_mortal_strike",
			"skeleton_king_hellfire_blast",
		},
		Tasks =
		{
			{
				TaskName = "buy_two_tp",
				TaskType = "task_buy_item",
				UseHints = true,
				TaskParams =
				{
					ItemName = "item_tpscroll",
					ItemAmount = 2,
				},
				CheckTaskStart =
				function()
					return true
				end
			},
			{
				TaskName = "teleport_to_tower",
				TaskType = "task_teleport_to_unit",
				UseHints = true,
				TaskParams = { NoFailure = true, NoCameraTakeover = true },
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_two_tp" )
				end,
			},
			{
				TaskName = "stun_tp",
				TaskType = "task_interrupt_ability",
				UseHints = true,
				TaskParams = { AbilityName = "item_tpscroll", FailureReason = "scenario_tp_scroll_task_stun_tp_Failure" },
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "teleport_to_tower" )
				end,
			},
			{
				TaskName = "kill_enemy",
				TaskType = "task_kill_units",
				UseHints = true,
				TaskParams = {},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "stun_tp" )
				end,
			},
		},

		Queries =
		{
		},
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_TP_Scroll:SetupScenario()
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
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	
	GameRules:AddItemToWhiteList( "item_tpscroll" )
	GameRules:SetWhiteListEnabled( true )

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "item_build_tp_scroll" )
	
	for _,hBlocker in pairs ( Entities:FindAllByClassname( "tutorial_npc_blocker" ) ) do
		hBlocker:SetEnabled( true )
	end
	
	for _,hTower in ipairs( Entities:FindAllByClassname( "npc_dota_tower" ) ) do
		if hTower:GetTeam() == DOTA_TEAM_GOODGUYS then
			self.hTower = hTower
			self:GetTask( "teleport_to_tower" ):SetTeleportUnit( self.hTower )
			break
		end
	end
	
	ListenToGameEvent( "dota_hero_teleport_to_unit", Dynamic_Wrap( CDotaNPXScenario_TP_Scroll, "OnTeleportToUnit" ), self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_TP_Scroll:OnHeroFinishSpawn( hHero, hPlayer )
	self.hHero = hHero
	self.vStart = hHero:GetAbsOrigin()

	for i=0,DOTA_MAX_ABILITIES-1 do
		local hAbility = hHero:GetAbilityByIndex(i)
		if hAbility then
			print( "Ability #" .. tostring(i) .. " = " .. hAbility:GetAbilityName() )
		end
	end

	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )

	if hHero then
		local hTP = hHero:FindItemInInventory( "item_tpscroll" )
		if hTP then
			hTP:EndCooldown()
			hHero:RemoveItem( hTP )
		end
	end
end

--------------------------------------------------------------------


function CDotaNPXScenario_TP_Scroll:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	
	if Task:GetTaskName() == "buy_two_tp" then
		self:ShowWizardTip( "scenario_tp_scroll_wizard_tip_intro", 10.0 )
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + 3.0, function ()
			self:ShowUIHint( "StickyItemSlotContainer", "scenario_regen_ui_tip_quick_buy_slot", 7.0, nil )
		end )
	end
	
	if Task:GetTaskName() == "teleport_to_tower" then
		SendToConsole( "dota_camera_lerp_position " .. self.hTower:GetAbsOrigin().x .. " " .. self.hTower:GetAbsOrigin().y .. " " .. 1 )
		self:ScheduleFunctionAtGameTime( GameRules:GetGameTime() + 0.5, function()
			self:ShowWizardTip( "scenario_tp_scroll_wizard_tip_teleport", 10.0 )
			self:ShowUIHint( "inventory_tpscroll_slot" )
		end )
	end

	if Task:GetTaskName() == "stun_tp" then
		self:ShowWizardTip( "scenario_tp_scroll_wizard_tip_stun", 10.0 )
		self:ShowUIHint( "Ability0 AbilityButton" )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_TP_Scroll:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	
	if event.task_name == "buy_two_tp" then
		self.DragonKnightSpawner = CDotaSpawner( "enemy_spawn_location",
		{
			{
				EntityName = "npc_dota_hero_dragon_knight",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Dragon Knight",
					EntityScript = "ai/tp_scroll/ai_tp_scroll_dragon_knight.lua",
					StartingHeroLevel = 2,
					StartingItems = 
					{
						"boots",
					},
					AbilityBuild = 
					{
						AbilityPriority = {
							"dragon_knight_dragon_tail",
						},
					},
				},
				PostSpawn = function( hUnit )
					GameRules.DotaNPX:GetTask( "stun_tp" ):SetTargetCaster( hUnit )
					GameRules.DotaNPX:GetTask( "kill_enemy" ):SetUnitsToKill( { hUnit } )
				end
			},
		}, self, true )

		self.CreepSpawner = CDotaSpawner( "creep_spawn_location",
		{
			{
				EntityName = "npc_dota_neutral_kobold",
				Team = DOTA_TEAM_NEUTRALS,
				Count = 1,
				PositionNoise = 0,
				PostSpawn = function( hUnit )
					hUnit:SetMaxHealth( 4000 )
					hUnit:SetHealth( 4000 )
				end
			},
		}, self, true )

		AddFOWViewer( DOTA_TEAM_GOODGUYS, Entities:FindByName( nil, "enemy_spawn_location" ):GetAbsOrigin(), 250, 999, false )

		return
	elseif event.task_name == "kill_enemy" then
		self:ScheduleFunctionAtGameTime(GameRules:GetDOTATime( false, false ) + 2.0, function()
			self:OnScenarioComplete( true )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_TP_Scroll:OnEntityKilled( hVictim, hKiller, hInflictor )
	CDotaNPXScenario:OnEntityKilled( hVictim, hKiller, hInflictor )

	if hVictim == self.hHero then
		self:ScheduleFunctionAtGameTime(GameRules:GetDOTATime( false, false ) + 2.0, function()
			self:OnScenarioComplete( false )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_TP_Scroll:OnTeleportToUnit( event )
	if self:GetTask( "buy_two_tp" ):IsActive() then
		self.hHero:SetAbsOrigin( self.vStart )
		
		local hTP = self.hHero:FindItemInInventory( "item_tpscroll" )
		if hTP then
			hTP:SetCurrentCharges( hTP:GetCurrentCharges() + 1 )
			hTP:EndCooldown()
		else
			hTP = self.hHero:AddItemByName( "item_tpscroll" )
			if hTP then
				hTP:SetCurrentCharges( 1 )
				hTP:EndCooldown()
			end
		end

		self:ShowWizardTip( "scenario_tp_scroll_wizard_tip_wait", 15.0 )
		EmitGlobalSound( "General.InvalidTarget_Invulnerable" )
	end
end

return CDotaNPXScenario_TP_Scroll