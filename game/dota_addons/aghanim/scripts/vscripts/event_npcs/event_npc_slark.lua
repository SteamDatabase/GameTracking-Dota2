
require( "event_npc" )

LinkLuaModifier( "modifier_event_slark_greed", "modifiers/events/modifier_event_slark_greed", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_Slark == nil then
	CEvent_NPC_Slark = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:GetEventNPCName()
	return "npc_dota_creature_event_slark"
end

--------------------------------------------------------------------------------

EVENT_NPC_SLARK_DECLINE = 0
EVENT_NPC_SLARK_ACCEPT_GREED = 1
EVENT_NPC_SLARK_LOSE_GOLD = 2


EVENT_NPC_SLARK_GREED_GOLD_PCT = 15
EVENT_NPC_SLARK_GOLD_LOSS = 200

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_SLARK_DECLINE, EVENT_NPC_SLARK_LOSE_GOLD do
		if nOptionResponse ~= EVENT_NPC_SLARK_LOSE_GOLD then 
			table.insert( EventOptionsResponses, nOptionResponse )
		end
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	if nOptionResponse == EVENT_NPC_SLARK_ACCEPT_GREED then 
		EventOption[ "ability_name" ] = "slark_dark_pact"
		EventOption[ "dialog_vars" ][ "gold_pct" ] = EVENT_NPC_SLARK_GREED_GOLD_PCT
	end

	if nOptionResponse == EVENT_NPC_SLARK_LOSE_GOLD then 
		EventOption[ "dialog_vars" ][ "gold_loss" ] = EVENT_NPC_SLARK_GOLD_LOSS
	end

	if nOptionResponse == EVENT_NPC_SLARK_DECLINE then 
		EventOption[ "dismiss" ] = 1 
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_SLARK_ACCEPT_GREED then
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_1 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_pounce_start.vpcf", PATTACH_WORLDORIGIN, self:GetEntity() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetEntity():GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		--[[
		ParticleIndex_t nFXIndex = GetParticleManager()->CreateParticleIndex( "particles/units/heroes/hero_slark/slark_pounce_start.vpcf", PATTACH_WORLDORIGIN, nullptr, nullptr, GetCaster() );
		GetParticleManager()->SetParticleControl( nFXIndex, 0, GetCaster()->GetAbsOrigin() );
		GetParticleManager()->ReleaseParticleIndex( nFXIndex );
		]]

		EmitSoundOn( "Hero_Slark.Pounce.Impact", hPlayerHero )

		local hBuff = hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_slark_greed", { duration = -1 } )
		hBuff.flGoldMultiplier = ( 100.0 + EVENT_NPC_SLARK_GREED_GOLD_PCT ) / 100.0

		local gameEvent = {}
		gameEvent["int_value"] = tonumber( EVENT_NPC_SLARK_GREED_GOLD_PCT )
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventSlark_AcceptGreed_Toast"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_SLARK_LOSE_GOLD then
		local nPlayerID = hPlayerHero:GetPlayerID()
		self:GiveGoldToNPC( hPlayerHero, EVENT_NPC_SLARK_GOLD_LOSS )

		EmitSoundOn( "Item.BagOfGold.Destroy", hPlayerHero )

		-- @todo: show some gold loss particle

		local gameEvent = {}
		gameEvent["int_value"] = tonumber( EVENT_NPC_SLARK_GOLD_LOSS )
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventSlark_AcceptGoldLoss_Toast"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_SLARK_ACCEPT_GREED then
		szLines = 
		{
			"slark_slark_happy_04",
			"slark_slark_happy_05",
			"slark_slark_happy_06",
			"slark_slark_happy_07",
			"slark_slark_levelup_05",
			"slark_slark_levelup_06",
		} 
	elseif nOptionResponse == EVENT_NPC_SLARK_LOSE_GOLD then
		szLines = 
		{
			"slark_slark_deny_04",
			"slark_slark_deny_07",
			"slark_slark_deny_16",
			"slark_slark_laugh_01",
			"slark_slark_laugh_02",
			"slark_slark_laugh_03",
			"slark_slark_thanks_01",
			"slark_slark_thanks_02",
			"slark_slark_kill_01",
			"slark_slark_kill_03",
			"slark_slark_kill_04",
			"slark_slark_levelup_09",
			"slark_slark_levelup_10",
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_Slark:GetInteractEventNPCVoiceLine( hPlayerHero )
	local SlarkGreetings =
	{
		"slark_slark_attack_11",
		"slark_slark_attack_12",
		"slark_slark_attack_13",
		"slark_slark_rival_02",
		"slark_slark_spawn_03",
	}

	return SlarkGreetings[ RandomInt( 1, #SlarkGreetings ) ]
end

--------------------------------------------------------------------------------

return CEvent_NPC_Slark
