
require( "event_npc" )

LinkLuaModifier( "modifier_event_leshrac_no_heal", "modifiers/events/modifier_event_leshrac_no_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_event_leshrac_spell_lifesteal", "modifiers/events/modifier_event_leshrac_spell_lifesteal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_event_leshrac_pulse_nova", "modifiers/events/modifier_event_leshrac_pulse_nova", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_event_leshrac_pulse_nova_recreate", "modifiers/events/modifier_event_leshrac_pulse_nova_recreate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_event_leshrac_pulse_nova_activated", "modifiers/events/modifier_event_leshrac_pulse_nova_activated", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_Leshrac == nil then
	CEvent_NPC_Leshrac = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:GetEventNPCName()
	return "npc_dota_creature_event_leshrac"
end

--------------------------------------------------------------------------------

EVENT_NPC_LESHRAC_GET_NOHEAL = 0
EVENT_NPC_LESHRAC_GET_PULSE_NOVA = 1

LESHRAC_NOHEAL_ENCOUNTERS = 1
LESHRAC_HEAL_SUPPRESSION_PCT = 100
LESHRAC_SPELL_LIFESTEAL = 4
LESHRAC_SPELL_LIFESTEAL_CAPTAINS = 8
LESHRAC_SPELL_LIFESTEAL_BOSSES = 15

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}

	for nOptionResponse = EVENT_NPC_LESHRAC_GET_NOHEAL, EVENT_NPC_LESHRAC_GET_PULSE_NOVA do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	if nOptionResponse == EVENT_NPC_LESHRAC_GET_NOHEAL then
		EventOption[ "ability_name" ] = "leshrac_greater_lightning_storm"
		EventOption[ "dialog_vars" ][ "noheal_encounters" ] = LESHRAC_NOHEAL_ENCOUNTERS

		local hNPCSpellLifestealAbility = self:GetEntity():FindAbilityByName( "event_leshrac_spell_lifesteal" )
		DoScriptAssert( hNPCSpellLifestealAbility ~= nil, "event_leshrac_spell_lifesteal not found on event npc" )

		EventOption[ "dialog_vars" ][ "spell_lifesteal" ] = hNPCSpellLifestealAbility:GetSpecialValueFor( "spell_lifesteal" )
		EventOption[ "dialog_vars" ][ "spell_lifesteal_captains" ] = hNPCSpellLifestealAbility:GetSpecialValueFor( "spell_lifesteal_captains" )
		EventOption[ "dialog_vars" ][ "spell_lifesteal_bosses" ] = hNPCSpellLifestealAbility:GetSpecialValueFor( "spell_lifesteal_bosses" )
	end

	if nOptionResponse == EVENT_NPC_LESHRAC_GET_PULSE_NOVA then
		EventOption[ "ability_name" ] = "leshrac_pulse_nova"

		local hNPCPulseNovaAbility = self:GetEntity():FindAbilityByName( "event_leshrac_pulse_nova" )
		DoScriptAssert( hNPCPulseNovaAbility ~= nil, "event_leshrac_pulse_nova not found on event npc" )

		EventOption[ "dialog_vars" ][ "int_mult_for_damage" ] = hNPCPulseNovaAbility:GetSpecialValueFor( "int_mult_for_damage" )
		EventOption[ "dialog_vars" ][ "cooldown" ] = hNPCPulseNovaAbility:GetSpecialValueFor( "cooldown" )
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_LESHRAC_GET_NOHEAL then 
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )

		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_3 )

		EmitSoundOn( "Event_Leshrac.Lightning_Storm", hPlayerHero )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, self:GetEntity() );
		ParticleManager:SetParticleControl( nFXIndex, 0, hPlayerHero:GetAbsOrigin() + Vector( 0, 0, 1024 ) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		hPlayerHero:Heal( hPlayerHero:GetMaxHealth(), self:GetEntity() )

		local hNPCSpellLifestealAbility = self:GetEntity():FindAbilityByName( "event_leshrac_spell_lifesteal" )
		DoScriptAssert( hNPCSpellLifestealAbility ~= nil, "event_leshrac_spell_lifesteal not found on event npc" )

		local kv =
		{
			duration = -1,
			heal_suppression_pct = LESHRAC_HEAL_SUPPRESSION_PCT,
			spell_lifesteal = hNPCSpellLifestealAbility:GetSpecialValueFor( "spell_lifesteal" ),
			spell_lifesteal_captains = hNPCSpellLifestealAbility:GetSpecialValueFor( "spell_lifesteal_captains" ),
			spell_lifesteal_bosses = hNPCSpellLifestealAbility:GetSpecialValueFor( "spell_lifesteal_bosses" ),
			encounters_remaining = LESHRAC_NOHEAL_ENCOUNTERS,
		}
	
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_leshrac_no_heal", kv )

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventLeshrac_NoHeal"
		
		FireGameEvent( "dota_combat_event_message", gameEvent )
	elseif nOptionResponse == EVENT_NPC_LESHRAC_GET_PULSE_NOVA then 
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )

		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_4 )

		EmitSoundOn( "Event_Leshrac.Pulse_Nova_Strike", hPlayerHero )

		local nPulseNovaFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, hPlayerHero )
		ParticleManager:ReleaseParticleIndex( nPulseNovaFX )

		local hPulseNovaAbility = hPlayerHero:AddAbility( "event_leshrac_pulse_nova" )
		if ( hPulseNovaAbility ) then
			-- Grants and upgrades the ability
			hPulseNovaAbility:UpgradeAbility( false )
		end

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventLeshrac_PulseNova"
		
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_LESHRAC_GET_NOHEAL then
		szLines = 
		{
			"leshrac_lesh_ability_edict_01",
			"leshrac_lesh_ability_edict_03",
			"leshrac_lesh_attack_04",
			"leshrac_lesh_attack_07",
			"leshrac_lesh_attack_10",
		} 
	elseif nOptionResponse == EVENT_NPC_LESHRAC_GET_PULSE_NOVA then
		szLines = 
		{
			"leshrac_lesh_ability_nova_02",
			"leshrac_lesh_kill_03",
			"leshrac_lesh_cast_01",
			"leshrac_lesh_cast_02",
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_Leshrac:GetInteractEventNPCVoiceLine( hPlayerHero )
	local LeshracGreetings =
	{
		"leshrac_lesh_spawn_03",
		"leshrac_lesh_spawn_04",
		"leshrac_lesh_attack_12",
		"leshrac_lesh_battlebegins_01",
		"leshrac_lesh_bottle_01",
		"leshrac_lesh_deny_14",
		"leshrac_lesh_kill_13",
	}

	return LeshracGreetings[ RandomInt( 1, #LeshracGreetings ) ]
end

--------------------------------------------------------------------------------

return CEvent_NPC_Leshrac
