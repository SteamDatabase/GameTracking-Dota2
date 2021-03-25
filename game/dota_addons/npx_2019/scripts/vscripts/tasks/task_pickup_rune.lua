require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_PickupRune == nil then
	CDotaNPXTask_PickupRune = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PickupRune:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )

	self.nRuneType = hTaskInfo.RuneType
end
----------------------------------------------------------------------------

function CDotaNPXTask_PickupRune:RegisterTaskEvent()
	self.nTaskListener = ListenToGameEvent( "dota_rune_activated_server", Dynamic_Wrap( CDotaNPXTask_PickupRune, "OnRunePickup" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXTask_PickupRune:OnRunePickup( event )

	if event.PlayerID ~= nil and event.PlayerID == 0 and (self.nRuneType == nil or self.nRuneType == event.rune) then
		self:CompleteTask()
	end

end


----------------------------------------------------------------------------

return CDotaNPXTask_PickupRune