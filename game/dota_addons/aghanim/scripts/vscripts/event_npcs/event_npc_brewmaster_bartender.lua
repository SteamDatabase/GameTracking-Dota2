require( "event_npc" )

EVENT_NPC_BREWMASTER_POTION_COST = 0
EVENT_NPC_BREWMASTER_BIG_POTION_COST = 150

EVENT_NPC_BREWMASTER_DECLINE = 0

EVENT_NPC_BREWMASTER_PURIFICATION = 1
EVENT_NPC_BREWMASTER_RAVAGE = 2
EVENT_NPC_BREWMASTER_DRAGON = 3
EVENT_NPC_BREWMASTER_ARCANIST = 4
EVENT_NPC_BREWMASTER_ECHO_SLAM = 5
EVENT_NPC_BREWMASTER_ELIXIR = 6

EVENT_NPC_BREWMASTER_NUM_CHOICES = 3

--------------------------------------------------------------------------------

if CEvent_NPC_BrewmasterBartender == nil then
	CEvent_NPC_BrewmasterBartender = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetEventNPCName()
	return "npc_dota_creature_brewmaster_bartender"
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:OnSpawn()
	self.flTalkDistance = 400.0

	CEvent_NPC.OnSpawn( self )
end


--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}

	for nOptionResponse = EVENT_NPC_BREWMASTER_PURIFICATION, EVENT_NPC_BREWMASTER_ELIXIR do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	local nOptionsRemaining = EVENT_NPC_BREWMASTER_NUM_CHOICES
	local ActualOptions = deepcopy( EventOptionsResponses )
	while #ActualOptions > nOptionsRemaining do 
		local nRandomOptionToRemove = RandomInt( 1, #ActualOptions )
		table.remove( ActualOptions, nRandomOptionToRemove )
	end

	table.insert( ActualOptions, EVENT_NPC_BREWMASTER_DECLINE )

	return ActualOptions
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	local szItem = self:GetItemForOption( nOptionResponse )

	EventOption[ "dialog_vars" ] = {}
	if nOptionResponse == EVENT_NPC_BREWMASTER_DECLINE then 
		EventOption[ "dismiss" ] = 1 
	end

	
	EventOption[ "item_name" ] = self:GetItemForOption( nOptionResponse )

	if szItem then
		EventOption[ "dialog_vars" ][ "item_name" ] = "DOTA_Tooltip_ability_" .. self:GetItemForOption( nOptionResponse )
		EventOption[ "item_name" ] = self:GetItemForOption( nOptionResponse )
	end

	EventOption[ "item_name" ] = self:GetItemForOption( nOptionResponse )
	
	return EventOption 
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT 
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetInteractionLimitForNPC( hEventNPC )
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetOptionInitialStockCount( nPlayerID, nOptionResponse )
	if nOptionResponse == EVENT_NPC_BREWMASTER_DECLINE then 
		return -1 --inf
	end

	return 1
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetInteractEventNPCVoiceLine( hPlayerHero )
	local BrewmasterGreetings =
	{
		"brewmaster_brew_spawn_01",
		"brewmaster_brew_spawn_02",
		"brewmaster_brew_ability_drunkenhaze_01",
		"brewmaster_brew_ability_drunkenhaze_02",
		"brewmaster_brew_ability_drunkenhaze_03",
	}
	return BrewmasterGreetings[ RandomInt( 1, #BrewmasterGreetings ) ]
end


--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetOptionGoldCost( nPlayerID, nOptionResponse )
	if nOptionResponse == EVENT_NPC_BREWMASTER_RAVAGE or nOptionResponse == EVENT_NPC_BREWMASTER_ECHO_SLAM then 
		return EVENT_NPC_BREWMASTER_POTION_COST
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_PURIFICATION or nOptionResponse == EVENT_NPC_BREWMASTER_ARCANIST then 
		return EVENT_NPC_BREWMASTER_POTION_COST
	end

	if nOptionResponse == EVENT_NPC_BREWMASTER_DRAGON then 
		return EVENT_NPC_BREWMASTER_BIG_POTION_COST
	end

	if nOptionResponse == EVENT_NPC_BREWMASTER_ELIXIR then 
		return EVENT_NPC_BREWMASTER_BIG_POTION_COST 
	end

	return CEvent_NPC.GetOptionGoldCost( self, nPlayerID, nOptionResponse ) 
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetItemForOption( nOptionResponse )
	if nOptionResponse == EVENT_NPC_BREWMASTER_PURIFICATION then 
		return "item_purification_potion"
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_RAVAGE then 
		return "item_ravage_potion"
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_ARCANIST then 
		return "item_arcanist_potion"
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_DRAGON then 
		return "item_dragon_potion"
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_ECHO_SLAM then 
		return "item_echo_slam_potion"
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_SHADOW_WAVE_EFFECT then 
		return "item_shadow_wave_effect_potion"
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_TORRENT_EFFECT then 
		return "item_torrent_effect_potion"
	end
	if nOptionResponse == EVENT_NPC_BREWMASTER_ELIXIR then 
		return "item_elixer"
	end

	return nil
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_BREWMASTER_DECLINE then 
		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_Decline_Toast"
		FireGameEvent( "dota_combat_event_message", gameEvent )
		return EVENT_NPC_OPTION_DISMISS
	end

	local szItemName = self:GetItemForOption( nOptionResponse )
	if szItemName == nil then 
		return EVENT_NPC_OPTION_INVALID 
	end

	print( "Purchased " .. szItemName .. " from Brewmaster." )
	-- Transaction succeeded
	local hItem = CreateItem( szItemName, hPlayerHero, hPlayerHero )
	if hItem == nil then 
		print( "Item creation failed!  How can this happen?" )
	end
	hItem:SetSellable( false )
	hItem:SetShareability( ITEM_FULLY_SHAREABLE )
	hItem:SetPurchaseTime( GameRules:GetGameTime() )
	hPlayerHero:AddItem( hItem )

	local gameEvent = {}
	gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
	gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. szItemName
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#DOTA_HUD_ItemPurchase_Toast"
	FireGameEvent( "dota_combat_event_message", gameEvent )

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_BrewmasterBartender:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_BREWMASTER_DECLINE then
		szLines = 
		{
			"brewmaster_brew_ally_01",
		} 
	else
		szLines = 
		{
			"brewmaster_brew_attack_09",
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end


--------------------------------------------------------------------------------

return CEvent_NPC_BrewmasterBartender