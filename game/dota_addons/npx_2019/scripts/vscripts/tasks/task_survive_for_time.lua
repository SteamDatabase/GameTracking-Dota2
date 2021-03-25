require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_SurviveForTime == nil then
	CDotaNPXTask_SurviveForTime = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )

	self.fTimeLimit = self.hTaskInfo.TaskParams.TimeLimit
	self.nProgress = 0
	self.nPrevTimerUpdate = -1

	local hQueryTable = 
	{
		matching_type =	"linear_series",
		query_match_causes_failure = 1,
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
				amount = 1,
			},
		},
	}

	self.nTaskListener = GameRules:GetGameModeEntity():AddRealTimeCombatAnalyzerQuery( hQueryTable, PlayerResource:GetPlayer( 0 ), self:GetTaskName() )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:StartTask()
	CDotaNPXTask.StartTask( self )

	self.flStartTime = GameRules:GetGameTime()

	-- turn on timer ui
	FireGameEvent( "timer_set", { timer_header = "scenario_support_survival_time_remaining", timer_value = self.fTimeLimit, timer_countdown = 1 } )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:OnThink()
	local flGameTime = GameRules:GetGameTime()

	if flGameTime > self.flStartTime + self.fTimeLimit then
		self:CompleteTask( true )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	CustomGameEventManager:Send_ServerToAllClients( "task_progress_changed", { task_name = self:GetTaskName(), task_progress = self.nProgress } )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:OnQueryFailed( nQueryID )
	self:CompleteTask( false )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:CompleteTask( bSuccess )
	CDotaNPXTask.CompleteTask( self, bSuccess )
	
	-- disable ui
	local event = {}
	FireGameEvent( "timer_hide", event )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SurviveForTime:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1

	local event = {}
	FireGameEvent( "timer_hide", event )
end

----------------------------------------------------------------------------

return CDotaNPXTask_SurviveForTime