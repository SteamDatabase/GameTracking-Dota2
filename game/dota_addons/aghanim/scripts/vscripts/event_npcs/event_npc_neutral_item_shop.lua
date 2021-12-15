require( "event_npc" )


EVENT_NPC_ALCHEMIST_BUY_FEATURED_ITEM = 0
EVENT_NPC_ALCHEMIST_BUY_RANDOM_ITEM = 1
EVENT_NPC_ALCHEMIST_DUPLICATE_ITEM = 2
EVENT_NPC_ALCHEMIST_FREE_GOLD = 3

ALCHEMIST_FREE_GOLD_AMOUNT = 200

ALCHEMIST_ITEM_COST_MULTIPLIER = 0.6
ALCHEMIST_ITEM_COST_MULTIPLIER_RANDOM = 0.4

--------------------------------------------------------------------------------

if CEvent_NPC_NeutralItemShop == nil then
	CEvent_NPC_NeutralItemShop = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:constructor( vPos )
	self.vecFilteredItems = {}
	self:SetupShopContents()

	CEvent_NPC.constructor( self, vPos )
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetEventNPCName()
	return "npc_dota_creature_alchemist_event"
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetItemForOptionForPlayer( nPlayerID, nOptionResponse )
	local nIndex = nil 
	if nOptionResponse == EVENT_NPC_ALCHEMIST_BUY_FEATURED_ITEM then 
		nIndex = nPlayerID + 1 
	end
	if nOptionResponse == EVENT_NPC_ALCHEMIST_BUY_RANDOM_ITEM then 
		nIndex = nPlayerID + 1 + AGHANIM_PLAYERS
	end
	if nOptionResponse == EVENT_NPC_ALCHEMIST_DUPLICATE_ITEM then 
		local szItemName = nil 
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			local hNeutralItem = hPlayerHero:GetItemInSlot( DOTA_ITEM_NEUTRAL_SLOT ) 
			if hNeutralItem then 
				szItemName = hNeutralItem:GetAbilityName()
			end
		end

		return szItemName
	end

	if nIndex == nil then 
		return nil 
	end

	return self.vecFilteredItems[ nIndex ]
end


--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_ALCHEMIST_BUY_FEATURED_ITEM, EVENT_NPC_ALCHEMIST_FREE_GOLD do
		table.insert( EventOptionsResponses, nOptionResponse )
	end
	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}
	if nOptionResponse == EVENT_NPC_ALCHEMIST_BUY_FEATURED_ITEM then 
		local szFeaturedItemName = self:GetItemForOptionForPlayer( hPlayerHero:GetPlayerOwnerID(), EVENT_NPC_ALCHEMIST_BUY_FEATURED_ITEM )
		--EventOption[ "description" ] = "#npc_dota_creature_alchemist_event_featured_item_for_sale"
		EventOption[ "item_name" ] = szFeaturedItemName
		EventOption[ "dialog_vars" ][ "item_name" ] = "DOTA_Tooltip_ability_" .. szFeaturedItemName
	end
	if nOptionResponse == EVENT_NPC_ALCHEMIST_BUY_RANDOM_ITEM then 
		EventOption[ "image" ] = "items/sample_picker.png"	
	end
	-- if nOptionResponse == EVENT_NPC_ALCHEMIST_BUY_RANDOM_ITEM then 
	-- 	local szRandomItemName = self:GetItemForOptionForPlayer( hPlayerHero:GetPlayerOwnerID(), EVENT_NPC_ALCHEMIST_BUY_RANDOM_ITEM )
	-- 	--EventOption[ "description" ] = "#npc_dota_creature_alchemist_event_random_item_for_sale"
	-- 	--EventOptions[ "item_name" ] = szRandomItemName
	-- 	--EventOptions[ "dialog_vars" ][ "item_name" ] = "DOTA_Tooltip_ability_" .. szRandomItemName
	-- end
	if nOptionResponse == EVENT_NPC_ALCHEMIST_DUPLICATE_ITEM then 
		local szDuplicateItemName = self:GetItemForOptionForPlayer( hPlayerHero:GetPlayerOwnerID(), EVENT_NPC_ALCHEMIST_DUPLICATE_ITEM )
		if szDuplicateItemName == nil then 
			return nil
		end
		EventOption[ "item_name" ] = szDuplicateItemName 
		EventOption[ "dialog_vars" ] [ "item_name" ] = "DOTA_Tooltip_ability_" .. szDuplicateItemName
	end
	if nOptionResponse == EVENT_NPC_ALCHEMIST_FREE_GOLD then 
		EventOption[ "ability_name" ] = "alchemist_goblins_greed"	
		EventOption[ "dialog_vars" ][ "gold" ] = GameRules.Aghanim:EstimateFilteredGold( hPlayerHero:GetPlayerID(), ALCHEMIST_FREE_GOLD_AMOUNT, DOTA_ModifyGold_Unspecified )
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:ResetAllOptionStockCounts()
	self:SetupShopContents()
	CEvent_NPC.ResetAllOptionStockCounts( self )
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:SetupShopContents()
	local vecPricedItems1 = GetPricedNeutralItems( GameRules.Aghanim:GetCurrentRoom():GetDepth(), false )
	local vecPricedItems2 = GetPricedNeutralItems( GameRules.Aghanim:GetCurrentRoom():GetDepth() + 1, false )

	for _,szLessItem in pairs ( vecPricedItems1 ) do
		local bFound = false
		for _,szThisDepthItem in pairs ( vecPricedItems2 ) do
			if szThisDepthItem == szLessItem then
				bFound = true
				break
			end
		end

		if not bFound then
			table.insert( vecPricedItems2, szLessItem )
		end
	end 

	self.vecFilteredItems = GameRules.Aghanim:FilterPreviouslyDroppedItems( vecPricedItems2 )
	if #self.vecFilteredItems < ( AGHANIM_PLAYERS * 2 ) then 
		print( "ERROR! Not enough neutral items found for alchemist trader; only found " .. #self.vecFilteredItems )
	else
		-- shuffle
		for i = #self.vecFilteredItems, 2, -1 do
			local nFlipIndex = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 1, i )
			self.vecFilteredItems[i], self.vecFilteredItems[nFlipIndex] = self.vecFilteredItems[nFlipIndex], self.vecFilteredItems[i]
		end

		-- select affordable items
		local vecResults = {}
		for i = 1, ( AGHANIM_PLAYERS * 2 ) do
			local nPlayerID = i - 1
			if nPlayerID >= AGHANIM_PLAYERS then
				nPlayerID = nPlayerID - AGHANIM_PLAYERS
			end
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			local hHero = nil
			if hPlayer ~= nil then
				hHero = hPlayer:GetAssignedHero()
			end

			local bFound = false
			if hHero ~= nil then
				local nGold = hHero:GetGold()
				for j = 1, #self.vecFilteredItems do
					local szItemName = self.vecFilteredItems[ j ]
					local nCost = GetDOTAItemCost( szItemName )
					if i <= AGHANIM_PLAYERS then
						nCost = 0 -- disable checking cost when giving named items - nCost * ALCHEMIST_ITEM_COST_MULTIPLIER
					else
						nCost = nCost * ALCHEMIST_ITEM_COST_MULTIPLIER_RANDOM
					end
					if nCost <= nGold then
						table.insert( vecResults, szItemName )
						table.remove( self.vecFilteredItems, j )
						bFound = true
						break
					end
				end
			end
			if bFound == false then
				table.insert( vecResults, self.vecFilteredItems[1] )
				table.remove( self.vecFilteredItems, 1 )
			end
		end
				
		self.vecFilteredItems = vecResults
	end

	print( "Alchemist has spawned these items:" )
	PrintTable( self.vecFilteredItems, " ---> " )
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_ALCHEMIST_FREE_GOLD then 
		local nActualGold = self:GiveGoldToPlayer( hPlayerHero, ALCHEMIST_FREE_GOLD_AMOUNT )
		local gameEvent = {}
		gameEvent["int_value"] = tonumber( nActualGold )
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_Hud_EventAlchemist_StealGold"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	else
		local szItemName = self:GetItemForOptionForPlayer( hPlayerHero:GetPlayerOwnerID(), nOptionResponse )
		if szItemName == nil or szItemName == "" then 
			print( "item response is nil?" )
			return nil
		end

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. szItemName
		gameEvent["teamnumber"] = -1

		local nItemCost = self:GetOptionGoldCost( hPlayerHero:GetPlayerOwnerID(), nOptionResponse )

		if nItemCost <= hPlayerHero:GetGold() then
			-- Done by internal interaction handler - self:GiveGoldToNPC( hPlayerHero, nItemCost )
			GameRules.Aghanim:MarkNeutralItemAsDropped( szItemName )

			local hItem = DropNeutralItemAtPositionForHero( szItemName, self:GetEntity():GetAbsOrigin(), hPlayerHero, -1, true )
			if hItem then 
				hPlayerHero:PickupDroppedItem( hItem )
			end
			
			gameEvent["message"] = "#DOTA_HUD_ItemPurchase_Toast"
		else
			gameEvent["message"] = "#DOTA_HUD_ItemPurchaseFail_Toast"
		end
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end 
	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetOptionGoldCost( nPlayerID, nOptionResponse )
	if nOptionResponse == EVENT_NPC_ALCHEMIST_BUY_FEATURED_ITEM then 
		return GetDOTAItemCost( self:GetItemForOptionForPlayer( nPlayerID, EVENT_NPC_ALCHEMIST_BUY_FEATURED_ITEM ) ) * ALCHEMIST_ITEM_COST_MULTIPLIER
	end

	if nOptionResponse == EVENT_NPC_ALCHEMIST_BUY_RANDOM_ITEM then 
		return GetDOTAItemCost( self:GetItemForOptionForPlayer( nPlayerID, EVENT_NPC_ALCHEMIST_BUY_RANDOM_ITEM ) ) * ALCHEMIST_ITEM_COST_MULTIPLIER_RANDOM
	end

	if nOptionResponse == EVENT_NPC_ALCHEMIST_DUPLICATE_ITEM then 
		return GetDOTAItemCost( self:GetItemForOptionForPlayer( nPlayerID, EVENT_NPC_ALCHEMIST_DUPLICATE_ITEM ) ) * ALCHEMIST_ITEM_COST_MULTIPLIER
	end

	return CEvent_NPC.GetOptionGoldCost( self, nPlayerID, nOptionResponse )
end


--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )

end

--------------------------------------------------------------------------------

function CEvent_NPC_NeutralItemShop:GetInteractEventNPCVoiceLine( hPlayerHero )
end

return CEvent_NPC_NeutralItemShop