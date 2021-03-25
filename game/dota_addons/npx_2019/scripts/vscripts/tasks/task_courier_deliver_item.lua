require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_CourierDeliverItem == nil then
	CDotaNPXTask_CourierDeliverItem = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_CourierDeliverItem:RegisterTaskEvent()
	self.ItemNames = self.hTaskInfo.TaskParams.ItemNames or {}
	self.nTaskListener = ListenToGameEvent( "dota_courier_transfer_item", Dynamic_Wrap( CDotaNPXTask_CourierDeliverItem, "OnCourierDeliverItem" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXTask_CourierDeliverItem:OnCourierDeliverItem( event )
	if event.hero_entindex == PlayerResource:GetSelectedHeroEntity( 0 ):entindex() then	
		local hItemDelivered = EntIndexToHScript( event.item_entindex )
		if hItemDelivered == nil then
			return
		end

		for k,ItemName in pairs ( self.ItemNames ) do
			if ItemName == hItemDelivered:GetAbilityName() then
				table.remove( self.ItemNames, k )
			end
		end
		if #self.ItemNames == 0 then
			self:CompleteTask()
		end
	end
end


----------------------------------------------------------------------------

return CDotaNPXTask_CourierDeliverItem