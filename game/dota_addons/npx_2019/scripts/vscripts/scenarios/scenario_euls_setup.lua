
require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_modifier_added_to_enemy" )
require( "tasks/task_move_to_location" )

--------------------------------------------------------------------------------

if CDotaNPXScenario_EulsSetup == nil then
	CDotaNPXScenario_EulsSetup = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:InitScenarioKeys()
	self.hInitialPlayerMoveLoc = Entities:FindByName( nil, "initial_player_move_loc" )
	self.fIcePathTimer = GameRules:GetGameTime()
	self.fItemTimer = GameRules:GetGameTime()
	self.bShouldReset = false
	self.hShadowFiend = nil

	self.hScenario =
	{
		DaynightCycleDisabled = true,
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_jakiro",
		StartingHeroLevel	= 1,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_boots",
		},
		StartingAbilities =
		{

		},
		
		ScenarioTimeLimit = 0.0,

		Tasks = 
		{
			{
				TaskName = "move_to_location",
				TaskType = "task_move_to_location",
				UseHints = true,
				TaskParams =
				{
					GoalLocation = self.hInitialPlayerMoveLoc:GetAbsOrigin(),
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
			},

			{ 
				TaskName = "ice_path_shadow_fiend_1",
				TaskType = "task_modifier_added_to_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_jakiro_ice_path_stun",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location" )
				end,
			},

			{ 
				TaskName = "ice_path_shadow_fiend_2",
				TaskType = "task_modifier_added_to_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_jakiro_ice_path_stun",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "ice_path_shadow_fiend_1" )
				end,
			},

			{ 
				TaskName = "ice_path_shadow_fiend_3",
				TaskType = "task_modifier_added_to_enemy",
				UseHints = true,
				TaskParams =
				{
					AbilityName = "modifier_jakiro_ice_path_stun",
					TimesToComplete = 1,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "ice_path_shadow_fiend_2" )
				end,
			},
		}
	}
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_EulsSetup, "OnTriggerStartTouch" ), self)
	self.nPlayerUsedAbilityListener = ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( CDotaNPXScenario_EulsSetup, "OnPlayerUsedAbility" ), self )

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_QUICK_STATS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_KILLCAM, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_BAR, false )




end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnTriggerStartTouch( event )
	printf( "OnTriggerStartTouch" )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero and event.trigger_name == "start_trigger" and event.activator_entindex == hPlayerHero:GetEntityIndex() then

	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	self.hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	local hAbility = self.hPlayerHero:FindAbilityByName( "jakiro_ice_path" )
	ScriptAssert( hAbility ~= nil, "Ability named %s is nil, could not upgrade it!", hAbility:GetAbilityName() )
	if hAbility ~= nil then
		self.hPlayerHero:UpgradeAbility( hAbility )
	end

	local hTeleportItem = self.hPlayerHero:FindItemInInventory( "item_tpscroll" )
	if hTeleportItem ~= nil then
		self.hPlayerHero:RemoveItem(hTeleportItem)
	end

end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_to_location" then
		self.ShadowFiendSpawner = CDotaSpawner( "enemy_waypoint_1",
		{
			{
				EntityName = "npc_dota_hero_nevermore",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Shadow Fiend",
					EntityScript = "ai/euls_setup/ai_euls_setup_shadow_fiend.lua",
					StartingHeroLevel = 6,
					StartingItems = 
					{
						"item_boots",
						"item_vanguard",
					},
					StartingAbilities	= 
					{
						
					}, 
					AbilityBuild = 
					{
						
					},
				},
			},
		}, self, true )

		return
	elseif Task:GetTaskName() == "ice_path_shadow_fiend_1" then
		local hPlayerHero = self:GetPlayerHero()
		RefreshHero( hPlayerHero )
		hPlayerHero:AddItemByName("item_rod_of_atos")

		--self.hShadowFiend:AddItemByName("item_recipe_travel_boots")
		self.hShadowFiend:AddItemByName("item_yasha")

	elseif Task:GetTaskName() == "ice_path_shadow_fiend_2" then
		local hPlayerHero = self:GetPlayerHero()
		RefreshHero( hPlayerHero )
		hPlayerHero:AddItemByName("item_cyclone")

		self.hShadowFiend:AddItemByName("item_blink")

	elseif Task:GetTaskName() == "ice_path_shadow_fiend_3" then
		self:OnScenarioRankAchieved( 1 )
	end


end	
--------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_to_location" then
		self:ShowWizardTip( "scenario_euls_setup_wizard_tip_intro", 15.0 )
	elseif Task:GetTaskName() == "ice_path_shadow_fiend_1" then
		self:ShowWizardTip( "scenario_euls_setup_wizard_tip_ice_path_shadow_fiend_1", 15.0 )
	elseif Task:GetTaskName() == "ice_path_shadow_fiend_2" then
		self:ShowWizardTip( "scenario_euls_setup_wizard_tip_ice_path_shadow_fiend_2", 15.0 )
	elseif Task:GetTaskName() == "ice_path_shadow_fiend_3" then
		self:ShowWizardTip( "scenario_euls_setup_wizard_tip_ice_path_shadow_fiend_3", 15.0 )
	end
end
--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnNPCSpawned( hEnt )
	CDotaNPXScenario:OnEntityKilled( hEnt )	

	if hEnt ~= nil and hEnt:IsNull() == false and hEnt:GetUnitName() == "npc_dota_hero_nevermore" then
		self.hShadowFiend = hEnt
	end
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnEntityKilled( hVictim, hKiller, hInflictor )
	CDotaNPXScenario:OnEntityKilled( hVictim, hKiller, hInflictor )	
end

--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:Restart()

	CDotaNPXScenario.Restart( self )
end


--------------------------------------------------------------------------------
function CDotaNPXScenario_EulsSetup:OnPlayerUsedAbility( event )
	if event.PlayerID == nil or event.PlayerID ~= 0 then
		return
	end

	if  event.abilityname == "jakiro_ice_path" then
		self.bShouldReset = true
		self.fIcePathTimer = GameRules:GetGameTime()
	end


	if  event.abilityname == "item_cyclone" or event.abilityname == "item_rod_of_atos" then
		self.fItemTimer = GameRules:GetGameTime()
		self.bShouldReset = true
	end

end


--------------------------------------------------------------------------------

function CDotaNPXScenario_EulsSetup:OnThink()
	CDotaNPXScenario.OnThink( self )

	if self.bShouldReset == true then
		if self.hShadowFiend ~= nil then
			if self.hShadowFiend:FindModifierByName("modifier_jakiro_ice_path_stun") ~= nil then
				self.bShouldReset = false
			end
		end
	end


	if GameRules:GetGameTime() >= self.fIcePathTimer + 3 and self.bShouldReset == true then
		local hPlayerHero = self:GetPlayerHero()
		if hPlayerHero then
			local hIcePathAbility = hPlayerHero:FindAbilityByName("jakiro_ice_path")
			if hIcePathAbility and hIcePathAbility:GetCooldownTimeRemaining() > 0 then
				self.bShouldReset = false
				RefreshHero( hPlayerHero )

				local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, hPlayerHero )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )


				if GameRules.DotaNPX:IsTaskComplete( "ice_path_shadow_fiend_2" ) then 
					self:ShowWizardTip( "scenario_euls_setup_wizard_tip_ice_path_shadow_fiend_3_missed", 5.0 )
				elseif GameRules.DotaNPX:IsTaskComplete( "ice_path_shadow_fiend_1" ) then
					self:ShowWizardTip( "scenario_euls_setup_wizard_tip_ice_path_shadow_fiend_2_missed", 5.0 )
				elseif GameRules.DotaNPX:IsTaskComplete( "move_to_location" ) then
					self:ShowWizardTip( "scenario_euls_setup_wizard_tip_ice_path_shadow_fiend_1_missed", 5.0 )
				else
					self:ShowWizardTip( "scenario_euls_setup_wizard_tip_ice_path_generic_missed", 5.0 )
				end
			end
		end
	end

	if GameRules:GetGameTime() >= self.fItemTimer + 4.5 and self.bShouldReset == true then
		local hPlayerHero = self:GetPlayerHero()
		if hPlayerHero then
			local hAtosItem = hPlayerHero:FindItemInInventory( "item_rod_of_atos" )
			local hEulsItem = hPlayerHero:FindItemInInventory( "item_cyclone" )
			if ( hAtosItem and hAtosItem:GetCooldownTimeRemaining() > 0 ) or ( hEulsItem and hEulsItem:GetCooldownTimeRemaining() > 0 ) then
				self.bShouldReset = false
				RefreshHero( hPlayerHero )

				local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, hPlayerHero )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				self:ShowWizardTip( "scenario_euls_setup_wizard_tip_item_missed", 5.0 )
			end
		end
	end


end





return CDotaNPXScenario_EulsSetup
