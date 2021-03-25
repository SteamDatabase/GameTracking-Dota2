require( "npx_scenario" )

--------------------------------------------------------------------

if CDotaNPXScenario_EarthshakerIntro == nil then
	CDotaNPXScenario_EarthshakerIntro = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_EarthshakerIntro:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_earthshaker",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingItems 		=
		{
		},

		ScenarioTimeLimit = 0, -- Not timed.

		Tasks =
		{

			{
				TaskName = "move_to_location_1",
				TaskType = "task_move_to_trigger",
				TaskParams =
				{
					TriggerName = "move_to_location_1",
				},
				UseHints = true,
				CheckTaskStart =
				function() 
					return true
				end,
			},

			{
				TaskName = "kill_creeps",
				TaskType = "task_kill_units",
				TaskParams = {},
				UseHints = true,
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
		},

		Spawners =
		{
			{
				SpawnerName = "creeps_spawn_1",
				SpawnOnPrecacheComplete = true,
				NPCs = 
				{
					{
						EntityName = "npc_dota_creep_badguys_melee",
						Team = DOTA_TEAM_BADGUYS,
						Count = 3,
						PositionNoise = 225.0,
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseMaxHealth( 30 )
							hNPC:SetMaxHealth( 30 )
						end,

					},
					{
						EntityName = "npc_dota_creep_badguys_ranged",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						PositionNoise = 0.0,
						PostSpawn = 
						function( hNPC )
							hNPC:SetBaseMaxHealth( 30 )
							hNPC:SetMaxHealth( 30 )
						end,

					},
				},
			},
		},

		Queries =
		{
		},
	}

end

--------------------------------------------------------------------

function CDotaNPXScenario_EarthshakerIntro:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_HEROES, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_PANEL, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_MINIMAP, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_PANEL, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_SHOP, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_ITEMS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_COURIER, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_PROTECT, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_INVENTORY_GOLD, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_QUICK_STATS, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_KILLCAM, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_TOP_BAR, false )
end

--------------------------------------------------------------------

function CDotaNPXScenario_EarthshakerIntro:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
end

--------------------------------------------------------------------

function CDotaNPXScenario_EarthshakerIntro:OnTaskStarted( event )
	CDotaNPXScenario.OnTaskStarted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_to_location_1" then
		local Triggers = Entities:FindAllByName( "move_to_location_1" )
		self:HintWorldText( Triggers[1]:GetAbsOrigin(), "how_to_move", 18, -1 )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_EarthshakerIntro:OnTaskCompleted( event )
	CDotaNPXScenario.OnTaskCompleted( self, event )

	local Task = self:GetTask( event.task_name )
	if Task == nil then
		return
	end

	if Task:GetTaskName() == "move_to_location_1" then
		local Triggers = Entities:FindAllByName( "move_to_location_1" )
		self:EndHintWorldText( Triggers[1]:GetAbsOrigin() )
	end

	if Task:GetTaskName() == "kill_creeps" then
		GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_ACTION_PANEL, true )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_EarthshakerIntro:OnSpawnerFinished( event )
	CDotaNPXScenario.OnSpawnerFinished( self, event )

	local Spawner = self:GetSpawner( event.spawner_name )
	if Spawner == nil then
		return
	end

	if event.spawner_name == "creeps_spawn_1" then
		local Task = self:GetTask( "kill_creeps" )
		if Task then
			Task:SetUnitsToKill( Spawner:GetSpawnedUnits() )
		end
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_EarthshakerIntro