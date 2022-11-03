--------------------------------------------------------------------------------

if CAnnouncerWinter2022 == nil then
	CAnnouncerWinter2022 = class( {} )
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

		thisEntity.AI = CAnnouncerWinter2022( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:constructor( hUnit, flInterval )
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
 
function CAnnouncerWinter2022:OverrideSpeakingUnit( hOverrideUnit )
	self.hSpeakingUnitOverride = hOverrideUnit
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnAnnouncerThink()

	-- Anything that needs thinking is here
	return self.flDefaultInterval
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:Speak( flDelay, bForce, bRestrictToTeam, hCriteriaTable )

	-- print( "CAnnouncerWinter2022:Speak speaking:" .. tostring( self.bIsSpeaking ) .. " ( force: " .. tostring( bForce ) .. " ) " .. hCriteriaTable.announce_event )

	-- Safety valve in case the callback breaks
	if ( self.bIsSpeaking == true ) and ( self.flLastSpeakTime > 0 ) and ( GameRules:GetGameTime() - self.flLastSpeakTime ) > 10 then
		print( "*** ERROR : CAnnouncerWinter2022 never got the OnSpeechComplete callback!" )
		self.bIsSpeaking = false
	end

	-- Don't overlap lines unless this is a required line
	if bForce == false and self:IsCurrentlySpeaking( ) == true then
		print( "*** CAnnouncerWinter2022 discarding line -- " .. hCriteriaTable.announce_event .. " ( pst " .. self.flPostSpeechTime .. " cur " .. GameRules:GetGameTime() .. " ) " )
		return false
	end

	-- Add standard criteria all speech has
	local hSpeakingUnit = self.me
	if self.hSpeakingUnitOverride ~= nil then
		hSpeakingUnit = self.hSpeakingUnitOverride
	end

 	self.nCallbacksIssued = self.nCallbacksIssued + 1
    self.flLastSpeakTime = GameRules:GetGameTime() + flDelay
	if bRestrictToTeam then
		hSpeakingUnit:QueueTeamConceptNoSpectators( flDelay, hCriteriaTable, Dynamic_Wrap( CAnnouncerWinter2022, 'OnSpeechComplete' ), self, { nCallbackIndex = self.nCallbacksIssued } )
	else
		hSpeakingUnit:QueueConcept( flDelay, hCriteriaTable, Dynamic_Wrap( CAnnouncerWinter2022, 'OnSpeechComplete' ), self, { nCallbackIndex = self.nCallbacksIssued } )
	end
	self.bIsSpeaking = true

	return true
	
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnSpeechComplete( bDidActuallySpeak, hCallbackInfo )
	--print( "CAnnouncerWinter2022:OnSpeechComplete " .. tostring( bDidActuallySpeak ) .. " " .. hCallbackInfo.nCallbackIndex .. " - " .. self.nCallbacksIssued )
	if hCallbackInfo.nCallbackIndex == self.nCallbacksIssued then
		self.bIsSpeaking = false
		self.flPostSpeechTime = GameRules:GetGameTime() + self.flPostSpeechDelay
	end
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:IsCurrentlySpeaking( )
	return self.bIsSpeaking or ( self.flPostSpeechTime > GameRules:GetGameTime() )
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnIntroScene( )
	self:Speak( 1.0, true, false,
	{ 
		announce_event = "boss_intro",
	})
end 



--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnHeroSelectionStarted( )
	self:Speak( _G.WINTER2022_BAN_PHASE_TIME - 1.0, true, false,
	{
		announce_event = "hero_selection",
	})
end 

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnStrategyTime( )
	self:Speak( 1.0, false, false,
	{
		announce_event = "strategy_time",
	})
end

--------------------------------------------------------------------------------
 -- unused
function CAnnouncerWinter2022:OnGameStarted( )
	self:Speak( 3.0, true, false,
	{
		announce_event = "game_started",
	})
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnSelectMount( )
	self:Speak( 0, true, true,
	{
		announce_event = "select_mount",
	})
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnMountSelected( hPlayerHero, sChoice )
	self:Speak( 1.0, true, true,
	{
		announce_event = "mount_selected",
		target_player_id = hPlayerHero:GetPlayerOwnerID(),
		mount_type = sChoice,
	})
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnMountCrash( hPlayerHero )
	--print( 'OnMountCrash! Player named ' .. hPlayerHero:GetUnitName() )
	self:Speak( 0.5, false, true,
	{
		announce_event = "mount_mount_crash",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnMountKill( hPlayerHero )
	--print( 'OnMountCrash! Player named ' .. hPlayerHero:GetUnitName() )
	self:Speak( 0.5, false, true,
	{
		announce_event = "mount_kill",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------
 
function CAnnouncerWinter2022:OnRoundStart( nRoundNumber, bFinalRound )

	local well_state_all = nil
	if bFinalRound == true then
		well_state_all = "1v1"
	end

	self:Speak( 2.0, true, false,
	{ 
        announce_event = "round_started",
		well_state_all = well_state_all,
        round = nRoundNumber
	})
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnRoshanAwakes()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, false,
	{
		announce_event = "roshan_awakes",
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnRoshanSleep()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.0, false, false,
	{
		announce_event = "roshan_sleep",
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnRoshanTargetsWell()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, false,
	{
		announce_event = "roshan_targets",
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnRoshanRetargets()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, false,
	{
		announce_event = "roshan_retargets",
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnRoshanTarget( hPlayerHero )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, true,
	{
		announce_event = "roshan_target",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnRoshanSatiated( hPlayerHero )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, true,
	{
		announce_event = "roshan_satiated",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnRoshanKill( hPlayerHero )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, true,
	{
		announce_event = "roshan_kill",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnKill( hKiller, hVictim )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end

	--print( '###ON KILL!' )
	local killed_unit = nil
	if hVictim ~= nil then
		--print( '###VICTIM = ' .. hVictim:GetUnitName() )
		if IsGreevil( hVictim ) then
			killed_unit = "greevil"
			--print( '###GREEVIL KILL!' )
			local hFillingBuff = hVictim:FindModifierByName( "modifier_greevil_filling" )
			if hFillingBuff ~= nil and hFillingBuff:GetFillingType() == WINTER2022_GREEVIL_FILLING_TYPE_PURPLE then
				--print( '###PURPLE GREEVIL KILL!' )
				killed_unit = "greevil_purple"
			end
		end
	end

	local killer_unit = nil
	if hKiller == GameRules.Winter2022.hRoshan then
		--print( '###ROSHAN KILL!' )
		killer_unit = "roshan"
	end

	local has_candy = 0
	if GetCandyCount( hVictim ) > 0 then
		--print( '###VICTIM HAS CANDY!' )
		has_candy = 1
	end

	self:Speak( 1.0, false, true,
	{
		announce_event = "player_kill",
		killed_unit = killed_unit,
		killer_unit = killer_unit,
		has_candy = has_candy,
		target_player_id = hKiller:GetPlayerOwnerID(),
	})
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnDeath( hVictim, hKiller )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end

	local killer_unit = nil
	if hKiller == GameRules.Winter2022.hRoshan then
		killer_unit = "roshan"
	end

	local has_candy = 0
	if GetCandyCount( hVictim ) > 0 then
		has_candy = 1
	end

	self:Speak( 1.0, false, true,
	{
		announce_event = "player_death",
		killer_unit = killer_unit,
		has_candy = has_candy,
		target_player_id = hVictim:GetPlayerOwnerID(),
	})
end

--------------------------------------------------------------------------------

function CAnnouncerWinter2022:OnHeroRespawn( hPlayerHero )
	self:Speak( 1.0, true, true,
	{
		announce_event = "respawn",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnWellAttacked()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, false, true,
	{
		announce_event = "well_attacked"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnWellAttackedEnemy( nHeroID )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, false, true,
	{
		announce_event = "well_attacked_enemy",
		target_player_id = nHeroID,
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnWellLost( nWellsRemaining )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, true, true,
	{
		announce_event = "well_lost",
		well_state = nWellsRemaining,
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnWellLostEnemy( nWellsRemaining )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, true, true,
	{
		announce_event = "well_lost_enemy",
		well_state_enemy = nWellsRemaining,
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnBucketAttacked()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, true, true,
	{
		announce_event = "bucket_attacked"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnCountdown( nSeconds )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	--print("--- Speaking countdown, seconds " .. nSeconds )
	-- checking is now done directly at callsite in diretide_think.lua
	--if nSeconds == 30 or nSeconds == 20 or nSeconds == 10 or ( nSeconds <= 5 and nSeconds >= 1 ) then
		self:Speak( 0.0, true, false, 
		{ 
			announce_event = "timer_" .. nSeconds
		})
	--end
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnWin()
	self:Speak( 1.0, true, true,
	{
		announce_event = "diretide_win"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnLoss()
	self:Speak( 1.0, true, true,
	{
		announce_event = "diretide_loss"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnSpectatorWinLoss( nTeam )
	self:Speak( 1.0, true, true,
	{
		announce_event = ( nTeam == DOTA_TEAM_GOODGUYS and "diretide_spectator_radiant_win" ) or "diretide_spectator_dire_win"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnKillStreak( nStreak, nKillerID, nVictimID )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, true, true,
	{
		announce_event = "killing_spree",
		target_player_id = nKillerID
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnCandyPickup( nHeroID )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	--print( 'SPEAK CANDY PICKUP!' )
	self:Speak( 0.1, false, true,
	{
		announce_event = "candy_pickup",
		target_player_id = nHeroID,
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnCandyScoreLow( nHeroID )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, false, true,
	{
		announce_event = "scoring_candy_low",
		target_player_id = nHeroID,
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnCandyScoreHigh( nHeroID )
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, false, true,
	{
		announce_event = "scoring_candy_high",
		target_player_id = nHeroID,
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnCandyScoreAlly()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, true, true,
	{
		announce_event = "ally_score"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnCandyScoreEnemy()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, true, true,
	{
		announce_event = "enemy_score"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnTaffyGuardianAggro()
	if not ( GameRules.Winter2022 ~= nil and GameRules.Winter2022.m_GameState == WINTER2022_GAMESTATE_GAME_IN_PROGRESS ) then
		return
	end
	--print( 'TAFFY GUARDIAN AGGRO' )
	self:Speak( 0.1, false, true,
	{
		announce_event = "guardian_attacks_allied"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerWinter2022:OnRoundEnd()
	self:Speak( 1.0, true, false,
	{
		announce_event = "round_end"
	})
end
