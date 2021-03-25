require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_MoveToTrigger == nil then
	CDotaNPXTask_MoveToTrigger = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToTrigger:RegisterTaskEvent()
	if self:UseHints() then
		local Triggers = Entities:FindAllByName( self:GetTriggerName() )
		for _,hTrigger in pairs ( Triggers ) do
	 		self:GetScenario():HintLocation( hTrigger:GetAbsOrigin(), true )
 		end
 	end

	self.nTaskListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDotaNPXTask_MoveToTrigger, "OnTriggerStartTouch" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToTrigger:GetTriggerName()
	return self.hTaskInfo.TaskParams.TriggerName

end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToTrigger:OnTriggerStartTouch( event )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
	if hPlayerHero and event.trigger_name == self.hTaskInfo.TaskParams.TriggerName and event.activator_entindex == hPlayerHero:GetEntityIndex() then
		self:CompleteTask()
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_MoveToTrigger:UnregisterTaskEvent()
	if self:UseHints() then
		local Triggers = Entities:FindAllByName( self:GetTriggerName() )
		for _,hTrigger in pairs ( Triggers ) do
	 		self:GetScenario():HintLocation( hTrigger:GetAbsOrigin(), false )
 		end
 	end
	CDotaNPXTask.UnregisterTaskEvent( self )
end

----------------------------------------------------------------------------

return CDotaNPXTask_MoveToTrigger