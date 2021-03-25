require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_LastHits == nil then
	CDotaNPXTask_LastHits = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_LastHits:RegisterTaskEvent()
	self.nCount = self.hTaskInfo.TaskParams.Count
	self.nProgress = 0
	self.nGoal = self.nCount

	local hQueryTable = CDotaNPX:ConvertTemplateToQueryTable( "last_hits" )
	local hVarTable = { }
	hVarTable[ "<target_last_hits>" ] = self.nCount
	CDotaNPX:ReplaceQueryVariableValues( hQueryTable, hVarTable )

	self:OnTaskProgress()

	self.nTaskListener = GameRules:GetGameModeEntity():AddRealTimeCombatAnalyzerQuery( hQueryTable, PlayerResource:GetPlayer( 0 ), self:GetTaskName() )
end

----------------------------------------------------------------------------

function CDotaNPXTask_LastHits:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	self:OnTaskProgress()
end

----------------------------------------------------------------------------

function CDotaNPXTask_LastHits:OnQuerySucceeded( nQueryID )
	self:CompleteTask()
end

----------------------------------------------------------------------------

function CDotaNPXTask_LastHits:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_LastHits:UnregisterTaskEvent()
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1
end

----------------------------------------------------------------------------

return CDotaNPXTask_LastHits