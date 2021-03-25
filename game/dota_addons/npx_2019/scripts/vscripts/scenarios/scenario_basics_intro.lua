require( "npx_scenario" )
require( "tasks/task_sequence" )
require( "tasks/task_move_to_location" )

--------------------------------------------------------------------

if CDotaNPXScenario_BasicsIntro == nil then
	CDotaNPXScenario_BasicsIntro = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_BasicsIntro:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 0.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_phantom_assassin",
		StartingHeroLevel	= 18,
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_phase_boots",
			"item_vanguard",
			"item_bfury",
		},

		ScenarioTimeLimit = 600.0,
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_BasicsIntro:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	self.MiranaSpawner = CDotaSpawner( "mirana_spawn_location", 
	{
		{
			EntityName = "npc_dota_hero_mirana",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				BotName = "POTM",
				EntityScript = "ai/ai_basics_intro_mirana.lua",
				StartingHeroLevel = 18,
				StartingItems = 
				{
					"item_ultimate_scepter",
					"item_ethereal_blade",
					"item_dagon_5",
				},
				AbilityBuild = 
				{
					AbilityPriority = { "mirana_arrow", "mirana_starfall", "mirana_leap" },
				},
			},
		},
	}, self, true )

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXScenario_BasicsIntro, "OnTriggerStartTouch" ), self )
end

function CDotaNPXScenario_BasicsIntro:SetupTasks()
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

	local hMoveBehindTarget = Entities:FindByName( nil, "move_behind_mirana_location" )
	local moveBehindMiranaTask = rootTask:AddTask( CDotaNPXTask_MoveToLocation( {
		TaskName = "move_to_location_1",
		UseHints = true,
		TaskParams =
		{
			GoalLocation = hMoveBehindTarget:GetAbsOrigin(),
			GoalDistance = 64,
		},
	}, self ), 0 )

	return true
end

function CDotaNPXScenario_BasicsIntro:OnTriggerStartTouch( event )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero and event.trigger_name == "mirana_attack_trigger" and event.activator_entindex == hPlayerHero:GetEntityIndex() then
		local hMirana = self.MiranaSpawner:GetSpawnedUnits()[ 1 ]
		hMirana.Bot:SetScriptedAttackTarget( hPlayerHero )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_BasicsIntro:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

return CDotaNPXScenario_BasicsIntro