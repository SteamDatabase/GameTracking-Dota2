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
		GameRules.Aghanim:GetAnnouncer():SetServerAuthoritative( true ) 
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
	self.flHoldEncourageTime = -1
	self.flLastEncourageTime = -1
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:GetUnit()
	return self.me
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
	--PrintTable( hCriteriaTable, " criteria --> " )

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
	hCriteriaTable[ "ascension_level" ] = math.min( 4, GameRules.Aghanim:GetAscensionLevel() )
	hCriteriaTable[ "tournament_mode" ] = GameRules.Aghanim:IsInTournamentMode()
	local nNumEnemies = 0
	if GameRules.Aghanim:GetCurrentRoom() ~= nil then
		local hEnemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, GameRules.Aghanim:GetCurrentRoom():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
		nNumEnemies = #hEnemies
	end
	hCriteriaTable[ "active_enemies" ] = nNumEnemies

	local nNumMale = 0
	local nNumValid = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero ~= nil then
			nNumValid = nNumValid + 1
			local szUnitName = hPlayerHero:GetUnitName()
			local nHeroGender = _G.HERO_GENDER[ szUnitName ]
			if nHeroGender == 1 then
				nNumMale = nNumMale + 1
			end
		end
	end
	if nNumValid > 0 and nNumValid < 4 then
		nNumMale = math.floor ( ( 4.0 / nNumValid ) * nNumMale + 0.5 )
	end

	hCriteriaTable[ "party_gender" ] = nNumMale

	if hCriteriaTable[ "encounter_type" ] == ROOM_TYPE_BOSS then
		local szEncounterName = hCriteriaTable[ "encounter_name" ]
		if szEncounterName == "encounter_boss_earthshaker"
				or szEncounterName == "encounter_boss_visage"
				or szEncounterName == "encounter_boss_arc_warden"
				or szEncounterName == "encounter_boss_clockwerk_tinker"
				or szEncounterName == "encounter_boss_amoeba"
				then
			hCriteriaTable[ "boss_male" ] = 1
		end
		if szEncounterName == "encounter_boss_winter_wyvern"
				or szEncounterName == "encounter_boss_earthshaker"
				or szEncounterName == "encounter_boss_dark_willow"
				or szEncounterName == "encounter_boss_visage"
				or szEncounterName == "encounter_boss_arc_warden"
				or szEncounterName == "encounter_boss_amoeba"
				then
			hCriteriaTable[ "boss_single" ] = 1
		end
	end

	if hCriteriaTable[ "encounter_type" ] == ROOM_TYPE_EVENT then
		local szEncounterName = hCriteriaTable[ "encounter_name" ]
		if szEncounterName == "encounter_event_minor_shard_shop"
				or szEncounterName == "encounter_event_doom_life_swap"
				or szEncounterName == "encounter_event_warlock_library"
				or szEncounterName == "encounter_event_alchemist_neutral_items"
				or szEncounterName == "encounter_event_brewmaster_bar"
				or szEncounterName == "encounter_event_life_shop"
				or szEncounterName == "encounter_event_morphling_attribute_shift"
				or szEncounterName == "encounter_event_tinker_range_retrofit"
				or szEncounterName == "encounter_event_slark"
				or szEncounterName == "encounter_event_zeus"
				or szEncounterName == "encounter_event_leshrac"
				or szEncounterName == "encounter_event_necrophos"
				or szEncounterName == "encounter_event_small_tiny_shrink"
				or szEncounterName == "encounter_event_big_tiny_grow"
				or szEncounterName == "encounter_event_ogre_magi_casino"
				then
			hCriteriaTable[ "event_npc_male" ] = 1
		end
	end

	hCriteriaTable[ "always_valid_1" ] = 1
	hCriteriaTable[ "always_valid_2" ] = 1

	hCriteriaTable[ "lost_to_beast" ] = GameRules.Aghanim:HaveAllPlayersLostToPrimalBeast()

	local hSpeakingUnit = self.me
	if self.hSpeakingUnitOverride ~= nil then
		hSpeakingUnit = self.hSpeakingUnitOverride
	end

	if hSpeakingUnit == nil or hSpeakingUnit:IsNull() == true then
		--print( "abort speaking: announcer nil" )
		return false
	end

	self.nCallbacksIssued = self.nCallbacksIssued + 1
	print( "@@@@ Speak! Event " .. ( ( hCriteriaTable.announce_event ~= nil and hCriteriaTable.announce_event ) or "none" ) .. ", callback " .. self.nCallbacksIssued )
	self.flLastSpeakTime = GameRules:GetGameTime() + flDelay
	self.bIsSpeaking = true
	hSpeakingUnit:QueueConcept( flDelay, hCriteriaTable, Dynamic_Wrap( CAnnouncerAghanim, 'OnSpeechComplete' ), self, { nCallbackIndex = self.nCallbacksIssued } )

	return true
	
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnSpeechComplete( bDidActuallySpeak, hCallbackInfo )
	print( "@@@@ CAnnouncerAghanim:OnSpeechComplete " .. tostring( bDidActuallySpeak ) .. " " .. hCallbackInfo.nCallbackIndex .. " - " .. self.nCallbacksIssued )
	if hCallbackInfo.nCallbackIndex == self.nCallbacksIssued then
		self.bIsSpeaking = false
		self.flPostSpeechTime = GameRules:GetGameTime() + ( ( bDidActuallySpeak and self.flPostSpeechDelay ) or 0 )
	elseif hCallbackInfo.nCallbackIndex < self.nCallbacksIssued then
		print( "@@@ CAnnouncerAghanim:OnSpeechComplete -- we got a callback for a previous line: " .. hCallbackInfo.nCallbackIndex .. ", with current index " .. self.nCallbacksIssued )
	end
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:IsCurrentlySpeaking( )
	return self.bIsSpeaking or ( self.flPostSpeechTime > GameRules:GetGameTime() )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnHeroSelectionStarted( )

	self:Speak( 0.2, true,
	{ 
		announce_event = "hero_selection",
	})

end 

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnHeroSelected( szHeroName )

	self:Speak( 0.2, false,
	{ 
		announce_event = "hero_selected",
		hero_name = szHeroName,
		pick_number = self.nHeroSelected,
	})

	self.nHeroSelected = self.nHeroSelected + 1

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnGameStarted( )

	self:Speak( -1.0, true,
	{ 
		announce_event = "game_started",
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnSelectRewards( )
 
	self:Speak( 1.0, false,
	{ 
		announce_event = "select_rewards",
		depth = GameRules.Aghanim:GetCurrentRoom():GetDepth(),
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnItemPurchased( szHeroName, szItemName )
 
 	local nDepth = GameRules.Aghanim:GetCurrentRoom():GetDepth()
 	if self.nLastShopDepth == nDepth then
 		return
 	end

 	self.nLastShopDepth = nDepth

	self:Speak( 1.0, false,
	{ 
		announce_event = "item_purchased",
		hero_name = szHeroName,
		item = szItemName,
	})

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnShopSpawn()
 
 	local nDepth = GameRules.Aghanim:GetCurrentRoom():GetDepth()
 	if self.nLastShopDepthSpawned == nDepth then
 		return
 	end

 	self.nLastShopDepthSpawned = nDepth

	self:Speak( 1.0, false,
	{ 
		announce_event = "shop_spawn",
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

	local kv = { 
		announce_event = "encounter_selected",
		encounter_type = hEncounter:GetRoom():GetType(),
	    encounter_name = hEncounter:GetName(),
	    encounter_act = hEncounter:GetRoom():GetAct(),
	    elite = hEncounter:GetRoom():GetEliteRank(),
		depth = hEncounter:GetRoom():GetDepth(),
		act_boss = GameRules.Aghanim:GetBossUnitForAct( hEncounter:GetRoom():GetAct() )
	}

	self.flHoldEncourageTime = GameRules:GetGameTime() + 40.0

	self:Speak( 1.0, true, kv )

end

--------------------------------------------------------------------------------
 -- Dirty hack: we're speaking exposition lines as reward room start lines,
 -- so when we want to speak exposition in the Hub, we pass that as the criteria table.
function CAnnouncerAghanim:OnSpeakExposition()

	local kv = { 
		announce_event = "encounter_selected",
		encounter_type = 6,
	    --encounter_name = hEncounter:GetName(),
	    --encounter_act = hEncounter:GetRoom():GetAct(),
	    --elite = hEncounter:GetRoom():GetEliteRank(),
		--depth = hEncounter:GetRoom():GetDepth(),
		--act_boss = GameRules.Aghanim:GetBossUnitForAct( hEncounter:GetRoom():GetAct() )
	}

	self:Speak( 0.5, false, kv )

end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnEncounterStarted( hEncounter )

	if hEncounter:GetRoom():GetDepth() == 1 then
		return
	end
	
	self:Speak( 1.0, false,
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

	-- In the hub, speak the line after the current line rather than stomp the current line.
	local nDepth = hEncounter:GetRoom():GetDepth()
	local flDelay = ( nDepth == 1 and -1.0 ) or 1.0
	self:Speak( flDelay, true,
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

	local flTime = GameRules:GetGameTime()
	if flTime < self.flHoldEncourageTime then
		--print( " $$ Blocking encourage speak, time %f, desired %f", flTime, self.flHoldEncourageTime )
		return
	end

	if flTime < self.flLastEncourageTime + _G.ANNOUNCER_ENCOURAGE_LINE_COOLDOWN then
		--printf( " $$ Encourage line blocked because it is now %f and we last played one at %f", flTime, self.flLastEncourageTime )
		return
	end

	self.flLastEncourageTime = flTime

	self:Speak( 0.0, false,
	{ 
		announce_event = "creature_killed",
		unit = hUnit:GetUnitName(),
		boss = hUnit:IsBoss(),
		captain = hUnit:IsConsideredHero() == true and hUnit:IsBoss() == false,
		encounter_type = hEncounter:GetRoom():GetType(),
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

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnPrimalBeastPhase( nPhase )
	if self.nPrimalBeastPhase == nPhase then
		return
	end

	self.nPrimalBeastPhase = nPhase

	self:Speak( 0.0, true,
	{ 
		announce_event = "primal_beast_phase_activate",
		primal_beast_phase = nPhase,
	})
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnPrimalBeastDefeated( )

	local kv =
	{
		announce_event = "primal_beast_defeated",
	}

	self:Speak( 1.0, true, kv )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnCloneIntroducePre()

	local kv =
	{
		announce_event = "clone_introduce_pre",
	}

	self:Speak( 0, true, kv )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnCloneIntroducePost( szCloneUnitName )

	local kv =
	{
		announce_event = "clone_introduce_post",
		unit_name = szCloneUnitName,
	}

	self:Speak( 0, true, kv )
end

--------------------------------------------------------------------------------
 
function CAnnouncerAghanim:OnAllTalkedToAghanim()

	local kv =
	{
		announce_event = "all_talked_to_aghanim",
	}

	self:Speak( 0.25, true, kv )
end