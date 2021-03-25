require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_Regen == nil then
	CDotaNPXTask_Regen = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_Regen:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )

	if hTaskInfo.TaskParams.HealthPercent == nil and hTaskInfo.TaskParams.ManaPercent == nil then
		print( 'CDotaNPXTask_Regen:constructor - ERROR - no HealthPercent or ManaPercent set in TaskParams!' )
	end 
	self.flHealthPercent = hTaskInfo.TaskParams.HealthPercent
	self.flManaPercent = hTaskInfo.TaskParams.ManaPercent

	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_Regen:SetRegenUnit( hUnit )
	self.hUnit = hUnit
end

----------------------------------------------------------------------------

function CDotaNPXTask_Regen:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_Regen:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_Regen:OnThink()
	if self.flHealthPercent ~= nil and self.hUnit:GetHealthPercent() < self.flHealthPercent then
		return
	end
	if self.flManaPercent ~= nil and self.hUnit:GetManaPercent() < self.flManaPercent then
		return
	end

	self:CompleteTask( true )
end
----------------------------------

function CDotaNPXTask_Regen:UnregisterTaskEvent()	
	CDotaNPXTask.UnregisterTaskEvent( self )
 	self.bIsActive = false
end

return CDotaNPXTask_Regen