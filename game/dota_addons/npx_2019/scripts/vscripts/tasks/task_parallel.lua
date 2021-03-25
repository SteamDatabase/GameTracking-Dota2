require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Parallel == nil then
	CDotaNPXTask_Parallel = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.Tasks = {}
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:GetTask( szTaskName )	
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

function CDotaNPXTask_Parallel:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:StartTask()
	CDotaNPXTask.StartTask( self )
 	self.flNextTaskTime = nil
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:OnUIHintAdvanced( nUIHintID )
	CDotaNPXTask.OnUIHintAdvanced( self, nUIHintID )

	for _,Task in pairs ( self.Tasks ) do
		Task:OnUIHintAdvanced( nUIHintID )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:OnThink()	
	CDotaNPXTask.OnThink( self )
	local bSuccess = true
	local bCompleted = true
	for _,Task in pairs ( self.Tasks ) do
		if not Task:IsActive() and not Task:IsCompleted() then
			if Task.CheckTaskStart == nil or Task:CheckTaskStart() then
				Task:StartTask()
			end
		end
		if not Task:IsCompleted() then
			bCompleted = false
		end
		if Task:IsActive() and not Task:IsCompleted() then
			Task:OnThink()
		end
	end

	if bCompleted then
		self:CompleteTask( bSuccess )
		return
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:HasAnySubTaskWithQueryID( nQueryID )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetQueryID() == nQueryID or Task:HasAnySubTaskWithQueryID( nQueryID ) then
			return true
		end
	end
	return false
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:HasAnySubTaskWithName( szTaskName )
	for _,Task in pairs ( self.Tasks ) do
		if Task:GetTaskName() == szTaskName or Task:HasAnySubTaskWithName( szTaskName ) then
			return true
		end
	end
	return nil
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:GetSubTaskWithName( szTaskName )
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

----------------------------------

function CDotaNPXTask_Parallel:OnQueryProgressChanged( nQueryID, nProgress )
	for _,Task in pairs ( self.Tasks ) do
		if Task:IsActive() and not Task:IsCompleted() and Task.OnQueryProgressChanged ~= nil and Task:GetQueryID() == nQueryID or self:HasAnySubTaskWithQueryID( nQueryID ) then
			Task:OnQueryProgressChanged( nQueryID, nProgress )
		end
	end
end

----------------------------------

function CDotaNPXTask_Parallel:OnQuerySucceeded( nQueryID )
	for _,Task in pairs ( self.Tasks ) do
		if Task:IsActive() and not Task:IsCompleted() and Task.OnQuerySucceeded ~= nil and Task:GetQueryID() == nQueryID or self:HasAnySubTaskWithQueryID( nQueryID ) then
			Task:OnQuerySucceeded( nQueryID )
		end
	end
end

----------------------------------

function CDotaNPXTask_Parallel:OnQueryFailed( nQueryID )
	for _,Task in pairs ( self.Tasks ) do
		if Task:IsActive() and not Task:IsCompleted() and Task.OnQueryFailed ~= nil and Task:GetQueryID() == nQueryID or self:HasAnySubTaskWithQueryID( nQueryID ) then
			Task:OnQueryFailed( nQueryID )
		end
	end
end

----------------------------------

function CDotaNPXTask_Parallel:UnregisterTaskEvent()	
	CDotaNPXTask.UnregisterTaskEvent( self )
	for _,t in pairs( self.Tasks ) do
		if t:IsActive() then
			t:UnregisterTaskEvent()
		end
	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_Parallel:AddTask( t )
	table.insert( self.Tasks, t )
	t.TaskParent = self
	return t
end

return CDotaNPXTask_Parallel