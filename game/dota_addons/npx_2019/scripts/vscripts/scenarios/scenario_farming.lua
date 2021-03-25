require( "npx_scenario" )
require( "spawner" )

--------------------------------------------------------------------

if CDotaNPXScenario_Farming == nil then
	CDotaNPXScenario_Farming = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Farming:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 20.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_sniper",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingHeroLevel	= 1,
		StartingGold		= 500,

		ScenarioTimeLimit = 600.0,

		Tasks =
		{
			{
				TaskName = "learn_shrapnel",
				TaskType = "task_learn_ability",
				TaskParams = 
				{
					AbilityName = "sniper_shrapnel",
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
				TaskName = "buy_boots",
				TaskType = "task_buy_item",
				TaskParams = 
				{
					ItemName = "item_boots",
					WhiteList =
					{
						"item_boots",
					},
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "learn_shrapnel" )
				end,
			},

			{
				TaskName = "move_to_location_1",
				TaskType = "task_move_to_trigger",
				TaskParams =
				{
					TriggerName = "move_to_location_1",
				},
				CheckTaskStart =
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "buy_boots" )
				end,
			},

			{
				TaskName = "kill_creeps",
				TaskType = "task_last_hits",
				TaskParams = 
				{
					Count = 5,
				},
				CheckTaskStart = 
				function() 
					return GameRules.DotaNPX:IsTaskComplete( "move_to_location_1" )
				end,
			},
		},

		Queries =
		{
		},
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_Farming:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	local waveOneSpawner = CDotaSpawner( "enemy_camp_1", 
	{
		{
			EntityName = "npc_dota_creep_badguys_melee",
			Team = DOTA_TEAM_BADGUYS,
			Count = 6,
			PositionNoise = 150.0
		},
		{
			EntityName = "npc_dota_creep_badguys_ranged",
			Team = DOTA_TEAM_BADGUYS,
			Count = 2,
			PositionNoise = 150.0
		}
	}, self )

	self:ScheduleFunctionAtGameTime( 0, function()
		waveOneSpawner:SpawnUnits()

		local rgUnits = waveOneSpawner:GetSpawnedUnits()
		for _,hUnit in pairs( rgUnits ) do
			hUnit:ModifyHealth( 1, nil, false, 0 )
		end
	end )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Farming:OnThink()
	CDotaNPXScenario.OnThink( self )
end

--------------------------------------------------------------------

return CDotaNPXScenario_Farming