require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Denies == nil then
	CDotaNPXTask_Denies = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Denies:RegisterTaskEvent()
	self.nCount = self.hTaskInfo.TaskParams.Count
	self.nProgress = 0
	self.nGoal = self.nCount

	local hQueryTable = CDotaNPX:ConvertTemplateToQueryTable( "deny_creeps_ranked" )
	local hVarTable = { }
	hVarTable[ "<denies>" ] = self.nCount
	CDotaNPX:ReplaceQueryVariableValues( hQueryTable, hVarTable )

	self:OnTaskProgress()

	self.nTaskListener = GameRules:GetGameModeEntity():AddRealTimeCombatAnalyzerQuery( hQueryTable, PlayerResource:GetPlayer( 0 ), self:GetTaskName() )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Denies:OnQueryProgressChanged( nQueryID, nProgress )
	self.nProgress = nProgress
	self:OnTaskProgress()
end

----------------------------------------------------------------------------

function CDotaNPXTask_Denies:OnQuerySucceeded( nQueryID )
	self:CompleteTask()
end

----------------------------------------------------------------------------

function CDotaNPXTask_Denies:GetQueryID()
	return self.nTaskListener
end

----------------------------------------------------------------------------

function CDotaNPXTask_Denies:UnregisterTaskEvent()
	GameRules:GetGameModeEntity():RemoveRealTimeCombatAnalyzerQuery( self.nTaskListener )
	self.nTaskListener = -1
end

----------------------------------------------------------------------------

return CDotaNPXTask_Denies