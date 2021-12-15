
item_cursed_key = class({})

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function item_cursed_key:OnSpellStart()
	if IsServer() then
		
		for nItemSlot = 0,DOTA_ITEM_INVENTORY_SIZE - 1 do 
			local hItem = self:GetCaster():GetItemInSlot( nItemSlot )
			if hItem and hItem:GetAbilityName() == "item_cursed_item_slot" then 
				self:GetCaster():RemoveItem( hItem )
				EmitSoundOn( "Item.MoonShard.Consume", self:GetCaster() )
				local gameEvent = {}
	 			gameEvent[ "player_id" ] = self:GetCaster():GetPlayerOwnerID()
				gameEvent[ "teamnumber" ] = -1
	 			gameEvent[ "message" ] = "#DOTA_HUD_Curse_Lifted"
	 			FireGameEvent( "dota_combat_event_message", gameEvent )
	 			self:SpendCharge()
	 			break
			end	
		end
	end
end

--------------------------------------------------------------------------------
