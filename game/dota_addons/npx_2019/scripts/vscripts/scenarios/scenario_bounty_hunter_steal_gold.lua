require( "npx_scenario" )

--------------------------------------------------------------------

if CDotaNPXScenario_BountyHunterStealGold == nil then
	CDotaNPXScenario_BountyHunterStealGold  = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_BountyHunterStealGold:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 1.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_bounty_hunter",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,

		ScenarioTimeLimit = 20.0,
		Queries =
		{
			bounty_hunter_gold_stolen =
			{
				QueryType = NPX_QUERY_TYPE.SUCCESS,
				QueryTable = CDotaNPX:GenerateKilleaterQueryTable( 807, "sum" ),		
				Vars =
				{
					{
						VarName = "<killeater_count>",
						Values =
						{
							12,
							24,
							36,
						},
					},
				},
				ProgressGoals = 
				{
					12,
					24,
					36,
				},
			},
		},

		Spawners =
		{
			{
				SpawnerName = "pudge_spawner",
				NPCs = 
				{
					{
						EntityName = "npc_dota_hero_pudge",
						Team = DOTA_TEAM_BADGUYS,
						Count = 1,
						SpawnTime = 0.0,
					},
					{
						EntityName = "npc_dota_hero_bounty_hunter",
						Team = DOTA_TEAM_BADGUYS,
						Count = 3,
						SpawnTime = 10.0,
					},
				},
			},
			{
				SpawnerName = "slark_spawner",
				NPCs = 
				{
					{
						EntityName = "npc_dota_hero_slark",
						Team = DOTA_TEAM_GOODGUYS,
						HeroLevel = 5,
						AbilityLevels =
						{
							slark_dark_pact = 2,
							slark_pounce = 2,
							slark_essence_shift = 1,
						},
						Count = 1,
						SpawnTime = 0.0,
					},
				}
			},
		},
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_BountyHunterStealGold:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

return CDotaNPXScenario_BountyHunterStealGold