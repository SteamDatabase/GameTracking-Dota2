
if CDotaNPXTask == nil then
	CDotaNPXTask = class({})
end

----------------------------------------------------------------------------

function CDotaNPXTask:constructor( hTaskInfo, hScenario )
	if hTaskInfo == nil then
		print( "CDotaNPXTask:constructor - ERROR - Task registered with nil params!" ) 
		return
	end
	self.hScenario = hScenario
	self.hTaskInfo = hTaskInfo
	self.nTaskListener = -1
	self.flLastCheckTime = -1
	self.nLastIteration = 0
	self.TaskListeners = {}
	self.nGoal = 0
	self.bCompleted = false
end

----------------------------------------------------------------------------

function CDotaNPXTask:StartTask()
	print( "CDotaNPXTask:StartTask - Starting task " .. self:GetTaskName() )

	local event = {}
	event[ "task_name" ] = self:GetTaskName()
	FireGameEvent( "task_started", event )

	local event = {}
	event[ "task_name" ] = self:GetTaskName()
	event[ "task_type" ] = self:GetTaskType()

	if self.TaskParent == nil then
		event[ "task_parent" ] = nil
	else
		event[ "task_parent" ] = self.TaskParent:GetTaskName()
	end

	if self:IsTaskHidden() then
		event[ "task_hidden" ] = 1
	else
		event[ "task_hidden" ] = 0
	end

	event[ "task_dialog_variables" ] = {}
	if self.hTaskInfo.TaskParams then
		for k,v in pairs( self.hTaskInfo.TaskParams ) do
			local serializedValue = self:SerializeParams( v )
			event[ "task_dialog_variables" ][ k ] = serializedValue
		end
	end
	
	PrintTable( event[ "task_dialog_variables" ], " >> ")
	CustomGameEventManager:Send_ServerToAllClients( "task_start", event )
	
	GameRules:GetAnnouncer( DOTA_TEAM_GOODGUYS ):SpeakConcept ( { 
		TaskName = self:GetTaskName(),
		TaskStart = 1,
	})
	self:RegisterTaskEvent()
end

----------------------------------------------------------------------------

function CDotaNPXTask:OnUIHintAdvanced( nUIHintID )
end

----------------------------------------------------------------------------

function CDotaNPXTask:SerializeParams( taskParam )
	if type( taskParam ) ~= "table" then
		return tostring( taskParam )
	else
		local ret = {}
		for k,v in pairs( taskParam ) do
			ret[ k ] = self:SerializeParams( v )
		end
		return ret
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask:RegisterTaskEvent()
	--intentionally empty
end

----------------------------------------------------------------------------

function CDotaNPXTask:GetTask( szTaskName )
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXTask:AddListener( nListener )
	table.insert( self.TaskListeners, nListener )
end

----------------------------------------------------------------------------

function CDotaNPXTask:UnregisterTaskEvent()
	for _,nListener in pairs ( self.TaskListeners ) do
		StopListeningToGameEvent( nListener )
	end

	self.TaskListeners = {}

	if self.nTaskListener == -1 then
		return
	end

	StopListeningToGameEvent( self.nTaskListener )
	self.nTaskListener = -1
end
			
----------------------------------------------------------------------------

function CDotaNPXTask:CompleteTask( bSuccess, bCheckpointSkip, szFailureReason )
	print( "CDotaNPXTask:CompleteTask - Completing task " .. self:GetTaskName() .. ", success = " .. tostring( bSuccess ) )
	self.bCompleted = true
	self.flTimeCompleted = GameRules:GetDOTATime( false, false )
	self:UnregisterTaskEvent()

	if bSuccess ~= nil then
		self.bSuccess = bSuccess
	else
		self.bSuccess = true
	end

	self.szFailureReason = szFailureReason

	local event = {}
	event[ "task_name" ] = self:GetTaskName()
	event[ "success" ] = bSuccess
	if bCheckpointSkip ~= nil then
		event[ "checkpoint_skip" ] = bCheckpointSkip
	else
		event[ "checkpoint_skip" ] = false
	end
	event[ "failure_reason" ] = szFailureReason
	FireGameEvent( "task_completed", event )
	
	GameRules:GetAnnouncer(2):SpeakConcept ( { 
						TaskName = self:GetTaskName(),
						TaskComplete = 1,
					})

	-- For Javascript
	if bSuccess == true then 
		event[ "success" ] = 1
	else
		event[ "success" ] = 0
	end
	print( 'CDotaNPXTask:CompleteTask - setting success flag for ' .. self:GetTaskName() .. ' to ' .. tostring( self.bSuccess ) )
	CustomGameEventManager:Send_ServerToAllClients( "task_complete", event )
end

----------------------------------------------------------------------------

function CDotaNPXTask:IsActive()
	if self.nTaskListener ~= -1 then
		return true
	end
	if #self.TaskListeners > 0 then
		return true
	end
	return false
end

----------------------------------------------------------------------------

function CDotaNPXTask:IsCompleted()
	return self.bCompleted
end

----------------------------------------------------------------------------

function CDotaNPXTask:CheckSuccess()
	return self.bSuccess
end

----------------------------------------------------------------------------

function CDotaNPXTask:GetCompletedTime()
	if not self.bCompleted then
		return -1
	else
		return self.flTimeCompleted
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask:GetTaskName()
	return self.hTaskInfo.TaskName
end

----------------------------------------------------------------------------

function CDotaNPXTask:GetTaskType()
	return self.hTaskInfo.TaskType
end

----------------------------------------------------------------------------

function CDotaNPXTask:GetScenario()
	return self.hScenario
end

----------------------------------------------------------------------------

function CDotaNPXTask:GetQueryID()
	return -1
end

----------------------------------------------------------------------------

function CDotaNPXTask:OnQueryProgressChanged( nQueryID, nProgress )
end

----------------------------------------------------------------------------

function CDotaNPXTask:OnQuerySucceeded( nQueryID )
end

----------------------------------------------------------------------------

function CDotaNPXTask:OnQueryFailed( nQueryID )
end

----------------------------------------------------------------------------

function CDotaNPXTask:HasAnySubTaskWithQueryID( nQueryID )
	return ( nQueryID == self:GetQueryID() )
end


----------------------------------------------------------------------------

function CDotaNPXTask:GetSubTaskWithName( szTaskName )
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXTask:HasAnySubTaskWithName( szTaskName )
	return false
end

----------------------------------------------------------------------------

function CDotaNPXTask:UseHints()
	return self.hTaskInfo.UseHints
end

----------------------------------------------------------------------------

function CDotaNPXTask:IsTaskHidden()
	return self.hTaskInfo.Hidden
end

----------------------------------------------------------------------------

function CDotaNPXTask:SetTaskHidden( bHidden )
	self.hTaskInfo.Hidden = bHidden
end

----------------------------------------------------------------------------

function CDotaNPXTask:ResetIdleCounter()
	self.flLastCheckTime = GameRules:GetDOTATime( false, false )
end
----------------------------------------------------------------------------
function CDotaNPXTask:OnThink()
	if self.hTaskInfo == nil then 
		return
	end
	local curtime = GameRules:GetDOTATime( false, false )
	if self.flLastCheckTime == nil then
		self.flLastCheckTime = -1
	end
	if self.nLastIteration == nil then
		self.nLastIteration = 0
	end

	if self.flLastCheckTime == -1 or curtime - self.flLastCheckTime  >= 10 then
		self.flLastCheckTime = curtime
		self.nLastIteration = self.nLastIteration + 1
		GameRules:GetAnnouncer( DOTA_TEAM_GOODGUYS ):SpeakConcept ( { 
						TaskName = self:GetTaskName(),
						TaskIdle = 1,
						IdleIteration = self.nLastIteration
					})
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask:OnTaskProgress()
	CustomGameEventManager:Send_ServerToAllClients( "task_progress_changed", { task_name = self:GetTaskName(), task_progress = self.nProgress, task_goal = self.nGoal } )
end


----------------------------------------------------------------------------

function CDotaNPXTask:GetTaskProgress()
	return self.nProgress
end

----------------------------------------------------------------------------

function CDotaNPXTask:GetTaskGoal()
	return self.nGoal
end

----------------------------------------------------------------------------

function CDotaNPXTask:OnTriggerStartTouch( sTriggerName, sActivator)
	print( "task " .. self:GetTaskName() .. " checking trigger " .. sTriggerName )
	GameRules:GetAnnouncer(2):SpeakConcept ( { 
		Trigger = 1,
		TaskName = self:GetTaskName(),
		TriggerName = sTriggerName,
		Activator = sActivator,				
	})
	self:ResetIdleCounter()
end

----------------------------------------------------------------------------

return CDotaNPXTask