require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_UnitShowcase == nil then
	CDotaNPXTask_UnitShowcase = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnitShowcase:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )

	self.hUnit = hTaskInfo.Unit
	self.flDuration = 5.0

	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnitShowcase:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnitShowcase:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnitShowcase:StartTask()
	CDotaNPXTask.StartTask( self )

	self.flStartTime = GameRules:GetGameTime()

	-- todo(ericl): this should ensure that the correct unit is selected and that the facing angle is correct
	SendToConsole( "inspectheroinworld" )
end

----------------------------------------------------------------------------

function CDotaNPXTask_UnitShowcase:OnThink()	
	local flGameTime = GameRules:GetGameTime()

	if flGameTime > self.flStartTime + self.flDuration then
		-- todo(ericl): this should ensure that the correct unit is selected and that the facing angle is correct
		SendToConsole( "inspectheroinworld" )

		self:CompleteTask( true )
	end
end

----------------------------------

function CDotaNPXTask_UnitShowcase:UnregisterTaskEvent()	
	CDotaNPXTask.UnregisterTaskEvent( self )
 	self.bIsActive = false
end

return CDotaNPXTask_UnitShowcase