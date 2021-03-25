require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Delay == nil then
	CDotaNPXTask_Delay = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Delay:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )

	if self.hTaskInfo.TaskParams.Delay == nil then
		print( 'CDotaNPXTask_Delay:constructor - ERROR - no delay set in TaskParams!' )
	end 
	self.flDelay = hTaskInfo.TaskParams.Delay
	self.flStartTime = -1.0

	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_Delay:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_Delay:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_Delay:StartTask()
	CDotaNPXTask.StartTask( self )

	self.flStartTime = GameRules:GetGameTime()
end

----------------------------------------------------------------------------

function CDotaNPXTask_Delay:OnThink()
	local flGameTime = GameRules:GetGameTime()

	if flGameTime > self.flStartTime + self.flDelay then
		self:CompleteTask( true )
	end
end
----------------------------------

function CDotaNPXTask_Delay:UnregisterTaskEvent()	
	CDotaNPXTask.UnregisterTaskEvent( self )
 	self.bIsActive = false
end

return CDotaNPXTask_Delay