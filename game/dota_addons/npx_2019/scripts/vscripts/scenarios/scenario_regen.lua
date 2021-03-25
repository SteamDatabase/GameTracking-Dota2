require( "npx_scenario" )
require( "tasks/task_buy_item" )
require( "tasks/task_regen" )

--------------------------------------------------------------------

if CDotaNPXScenario_Regen == nil then
	CDotaNPXScenario_Regen = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Regen:InitScenarioKeys()
	self.nTangoHealthDrop = 300
	self.bDidLionFire = false
	self.hReplenishing = {}
	local this = self
	self.hScenario =
	{
		PreGameTime 			= 0,
		HeroSelectionTime 		= 0.0,
		StrategyTime 			= 0.0,
		DayNightCycleDisabled	= true,
		ScenarioTimeLimit		= 0,
		ForceHero 				= "npc_dota_hero_viper",
		Team 					= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel		= 5,
		StartingGold			= 0,
		StartingMana			= 50,
		StartingItems 			=
		{
		},
		StartingAbilities   =
		{
			"viper_corrosive_skin",
			"viper_nethertoxin",
			"viper_corrosive_skin",
			"viper_nethertoxin",
			"viper_corrosive_skin",
		},
		Tasks =
		{
			{
				TaskName = "buy_regen",
				TaskType = "task_parallel",
				Hidden = true,
				TaskParams = {},
				CheckTaskStart = function() return GameRules:GetGameTime() > 5 end
			},
			{
				TaskName = "use_clarity",
				TaskType = "task_use_ability",
				UseHints = true,
				TaskParams =
                {
                    AbilityName = "item_clarity"
                },
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_regen" )
				end,
			},
			{
				TaskName = "use_tango",
				TaskType = "task_use_ability",
				UseHints = true,
				TaskParams =
                {
                    AbilityName = "item_tango"
                },
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "use_clarity" )
				end,
			},
			{
				TaskName = "share_tango",
				TaskType = "task_share_item",
				UseHints = true,
				TaskParams =
                {
                    ItemName = "item_tango_single",
                    ReceivingHero = "npc_dota_hero_lina",
                },
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "use_tango" )
				end,
			},
			{
				TaskName = "use_salve",
				TaskType = "task_use_ability",
				UseHints = true,
				TaskParams =
                {
                    AbilityName = "item_flask"
                },
				CheckTaskStart =
				function()
					return this.bDidLionFire
				end,
			},
			{
				TaskName = "regen_full",
				TaskType = "task_parallel",
				Hidden = true,
				TaskParams = {},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "use_salve" )
				end,
			},
		},

		Queries =
		{
		},
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_Regen:SetupTasks()
	CDotaNPXScenario.SetupTasks( self )

	local buyTask = self:GetTask( "buy_regen" )

	buyTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_clarity",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_clarity",
			PreCheck = true,
		},
		CheckTaskStart = function() return true end,
	}, self ) )

	buyTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_tango",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_tango",
			PreCheck = true,
		},
		CheckTaskStart = function() return true end,
	}, self ) )

	buyTask:AddTask( CDotaNPXTask_BuyItem( {
		TaskName = "buy_salve",
		UseHints = true,
		TaskParams =
		{
			ItemName = "item_flask",
			PreCheck = true,
		},
		CheckTaskStart = function() return true end,
	}, self ) )
	

	local regenTask = self:GetTask( "regen_full" )

	regenTask:AddTask( CDotaNPXTask_Regen( {
		TaskName = "regen_self",
		TaskParams =
		{
			HealthPercent = 100,
			ManaPercent = 100,
		},
		CheckTaskStart = function() return true end,
	}, self ) )

	regenTask:AddTask( CDotaNPXTask_Regen( {
		TaskName = "regen_lina",
		TaskParams =
		{
			HealthPercent = 100,
			ManaPercent = 100,
		},
		CheckTaskStart = function() return true end,
	}, self ) )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Regen:SetupScenario()
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
	
	GameRules:AddItemToWhiteList( "item_clarity" )
	GameRules:AddItemToWhiteList( "item_tango" )
	GameRules:AddItemToWhiteList( "item_flask" )
	GameRules:SetWhiteListEnabled( true )

	Tutorial:StartTutorialMode()
	Tutorial:SetItemGuide( "item_build_regen" )


end

--------------------------------------------------------------------

function CDotaNPXScenario_Regen:OnHeroFinishSpawn( hHero, hPlayer )
	self.hHero = hHero
	self.hHero:SetHealth( self.hHero:GetMaxHealth() - self.nTangoHealthDrop )
	self:GetTask("regen_self"):SetRegenUnit( hHero )

	self:ShowWizardTip( "scenario_regen_wizard_tip_intro", 10.0 )

	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Regen:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )
	
	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end
	
	if Task:GetTaskName() == "buy_regen" then
		self:ShowUIHint( "ShopButton", nil, 0, "DOTAHUDShopOpened" )
		self.hHero:SetGold( GetCostOfItem( "item_clarity" ) + GetCostOfItem( "item_tango" ) + GetCostOfItem( "item_flask" ), true )
	elseif Task:GetTaskName() == "use_clarity" then
		self:ShowWizardTip( "scenario_regen_wizard_tip_clarity", 10.0 )
	elseif Task:GetTaskName() == "use_tango" then
		self:ShowWizardTip( "scenario_regen_wizard_tip_tango", 10.0 )
	elseif Task:GetTaskName() == "use_salve" then
		self:ShowWizardTip( "scenario_regen_wizard_tip_salve", 10.0 )
	elseif Task:GetTaskName() == "regen_full" then
		self:ReplenishItem( "item_clarity", 10, false, true )
		self:ReplenishItem( "item_tango", 10, false, true )
		self:ReplenishItem( "item_flask", 10, false, true )
		self:HideUIHint()
		self:ScheduleFunctionAtGameTime(GameRules:GetDOTATime( false, false ) + 5.0, function()
			self:ShowWizardTip( "scenario_regen_wizard_tip_regen", 20.0 )
		end )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Regen:OnTaskCompleted( event )
	if event.task_name == "buy_clarity" then
		GameRules:RemoveItemFromWhiteList( "item_clarity" )
	elseif event.task_name == "buy_tango" then
		GameRules:RemoveItemFromWhiteList( "item_tango" )
	elseif event.task_name == "buy_flask" then
		GameRules:RemoveItemFromWhiteList( "item_flask" )
	elseif event.task_name == "buy_regen" then
		local nTangoHealthDrop = self.nTangoHealthDrop
		CDotaSpawner( "ally_spawn_location",
		{
			{
				EntityName = "npc_dota_hero_lina",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0,
				StartingMana = 400,
				BotPlayer =
				{
					BotName = "Lina",
					EntityScript = "ai/regen/ai_regen_lina.lua",
					StartingHeroLevel = 6,
					StartingItems = {},
					AbilityBuild = { "lina_laguna_blade" },
				},
				PostSpawn = function( hHero )
					hHero:SetHealth( 200 )
					GameRules.DotaNPX:GetTask("regen_lina"):SetRegenUnit( hHero )
				end
			},
		}, self, true )
    elseif event.task_name == "share_tango" then
		self:HideUIHint()
		CDotaSpawner( "enemy_spawn_location",
		{
			{
				EntityName = "npc_dota_hero_lion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0,
				BotPlayer =
				{
					BotName = "Lion",
					EntityScript = "ai/regen/ai_regen_lion.lua",
					StartingHeroLevel = 6,
					StartingItems = { "item_blink" },
					AbilityBuild = { "lion_finger_of_death" },
				},
			},
		}, self, true )
	elseif event.task_name == "regen_full" then
		self:ScheduleFunctionAtGameTime(GameRules:GetDOTATime( false, false ) + 2.0, function()
			self:OnScenarioComplete( true )
		end )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Regen:OnThink()
	CDotaNPXScenario.OnThink( self )

	local clarityTask = self:GetTask( "use_clarity" )
	if clarityTask and clarityTask:IsActive() then
		self:ReplenishItem( "item_clarity", 1, true )
	end

	local tangoTask = self:GetTask( "use_tango" )
	if tangoTask and tangoTask:IsActive() then
		self:ReplenishItem( "item_tango", 3, true )
	end

	local tangoTask = self:GetTask( "share_tango" )
	if tangoTask and tangoTask:IsActive() then
		self:ReplenishItem( "item_tango", 3, true )
	end

	local salveTask = self:GetTask( "use_salve" )
	if salveTask and salveTask:IsActive() then
		self:ReplenishItem( "item_flask", 1, true )
	end

	local regenTask = self:GetTask( "regen_full" )
	if regenTask and regenTask:IsActive() then
		self:ReplenishItem( "item_clarity", 10 )
		self:ReplenishItem( "item_tango", 10 )
		self:ReplenishItem( "item_flask", 10 )
	end
end

function CDotaNPXScenario_Regen:ReplenishItem( szItemName, nCharges, bShowHint, bForce )
	if self.hReplenishing[szItemName] == true then
		return
	end

	local hItem = self.hHero:FindItemInInventory( szItemName )
	if hItem == nil or hItem:IsNull() or hItem:GetCurrentCharges() == 0 or ( bForce and hItem:GetCurrentCharges() ~= nCharges ) then
		local hHero = self.hHero
		local this = self
		self.hReplenishing[szItemName] = true
		local nDelay = bForce and 0 or 2
		self:ScheduleFunctionAtGameTime( GameRules:GetDOTATime( false, false ) + nDelay, function()
			self.hReplenishing[szItemName] = nil
			
			if hItem == nil or hItem:IsNull() or hItem:GetCurrentCharges() == 0 then
				hItem = hHero:AddItemByName( szItemName )
			end

			if hItem ~= nil then
				EmitSoundOn( "NeutralLootDrop.Spawn", self.hHero )
				hItem:SetCurrentCharges( nCharges )
				if bShowHint then
					this:ShowItemHint( szItemName )
				end
			end
		end )
	elseif bShowHint == true then
		self:ShowItemHint( szItemName )
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Regen:OnTakeDamage( hVictim, hKiller, hInflictor )
	if hInflictor and hInflictor:GetAbilityName() == "lion_finger_of_death" then
		self.bDidLionFire = true
	end
end

----------------------------------------------------------------------------

function CDotaNPXScenario_Regen:ShowItemHint( szItemName )
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

return CDotaNPXScenario_Regen