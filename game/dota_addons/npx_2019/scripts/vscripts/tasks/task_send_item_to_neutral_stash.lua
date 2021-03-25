require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_SendItemToNeutralStash == nil then
	CDotaNPXTask_SendItemToNeutralStash = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SendItemToNeutralStash:RegisterTaskEvent()
	self.ItemNames = self.hTaskInfo.TaskParams.ItemNames or {}
	self.nTaskListener = ListenToGameEvent( "dota_neutral_item_sent_to_stash", Dynamic_Wrap( CDotaNPXTask_SendItemToNeutralStash, "OnItemSentToNeutralStash" ), self )
end

--------------------------------------------------------------------------------
-- dota_neutral_item_sent_to_stash
-- > itemname- string
-- > item_entindex - short
-- > player_id - short

--------------------------------------------------------------------------------
function CDotaNPXTask_SendItemToNeutralStash:OnItemSentToNeutralStash( event )
	print( "CDotaNPXTask_SendItemToNeutralStash:OnItemSentToNeutralStash" )
	if event.itemname then	
		for k,ItemName in pairs ( self.ItemNames ) do
			if ItemName == event.itemname then
				table.remove( self.ItemNames, k )
			end
		end

		if #self.ItemNames == 0 then
			self:CompleteTask()
		end
	end
end

----------------------------------------------------------------------------

return CDotaNPXTask_SendItemToNeutralStash