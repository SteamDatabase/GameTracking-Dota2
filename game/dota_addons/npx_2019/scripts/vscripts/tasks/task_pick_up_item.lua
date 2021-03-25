require( "npx_task" ) 

if CDotaNPXTask_PickUpItem == nil then
	CDotaNPXTask_PickUpItem = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_PickUpItem:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )

	self.szItemName = self.hTaskInfo.TaskParams.ItemName
end
----------------------------------------------------------------------------

function CDotaNPXTask_PickUpItem:RegisterTaskEvent()
	self.nTaskListener = ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CDotaNPXTask_PickUpItem, "OnItemPickedUp" ), self )
end

--------------------------------------------------------------------------------
-- dota_item_picked_up
-- > itemname - string
-- > PlayerID - short
-- > ItemEntityIndex - short
-- > HeroEntityIndex - short
--------------------------------------------------------------------------------
function CDotaNPXTask_PickUpItem:OnItemPickedUp( event )
	if event.PlayerID ~= nil and event.PlayerID == 0 and event.itemname == self.szItemName then
		self:CompleteTask()
	end
end

return CDotaNPXTask_PickUpItem