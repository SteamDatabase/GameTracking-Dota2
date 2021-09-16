require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_PlaceUnit == nil then
	CDotaNPXTask_PlaceUnit = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceUnit:StartTask()

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceUnit:RegisterTaskEvent()
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), true )
 	end
 	self.hUnit = nil
	self.nTaskListener = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDotaNPXTask_PlaceUnit, "OnUnitPlaced" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceUnit:GetGoalLocation()
	return self.hTaskInfo.TaskParams.GoalLocation
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceUnit:GetGoalDistance()
	return self.hTaskInfo.TaskParams.GoalDistance
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceUnit:OnUnitPlaced( event )
	local hUnit = EntIndexToHScript( event.entindex )
	if hUnit ~= nil then
		if hUnit:GetUnitName() == self.hTaskInfo.TaskParams.UnitName then
			self.hUnit = hUnit
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceUnit:OnThink()
	CDotaNPXTask.OnThink( self )
	if self.hUnit ~= nil then
		local vAbsOrigin = self.hUnit:GetAbsOrigin()
		if ( vAbsOrigin - self:GetGoalLocation() ):Length2D() <= self.hTaskInfo.TaskParams.GoalDistance then
			self:CompleteTask( true )
		else
			self:CompleteTask( false, false, "task_place_unit_at_location_fail" )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceUnit:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), false )
 	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_PlaceUnit