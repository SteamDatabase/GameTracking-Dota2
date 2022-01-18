
require( "event_npc" )

LinkLuaModifier( "modifier_event_big_tiny_grow", "modifiers/events/modifier_event_big_tiny_grow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_BigTiny_Grow == nil then
	CEvent_NPC_BigTiny_Grow = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:GetEventNPCName()
	return "npc_dota_creature_event_big_tiny"
end

--------------------------------------------------------------------------------

EVENT_NPC_BIG_TINY_ACCEPT_DECLINE = 0
EVENT_NPC_BIG_TINY_ACCEPT_GROW = 1

EVENT_NPC_BIG_TINY_MOVEMENT_SPEED_REDUCTION = 75
EVENT_NPC_BIG_TINY_MORE_MODEL_SCALE = 75
EVENT_NPC_BIG_TINY_MORE_HP = 40


--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:constructor( vPos )
	self.vecPlayerHPValues = {}
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			local nHPValue = math.floor( hPlayerHero:GetMaxHealth() * EVENT_NPC_BIG_TINY_MORE_HP / 100 )
			self.vecPlayerHPValues[ nPlayerID ] = nHPValue 
		end
	end
	
	CEvent_NPC.constructor( self, vPos )

	
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_BIG_TINY_ACCEPT_DECLINE, EVENT_NPC_BIG_TINY_ACCEPT_GROW do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	if nOptionResponse == EVENT_NPC_BIG_TINY_ACCEPT_GROW then 
		EventOption[ "ability_name" ] = "tiny_toss"
		EventOption[ "dialog_vars" ][ "movement_speed_reduction" ] = EVENT_NPC_BIG_TINY_MOVEMENT_SPEED_REDUCTION
		EventOption[ "dialog_vars" ][ "bonus_hp" ] = self.vecPlayerHPValues[ hPlayerHero:GetPlayerOwnerID() ]
	end

	if nOptionResponse == EVENT_NPC_BIG_TINY_ACCEPT_DECLINE then 
		EventOption[ "dismiss"] = 1 
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_BIG_TINY_ACCEPT_GROW then
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
			movement_speed_reduction = EVENT_NPC_BIG_TINY_MOVEMENT_SPEED_REDUCTION,
			model_scale = EVENT_NPC_BIG_TINY_MORE_MODEL_SCALE,
			bonus_hp = self.vecPlayerHPValues[ hPlayerHero:GetPlayerOwnerID() ],
		}
	
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_big_tiny_grow", kv )

		local gameEvent = {}
		gameEvent["int_value"] = self.vecPlayerHPValues[ hPlayerHero:GetPlayerOwnerID() ]
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventBigTiny_AcceptGrow"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_BIG_TINY_ACCEPT_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end 

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_BIG_TINY_ACCEPT_GROW then
		szLines = 
		{
			
		} 
	elseif nOptionResponse == EVENT_NPC_BIG_TINY_ACCEPT_DECLINE then
		szLines = 
		{
		
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_BigTiny_Grow:GetInteractEventNPCVoiceLine( hPlayerHero )
	local SmallTinyGreetings =
	{

	}

	return SmallTinyGreetings[ RandomInt( 1, #SmallTinyGreetings ) ]
end

--------------------------------------------------------------------------------

return CEvent_NPC_BigTiny_Grow
