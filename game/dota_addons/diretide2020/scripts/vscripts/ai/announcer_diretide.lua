--------------------------------------------------------------------------------

if CAnnouncerDiretide == nil then
	CAnnouncerDiretide = class( {} )
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

		thisEntity.AI = CAnnouncerDiretide( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CAnnouncerDiretide:constructor( hUnit, flInterval )
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
 
function CAnnouncerDiretide:OverrideSpeakingUnit( hOverrideUnit )
	self.hSpeakingUnitOverride = hOverrideUnit
end

--------------------------------------------------------------------------------
 
function CAnnouncerDiretide:OnAnnouncerThink()

	-- Anything that needs thinking is here
	return self.flDefaultInterval
end

--------------------------------------------------------------------------------
 
function CAnnouncerDiretide:Speak( flDelay, bForce, bRestrictToTeam, hCriteriaTable )

	-- print( "CAnnouncerDiretide:Speak speaking:" .. tostring( self.bIsSpeaking ) .. " ( force: " .. tostring( bForce ) .. " ) " .. hCriteriaTable.announce_event )

	-- Safety valve in case the callback breaks
	if ( self.bIsSpeaking == true ) and ( self.flLastSpeakTime > 0 ) and ( GameRules:GetGameTime() - self.flLastSpeakTime ) > 30 then
		print( "*** ERROR : CAnnouncerDiretide never got the OnSpeechComplete callback!" )
		self.bIsSpeaking = false
	end

	-- Don't overlap lines unless this is a required line
	if bForce == false and self:IsCurrentlySpeaking( ) == true then
		print( "*** CAnnouncerDiretide discarding line -- " .. hCriteriaTable.announce_event .. " ( pst " .. self.flPostSpeechTime .. " cur " .. GameRules:GetGameTime() .. " ) " )
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
		hSpeakingUnit:QueueTeamConceptNoSpectators( flDelay, hCriteriaTable, Dynamic_Wrap( CAnnouncerDiretide, 'OnSpeechComplete' ), self, { nCallbackIndex = self.nCallbacksIssued } )
	else
		hSpeakingUnit:QueueConcept( flDelay, hCriteriaTable, Dynamic_Wrap( CAnnouncerDiretide, 'OnSpeechComplete' ), self, { nCallbackIndex = self.nCallbacksIssued } )
	end
	self.bIsSpeaking = true

	return true
	
end

--------------------------------------------------------------------------------
 
function CAnnouncerDiretide:OnSpeechComplete( bDidActuallySpeak, hCallbackInfo )
	--print( "CAnnouncerDiretide:OnSpeechComplete " .. tostring( bDidActuallySpeak ) .. " " .. hCallbackInfo.nCallbackIndex .. " - " .. self.nCallbacksIssued )
	if hCallbackInfo.nCallbackIndex == self.nCallbacksIssued then
		self.bIsSpeaking = false
		self.flPostSpeechTime = GameRules:GetGameTime() + self.flPostSpeechDelay
	end
end

--------------------------------------------------------------------------------
 
function CAnnouncerDiretide:IsCurrentlySpeaking( )
	return self.bIsSpeaking or ( self.flPostSpeechTime > GameRules:GetGameTime() )
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnIntroScene( )
	self:Speak( 1.0, true, false,
	{ 
		announce_event = "boss_intro",
	})
end 



--------------------------------------------------------------------------------
 
function CAnnouncerDiretide:OnHeroSelectionStarted( )
	self:Speak( DIRETIDE_BAN_PHASE_TIME - 1.0, true, false,
	{ 
		announce_event = "hero_selection",
	})
end 

--------------------------------------------------------------------------------
 
function CAnnouncerDiretide:OnGameStarted( )
	self:Speak( 3.0, true, false,
	{ 
		announce_event = "game_started",
	})
end

--------------------------------------------------------------------------------
 
function CAnnouncerDiretide:OnRoundStart( nRoundNumber )
	self:Speak( 0.0, true, false,
	{ 
        announce_event = "round_started",
        round = nRoundNumber
	})
end

--------------------------------------------------------------------------------

function CAnnouncerDiretide:OnRoshanTarget( hPlayerHero )
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, true,
	{
		announce_event = "roshan_target",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerDiretide:OnRoshanSatiated( hPlayerHero )
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, true,
	{
		announce_event = "roshan_satiated",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerDiretide:OnRoshanKill( hPlayerHero )
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.25, true, true,
	{
		announce_event = "roshan_kill",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	} )
end

--------------------------------------------------------------------------------

function CAnnouncerDiretide:OnHeroRespawn( hPlayerHero )
	self:Speak( 1.0, true, true,
	{
		announce_event = "respawn",
		target_player_id = hPlayerHero:GetPlayerOwnerID()
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnWellAttacked()
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, false, true,
	{
		announce_event = "well_attacked"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnWellLost()
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, true, true,
	{
		announce_event = "well_lost"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnBucketAttacked()
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.2, true, true,
	{
		announce_event = "bucket_attacked"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnCountdown( nSeconds )
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	-- checking is now done directly at callsite in diretide_think.lua
	--if nSeconds == 30 or nSeconds == 20 or nSeconds == 10 or ( nSeconds <= 5 and nSeconds >= 1 ) then
		self:Speak( 0.0, true, false, 
		{ 
			announce_event = "timer_" .. nSeconds
		})
	--end
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnWin()
	self:Speak( 1.0, true, true,
	{
		announce_event = "diretide_win"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnLoss()
	self:Speak( 1.0, true, true,
	{
		announce_event = "diretide_loss"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnSpectatorWinLoss( nTeam )
	self:Speak( 1.0, true, true,
	{
		announce_event = ( nTeam == DOTA_TEAM_GOODGUYS and "diretide_spectator_radiant_win" ) or "diretide_spectator_dire_win"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnKillStreak( nStreak, nKillerID, nVictimID )
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, true, true,
	{
		announce_event = "killing_spree",
		target_player_id = nKillerID
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnCandyScoreAlly()
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, true, true,
	{
		announce_event = "ally_score"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnCandyScoreEnemy()
	if not ( GameRules.Diretide ~= nil and GameRules.Diretide.m_GameState == DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS ) then
		return
	end
	self:Speak( 0.1, true, true,
	{
		announce_event = "enemy_score"
	})
end

--------------------------------------------------------------------------------
function CAnnouncerDiretide:OnRoundEnd()
	self:Speak( 1.0, true, false,
	{
		announce_event = "round_end"
	})
end
