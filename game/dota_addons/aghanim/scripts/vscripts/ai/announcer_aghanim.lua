--------------------------------------------------------------------------------

if CAnnouncerAghanim == nil then
	CAnnouncerAghanim = class( {} )
end

--------------------------------------------------------------------------------

function Precache( context )
	
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CAnnouncerAghanim( thisEntity, 1.0 )
		GameRules.Aghanim:SetAnnouncer( thisEntity.AI )
	end
end

--------------------------------------------------------------------------------

function CAnnouncerAghanim:constructor( hUnit, flInterval )
	self.me = hUnit
	self.flDefaultInterval = flInterval
	self.nHeroSelected = 1
	self.flLastSpeakTime = -1000
	self.flPostSpeechTime = -1000
	self.flPostSpeechDelay = 0.5
	self.bIsSpeaking = false
	self.lastAbilityUpgradeHeroes = {}
	self.hSpeakingUnitOverride = nil
	self.nLastLaggingDepth = 0
	self.nLastShopDepth = 0
	self.nCallbacksIssued = 0
	self.me:SetThink( "OnAnnouncerThink", self, "OnAnnouncerThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OverrideSpeakingUnit( hOverrideUnit )
	self.hSpeakingUnitOverride = hOverrideUnit
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:SetServerAuthoritative( bServerAuthoritative )
	self.me:SetServerAuthoritative( bServerAuthoritative )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnAnnouncerThink()

	-- Anything that needs thinking is here
	return self.flDefaultInterval
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:Speak( flDelay, bForce, hCriteriaTable )

	print( "CAnnouncerAghanim:Speak speaking:" .. tostring( self.bIsSpeaking ) .. " ( force: " .. tostring( bForce ) .. " ) " .. hCriteriaTable.announce_event )

	-- Safety valve in case the callback breaks
	if ( self.bIsSpeaking == true ) and ( self.flLastSpeakTime > 0 ) and ( GameRules:GetGameTime() - self.flLastSpeakTime ) > 30 then
		print( "*** ERROR : CAnnouncerAghanim never got the OnSpeechComplete callback!" )
		self.bIsSpeaking = false
	end

	-- Don't overlap lines unless this is a required line
	if bForce == false and self:IsCurrentlySpeaking( ) == true then
		print( "*** CAnnouncerAghanim discarding line -- " .. hCriteriaTable.announce_event .. " ( pst " .. self.flPostSpeechTime .. " cur " .. GameRules:GetGameTime() .. " ) " )
		return false
	end

	-- Add standard criteria all speech has
	hCriteriaTable[ "has_new_players" ] = ( GameRules.Aghanim:HasAnyNewPlayers() == true ) and ( GameRules.Aghanim:IsInTournamentMode() == false )
	hCriteriaTable[ "ascension_level" ] = GameRules.Aghanim:GetAscensionLevel()
	hCriteriaTable[ "tournament_mode" ] = GameRules.Aghanim:IsInTournamentMode()

	local hSpeakingUnit = self.me
	if self.hSpeakingUnitOverride ~= nil then
		hSpeakingUnit = self.hSpeakingUnitOverride
	end

 	self.nCallbacksIssued = self.nCallbacksIssued + 1
	self.flLastSpeakTime = GameRules:GetGameTime() + flDelay
	hSpeakingUnit:QueueConcept( flDelay, hCriteriaTable, Dynamic_Wrap( CAnnouncerAghanim, 'OnSpeechComplete' ), self, { nCallbackIndex = self.nCallbacksIssued } )
	self.bIsSpeaking = true

	return true
	
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnSpeechComplete( bDidActuallySpeak, hCallbackInfo )
	--print( "CAnnouncerAghanim:OnSpeechComplete " .. tostring( bDidActuallySpeak ) .. " " .. hCallbackInfo.nCallbackIndex .. " - " .. self.nCallbacksIssued )
	if hCallbackInfo.nCallbackIndex == self.nCallbacksIssued then
		self.bIsSpeaking = false
		self.flPostSpeechTime = GameRules:GetGameTime() + self.flPostSpeechDelay
	end
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:IsCurrentlySpeaking( )
	return self.bIsSpeaking or ( self.flPostSpeechTime > GameRules:GetGameTime() )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnHeroSelectionStarted( )

	self:Speak( 1.0, true,
	{ 
		announce_event = "hero_selection",
	})

end 

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnHeroSelected( szHeroName )

	self:Speak( 1.0, false,
	{ 
		announce_event = "hero_selected",
		hero_name = szHeroName,
		pick_number = self.nHeroSelected,
	})

	self.nHeroSelected = self.nHeroSelected + 1

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnGameStarted( )

	self:Speak( 3.0, true,
	{ 
		announce_event = "game_started",
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnSelectRewards( )
 
	self:Speak( 1.0, false,
	{ 
		announce_event = "select_rewards",
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnItemPurchased( szHeroName, szItemName )
 
 	local nDepth = GameRules.Aghanim:GetCurrentRoom():GetDepth()
 	if self.nLastShopDepth == nDepth then
 		return
 	end

 	self.nLastShopDepth = nDepth

	self:Speak( 1.0, true,
	{ 
		announce_event = "item_purchased",
		hero_name = szHeroName,
		item = szItemName,
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnGameLost( )

	self:Speak( 1.0, true,
	{ 
		announce_event = "game_lost",
		depth = GameRules.Aghanim:GetCurrentRoom():GetDepth(),
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnGameWon( )

	self:Speak( 1.0, true,
	{ 
		announce_event = "game_won",
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnEncounterSelected( hEncounter )

	if hEncounter:GetRoom():GetDepth() == 1 then
		return
	end

	self:Speak( 3.0, true,
	{ 
		announce_event = "encounter_selected",
		encounter_type = hEncounter:GetRoom():GetType(),
	    encounter_name = hEncounter:GetName(),
	    encounter_act = hEncounter:GetRoom():GetAct(),
	    elite = hEncounter:GetRoom():GetEliteRank(),
		depth = hEncounter:GetRoom():GetDepth(),
		act_boss = GameRules.Aghanim:GetBossUnitForAct( hEncounter:GetRoom():GetAct() )
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnEncounterStarted( hEncounter )

	if hEncounter:GetRoom():GetDepth() == 1 then
		return
	end
	
	self:Speak( 3.0, false,
	{ 
		announce_event = "encounter_started",
		encounter_type = hEncounter:GetRoom():GetType(),
	    encounter_name = hEncounter:GetName(),
	    encounter_act = hEncounter:GetRoom():GetAct(),
	    elite = hEncounter:GetRoom():GetEliteRank(),
		depth = hEncounter:GetRoom():GetDepth(),
		act_boss = GameRules.Aghanim:GetBossUnitForAct( hEncounter:GetRoom():GetAct() )
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnEncounterComplete( hEncounter )

--	local bForceSpeech = false
--	if GameRules.Aghanim:HasAnyNewPlayersForAnnouncer() == true and hEncounter:GetRoom():GetDepth() == 1 then
--		bForceSpeech = true
--	end

	self:Speak( 2.0, true,
	{ 
		announce_event = "encounter_completed",
		encounter_type = hEncounter:GetRoom():GetType(),
	    encounter_name = hEncounter:GetName(),
	    encounter_act = hEncounter:GetRoom():GetAct(),
	    elite = hEncounter:GetRoom():GetEliteRank(),
		depth = hEncounter:GetRoom():GetDepth(),
		act_boss = GameRules.Aghanim:GetBossUnitForAct( hEncounter:GetRoom():GetAct() )
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnRewardSelected( hHero, nDepth, eRewardType, szRewardName )

	self:Speak( 1.0, false,
	{ 
		announce_event = "reward_selected",
		hero_name = hHero:GetUnitName(),
		depth = nDepth,
		reward_type = eRewardType,
	    reward_name = szRewardName,
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnCreatureKilled( hEncounter, hUnit )

	self:Speak( 1.0, false,
	{ 
		announce_event = "creature_killed",
		unit = hUnit:GetUnitName(),
		boss = hUnit:IsBoss(),
		captain = hUnit:IsConsideredHero() == true and hUnit:IsBoss() == false,
	    encounter_name = hEncounter:GetName(),
	    encounter_act = hEncounter:GetRoom():GetAct(),
		depth = hEncounter:GetRoom():GetDepth(),
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnHeroKilled( szHeroName, szKillerUnit, nRespawnsRemaining )

	local kv =
	{
		announce_event = "hero_killed",
		hero_name = szHeroName,
		respawns_remaining = nRespawnsRemaining,
	}

	if szKillerUnit ~= nil then
		kv.killer = szKillerUnit
	end

	-- Long delay to speak after the hero's own death line
	self:Speak( 4.0, false, kv )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnCowardlyHero( szUnitName, szHeroName )

	local kv =
	{
		announce_event = "hero_cowardly",
		unit = szUnitName,
		hero_name = szHeroName,
	}

	self:Speak( 0.5, true, kv )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnLaggingHero( szHeroName, nDepth )

	if self.nLastLaggingDepth >= nDepth then
		return
	end

	self.nLastLaggingDepth = nDepth
	local kv =
	{
		announce_event = "lagging_hero",
		hero_name = szHeroName,
	}

	self:Speak( 0.0, true, kv )
end



