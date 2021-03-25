require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_PullTarget == nil then
	CDotaNPXTask_PullTarget = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PullTarget:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	if self.hTaskInfo.TaskParams.GoalLocation == nil or
		self.hTaskInfo.TaskParams.GoalDistance == nil
	then
		print( "CDotaNPXTask_PullTarget:constructor - ERROR - Task registered with missing required parameters!" ) 
	end
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_PullTarget:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), true )
 	end
 	local playerHero = self:GetScenario():GetPlayerHero()
 	local targetUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, playerHero:GetOrigin(), playerHero, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #targetUnits > 0 then
		for _,target in pairs( targetUnits ) do
			if target:GetUnitName() == self.hTaskInfo.TaskParams.EntityName then
				self.hTarget = target
			elseif target:GetUnitName() == self.hTaskInfo.TaskParams.CompanionEntityName then
				self.hUnit = target
			end
		end
	else
		print("No units found")
	end
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_PullTarget:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_PullTarget:OnThink()
	CDotaNPXTask.OnThink(self)
	if self.hTarget ~= nil and self.hTarget:IsAlive() then
		local bTargetAtLocation = false
		local vTargetAbsOrigin = self.hTarget:GetAbsOrigin()
		local vCompanionAbsOrigin = self.hUnit:GetAbsOrigin()
		if ( vTargetAbsOrigin - vCompanionAbsOrigin ):Length2D() <= self.hTaskInfo.TaskParams.EntityDistance then
			self:CompleteTask( true )
		end
	else
		print( "Target unit died" )
		self:CompleteTask( false, false, "task_fail_pull_target" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_PullTarget:GetGoalLocation()
	return self.hTaskInfo.TaskParams.GoalLocation
end

----------------------------------------------------------------------------

function CDotaNPXTask_PullTarget:GetGoalDistance()
	return self.hTaskInfo.TaskParams.GoalDistance
end

----------------------------------

function CDotaNPXTask_PullTarget:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), false )
 	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_PullTarget