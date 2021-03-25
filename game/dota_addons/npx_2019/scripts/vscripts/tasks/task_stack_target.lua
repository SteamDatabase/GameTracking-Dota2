require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_StackTarget == nil then
	CDotaNPXTask_StackTarget = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	if self.hTaskInfo.TaskParams.GoalLocation == nil or
		self.hTaskInfo.TaskParams.GoalDistance == nil
	then
		print( "CDotaNPXTask_StackTarget:constructor - ERROR - Task registered with missing required parameters!" ) 
	end
	self.bTriggerInitialized = false
	self.bIsComplete = false
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:RegisterTaskEvent()
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
			end
		end
	else
		print("No units found")
	end
	self.nCreepsInCamp = 0
	local hTriggerRelay = Entities:FindAllByName( self.hTaskInfo.TaskParams.EnableRelay )
	if hTriggerRelay ~= nil then
		for _, rRelay in pairs( hTriggerRelay ) do
			print( "Enabling Trigger" )
			rRelay:Trigger( nil, nil )
		end
	end
	self.nCounter = 0
 	self.bIsActive = true
 	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXTask_StackTarget, "OnCampTriggerStartTouch" ), self )
 	self.nTaskListener = ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( CDotaNPXTask_StackTarget, "OnCampTriggerEndTouch" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:OnThink()
	CDotaNPXTask.OnThink(self)
	--print( self.nCreepsInCamp .. " units still in camp" )
	if self.bIsComplete == false then
		if self.hTaskInfo.TaskParams.TimeRequirement then
			-- What is the tick count?
			self.nCounter = self.nCounter + 0.16
			--print( self.nCounter )
		end
		if self.hTarget ~= nil and self.hTarget:IsAlive() then
			-- Need to initialize the trigger or it starts at nCounter = 0
			if self.bTriggerInitialized then
				if self.nCreepsInCamp == 0 then
					if self.hTaskInfo.TaskParams.TimeRequirement then
						if self.nCounter > 9 then
							self:CompleteTask( true )
							self.bIsComplete = true
						end
					else
						self:CompleteTask( true )
						self.bIsComplete = true
					end
				else
					if self.hTaskInfo.TaskParams.TimeRequirement then
						if self.nCounter > 9 then
							self:CompleteTask( false, false, "task_fail_stack_target_out_of_time" )
							self.bIsComplete = true
						end
					end
				end
			end
		else
			print( "Target unit died" )
			self:CompleteTask( false, false, "task_fail_stack_target_unit_died" )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:OnCampTriggerStartTouch( event )
	--print("OnCampTriggerStartTouch")
	if event.trigger_name == self.hTaskInfo.TaskParams.CampTrigger then
		self.nCreepsInCamp = self.nCreepsInCamp + 1
		-- Need to initialize the trigger or it starts at nCounter = 0
		self.bTriggerInitialized = true
		--print( self.nCreepsInCamp .. " OnStartTouch" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:OnCampTriggerEndTouch( event )
	--print("OnCampTriggerEndTouch")
	if event.trigger_name == self.hTaskInfo.TaskParams.CampTrigger then
		self.nCreepsInCamp = self.nCreepsInCamp - 1
		--print( self.nCreepsInCamp .. " OnEndTouch" )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:GetGoalLocation()
	return self.hTaskInfo.TaskParams.GoalLocation
end

----------------------------------------------------------------------------

function CDotaNPXTask_StackTarget:GetGoalDistance()
	return self.hTaskInfo.TaskParams.GoalDistance
end

----------------------------------

function CDotaNPXTask_StackTarget:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self:GetGoalLocation(), false )
 	end
 	self.bIsActive = false
 	local hTriggerRelay = Entities:FindAllByName( self.hTaskInfo.TaskParams.DisableRelay )
	if hTriggerRelay ~= nil then
		for _, rRelay in pairs( hTriggerRelay ) do
			rRelay:Trigger( nil, nil )
		end
	end
end

----------------------------------------------------------------------------

return CDotaNPXTask_StackTarget