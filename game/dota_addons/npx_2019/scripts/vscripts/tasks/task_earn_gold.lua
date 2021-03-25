require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_EarnGold == nil then
	CDotaNPXTask_EarnGold = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_EarnGold:RegisterTaskEvent()
	self.nGoldAmount = self.hTaskInfo.TaskParams.Gold
	self.nProgress = 0
	self.nGoal = self.nGoldAmount

	local hQueryTable = 
	{
		matching_type =	"linear_series",
		ignore_previous_entries = 1,
		query =
		{
			earn_gold =
			{
				event 				= "gold",
				hero 				= "!hero",
				storage =
				{
					{
						key 		= "value",
						aggregator	= "sum",
					},
				},
			},
		},
		
		progress_stored_in = 1,
		post_tests =
		{
			test_gold =
			{
				storage =	1,
				compare	= 	">=",
				amount  =	self.nGoldAmount,
			},
		},
	}

	self.nTaskListener = GameRules:GetGameModeEntity():AddRealTimeCombatAnalyzerQuery( hQueryTable, PlayerResource:GetPlayer( 0 ), self:GetTaskName() )
	self:OnTaskProgress()
end

----------------------------------------------------------------------------

function CDotaNPXTask_EarnGold:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	self.nGoal = self.nGoldAmount
	self:OnTaskProgress()
end

----------------------------------------------------------------------------

function CDotaNPXTask_EarnGold:OnQuerySucceeded( nQueryID )
	self:CompleteTask()
end

----------------------------------------------------------------------------

function CDotaNPXTask_EarnGold:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_EarnGold:UnregisterTaskEvent()
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1
end

----------------------------------------------------------------------------

return CDotaNPXTask_EarnGold