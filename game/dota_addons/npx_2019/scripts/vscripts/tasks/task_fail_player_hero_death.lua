require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Fail_PlayerHeroDeath == nil then
	CDotaNPXTask_Fail_PlayerHeroDeath = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroDeath:RegisterTaskEvent()
	self.nCount = self.hTaskInfo.TaskParams.Count
	self.nProgress = 0

	local hQueryTable = 
	{
		matching_type =	"linear_series",
		query_match_causes_failure = 1,
		ignore_previous_entries = 1,
		query =
		{
			player_hero_killed =
			{
				event = "death",
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

function CDotaNPXTask_Fail_PlayerHeroDeath:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	CustomGameEventManager:Send_ServerToAllClients( "task_progress_changed", { task_name = self:GetTaskName(), task_progress = self.nProgress } )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroDeath:OnQueryFailed( nQueryID )
	self:CompleteTask( false, false, "task_fail_player_hero_death_fail" )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroDeath:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_Fail_PlayerHeroDeath:UnregisterTaskEvent()
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1
end

----------------------------------------------------------------------------

return CDotaNPXTask_Fail_PlayerHeroDeath