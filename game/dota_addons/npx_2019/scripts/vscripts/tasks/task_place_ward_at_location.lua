require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_PlaceWard == nil then
	CDotaNPXTask_PlaceWard = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceWard:StartTask()

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceWard:RegisterTaskEvent()
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), true )
 	end
 	self.hWard = nil
	self.szWardType = self.hTaskInfo.TaskParams.WardType
	self.nTaskListener = ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDotaNPXTask_PlaceWard, "OnWardPlaced" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceWard:GetGoalLocation()
	return self.hTaskInfo.TaskParams.GoalLocation
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceWard:GetGoalDistance()
	return self.hTaskInfo.TaskParams.GoalDistance
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceWard:OnWardPlaced( event )
	local hUnit = EntIndexToHScript( event.entindex )
	if hUnit ~= nil then
		if hUnit:GetUnitName() == "npc_dota_observer_wards" then
			print("Observer Ward Placed")
			if self.szWardType == "observer" then
				self.hWard = hUnit
			end
		elseif hUnit:GetUnitName() == "npc_dota_sentry_wards" then
			print("Sentry Ward Placed")
			if self.szWardType == "sentry" then
				self.hWard = hUnit
			end
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceWard:OnThink()
	CDotaNPXTask.OnThink( self )
	if self.hWard ~= nil then
		local vAbsOrigin = self.hWard:GetAbsOrigin()
		if ( vAbsOrigin - self:GetGoalLocation() ):Length2D() <= self.hTaskInfo.TaskParams.GoalDistance then
			self:CompleteTask( true )
		else
			self:CompleteTask( false, false, "task_place_ward_at_location_fail" )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_PlaceWard:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), false )
 	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_PlaceWard