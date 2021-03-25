require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_CourierMoveToLocation == nil then
	CDotaNPXTask_CourierMoveToLocation = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_CourierMoveToLocation:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	if self.hTaskInfo.TaskParams.GoalLocation == nil or
		self.hTaskInfo.TaskParams.GoalDistance == nil
	then
		print( "CDotaNPXTask_CourierMoveToLocation:constructor - ERROR - Task registered with missing required parameters!" ) 
	end
	
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_CourierMoveToLocation:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), true )
 	end

 	self.hCourier = PlayerResource:GetPreferredCourierForPlayer( 0 )

	if self.hCourier == nil then
		print( "CDotaNPXTask_CourierMoveToLocation:constructor - ERROR - No courier found for player 0!" ) 
	end

 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_CourierMoveToLocation:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_CourierMoveToLocation:OnThink()
	CDotaNPXTask.OnThink( self )
	local vAbsOrigin = self.hCourier:GetAbsOrigin()
	if ( vAbsOrigin - self:GetGoalLocation() ):Length2D() <= self.hTaskInfo.TaskParams.GoalDistance then
		self:CompleteTask( true )
	end
	
end

----------------------------------------------------------------------------

function CDotaNPXTask_CourierMoveToLocation:GetGoalLocation()
	return self.hTaskInfo.TaskParams.GoalLocation
end

----------------------------------------------------------------------------

function CDotaNPXTask_CourierMoveToLocation:GetGoalDistance()
	return self.hTaskInfo.TaskParams.GoalDistance
end

----------------------------------

function CDotaNPXTask_CourierMoveToLocation:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), false )
 	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_CourierMoveToLocation