require( "npx_scenario" )

--------------------------------------------------------------------

if CDotaNPXScenario_Mid1v1 == nil then
	CDotaNPXScenario_Mid1v1 = class( {}, {}, CDotaNPXScenario )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:InitScenarioKeys()
	self.hScenario =
	{
		PreGameTime 		= 0.0,
		HeroSelectionTime 	= 20.0,
		StrategyTime 		= 0.0,
		ForceHero 			= "npc_dota_hero_windrunner",
		Team 				= DOTA_TEAM_GOODGUYS,
		StartingGold		= 0,
		StartingItems 		=
		{
			"item_tango",
			"item_faerie_fire",
			"item_null_talisman",
			"item_branch",
			"item_branch",
			"item_branch",
		},

		ScenarioTimeLimit = 300.0,
		
		Tasks =
		{
			{
				TaskName = "get_last_hits",
				TaskType = "task_last_hits",
				TaskParams = 
				{
					Count = 50,
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
				TaskName = "get_denies",
				TaskType = "task_denies",
				TaskParams = 
				{
					Count = 30,
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
				TaskName = "do_not_die",
				TaskType = "task_fail_player_hero_death",
				TaskParams = 
				{
					Count = 1,
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
		},

		Queries =
		{
			last_hits =
			{
				QueryType = NPX_QUERY_TYPE.SUCCESS,
				QueryTable = CDotaNPX:ConvertTemplateToQueryTable( "last_hits" ),
				Vars =
				{
					{
						VarName = "<target_last_hits>",
						Values =
						{
							10,
							18,
							25,
						},
					},
				},
				ProgressGoals = 
				{
					10,
					18,
					25,
				},
			},

			denies =
			{
				QueryType = NPX_QUERY_TYPE.SUCCESS,
				QueryTable = CDotaNPX:ConvertTemplateToQueryTable( "deny_creeps_ranked" ),
				Vars =
				{
					{
						VarName = "<denies>",
						Values =
						{
							3,
							7,
							10,
						},
					},
				},
				ProgressGoals = 
				{
					3,
					7,
					10,
				},
			},
		},

		Spawners =
		{
		},
	}
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:SetupScenario()
	if not CDotaNPXScenario.SetupScenario( self ) then
		return false
	end

	local SfSpawner = CDotaSpawner( "npc_dota_spawner_bad_mid_staging", 
	{
		{
			EntityName = "npc_dota_hero_nevermore",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0,
			BotPlayer =
			{
				PlayerID = 1,
				BotName = "Shadow Fiend",
				EntityScript = "ai/ai_sf_mid_1v1.lua",
				StartingItems = 
				{
					"item_tango",
					"item_wraith_band",
					"item_faerie_fire",
					"item_branch",
					"item_branch",
					"item_branch",
				},
				StartingAbilities =
				{
				},
			},
		},
	}, self, true )

	return true
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnSetupComplete()
	CDotaNPXScenario.OnSetupComplete( self )
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnHeroFinishSpawn( hHero, hPlayer )
	CDotaNPXScenario.OnHeroFinishSpawn( self, hHero, hPlayer )
	
	if self.hPlayerHero then
		self:AddReactiveHint( "entity_hurt", function( event )
			local hEntVictim = nil
			local hEntAttacker = nil
			if event.entindex_killed == nil or event.entindex_attacker == nil then
				return false
			end

			hEntVictim = EntIndexToHScript( event.entindex_killed )
			hEntAttacker = EntIndexToHScript( event.entindex_attacker )

			if hEntVictim == self.hPlayerHero and hEntAttacker ~= nil and hEntAttacker:IsRealHero() and self.hPlayerHero:GetHealthPercent() < 70 then
				return true
			end

			return false
		end, "enemy_hero_damage" )
	end
end

--------------------------------------------------------------------

function CDotaNPXScenario_Mid1v1:OnGameRulesStateChange( nOldState, nNewState )
	CDotaNPXScenario.OnGameRulesStateChange( self, nOldState, nNewState )
	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameRules:SpawnAndReleaseCreeps()
	end
end

--------------------------------------------------------------------

return CDotaNPXScenario_Mid1v1