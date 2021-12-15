
require( "event_npc" )

LinkLuaModifier( "modifier_event_small_tiny_shrink", "modifiers/events/modifier_event_small_tiny_shrink", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_SmallTiny_Shrink == nil then
	CEvent_NPC_SmallTiny_Shrink = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:GetEventNPCName()
	return "npc_dota_creature_event_small_tiny"
end


--------------------------------------------------------------------------------

EVENT_NPC_SMALL_TINY_ACCEPT_DECLINE = 0
EVENT_NPC_SMALL_TINY_ACCEPT_SHRINK = 1


EVENT_NPC_SMALL_TINY_BONUS_MOVEMENT_SPEED = 90
EVENT_NPC_SMALL_TINY_LESS_MODEL_SCALE = 40
EVENT_NPC_SMALL_TINY_LESS_HP_PCT = 40

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:constructor( vPos )
	self.vecPlayerHPValues = {}
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			local nHPValue = math.floor( hPlayerHero:GetMaxHealth() * EVENT_NPC_SMALL_TINY_LESS_HP_PCT / 100 )
			self.vecPlayerHPValues[ nPlayerID ] = nHPValue 
		end
	end

	CEvent_NPC.constructor( self, vPos )
end


--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_SMALL_TINY_ACCEPT_DECLINE, EVENT_NPC_SMALL_TINY_ACCEPT_SHRINK do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	if nOptionResponse == EVENT_NPC_SMALL_TINY_ACCEPT_SHRINK then 
		EventOption[ "ability_name" ] = "tiny_toss"
		EventOption[ "dialog_vars" ][ "bonus_movement_speed" ] = EVENT_NPC_SMALL_TINY_BONUS_MOVEMENT_SPEED
		EventOption[ "dialog_vars" ][ "hp_penalty" ] = self.vecPlayerHPValues[ hPlayerHero:GetPlayerOwnerID() ] 
	end

	if nOptionResponse == EVENT_NPC_SMALL_TINY_ACCEPT_DECLINE then 
		EventOption[ "dismiss" ] = 1
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_SMALL_TINY_ACCEPT_SHRINK then
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		

		local hToss = self:GetEntity():FindAbilityByName( "tiny_toss" )
		if hToss then 
			--hToss:SetCursorCastTarget( nil )

			local kv =
			{
				x = hPlayerHero:GetAbsOrigin().x,
				y = hPlayerHero:GetAbsOrigin().y,
				z = hPlayerHero:GetAbsOrigin().z,
				target = nil,
			}
			hPlayerHero:AddNewModifier( self:GetEntity(), hToss, "modifier_tiny_toss", kv )
			self:GetEntity():StartGesture( ACT_TINY_TOSS )
			EmitSoundOn( "Ability.TossThrow", self:GetEntity() )
		end

		local kv = 
		{
			duration = -1,
			bonus_movement_speed = EVENT_NPC_SMALL_TINY_BONUS_MOVEMENT_SPEED,
			model_scale = EVENT_NPC_SMALL_TINY_LESS_MODEL_SCALE,
			hp_penalty = self.vecPlayerHPValues[ hPlayerHero:GetPlayerOwnerID() ],
		}
	
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_small_tiny_shrink", kv )

		local gameEvent = {}
		gameEvent["int_value"] = EVENT_NPC_SMALL_TINY_BONUS_MOVEMENT_SPEED
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventSmallTiny_AcceptShrink"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_SMALL_TINY_ACCEPT_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_SMALL_TINY_ACCEPT_SHRINK then
		szLines = 
		{
			
		} 
	elseif nOptionResponse == EVENT_NPC_SMALL_TINY_ACCEPT_DECLINE then
		szLines = 
		{
		
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_SmallTiny_Shrink:GetInteractEventNPCVoiceLine( hPlayerHero )
	local SmallTinyGreetings =
	{

	}

	return SmallTinyGreetings[ RandomInt( 1, #SmallTinyGreetings ) ]
end

--------------------------------------------------------------------------------

return CEvent_NPC_SmallTiny_Shrink
