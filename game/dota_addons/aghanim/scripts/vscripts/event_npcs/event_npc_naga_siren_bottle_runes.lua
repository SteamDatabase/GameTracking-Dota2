require( "event_npc" )

--------------------------------------------------------------------------------

if CEvent_NPC_Naga_BottleRunes == nil then
	CEvent_NPC_Naga_BottleRunes = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetEventNPCName()
	return "npc_dota_creature_naga_siren_event"
end

--------------------------------------------------------------------------------

EVENT_NPC_NAGA_RUNE_OPTION_1 = 0
EVENT_NPC_NAGA_RUNE_OPTION_2 = 1
EVENT_NPC_NAGA_BOTTLE_MAX_CHARGE = 2

EVENT_NPC_NAGA_NUM_CHARGES_WITH_RUNE = 1

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:constructor( vPos )
	self:SetupShopContents()
	CEvent_NPC.constructor( self, vPos )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:SetupShopContents()
	self.vecRuneOptions = {}
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			self.vecRuneOptions[ nPlayerID ] = {}

			local vecRuneOptions = { DOTA_RUNE_DOUBLEDAMAGE, DOTA_RUNE_HASTE, DOTA_RUNE_REGENERATION, DOTA_RUNE_ARCANE }
			local nRuneOption1Index = RandomInt( 1, #vecRuneOptions )
			self.vecRuneOptions[ nPlayerID ][ EVENT_NPC_NAGA_RUNE_OPTION_1 ] = vecRuneOptions[ nRuneOption1Index ]
			table.remove( vecRuneOptions, nRuneOption1Index )
			local nRuneOption2Index = RandomInt( 1, #vecRuneOptions )
			self.vecRuneOptions[ nPlayerID ][ EVENT_NPC_NAGA_RUNE_OPTION_2 ] = vecRuneOptions[ nRuneOption2Index ]
		end
	end
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:ResetAllOptionStockCounts()
	self:SetupShopContents()
	CEvent_NPC.ResetAllOptionStockCounts( self )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_NAGA_RUNE_OPTION_1, EVENT_NPC_NAGA_BOTTLE_MAX_CHARGE do
		table.insert( EventOptionsResponses, nOptionResponse )
	end
	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}
	if nOptionResponse == EVENT_NPC_NAGA_RUNE_OPTION_1 or nOptionResponse == EVENT_NPC_NAGA_RUNE_OPTION_2 then 

		local nRuneType = self.vecRuneOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ]
		if nRuneType == DOTA_RUNE_DOUBLEDAMAGE then 
			EventOption[ "image" ] = "items/bottle_doubledamage.png"
		end
		if nRuneType == DOTA_RUNE_HASTE then 
			EventOption[ "image" ] = "items/bottle_haste.png"
		end
		if nRuneType == DOTA_RUNE_REGENERATION then 
			EventOption[ "image" ] = "items/bottle_regeneration.png"
		end
		if nRuneType == DOTA_RUNE_ARCANE then 
			
			EventOption[ "image" ] = "items/bottle_arcane.png"
		end	

		EventOption[ "dialog_vars" ][ "rune_name" ] = self:GetLocStringForRune( nRuneType )
		EventOption[ "dialog_vars" ][ "num_charges" ] = EVENT_NPC_NAGA_NUM_CHARGES_WITH_RUNE
	end

	if nOptionResponse == EVENT_NPC_NAGA_BOTTLE_MAX_CHARGE then 
		EventOption[ "image" ] = "items/bottle4.png"
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	local hBottle = hPlayerHero:GetItemInSlot( DOTA_ITEM_TP_SCROLL )
	if nOptionResponse == EVENT_NPC_NAGA_RUNE_OPTION_1 or nOptionResponse == EVENT_NPC_NAGA_RUNE_OPTION_2 then 
		local nRuneType = self.vecRuneOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ]
		local nNumBottleCharges = 0
		
		if hBottle then 
			local nMaxCharges = hBottle:GetSpecialValueFor( "max_charges" )
			nNumBottleCharges = math.min( hBottle:GetCurrentCharges() + EVENT_NPC_NAGA_NUM_CHARGES_WITH_RUNE, nMaxCharges )
			hBottle:OnRune( nRuneType )
			hBottle:SetCurrentCharges( nNumBottleCharges )
		end

		local gameEvent = {}
		gameEvent["locstring_value"] = self:GetLocStringForRune( nRuneType )
		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_Naga_BottleRune"

		--DeepPrintTable( gameEvent )
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_NAGA_BOTTLE_MAX_CHARGE then 
		local hBuff = hPlayerHero:FindModifierByName( "modifier_blessing_bottle_upgrade" )
		if hBuff == nil then 
			hBuff = hPlayerHero:AddNewModifier( self:GetEntity(), nil, "modifier_blessing_bottle_upgrade", {} )
			hBuff:SetStackCount( 1 )
		else
			hBuff:SetStackCount( hBuff:GetStackCount() + 1 )
		end 

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_Naga_BottleMaxCharge"

		--DeepPrintTable( gameEvent )
		FireGameEvent( "dota_combat_event_message", gameEvent )

		-- if hBottle then
		-- 	local nMaxCharges = hBottle:GetSpecialValueFor( "max_charges" ) 
		-- 	hBottle:SetCurrentCharges( nMaxCharges )
		-- end
	end

	return nOptionResponse
end


--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetLocStringForRune( nRuneType )
	if nRuneType == DOTA_RUNE_DOUBLEDAMAGE then 
		return "#DOTA_Tooltip_rune_doubledamage"
	end
	if nRuneType == DOTA_RUNE_HASTE then 
		return "#DOTA_Tooltip_rune_haste"
	end
	if nRuneType == DOTA_RUNE_REGENERATION then 
		return "#DOTA_Tooltip_rune_regeneration"
	end
	if nRuneType == DOTA_RUNE_ARCANE then 
		return "#DOTA_Tooltip_rune_arcane"
	end
	return ""
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 
	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_Naga_BottleRunes:GetInteractEventNPCVoiceLine( hPlayerHero )
	local NagaGreetings =
	{
		
	}
	return NagaGreetings[ RandomInt( 1, #NagaGreetings ) ]
end

return CEvent_NPC_Naga_BottleRunes