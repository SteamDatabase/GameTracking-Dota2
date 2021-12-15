_G.EVENT_NPC_OPTION_INVALID = -1
_G.EVENT_NPC_OPTION_DISMISS = -2 

--------------------------------------------------------------------------------

_G.EVENT_NPC_SHOP_STYLE = -1
_G.EVENT_NPC_SINGLE_CHOICE = 1

--------------------------------------------------------------------------------

_G.EVENT_NPC_STOCK_TYPE_SHARED = 0
_G.EVENT_NPC_STOCK_TYPE_INDEPENDENT = 1

--------------------------------------------------------------------------------

_G.EVENT_NPC_RESPONSE_RESULT_SUCCESS = 0
_G.EVENT_NPC_RESPONSE_RESULT_NOT_FOUND = 1
_G.EVENT_NPC_RESPONSE_RESULT_OUT_OF_STOCK = 2
_G.EVENT_NPC_RESPONSE_RESULT_ALREADY_RESOLVED = 3
_G.EVENT_NPC_RESPONSE_RESULT_NOT_ENOUGH_GOLD = 4
_G.EVENT_NPC_RESPONSE_RESULT_NOT_ENOUGH_FRAGMENTS = 5
_G.EVENT_NPC_RESPONSE_RESULT_DISMISS = 6

--------------------------------------------------------------------------------

if CEvent_NPC == nil then
	CEvent_NPC = class( {} )
end

--------------------------------------------------------------------------------

function CEvent_NPC:constructor( vPos, hNPC )
	if self:GetEventNPCName() == nil then 
		print( "Event NPC has no defined NPC name." ) 
		return
	end

	self.hNPC = hNPC
	if self.hNPC == nil then
		self.hNPC = CreateUnitByName( self:GetEventNPCName(), vPos, true, nil, nil, DOTA_TEAM_GOODGUYS )
	else
		self.hNPC:SetAbsOrigin( vPos )
		FindClearSpaceForUnit( self.hNPC, vPos, true )
	end	

	if self.hNPC == nil then 
		print( "Failed to create event NPC " .. self:GetEventNPCName() )
		return 
	end

	self:OnSpawn()

	self.hNPC:SetAbsAngles( 0, 270, 0 )
	self.hNPC:AddNewModifier( self.hNPC, nil, "modifier_npc_dialog", { talk_distance = self.flTalkDistance } )

	self.vecEventDescriptionOverrides = {}

	self:NotifyPlayers( true )

	self:InitializePlayerOptions()

	self.nInteractWithNPCEvent = ListenToGameEvent( "aghsfort_interact_event_npc", Dynamic_Wrap( getclass( self ), "OnInteractWithNPC" ), self )
	CustomGameEventManager:RegisterListener( "interact_with_npc_response", function(...) return self:OnInteractWithNPCResponse_Internal( ... ) end )
end

--------------------------------------------------------------------------------

function CEvent_NPC:TrackStats()
	return true
end

--------------------------------------------------------------------------------

function CEvent_NPC:InitializePlayerOptions()
	if self:TrackStats() then
		GameRules.Aghanim:RegisterEventNPCAtDepthStat( GameRules.Aghanim:GetCurrentRoom():GetDepth(), self:GetEventNPCName() )
	end

	self.vecPlayerInteractionWithNPCComplete = {}
	self.EventOptions = {} 
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			self.vecPlayerInteractionWithNPCComplete[ nPlayerID ] = EVENT_NPC_OPTION_INVALID
			-- moved into GetEventOptionsData - self.EventOptions[ nPlayerID ] = {}
			self.EventOptions[ nPlayerID ] = self:GetEventOptionsData( hPlayerHero, true )
		end
	end
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetEventNPCName()
	return nil
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetEntity()
	return self.hNPC
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetEntIndex()
	return self.hNPC:GetEntityIndex()
end

--------------------------------------------------------------------------------

function CEvent_NPC:NotifyPlayers( bNotify )
	local netTable = {}
	netTable[ "ent_index" ] = self.hNPC:GetEntityIndex()

	if bNotify then 
		--self.hNPC:AddNewModifier( self.hNPC, nil, "modifier_npc_dialog_notify", {} )
		netTable[ "notify" ] = 1
	else
		--self.hNPC:RemoveModifierByName( "modifier_npc_dialog_notify" )
		netTable[ "notify" ] = 0
	end

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID ) 
		if hPlayer then 
			CustomGameEventManager:Send_ServerToPlayer( hPlayer, "notify_event_npc", netTable )
		end
	end
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_SHARED 
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetEventOptionsResponses( hPlayerHero )
	return {}
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetEventOptionData( hPlayerHero, nOptionResponse )
	return nil
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetEventOptionsData( hPlayerHero, bInitialize )
	if bInitialize then 
		local vecEventOptionResponses = self:GetEventOptionsResponses( hPlayerHero )
		if vecEventOptionResponses == nil or #vecEventOptionResponses == 0 then
			print( "Error!  Malformed event options table in update event options data " .. hPlayerHero:GetUnitName() .. " " .. self:GetEventNPCName() )
			return
		end

		if self.EventOptions == nil then 
			print( "Error! Update Event Options data could not find NPC" )
			return 
		end

		--[[if self.EventOptions[ hPlayerHero:GetPlayerID() ] == nil then 
			print( "Error! Update Event Options data could not find Player ID" )
			return 
		end--]]
		-- Now we clear the entry here.
		self.EventOptions[ hPlayerHero:GetPlayerID() ] = {}

		for _,nOptionResponse in pairs( vecEventOptionResponses ) do 
			local EventOptionData = self:GetEventOptionData( hPlayerHero, nOptionResponse ) 
			if EventOptionData ~= nil then 
				self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ] = EventOptionData 
				self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "gold_cost" ] = self:GetOptionGoldCost( hPlayerHero:GetPlayerID(), nOptionResponse )
				self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "fragment_cost" ] = self:GetOptionFragmentCost( hPlayerHero:GetPlayerID(), nOptionResponse )
				self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "stock_count" ] = self:GetOptionStockCount( hPlayerHero:GetPlayerID(), nOptionResponse )
				if self:GetEventNPCName() ~= "npc_dota_creature_shard_shop_oracle" then 
					self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "description" ] = tostring( self:GetEventNPCName() .. "_" .. tostring( nOptionResponse ) )
				end
			end
		end
	end

	return self.EventOptions[ hPlayerHero:GetPlayerID() ]
end

--------------------------------------------------------------------------------

function CEvent_NPC:HasEnoughGoldForOption( nPlayerID, nOptionResponse ) 
	return PlayerResource:GetGold( nPlayerID ) >= self:GetOptionGoldCost( nPlayerID, nOptionResponse ) 
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetOptionGoldCost( nPlayerID, nOptionResponse )
	return 0
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetOptionFragmentCost( nPlayerID, nOptionResponse )
	return 0
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetOptionInitialStockCount( nPlayerID, nOptionResponse )
	return -1 --infinite
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetOptionStockCount( nPlayerID, nOptionResponse )
	if self.EventOptions[ nPlayerID ][ nOptionResponse ][ "stock_count" ] == nil then 
		return self:GetOptionInitialStockCount( nPlayerID, nOptionResponse )
	end
	return self.EventOptions[ nPlayerID ][ nOptionResponse ][ "stock_count" ]
end

--------------------------------------------------------------------------------

function CEvent_NPC:SetOptionStockCount( nPlayerID, nOptionResponse, nAmount )
	self.EventOptions[ nPlayerID ][ nOptionResponse ][ "stock_count" ] = nAmount

	local netTable = {}
	netTable[ "interact_npc_ent_index" ] = self:GetEntIndex()
	netTable[ "stock_count" ] = self.EventOptions[ nPlayerID ][ nOptionResponse ][ "stock_count" ]
	netTable[ "option" ] = nOptionResponse

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "update_event_stock_count", netTable )

	if self:GetStockCountType( nPlayerID, nOptionResponse ) == EVENT_NPC_STOCK_TYPE_SHARED then 
		for k,v in pairs ( self.EventOptions ) do
			if k ~= nPlayerID then
				self.EventOptions[ k ][ nOptionResponse ][ "stock_count" ] = self.EventOptions[ nPlayerID ][ nOptionResponse ][ "stock_count" ]
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( k ), "update_event_stock_count", netTable )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CEvent_NPC:DecrementOptionStockCount( nPlayerID, nOptionResponse )
	self:SetOptionStockCount( nPlayerID, nOptionResponse, self.EventOptions[ nPlayerID ][ nOptionResponse ][ "stock_count" ] - 1 )
end

--------------------------------------------------------------------------------

function CEvent_NPC:ResetOptionStockCount( nPlayerID, nOptionResponse )
	self:SetOptionStockCount( nPlayerID, nOptionResponse, self:GetOptionInitialStockCount( nPlayerID, nOptionResponse ) )
end

--------------------------------------------------------------------------------

function CEvent_NPC:ResetAllOptionStockCounts()
	for nPlayerID,PlayerOptions in pairs ( self.EventOptions) do
		for nOptionResponse,EventOption in pairs ( PlayerOptions ) do 
			self:ResetOptionStockCount( nPlayerID, nOptionResponse )
		end
	end	
end

--------------------------------------------------------------------------------

function CEvent_NPC:OnInteractWithNPC( event )
	local nNPCEntIndex = event.entindex_event_npc 
	local nPlayerHeroEntIndex = event.entindex_hero
	if nNPCEntIndex == nil or nPlayerHeroEntIndex == nil then
		print( "no ent indices" )
		return
	end

	local hNPC = EntIndexToHScript( nNPCEntIndex )
	local hPlayerHero = EntIndexToHScript( nPlayerHeroEntIndex )
	if hNPC == nil or hPlayerHero == nil then 
		print( "no valid entities" )
		return
	end

	local hPlayer = hPlayerHero:GetPlayerOwner()
	if hPlayer == nil then 
		print( "no player owner" )
		return 
	end

	if hNPC ~= self.hNPC then 
		return 
	end

	local nInteractionLimit = self:GetInteractionLimitForNPC() 
	if self.vecPlayerInteractionWithNPCComplete[ hPlayer:GetPlayerID() ] ~= EVENT_NPC_OPTION_INVALID and
		nInteractionLimit ~= EVENT_NPC_SHOP_STYLE and
		#self.vecPlayerInteractionWithNPCComplete[ hPlayer:GetPlayerID() ] >= nInteractionLimit then  
		print( "Interaction NPC has already been resolved with this player" )
		return 
	end

	local EventOptions = self:GetEventOptionsData( hPlayerHero, false )
	if EventOptions == nil then 
		print( "interaction NPC has no options" )
		return 
	end

	local netTable = {}
	netTable[ "interact_npc_ent_index" ] = self:GetEntIndex()
	netTable[ "interact_player_hero_ent_index" ] = nPlayerHeroEntIndex
	netTable[ "event_options" ] = EventOptions
	netTable[ "interaction_limit" ] = tonumber( self:GetInteractionLimitForNPC() )
	if self.vecEventDescriptionOverrides[ hPlayerHero:GetPlayerID() ] ~= nil then
		netTable[ "event_description" ] = self.vecEventDescriptionOverrides[ hPlayerHero:GetPlayerID() ]
	end
	CustomGameEventManager:Send_ServerToPlayer( hPlayer, "interact_with_npc", netTable )
	print( "interaction " .. hPlayerHero:GetUnitName() .. " with " .. self.hNPC:GetUnitName() .. " sent to player id " .. hPlayer:GetPlayerID() )
	PrintTable( EventOptions, " --> " )

	local szVoiceLine = self:GetInteractEventNPCVoiceLine( hPlayerHero )
	if szVoiceLine ~= nil then 
		EmitSoundOnLocationForPlayer( szVoiceLine, self.hNPC:GetAbsOrigin(), hPlayer:GetPlayerID() )
	end
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetInteractEventNPCVoiceLine( hPlayerHero )
	return nil 
end

--------------------------------------------------------------------------------

function CEvent_NPC:OnInteractWithNPCResponse_Internal( eventSourceIndex, data )
	print( "interaction with npc received" )
	PrintTable( data, " --> " )
	local nPlayerID = data[ "player_id" ]
	local nNPCEntIndex = data[ "interact_npc_ent_index" ]
	local nOptionResponse = tonumber( data[ "interact_option_response" ] )
	if nNPCEntIndex == nil then
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_NOT_FOUND )
	end

	local hNPC = EntIndexToHScript( nNPCEntIndex )
	if hNPC == nil then 
		print( "Unable to find interaction npc ent index" )
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_NOT_FOUND ) 
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hPlayerHero == nil then 
		print( "unable to find player hero for interaction response" )
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_NOT_FOUND ) 
	end

	if hNPC ~= self.hNPC then 
		return 
	end

	local nInteractionLimit = self:GetInteractionLimitForNPC() 
	if self.vecPlayerInteractionWithNPCComplete[ nPlayerID ] ~= EVENT_NPC_OPTION_INVALID and
		nInteractionLimit ~= EVENT_NPC_SHOP_STYLE and
		#self.vecPlayerInteractionWithNPCComplete[ nPlayerID ] >= nInteractionLimit then  
		print( "Interaction NPC has already been resolved with this player" )
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_ALREADY_RESOLVED ) 
	end

	if nOptionResponse == EVENT_NPC_OPTION_INVALID then 
		print( "Interaction received with invalid option" )
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_NOT_FOUND )  
	end

	if self:HasEnoughGoldForOption( nPlayerID, nOptionResponse ) == false then 
		print( "interaction received with not enough gold!" )
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_NOT_ENOUGH_GOLD )   
	end

	local nStockCount = self:GetOptionStockCount( nPlayerID, nOptionResponse )
	if nStockCount == 0 then 
		print( "interaction received for out of stock option" )
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_OUT_OF_STOCK )  
	end

	local nResponseResult = self:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nResponseResult == EVENT_NPC_OPTION_INVALID then
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_NOT_FOUND )   
	end

	-- Track stats
	if self:TrackStats() then
		GameRules.Aghanim:RegisterEventNPCInteractionStat( nPlayerID, GameRules.Aghanim:GetCurrentRoom():GetDepth(), nOptionResponse )
	end

	if nResponseResult == EVENT_NPC_OPTION_DISMISS then
		return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_DISMISS )   
	end

	print( "interaction with npc success" )
	PrintTable( data, " --> " )

	if self.vecPlayerInteractionWithNPCComplete[ nPlayerID ] == EVENT_NPC_OPTION_INVALID then
		self.vecPlayerInteractionWithNPCComplete[ nPlayerID ] = {}
	end

	table.insert( self.vecPlayerInteractionWithNPCComplete[ nPlayerID ], nResponseResult )

	local szVoiceLine = self:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nResponseResult )
	if szVoiceLine ~= nil then
		EmitSoundOnLocationForPlayer( szVoiceLine, self.hNPC:GetAbsOrigin(), nPlayerID )
	end

	local nGoldCost = self:GetOptionGoldCost( hPlayerHero:GetPlayerID(), nResponseResult )
	if nGoldCost > 0 then 
		self:GiveGoldToNPC( hPlayerHero, nGoldCost )
	end
	if nStockCount > 0 then 
		self:DecrementOptionStockCount( hPlayerHero:GetPlayerID(), nResponseResult )
	end

	if self:HaveAllPlayersCompletedNPCInteractions() then 
		self:NotifyPlayers( false )
	end 

	return self:SendInteractionResponseToClient( nPlayerID, EVENT_NPC_RESPONSE_RESULT_SUCCESS )  
end

--------------------------------------------------------------------------------

function CEvent_NPC:SendInteractionResponseToClient( nPlayerID, nResultCode )
	if nResultCode == EVENT_NPC_RESPONSE_RESULT_SUCCESS or nResultCode == EVENT_NPC_RESPONSE_RESULT_DISMISS then 
		local notifyTable = {}
		notifyTable[ "ent_index" ] = self.hNPC:GetEntityIndex()
		notifyTable[ "notify" ] = 0
		local hPlayer = PlayerResource:GetPlayer( nPlayerID ) 
		if hPlayer then 
			CustomGameEventManager:Send_ServerToPlayer( hPlayer, "notify_event_npc", notifyTable )
		end
	end

	local netTable = {}
	netTable[ "result_code" ] = nResultCode
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "interact_with_npc_response_result", netTable )
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	return nil 
end

--------------------------------------------------------------------------------

function CEvent_NPC:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	-- Override this function in your npc.  If the response is invalid, return invalid and the player can try again, otherwise return the option to record what was selected.
	return EVENT_NPC_OPTION_INVALID
end

--------------------------------------------------------------------------------

function CEvent_NPC:HaveAllPlayersCompletedNPCInteractions()
	local bIncomplete = false 

	local nResponseLimit = self:GetInteractionLimitForNPC()
	for _,vecPlayerResponses in pairs ( self.vecPlayerInteractionWithNPCComplete ) do
		if nResponseLimit ~= EVENT_NPC_SHOP_STYLE and ( vecPlayerResponses == EVENT_NPC_OPTION_INVALID or #vecPlayerResponses < nResponseLimit ) then 
			bIncomplete = true 
			break
		end
	end

	return not bIncomplete
end

--------------------------------------------------------------------------------

function CEvent_NPC:GiveGoldToPlayer( hPlayerHero, nAmount )
	local nAdjustedAmount = math.ceil( nAmount * GameRules.Aghanim:GetGoldModifier() / 100 )
	local nActualGold = hPlayerHero:ModifyGoldFiltered( nAdjustedAmount, true, DOTA_ModifyGold_Unspecified )
	self:PlayGoldEffects( hPlayerHero, self.hNPC )
	EmitSoundOnLocationForPlayer( "DOTA_Item.Hand_Of_Midas", hPlayerHero:GetAbsOrigin(), hPlayerHero:GetPlayerOwnerID() )
	return nActualGold
end

--------------------------------------------------------------------------------

function CEvent_NPC:GiveGoldToNPC( hPlayerHero, nAmount )
	local nActualGold = hPlayerHero:SpendGold( nAmount, DOTA_ModifyGold_PurchaseItem )
	self:PlayGoldEffects( self.hNPC, hPlayerHero )
	EmitSoundOnLocationForPlayer( "General.Buy", hPlayerHero:GetAbsOrigin(), hPlayerHero:GetPlayerOwnerID() )
	return nActualGold
end

--------------------------------------------------------------------------------

function CEvent_NPC:PlayGoldEffects( hRecipient, hSpender )
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/hand_of_midas.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, hSpender, PATTACH_ABSORIGIN_FOLLOW, nil, hSpender:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, hRecipient, PATTACH_POINT_FOLLOW, "attach_hitloc", hRecipient:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

--------------------------------------------------------------------------------

function CEvent_NPC:GetRecordedOptions()
	return self.vecPlayerInteractionWithNPCComplete
end

--------------------------------------------------------------------------------

function CEvent_NPC:OnSpawn()
	-- Overridable in subclass
end