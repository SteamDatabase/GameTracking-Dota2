require( "event_npc" )

LinkLuaModifier( "modifier_event_doom_regen_reduction", "modifiers/events/modifier_event_doom_regen_reduction", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_DoomLifeSwap == nil then
	CEvent_NPC_DoomLifeSwap = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:GetEventNPCName()
	return "npc_dota_creature_doom_soultrader"
end

--------------------------------------------------------------------------------

EVENT_NPC_DOOM_DECLINE = 0
EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_LIFE = 1
EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_HP_REGEN = 2


EVENT_NPC_DOOM_GOLD_GAIN_FOR_LIFE = 1500
EVENT_NPC_DOOM_GOLD_GAIN_FOR_HP_REGEN = 666
EVENT_NPC_DOOM_HP_REGEN_LOST = 6.66
EVENT_NPC_DOOM_LIVES_LOST = 1

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_DOOM_DECLINE, EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_HP_REGEN do
		local bInsert = true 
		if nOptionResponse == EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_LIFE and hPlayerHero.nRespawnsRemaining == 0 then 
			bInsert = false
		end

		if bInsert then 
			table.insert( EventOptionsResponses, nOptionResponse )
		end
	end
	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	if nOptionResponse == EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_LIFE then 
		EventOption[ "dialog_vars" ][ "gold" ] = GameRules.Aghanim:EstimateFilteredGold( hPlayerHero:GetPlayerID(), EVENT_NPC_DOOM_GOLD_GAIN_FOR_LIFE, DOTA_ModifyGold_Unspecified )
		EventOption[ "dialog_vars" ][ "lives" ] = EVENT_NPC_DOOM_LIVES_LOST
		EventOption[ "ability_name" ] = "doom_bringer_devour"
	end
	if nOptionResponse == EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_HP_REGEN then 
		EventOption[ "dialog_vars" ][ "gold" ] = GameRules.Aghanim:EstimateFilteredGold( hPlayerHero:GetPlayerID(), EVENT_NPC_DOOM_GOLD_GAIN_FOR_HP_REGEN, DOTA_ModifyGold_Unspecified )
		EventOption[ "dialog_vars" ][ "hp_regen" ] = EVENT_NPC_DOOM_HP_REGEN_LOST
		EventOption[ "ability_name" ] = "doom_bringer_infernal_blade"
	end
	if nOptionResponse == EVENT_NPC_DOOM_DECLINE then 
		EventOption[ "dismiss" ] = 1
	end
	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_LIFE then
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_1 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetEntity() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetEntity(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetEntity():GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_DoomBringer.Devour", hPlayerHero )
		local nActualGold = self:GiveGoldToPlayer( hPlayerHero, EVENT_NPC_DOOM_GOLD_GAIN_FOR_LIFE )
		hPlayerHero:ForceKill( false )

		local gameEvent = {}
		gameEvent["int_value"] = tonumber( nActualGold )
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventDoom_AcceptGold_Toast"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_HP_REGEN then 
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_3 )

		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hPlayerHero ) )

		EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", hPlayerHero )
		
		local nActualGold = self:GiveGoldToPlayer( hPlayerHero, EVENT_NPC_DOOM_GOLD_GAIN_FOR_HP_REGEN )

		local kv = 
		{
			duration = -1,
			regen_reduction = EVENT_NPC_DOOM_HP_REGEN_LOST,
		}
	
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_doom_regen_reduction", kv )

		local gameEvent = {}
		gameEvent["int_value"] = tonumber( nActualGold )
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventDoom_AcceptMiniGold_Toast"

		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_DOOM_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_DOOM_ACCEPT_GOLD_FOR_LIFE or EVENT_NPC_DOOM_GOLD_GAIN_FOR_HP_REGEN then
		szLines = 
		{
			"doom_bringer_doom_ability_devour_04",
			"doom_bringer_doom_happy_01",
			"doom_bringer_doom_happy_02",
			"doom_bringer_doom_happy_03",
			"doom_bringer_doom_kill_05",
			"doom_bringer_doom_kill_11",
			"doom_bringer_doom_lasthit_02",
			"doom_bringer_doom_lasthit_05",
			"doom_bringer_doom_lasthit_06",
			"doom_bringer_doom_lasthit_07",
			"doom_bringer_doom_lasthit_08",
			"doom_bringer_doom_lasthit_10",
			"doom_bringer_doom_lasthit_11",
			"doom_bringer_doom_purch_01",
			"doom_bringer_doom_purch_02",
			"doom_bringer_doom_thanks_01",
			"doom_bringer_doom_thanks_02",
		} 
	else
		szLines = 
		{
			"doom_bringer_doom_rival_01",
			"doom_bringer_doom_rival_14",
			"doom_bringer_doom_pain_07",
			"doom_bringer_doom_lose_04",
			"doom_bringer_doom_anger_01",
			"doom_bringer_doom_anger_02",
			"doom_bringer_doom_anger_09",
			"doom_bringer_doom_ability_fail_02",
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_DoomLifeSwap:GetInteractEventNPCVoiceLine( hPlayerHero )
		local DoomGreetings =
	{
		"doom_bringer_doom_respawn_01",
		"doom_bringer_doom_respawn_02",
		"doom_bringer_doom_respawn_08",
		"doom_bringer_doom_respawn_12",
		"doom_bringer_doom_laugh_04",
		"doom_bringer_doom_laugh_05",
		"doom_bringer_doom_laugh_06",
		"doom_bringer_doom_laugh_09",
		"doom_bringer_doom_laugh_10",
	}
	return DoomGreetings[ RandomInt( 1, #DoomGreetings ) ]
end

return CEvent_NPC_DoomLifeSwap