require( "npx_task" ) 

----------------------------------------------------------------------------
-- Enter the name of an item will be added when the player disassembles.
----------------------------------------------------------------------------

if CDotaNPXTask_DisassembleItem == nil then
	CDotaNPXTask_DisassembleItem = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_DisassembleItem:RegisterTaskEvent()
	self.szItemName = self.hTaskInfo.TaskParams.ItemName
	self.bItemPurchased = false
	self.nTaskListener = ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( CDotaNPXTask_DisassembleItem, "OnItemPurchased" ), self )
	self.nTaskListener = ListenToGameEvent( "dota_inventory_item_added", Dynamic_Wrap( CDotaNPXTask_DisassembleItem, "OnInventoryItemAdded" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_DisassembleItem:OnItemPurchased( event )
	--print( "CDotaNPXTask_DisassembleItem:OnItemPurchased" )
	if self.szItemName == event.itemname then
		self.szPurchasedItem = event.itemname
		self.bItemPurchased = true
	end
end

--------------------------------------------------------------------------------

function CDotaNPXTask_DisassembleItem:OnInventoryItemAdded( event )
	--print( "CDotaNPXTask_DisassembleItem:OnInventoryItemAdded" )
	if self.szItemName == event.itemname then
		-- Need to wait a tick before comparing to set the boolean
		GameRules:GetGameModeEntity():SetContextThink( "CompareItems", function() self:CompareItems() end, 0.1 )
	end
end

--------------------------------------------------------------------------------

function CDotaNPXTask_DisassembleItem:CompareItems()
	--print( "CDotaNPXTask_DisassembleItem:CompareItems" )
	if self.bItemPurchased == false then
		self:CompleteTask()
	else
		--print( "Item Purchased Not Added" )
		self.bItemPurchased = false
	end
end

----------------------------------------------------------------------------

return CDotaNPXTask_DisassembleItem