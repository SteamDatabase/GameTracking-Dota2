require( "event_npc" )


EVENT_NPC_WARLOCK_TOME_COST = 0


EVENT_NPC_WARLOCK_DECLINE = 0
EVENT_NPC_WARLOCK_BOOK_OF_STRENGTH = 1
EVENT_NPC_WARLOCK_BOOK_OF_AGILITY = 2
EVENT_NPC_WARLOCK_BOOK_OF_INTELLIGENCE = 3
EVENT_NPC_WARLOCK_TOME_OF_TORRENT_REFLEX = 4
EVENT_NPC_WARLOCK_TOME_OF_SHADOW_REFLEX = 5
EVENT_NPC_WARLOCK_TOME_OF_KNOWLEDGE = 6
EVENT_NPC_WARLOCK_RANDOM_NEUTRAL_ITEM = 7


--------------------------------------------------------------------------------

if CEvent_NPC_WarlockTomeShop == nil then
	CEvent_NPC_WarlockTomeShop = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:GetEventNPCName()
	return "npc_dota_creature_warlock_librarian"
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:constructor( vPos )
	self.vecFilteredItems = {}
	self:SetupNeutralItems()

	CEvent_NPC.constructor( self, vPos )
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:SetupNeutralItems()
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
	if #self.vecFilteredItems < AGHANIM_PLAYERS then 
		print( "ERROR! Not enough neutral items found for warlock; only found " .. #self.vecFilteredItems )
	else
		-- shuffle
		for i = #self.vecFilteredItems, 2, -1 do
			local nFlipIndex = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 1, i )
			self.vecFilteredItems[i], self.vecFilteredItems[nFlipIndex] = self.vecFilteredItems[nFlipIndex], self.vecFilteredItems[i]
		end
	end

	print( "warlock has spawned these items:" )
	PrintTable( self.vecFilteredItems, " ---> " )
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	local nPrimaryAttribute = hPlayerHero:GetPrimaryAttribute()
	local nSpecialTomeOptionChosen = nil 
	local vecSpecialTomeOptions = {}
	
	for nSpecialTomeOption = EVENT_NPC_WARLOCK_TOME_OF_TORRENT_REFLEX,EVENT_NPC_WARLOCK_TOME_OF_KNOWLEDGE do 
		table.insert( vecSpecialTomeOptions, nSpecialTomeOption )
	end

	nSpecialTomeOption = vecSpecialTomeOptions[ RandomInt( 1, #vecSpecialTomeOptions ) ]

	for nOptionResponse = EVENT_NPC_WARLOCK_DECLINE, EVENT_NPC_WARLOCK_RANDOM_NEUTRAL_ITEM do
		local bInsert = false  
		if nOptionResponse == EVENT_NPC_WARLOCK_DECLINE or nOptionResponse == EVENT_NPC_WARLOCK_RANDOM_NEUTRAL_ITEM then 
			bInsert = true 
		end
		if nPrimaryAttribute == 0 and nOptionResponse == EVENT_NPC_WARLOCK_BOOK_OF_STRENGTH  then
			bInsert = true 
		end

		if nPrimaryAttribute == 1 and nOptionResponse == EVENT_NPC_WARLOCK_BOOK_OF_AGILITY  then
			bInsert = true 
		end

		if nPrimaryAttribute == 2 and nOptionResponse == EVENT_NPC_WARLOCK_BOOK_OF_INTELLIGENCE then
			bInsert = true 
		end

		if nOptionResponse == nSpecialTomeOption then 
			bInsert = true 
		end
			
		if bInsert then 
			table.insert( EventOptionsResponses, nOptionResponse )
		end
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}
	
	EventOption[ "item_name" ] = self:GetItemForOption( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_WARLOCK_DECLINE then 
		EventOption[ "dismiss" ] = 1 
	else
		EventOption[ "dialog_vars" ][ "item_name" ] = "DOTA_Tooltip_ability_" .. self:GetItemForOption( hPlayerHero, nOptionResponse )
	end

	return EventOption 
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_WARLOCK_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end

	local szItemName = self:GetItemForOption( hPlayerHero, nOptionResponse )
	if szItemName == nil then 
		return EVENT_NPC_OPTION_INVALID 
	end

	print( "Purchased " .. szItemName .. " from Warlock." )
	-- Transaction succeeded
	local hItem = CreateItem( szItemName, hPlayerHero, hPlayerHero )
	if hItem == nil then 
		print( "Item creation failed!  How can this happen?" )
	end
	hItem:SetSellable( false )
	hItem:SetShareability( ITEM_FULLY_SHAREABLE )
	hItem:SetPurchaseTime( GameRules:GetGameTime() )
	hPlayerHero:AddItem( hItem )

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:GetItemForOption( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_WARLOCK_TOME_OF_KNOWLEDGE then 
		return "item_tome_of_greater_knowledge"
	end
	if nOptionResponse == EVENT_NPC_WARLOCK_BOOK_OF_STRENGTH then 
		return "item_book_of_greater_strength"
	end
	if nOptionResponse == EVENT_NPC_WARLOCK_BOOK_OF_AGILITY then 
		return "item_book_of_greater_agility"
	end
	if nOptionResponse == EVENT_NPC_WARLOCK_BOOK_OF_INTELLIGENCE then 
		return "item_book_of_greater_intelligence"
	end
	if nOptionResponse == EVENT_NPC_WARLOCK_TOME_OF_TORRENT_REFLEX then 
		return "item_torrent_effect_potion"
	end
	if nOptionResponse == EVENT_NPC_WARLOCK_TOME_OF_SHADOW_REFLEX then 
		return "item_shadow_wave_effect_potion"
	end

	if nOptionResponse == EVENT_NPC_WARLOCK_RANDOM_NEUTRAL_ITEM then 
		return self.vecFilteredItems[ hPlayerHero:GetPlayerOwnerID() + 1 ]
	end
	
	return nil
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:GetOptionGoldCost( nPlayerID, nOptionResponse )
	if nOptionResponse == EVENT_NPC_WARLOCK_DECLINE then 
		return 0 
	end
	
	return EVENT_NPC_WARLOCK_TOME_COST
end


--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local WarlockGreetings =
	{
		"warlock_warl_spawn_02",
		"warlock_warl_spawn_03",
		"warlock_warl_level_07",
		"warlock_warl_level_06",
		"warlock_warl_level_05",
		"warlock_warl_level_10",
		"warlock_warl_kill_11",
		"warlock_warl_purch_01",
		"warlock_warl_respawn_10",
	}
	return WarlockGreetings[ RandomInt( 1, #WarlockGreetings ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_WarlockTomeShop:GetInteractEventNPCVoiceLine( hPlayerHero )
	local WarlockGreetings =
	{
		"warlock_warl_spawn_02",
		"warlock_warl_spawn_03",
		"warlock_warl_level_07",
		"warlock_warl_level_06",
		"warlock_warl_level_05",
		"warlock_warl_level_10",
		"warlock_warl_kill_11",
		"warlock_warl_purch_01",
		"warlock_warl_respawn_10",
	}
	return WarlockGreetings[ RandomInt( 1, #WarlockGreetings ) ]
end

return CEvent_NPC_WarlockTomeShop