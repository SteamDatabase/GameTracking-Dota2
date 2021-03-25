require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Fail_PlayerHeroTakeDamage == nil then
	CDotaNPXTask_Fail_PlayerHeroTakeDamage = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroTakeDamage:RegisterTaskEvent()
	self.nCount = self.hTaskInfo.TaskParams.Count
	self.nProgress = 0

	local hQueryTable = 
	{
		matching_type =	"linear_series",
		query_match_causes_failure = 1,
		ignore_previous_entries = 1,
		query =
		{
			player_hero_take_damage =
			{
				event = "damage",
				target = "!hero",
				storage =
				{
					{
						aggregator = "increment",
					}
				},
			},
		},
		progress_stored_in = 1,
		post_tests =
		{
			test_value =
			{
				storage = 1,
				compare = ">=",
				amount = self.nCount,
			},
		},
	}

	self.nTaskListener = GameRules:GetGameModeEntity():AddRealTimeCombatAnalyzerQuery( hQueryTable, PlayerResource:GetPlayer( 0 ), self:GetTaskName() )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroTakeDamage:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	CustomGameEventManager:Send_ServerToAllClients( "task_progress_changed", { task_name = self:GetTaskName(), task_progress = self.nProgress } )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroTakeDamage:OnQueryFailed( nQueryID )
	self:CompleteTask( false )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroTakeDamage:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroTakeDamage:UnregisterTaskEvent()
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1
end

----------------------------------------------------------------------------

return CDotaNPXTask_Fail_PlayerHeroTakeDamage