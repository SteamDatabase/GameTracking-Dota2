require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_AddItemToQuickBuy == nil then
	CDotaNPXTask_AddItemToQuickBuy = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AddItemToQuickBuy:RegisterTaskEvent()
	self.szItemName = self.hTaskInfo.TaskParams.ItemName

	GameRules:SetWhiteListEnabled( true )
	GameRules:AddItemToWhiteList( self.szItemName )		
	
	self.nTaskListener = CustomGameEventManager:RegisterListener( "dota_set_quick_buy", function(...) return self:OnPlayerSetQuickBuy( ... ) end )
end

--------------------------------------------------------------------------------
-- dota_set_quick_buy
-- > item - string
-- > recipe - bool
-- > toggle - false
--------------------------------------------------------------------------------
function CDotaNPXTask_AddItemToQuickBuy:OnPlayerSetQuickBuy( nSourceEventIndex, event )
	if event.item == self.szItemName then
		self:CompleteTask( true )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_AddItemToQuickBuy:UnregisterTaskEvent()
	GameRules:SetWhiteListEnabled( false )
	GameRules:RemoveItemFromWhiteList( self.szItemName  )		
	
	CDotaNPXTask.UnregisterTaskEvent( self )
end


----------------------------------------------------------------------------

return CDotaNPXTask_AddItemToQuickBuy