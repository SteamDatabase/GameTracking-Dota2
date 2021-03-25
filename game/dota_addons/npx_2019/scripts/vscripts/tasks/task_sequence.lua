require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Sequence == nil then
	CDotaNPXTask_Sequence = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.Tasks = {}
	self.bIsActive = false
	self.currentTaskIndex = 0
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:GetTask( szTaskName )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetTaskName() == szTaskName then
			return Task
		end
		local SubTask = Task:GetTask( szTaskName )
		if SubTask then
			return SubTask
		end			
	end
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:StartTask()
	CDotaNPXTask.StartTask( self )
 	self.currentTaskIndex = 1
 	self.flNextTaskTime = nil
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:GetCurrentTask()
	if self.currentTaskIndex <= 0 or self.currentTaskIndex > #self.Tasks then
		return nil
	end
	return self.Tasks[ self.currentTaskIndex ]
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:OnUIHintAdvanced( nUIHintID )
	CDotaNPXTask.OnUIHintAdvanced( self, nUIHintID )

	for _,Task in pairs ( self.Tasks ) do
		Task:OnUIHintAdvanced( nUIHintID )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:OnThink()
	CDotaNPXTask.OnThink(self)
	local t = self:GetCurrentTask()

	local bSuccess = true
	if t ~= nil and t:IsCompleted() then
		bSuccess = t.bSuccess
		local flCompletedTime = t:GetCompletedTime()
		self.currentTaskIndex = self.currentTaskIndex + 1
		t = self:GetCurrentTask()
		if t ~= nil then
			self.flNextTaskTime = flCompletedTime + t._CDotaNPXTask_Sequence_delay
		end
	end

	if t == nil or t.IsActive == nil then
		self:CompleteTask( bSuccess )
		return
	end

	if not t:IsActive() and ( self.flNextTaskTime == nil or GameRules:GetDOTATime( false, false )  >= self.flNextTaskTime ) then
		if t.CheckTaskStart == nil or t:CheckTaskStart() then
			t:StartTask()
		end
	end

	if t:IsActive() then
		t:OnThink()
	end
end

----------------------------------

function CDotaNPXTask_Sequence:GetQueryID()
	if self:GetCurrentTask() == nil then
		return -1
	end
	return self:GetCurrentTask():GetQueryID()
end

----------------------------------

function CDotaNPXTask_Sequence:OnQueryProgressChanged( nQueryID, nProgress )
	if self:GetCurrentTask() and self:GetCurrentTask().OnQueryProgressChanged ~= nil and ( self:GetCurrentTask():GetQueryID() == nQueryID or self:GetCurrentTask():HasAnySubTaskWithQueryID( nQueryID ) ) then
		self:GetCurrentTask():OnQueryProgressChanged( nQueryID, nProgress )
	end
end

----------------------------------

function CDotaNPXTask_Sequence:OnQuerySucceeded( nQueryID )
	if self:GetCurrentTask() and self:GetCurrentTask().OnQuerySucceeded ~= nil and ( self:GetCurrentTask():GetQueryID() == nQueryID or self:GetCurrentTask():HasAnySubTaskWithQueryID( nQueryID ) ) then
		self:GetCurrentTask():OnQuerySucceeded( nQueryID )
	end
end

----------------------------------

function CDotaNPXTask_Sequence:OnQueryFailed( nQueryID )
	if self:GetCurrentTask() and self:GetCurrentTask().OnQueryFailed ~= nil and ( self:GetCurrentTask():GetQueryID() == nQueryID or self:GetCurrentTask():HasAnySubTaskWithQueryID( nQueryID ) ) then
		self:GetCurrentTask():OnQueryFailed( nQueryID )
	end
end

----------------------------------

function CDotaNPXTask_Sequence:UnregisterTaskEvent()	
	CDotaNPXTask.UnregisterTaskEvent( self )
	for k,t in pairs( self.Tasks ) do
		print( k .. " " .. t:GetTaskName() )
		if t:IsActive() then
			t:UnregisterTaskEvent()
		end
	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:AddTask( t, delay )
	table.insert( self.Tasks, t )
	t._CDotaNPXTask_Sequence_delay = ( delay or 0 )
	t.TaskParent = self
	return t
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:HasAnySubTaskWithQueryID( nQueryID )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetQueryID() == nQueryID or Task:HasAnySubTaskWithQueryID( nQueryID ) then
			return true
		end
	end
	return false
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:HasAnySubTaskWithName( szTaskName )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetTaskName() == szTaskName or Task:HasAnySubTaskWithName( szTaskName ) then
			return true
		end
	end
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:GetSubTaskWithName( szTaskName )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetTaskName() == szTaskName then
			return Task
		else
			if Task:HasAnySubTaskWithName( szTaskName ) then
				return Task:GetSubTaskWithName( szTaskName )
			end
		end
	end
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXTask_Sequence:OnTriggerStartTouch( sTriggerName, sActivator)
	CDotaNPXTask.OnTriggerStartTouch( self, sTriggerName, sActivator)
	for k,t in pairs( self.Tasks ) do
		if t:IsActive() then
			t:OnTriggerStartTouch( sTriggerName, sActivator)
		end
	end
	self:ResetIdleCounter()
end

return CDotaNPXTask_Sequence