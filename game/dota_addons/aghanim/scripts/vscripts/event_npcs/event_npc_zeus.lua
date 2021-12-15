
require( "event_npc" )

LinkLuaModifier( "modifier_event_zeus_spell_amp", "modifiers/events/modifier_event_zeus_spell_amp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_event_zeus_magic_resist", "modifiers/events/modifier_event_zeus_magic_resist", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_Zeus == nil then
	CEvent_NPC_Zeus = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:GetEventNPCName()
	return "npc_dota_creature_event_zeus"
end

--------------------------------------------------------------------------------

EVENT_NPC_ZEUS_ACCEPT_SPELL_AMP = 0
EVENT_NPC_ZEUS_ACCEPT_MAGIC_RESIST = 1

EVENT_NPC_ZEUS_SPELL_AMP = 5
EVENT_NPC_ZEUS_MAGIC_RESIST = 10

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_ZEUS_ACCEPT_SPELL_AMP, EVENT_NPC_ZEUS_ACCEPT_MAGIC_RESIST do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	if nOptionResponse == EVENT_NPC_ZEUS_ACCEPT_SPELL_AMP then 
		EventOption[ "ability_name" ] = "zuus_lightning_bolt"	
		EventOption[ "dialog_vars" ][ "spell_amp" ] = EVENT_NPC_ZEUS_SPELL_AMP
	end

	if nOptionResponse == EVENT_NPC_ZEUS_ACCEPT_MAGIC_RESIST then 
		EventOption[ "ability_name" ] = "zuus_static_field"	
		EventOption[ "dialog_vars" ][ "magic_resist" ] = EVENT_NPC_ZEUS_MAGIC_RESIST
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_ZEUS_ACCEPT_SPELL_AMP then
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_4 )

		local vCastPosWithOverHeadOffset = hPlayerHero:GetAbsOrigin() + Vector( 0, 0, 4000 )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, self:GetEntity() )
		ParticleManager:SetParticleControl( nFXIndex, 0, vCastPosWithOverHeadOffset )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetEntity():GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		--[[
		Vector vecStartPos = pUnit->GetAbsOrigin() + GetVerticalOffsetForParticlesThatComeFromTheSkyAbove();
		ParticleIndex_t nFXIndex = CreateAbilityParticleEffect( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, GetCaster() );
		GetParticleManager()->SetParticleControl( nFXIndex, 0, vecStartPos );
		GetParticleManager()->SetParticleControlEnt( nFXIndex, 1, pUnit, PATTACH_POINT_FOLLOW, "attach_hitloc" );
		GetParticleManager()->ReleaseParticleIndex( nFXIndex );
		]]

		EmitSoundOn( "Hero_Zuus.LightningBolt.Cast", self:GetEntity() )
		EmitSoundOn( "Hero_Zuus.LightningBolt", hPlayerHero )

		local kv = {
			duration = -1,
			spell_amp = EVENT_NPC_ZEUS_SPELL_AMP,
		}
		printf( "OnInteractWithNPCResponse: kv[ \"spell_amp\" ] == %d", kv[ "spell_amp" ] )
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_zeus_spell_amp", kv )

		local gameEvent = {}
		gameEvent["int_value"] = tonumber( EVENT_NPC_ZEUS_SPELL_AMP )
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventZeus_AcceptSpellAmp_Toast"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_ZEUS_ACCEPT_MAGIC_RESIST then
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_1 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_CUSTOMORIGIN, self:GetEntity() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetEntity(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetEntity():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		--[[
		ParticleIndex_t nFXIndex = GetParticleManager()->CreateParticleIndex( "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_CUSTOMORIGIN, nullptr, nullptr, GetCaster() );
		GetParticleManager()->SetParticleControlEnt( nFXIndex, 0, GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", GetCaster()->GetAbsOrigin() );
		GetParticleManager()->SetParticleControlEnt( nFXIndex, 1, pTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", pTarget->GetAbsOrigin() );
		]]

		EmitSoundOn( "Hero_Zuus.ArcLightning.Cast", self:GetEntity() )
		EmitSoundOn( "Hero_Zuus.ArcLightning.Target", hPlayerHero )

		local kv = {
			duration = -1,
			magic_resist = EVENT_NPC_ZEUS_MAGIC_RESIST,
		}
		printf( "OnInteractWithNPCResponse: kv[ \"magic_resist\" ] == %d", kv[ "magic_resist" ] )
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_zeus_magic_resist", kv )

		local gameEvent = {}
		gameEvent["int_value"] = tonumber( EVENT_NPC_ZEUS_MAGIC_RESIST )
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventZeus_AcceptMagicResist_Toast"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_ZEUS_ACCEPT_SPELL_AMP then
		szLines = 
		{
			"zuus_zuus_arc_thanks_01",
			"zuus_zuus_arc_thanks_02",
			"zuus_zuus_arc_thanks_03",
			"zuus_zuus_arc_thanks_04",
		} 
	elseif nOptionResponse == EVENT_NPC_ZEUS_ACCEPT_MAGIC_RESIST then
		szLines = 
		{
			"zuus_zuus_arc_happy_01",
			"zuus_zuus_arc_happy_03",

			"zuus_zuus_arc_laugh_01",
			"zuus_zuus_arc_laugh_02",
			"zuus_zuus_arc_laugh_03",
			"zuus_zuus_arc_laugh_04",
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_Zeus:GetInteractEventNPCVoiceLine( hPlayerHero )
	local ZeusGreetings =
	{
		"zuus_zuus_arc_respawn_06",
		"zuus_zuus_arc_respawn_10",
		"zuus_zuus_arc_spawn_02",
		"zuus_zuus_arc_spawn_04",
		"zuus_zuus_arc_spawn_05",
		"zuus_zuus_arc_spawn_06",
		"zuus_zuus_arc_spawn_07",
		"zuus_zuus_arc_spawn_08",
	}

	return ZeusGreetings[ RandomInt( 1, #ZeusGreetings ) ]
end

--------------------------------------------------------------------------------

return CEvent_NPC_Zeus
