require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_DisjointSpell == nil then
	CDotaNPXTask_DisjointSpell = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_DisjointSpell:RegisterTaskEvent()
	self.szAbilityName = self.hTaskInfo.TaskParams.AbilityName
	self.nTimesToComplete = self.hTaskInfo.TaskParams.TimesToComplete
	self.nProgress = 0

	local hQueryTable = 
	{
		matching_type =	"linear_series",
		ignore_previous_entries = 1,
		query =
		{
			evade_spell_attack =
			{
				event				= "attack_evade",
				evading_unit		= "!hero",
				spell_dodge			= "1",
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

function CDotaNPXTask_DisjointSpell:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	self:OnTaskProgress()
end

----------------------------------------------------------------------------

function CDotaNPXTask_DisjointSpell:OnQuerySucceeded( nQueryID )
	self:CompleteTask()
end

----------------------------------------------------------------------------

function CDotaNPXTask_DisjointSpell:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_DisjointSpell:UnregisterTaskEvent()
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1
end

----------------------------------------------------------------------------

function CDotaNPXTask_DisjointSpell:ResetProgress()
	print('Resetting Progress')
	self:RegisterTaskEvent()
end

----------------------------------------------------------------------------

return CDotaNPXTask_DisjointSpell