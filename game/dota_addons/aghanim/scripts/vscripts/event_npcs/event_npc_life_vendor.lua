require( "event_npc" )

--------------------------------------------------------------------------------

if CEvent_NPC_LifeVendor == nil then
	CEvent_NPC_LifeVendor = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetEventNPCName()
	return "npc_dota_creature_event_life_roshan"
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:TrackStats()
	return false -- done separately as LivesPurchased
end

--------------------------------------------------------------------------------

EVENT_NPC_ROSHAN_DECLINE = 0
EVENT_NPC_ROSHAN_BUY_AEGIS = 1
EVENT_NPC_ROSHAN_BUY_CHEESE = 2
EVENT_NPC_ROSHAN_BUY_PHOENIX_ASH = 3
EVENT_NPC_ROSHAN_BUY_CURSE_KEY = 4

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	
	for nOptionResponse = EVENT_NPC_ROSHAN_DECLINE, EVENT_NPC_ROSHAN_BUY_CURSE_KEY do
		local bInsert = true 
		if nOptionResponse == EVENT_NPC_ROSHAN_BUY_CURSE_KEY and GameRules.Aghanim:GetAscensionLevel() < AGHANIM_ASCENSION_GRAND_MAGUS then 
			bInsert = false
		end 

		if bInsert then 
			table.insert( EventOptionsResponses, nOptionResponse )
		end
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetEventOptionData( hPlayerHero, nOptionResponse )
	
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}
	EventOption[ "item_name" ] = self:GetItemForOption( nOptionResponse )

	if nOptionResponse == EVENT_NPC_ROSHAN_DECLINE then 
		EventOption[ "dismiss" ] = 1 
	else
		EventOption[ "dialog_vars" ][ "item_name" ] = "DOTA_Tooltip_ability_" .. self:GetItemForOption( nOptionResponse )
	end

	return EventOption 
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetInteractionLimitForNPC( )
	return EVENT_NPC_SHOP_STYLE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:OnSpawn()
	self:GetEntity():SetMaterialGroup( "5" )
	print( "@@ Roshan spawned!" )
	CEvent_NPC.OnSpawn( self )
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetOptionInitialStockCount( nPlayerID, nOptionResponse )
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_AEGIS then 
		return 4
	end

	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_CHEESE then 
		return 1
	end

	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_PHOENIX_ASH then 
		return 1
	end

	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_CURSE_KEY then 
		return 1
	end

	return -1 --inf for decline
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_ROSHAN_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end

	-- Transaction succeeded
	local hItem = CreateItem( self:GetItemForOption( nOptionResponse ), hPlayerHero, hPlayerHero )
	if hItem == nil then 
		print( "Item creation failed!  How can this happen?" )
	end
	hItem:SetSellable( false )
	hItem:SetShareability( ITEM_FULLY_SHAREABLE )
	hItem:SetPurchaseTime( GameRules:GetGameTime() )
	hPlayerHero:AddItem( hItem )


	local gameEvent = {}
	gameEvent[ "player_id" ] = hPlayerHero:GetPlayerOwnerID()
	gameEvent[ "teamnumber" ] = -1
	gameEvent[ "message" ] = tostring( "#DOTA_HUD_LifeRoshan_" .. self:GetItemForOption( nOptionResponse ) )
	FireGameEvent( "dota_combat_event_message", gameEvent )

	GameRules.Aghanim:IncrementPlayerLivesPurchased( hPlayerHero:GetPlayerID(), GameRules.Aghanim:GetCurrentRoom():GetDepth() )

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetItemForOption( nOptionResponse )
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_AEGIS then 
		return "item_life_rune"
	end
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_CHEESE then 
		return "item_cheese"
	end
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_PHOENIX_ASH then 
		return "item_phoenix_ash"
	end
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_CURSE_KEY then 
		return "item_cursed_key"
	end

	return nil
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetOptionGoldCost( nPlayerID, nOptionResponse )

	local flDiscount = 0
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hPlayerHero ~= nil then
		local hDiscountBuff = hPlayerHero:FindModifierByName("modifier_blessing_roshan_shop_discount")
		if hDiscountBuff ~= nil then
			flDiscount = hDiscountBuff:GetStackCount()
		end
	end

	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_AEGIS then 
		return (GetDOTAItemCost( self:GetItemForOption( nOptionResponse ) )) * ((100 - flDiscount) / 100 )
	end
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_CHEESE then 
		return 500 * ((100 - flDiscount) / 100 )
	end
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_PHOENIX_ASH then 
		return 750 * ((100 - flDiscount) / 100 )
	end
	if nOptionResponse == EVENT_NPC_ROSHAN_BUY_CURSE_KEY then 
		return 500 * ((100 - flDiscount) / 100 )
	end 
	return CEvent_NPC.GetOptionGoldCost( self, nPlayerID, nOptionResponse ) 
end


--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	return nil
end

--------------------------------------------------------------------------------

function CEvent_NPC_LifeVendor:GetInteractEventNPCVoiceLine( hPlayerHero )
	return nil
end

return CEvent_NPC_LifeVendor