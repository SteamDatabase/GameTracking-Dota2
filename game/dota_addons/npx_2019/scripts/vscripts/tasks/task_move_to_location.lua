require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_MoveToLocation == nil then
	CDotaNPXTask_MoveToLocation = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToLocation:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	if self.hTaskInfo.TaskParams.GoalLocation == nil or
		self.hTaskInfo.TaskParams.GoalDistance == nil
	then
		print( "CDotaNPXTask_MoveToLocation:constructor - ERROR - Task registered with missing required parameters!" ) 
	end
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToLocation:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), true )
 	end
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToLocation:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToLocation:OnThink()
	CDotaNPXTask.OnThink(self)
	local playerHero = self:GetScenario():GetPlayerHero()
	local vAbsOrigin = playerHero:GetAbsOrigin()
	if ( vAbsOrigin - self:GetGoalLocation() ):Length2D() <= self.hTaskInfo.TaskParams.GoalDistance then
		self:CompleteTask( true )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToLocation:GetGoalLocation()
	return self.hTaskInfo.TaskParams.GoalLocation
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToLocation:GetGoalDistance()
	return self.hTaskInfo.TaskParams.GoalDistance
end

----------------------------------

function CDotaNPXTask_MoveToLocation:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), false )
 	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_MoveToLocation