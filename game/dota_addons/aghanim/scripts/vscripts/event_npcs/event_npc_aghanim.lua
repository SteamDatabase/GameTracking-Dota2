
require( "event_npc" )

--------------------------------------------------------------------------------

if CEvent_NPC_Aghanim == nil then
	CEvent_NPC_Aghanim = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:GetEventNPCName()
	return "npc_dota_announcer_aghanim"
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:TrackStats()
	return false
end

--------------------------------------------------------------------------------

EVENT_NPC_AGHANIM_EXIT = 0
EVENT_NPC_AGHANIM_SPEAK_EXPOSITION = 1
EVENT_NPC_AGHANIM_SHARD = 2
EVENT_NPC_AGHANIM_SHARD_AND_BLESSINGS = 3

function CEvent_NPC_Aghanim:GetEventOptionsResponses( hPlayerHero )
	local tBlessings = PlayerResource:GetEventGameUpgrades( hPlayerHero:GetPlayerOwnerID() )
	
	if hPlayerHero.bHasFirstShard then
		self.vecEventDescriptionOverrides[ hPlayerHero:GetPlayerID() ] = "npc_dota_announcer_aghanim_event_body_description_return"
	else
		self.vecEventDescriptionOverrides[ hPlayerHero:GetPlayerID() ] = nil
	end

	if hPlayerHero.bHasFirstShard then
		return { EVENT_NPC_AGHANIM_EXIT, EVENT_NPC_AGHANIM_SPEAK_EXPOSITION }
	elseif tBlessings ~= nil and next( tBlessings ) ~= nil then
		return { EVENT_NPC_AGHANIM_SHARD_AND_BLESSINGS }
	else
		return { EVENT_NPC_AGHANIM_SHARD }
	end
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}

	EventOption[ "dialog_vars" ] = {}
	EventOption[ "dismiss" ] = 1

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if self.bAllPlayersLoaded == true and hPlayerHero.bHasFirstShard ~= true and ( nOptionResponse == EVENT_NPC_AGHANIM_SHARD or nOptionResponse == EVENT_NPC_AGHANIM_SHARD_AND_BLESSINGS ) then
		if nOptionResponse == EVENT_NPC_AGHANIM_SHARD_AND_BLESSINGS then
			GameRules.Aghanim:InitBlessings( hPlayerHero )
		end

		print( " @@ Aghanim generating shard for " .. hPlayerHero:GetUnitName() )
		hPlayerHero.bHasFirstShard = true
		local nPlayerID = hPlayerHero:GetPlayerOwnerID()

		local nDepth = GameRules.Aghanim:GetCurrentRoom():GetDepth()
		local szDepth = string.format( "%d", nDepth )

		local RewardOptions = CustomNetTables:GetTableValue( "reward_options", szDepth )
		if RewardOptions == nil then
			print( " @@ No reward options!!" )
			RewardOptions = {}
		end
		
		-- certain abilities (like auras) we want to prevent being rolled more than once by the party as a whole
		local vecAbilityNamesToExclude = {}
		
		for _,szAbilityName in pairs( GetPlayerAbilityAndItemNames( nPlayerID ) ) do
			if string.match( szAbilityName, "aghsfort_aura" ) or string.match( szAbilityName, "aghsfort_tempbuff" ) then
				table.insert( vecAbilityNamesToExclude, szAbilityName )
			end
		end
	
		local vecPlayerRewards = GetRoomRewards( nDepth, false, nPlayerID, vecAbilityNamesToExclude )
		RewardOptions[ tostring(nPlayerID) ] = vecPlayerRewards
		--print( "CMapEncounter:GenerateRewards - Sending rewards to player id " .. nPlayerID .. " for encounter " .. self.szEncounterName )
		DeepPrintTable( vecPlayerRewards )

		CustomNetTables:SetTableValue( "reward_options", szDepth, RewardOptions )

		-- Reinitialize options
		self:GetEventOptionsData( hPlayerHero, true )

		-- Never speak exposition when getting a shard
		return EVENT_NPC_OPTION_DISMISS
	end

	if nOptionResponse == EVENT_NPC_AGHANIM_SPEAK_EXPOSITION then
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		GameRules.Aghanim:GetAnnouncer():OnSpeakExposition()
		return EVENT_NPC_OPTION_DISMISS
	end
	
	if nOptionResponse == EVENT_NPC_AGHANIM_EXIT then 
		return EVENT_NPC_OPTION_DISMISS
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	return nil 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:GetInteractEventNPCVoiceLine( hPlayerHero )
	return nil 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:GetInteractionLimitForNPC()
	return EVENT_NPC_SHOP_STYLE
end

--------------------------------------------------------------------------------

function CEvent_NPC_Aghanim:OnInteractWithNPC( event )
	if self.bAllPlayersLoaded ~= true then
		local nPlayerHeroEntIndex = event.entindex_hero
		if nPlayerHeroEntIndex == nil then
			print( "no ent index" )
			return
		end
		local hPlayerHero = EntIndexToHScript( nPlayerHeroEntIndex )
		if hPlayerHero == nil then
			print( "no valid entity" )
			return
		end

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#Aghanim_WaitForOtherPlayers"
		FireGameEvent( "dota_combat_event_message", gameEvent )
		return
	end

	if self.bHasFirstPlayerInteracted ~= true then
		GameRules.Aghanim:GetAnnouncer():OnSelectRewards()
		self.bHasFirstPlayerInteracted = true
	end

	CEvent_NPC.OnInteractWithNPC( self, event )
end

--------------------------------------------------------------------------------


return CEvent_NPC_Aghanim
