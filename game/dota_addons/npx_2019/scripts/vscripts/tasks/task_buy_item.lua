require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_BuyItem == nil then
	CDotaNPXTask_BuyItem = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_BuyItem:RegisterTaskEvent()
	self.szItemName = self.hTaskInfo.TaskParams.ItemName
	self.Items = self.hTaskInfo.TaskParams.Items
	self.bPreCheck = self.hTaskInfo.TaskParams.PreCheck
	self.bDisableWhitelistOnComplete = self.hTaskInfo.TaskParams.DisableWhitelistOnComplete ~= false
	
	if  self.szItemName ~= nil and self.Items ~= nil then
		print("ERROR: Need to only define Items or ItemName, not both, for this task to work.")
		return
	end
	
	if  self.szItemName == nil and self.Items == nil then
		print("ERROR: Need to define Items or ItemName for this task to work.")
		return
	end

	self.ItemAmount = self.hTaskInfo.TaskParams.ItemAmount
	if self.ItemAmount == nil then
		self.ItemAmount = 1
	end
	
	if self.hTaskInfo.TaskParams.WhiteList ~= nil then
		for _,szItemName in pairs ( self.hTaskInfo.TaskParams.WhiteList ) do
			GameRules:AddItemToWhiteList( szItemName )
		end
		GameRules:SetWhiteListEnabled( true )
	end

	self:AddListener( ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( CDotaNPXTask_BuyItem, "OnItemPurchased" ), self ) )
	self:AddListener( ListenToGameEvent( "dota_item_combined", Dynamic_Wrap( CDotaNPXTask_BuyItem, 'OnItemCombined' ), self ) )

end
----------------------------------------------------------------------------

function CDotaNPXTask_BuyItem:StartTask()
	CDotaNPXTask.StartTask( self )

	if self.bPreCheck == true then
		local hHero = self:GetScenario():GetPlayerHero()
		for iSlot = DOTA_ITEM_SLOT_1,DOTA_ITEM_MAX do
			local hItem = hHero:GetItemInSlot( iSlot )
			if hItem ~= nil and not hItem:IsNull() then
				self:OnNewItem( hItem:GetAbilityName() )
			end
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_BuyItem:OnItemPurchased( event )
	if event.PlayerID == 0 and event.itemname ~= nil then
		self:OnNewItem( event.itemname )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_BuyItem:OnItemCombined( event )
	if event.PlayerID == 0 and event.itemname ~= nil then
		self:OnNewItem( event.itemname )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_BuyItem:OnNewItem( szNewItem )
	if szNewItem == self.szItemName then
		self.ItemAmount = self.ItemAmount - 1;
	elseif self.Items ~= nil then
		for i = #self.Items,1,-1 do
			if szNewItem == self.Items[i] then
				self.ItemAmount = self.ItemAmount - 1;
				table.remove( self.Items, i )
				break
			end		
		end
	end

	if self.ItemAmount <= 0 then
		self:CompleteTask()
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_BuyItem:UnregisterTaskEvent()
	if self.hTaskInfo.TaskParams.WhiteList ~= nil then
		if self.bDisableWhitelistOnComplete then
			GameRules:SetWhiteListEnabled( false )
		end
		for _,szItemName in pairs ( self.hTaskInfo.TaskParams.WhiteList ) do
			GameRules:RemoveItemFromWhiteList( szItemName )
		end
	end
	CDotaNPXTask.UnregisterTaskEvent( self )
end

----------------------------------------------------------------------------

return CDotaNPXTask_BuyItem