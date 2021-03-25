require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Modifier_Removed_From_Enemy == nil then
	CDotaNPXTask_Modifier_Removed_From_Enemy = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Removed_From_Enemy:RegisterTaskEvent()
	self.szAbilityName = self.hTaskInfo.TaskParams.AbilityName
	self.nTimesToComplete = self.hTaskInfo.TaskParams.TimesToComplete
	self.nProgress = 0

	local hQueryTable = 
	{
		matching_type =	"linear_series",
		ignore_previous_entries = 1,
		query =
		{
			modifier_remove =
			{
				event = 			"modifier_remove",
				modifier = 			self.szAbilityName,
				caster = 			"!hero",
				target_team = 		"!enemyteam",
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
				amount = self.nTimesToComplete,
			},
		},
	}

	self.nTaskListener = GameRules:GetGameModeEntity():AddRealTimeCombatAnalyzerQuery( hQueryTable, PlayerResource:GetPlayer( 0 ), self:GetTaskName() )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Removed_From_Enemy:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	self:OnTaskProgress()
	print('Progress = ' .. nProgress)
	print('TimesToComplete = ' .. self.nTimesToComplete)
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Removed_From_Enemy:OnQuerySucceeded( nQueryID )
	self:CompleteTask()
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Removed_From_Enemy:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_Modifier_Removed_From_Enemy:UnregisterTaskEvent()
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1
end

----------------------------------------------------------------------------

return CDotaNPXTask_Modifier_Removed_From_Enemy