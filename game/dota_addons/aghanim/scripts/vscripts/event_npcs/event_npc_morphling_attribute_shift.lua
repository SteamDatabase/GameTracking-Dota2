require( "event_npc" )

--------------------------------------------------------------------------------

if CEvent_NPC_MorphlingAttributeShift == nil then
	CEvent_NPC_MorphlingAttributeShift = class( {}, {}, CEvent_NPC )
	LinkLuaModifier( "modifier_morphling_event_attribute_shift", "modifiers/events/modifier_morphling_event_attribute_shift", LUA_MODIFIER_MOTION_NONE )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetEventNPCName()
	return "npc_dota_creature_morphling_event"
end

--------------------------------------------------------------------------------

EVENT_NPC_MORPHLING_DECLINE = 0
EVENT_NPC_MORPHLING_ACCEPT_BIG_ATTRIBUTE_SHIFT = 1
EVENT_NPC_MORPHLING_ACCEPT_SMALL_ATTRIBUTE_SHIFT = 2


EVENT_NPC_MORPHLING_BIG_ATTRIBUTE_AMOUNT_PCT = 50
EVENT_NPC_MORPHLING_SMALL_ATTRIBUTE_AMOUNT = 10

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:constructor( vPos )
	self:SetupAttributeOptions()
	CEvent_NPC.constructor( self, vPos )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:SetupAttributeOptions()
	self.vecAttributeOptions = {}
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			self.vecAttributeOptions[ nPlayerID ] = {}

			local vecGainAttributes = { 0, 1, 2 }
			local vecLoseAttributes = { 0, 1, 2 }

			for nOptionResponse = EVENT_NPC_MORPHLING_ACCEPT_BIG_ATTRIBUTE_SHIFT, EVENT_NPC_MORPHLING_ACCEPT_SMALL_ATTRIBUTE_SHIFT do
				self.vecAttributeOptions[ nPlayerID ][ nOptionResponse ] = {}

				local nGainAttributeIndex = RandomInt( 1, #vecGainAttributes )
				self.vecAttributeOptions[ nPlayerID ][ nOptionResponse ][ "gain_attr" ] = vecGainAttributes[ nGainAttributeIndex ]
				table.remove( vecGainAttributes, nGainAttributeIndex )
				table.remove( vecLoseAttributes, nGainAttributeIndex )

				local nLoseAttributeIndex = RandomInt( 1, #vecLoseAttributes )
				self.vecAttributeOptions[ nPlayerID ][ nOptionResponse ][ "lose_attr" ] = vecLoseAttributes[ nLoseAttributeIndex ]
			end
		end
	end
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:ResetAllOptionStockCounts()
	self:SetupAttributeOptions()
	CEvent_NPC.ResetAllOptionStockCounts( self )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_MORPHLING_DECLINE, EVENT_NPC_MORPHLING_ACCEPT_SMALL_ATTRIBUTE_SHIFT do
		table.insert( EventOptionsResponses, nOptionResponse )
	end
	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}
	
	if nOptionResponse == EVENT_NPC_MORPHLING_ACCEPT_BIG_ATTRIBUTE_SHIFT or nOptionResponse == EVENT_NPC_MORPHLING_ACCEPT_SMALL_ATTRIBUTE_SHIFT then 

		local nGainAttributeBaseValue = 0
		local nLoseAttributeBaseValue = 0
		local nAttributeGainValue = 0
		local nAttributeLoseValue = 0
		local szAttrGainName = nil
		local szAttrLoseName = nil
		local nGainAttribute = self.vecAttributeOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "gain_attr" ]
		local nLoseAttribute = self.vecAttributeOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "lose_attr" ]

		if nGainAttribute == 0 then 
			nGainAttributeBaseValue = hPlayerHero:GetBaseStrength()
		end
		if nGainAttribute == 1 then 
			nGainAttributeBaseValue = hPlayerHero:GetBaseAgility()
		end
		if nGainAttribute == 2 then 
			nGainAttributeBaseValue = hPlayerHero:GetBaseIntellect()
		end

		if nLoseAttribute == 0 then 
			nLoseAttributeBaseValue = hPlayerHero:GetBaseStrength()
		end
		if nLoseAttribute == 1 then 
			nLoseAttributeBaseValue = hPlayerHero:GetBaseAgility()
		end
		if nLoseAttribute == 2 then 
			nLoseAttributeBaseValue = hPlayerHero:GetBaseIntellect()
		end

		szAttrGainName = self:GetLocStringForAttribute( nGainAttribute )
		szAttrLoseName = self:GetLocStringForAttribute( nLoseAttribute )

		EventOption[ "attr_gain" ] = nGainAttribute
		EventOption[ "attr_lose" ] = nLoseAttribute
		EventOption[ "dialog_vars" ][ "attr_gain_name" ] = szAttrGainName
		EventOption[ "dialog_vars" ][ "attr_lose_name" ] = szAttrLoseName

		if nOptionResponse == EVENT_NPC_MORPHLING_ACCEPT_BIG_ATTRIBUTE_SHIFT then 
			local nMinBaseValue = math.min( nGainAttributeBaseValue, nLoseAttributeBaseValue )
			nAttributeGainValue = math.ceil( nMinBaseValue * EVENT_NPC_MORPHLING_BIG_ATTRIBUTE_AMOUNT_PCT / 100 )
			nAttributeLoseValue = math.ceil( nMinBaseValue * EVENT_NPC_MORPHLING_BIG_ATTRIBUTE_AMOUNT_PCT / 100 )
		else
			nAttributeGainValue = EVENT_NPC_MORPHLING_SMALL_ATTRIBUTE_AMOUNT
			nAttributeLoseValue = EVENT_NPC_MORPHLING_SMALL_ATTRIBUTE_AMOUNT
		end

		if nOptionResponse == EVENT_NPC_MORPHLING_ACCEPT_BIG_ATTRIBUTE_SHIFT then 
			EventOption[ "ability_name" ] = "morphling_adaptive_strike_agi"
		else
			EventOption[ "ability_name" ] = "morphling_adaptive_strike_str"
		end

		EventOption[ "dialog_vars" ][ "attr_lose_value" ] = nAttributeLoseValue
		EventOption[ "dialog_vars" ][ "attr_gain_value" ] = nAttributeGainValue
	end

	if nOptionResponse == EVENT_NPC_MORPHLING_DECLINE then 
		EventOption[ "dismiss" ] = 1
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_MORPHLING_ACCEPT_BIG_ATTRIBUTE_SHIFT or nOptionResponse == EVENT_NPC_MORPHLING_ACCEPT_SMALL_ATTRIBUTE_SHIFT  then

		EmitSoundOn( "Hero_Morphling.AdaptiveStrike", self:GetEntity() )
		szMessage = nil 
		if nOptionResponse == EVENT_NPC_MORPHLING_ACCEPT_BIG_ATTRIBUTE_SHIFT then 
			self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_3 ) 
			EmitSoundOn( "Hero_Morphling.AdaptiveStrikeStr.Target", hPlayerHero )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetEntity():GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, hPlayerHero:GetAbsOrigin() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetEntity(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetEntity():GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			szMessage = "#DOTA_HUD_Morphling_AttributeSwap_Big"
		else
			self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_2 ) 
			EmitSoundOn( "Hero_Morphling.AdaptiveStrikeAgi.Target", hPlayerHero )
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", PATTACH_WORLDORIGIN,nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetEntity():GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, hPlayerHero:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			szMessage = "#DOTA_HUD_Morphling_AttributeSwap_Small"
		end

		local nAttributeGainValue = self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "dialog_vars" ][ "attr_gain_value" ]
		local nAttributeLoseValue = self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "dialog_vars" ][ "attr_lose_value" ]
		local nGainAttribute = self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "attr_gain" ]
		local nLoseAttribute = self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "attr_lose" ]

		local kv = { }
		kv[ "duration" ] = -1
		kv[ "gain_attribute" ] = nGainAttribute
		kv[ "lose_attribute" ] = nLoseAttribute
		kv[ "gain_attribute_value" ] = nAttributeGainValue
		kv[ "lose_attribute_value" ] = nAttributeLoseValue
		hPlayerHero:AddNewModifier( self:GetEntity(), nil, "modifier_morphling_event_attribute_shift", kv )

		local gameEvent = {}
		gameEvent["int_value"] = nAttributeGainValue
		gameEvent["int_value2"] = nAttributeLoseValue
		gameEvent["locstring_value"] = self:GetLocStringForAttribute( nGainAttribute )
		gameEvent["locstring_value2"] = self:GetLocStringForAttribute( nLoseAttribute )
		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = szMessage

		--DeepPrintTable( gameEvent )
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_MORPHLING_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetLocStringForAttribute( nAttribute )
	if nAttribute == 0 then 
		return "#DOTA_SHOP_TAG_STR"
	end
	if nAttribute == 1 then 
		return "#DOTA_SHOP_TAG_AGI"
	end
	if nAttribute == 2 then 
		return "#DOTA_SHOP_TAG_INT"
	end

	return ""
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 



	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_MorphlingAttributeShift:GetInteractEventNPCVoiceLine( hPlayerHero )
	local MorphGreetings =
	{
		
	}
	return MorphGreetings[ RandomInt( 1, #MorphGreetings ) ]
end

return CEvent_NPC_MorphlingAttributeShift