
--------------------------------------------------------------------------------
function CDiretide:OnThink()
	local oldGameState = self.m_GameState
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME and self.m_GameState == _G.DIRETIDE_GAMESTATE_PREGAME then
		self:OnThink_Pregame()
	elseif self.m_GameState == _G.DIRETIDE_GAMESTATE_INTERSTITIAL_ROUND_PHASE then
		self:OnThink_InterstitialRoundPeriod()
	elseif self.m_GameState == _G.DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS then
		self:OnThink_RoundInProgress()
	elseif self.m_GameState == _G.DIRETIDE_GAMESTATE_DISPLAY_FINAL_ROUND_RESULTS then
		self:OnThink_DisplayFinalGameResults()
	elseif self.m_GameState == _G.DIRETIDE_GAMESTATE_ENDING_CINEMATIC then
		self:OnThink_EndingCinematic()
	elseif self.m_GameState == _G.DIRETIDE_GAMESTATE_GAMEOVER then
		-- We're done thinking.
		return
	end

	local nTrickOrTreatHeroID = 0
	local nTrickOrTreatTeam = 0
	local nTrickOrTreatTargetEntIndex = -1
	local nRoshanCandy = 0
	local bRoshanNearPlayer = false
	local nTrickOrTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
	if self.hRoshan ~= nil then
		nTrickOrTreatMode = self.hRoshan.nTreatMode
		if self.hRoshan.hTrickOrTreatTarget ~= nil then
			nTrickOrTreatHeroID = self.hRoshan.hTrickOrTreatTarget:GetHeroID()
			nTrickOrTreatTeam = self.hRoshan.hTrickOrTreatTarget:GetTeamNumber()
			nTrickOrTreatTargetEntIndex = self.hRoshan.hTrickOrTreatTarget:entindex()
			bRoshanNearPlayer = self.hRoshan.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK

			local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
			if hBuff then
				nRoshanCandy = hBuff:GetStackCount()
				if bRoshanNearPlayer == false then
					bRoshanNearPlayer = self.hRoshan.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST and hBuff.flRequestTimer ~= -1
				end
			end
		end
	end

	local nRadiantLosingCandy = 0
	if self.bForceLosingCandy[DOTA_TEAM_GOODGUYS] == true then
		nRadiantLosingCandy = 1
	elseif self:IsRoundInProgress() and self._buildingHomeHurtTimerRadiant ~= nil and self._buildingHomeHurtTimerRadiant > GameRules:GetGameTime() then
		nRadiantLosingCandy = 1
	end

	local nDireLosingCandy = 0
	if self.bForceLosingCandy[DOTA_TEAM_BADGUYS] == true then
		nDireLosingCandy = 1
	elseif self:IsRoundInProgress() and self._buildingHomeHurtTimerDire ~= nil and self._buildingHomeHurtTimerDire > GameRules:GetGameTime() then
		nDireLosingCandy = 1
	end

	CustomNetTables:SetTableValue( "globals", "values", { 
		GameState = self.m_GameState,
		RoundNumber = self:GetRoundNumber(),
		TimeRoundStarted = self.m_flTimeRoundStarted,
		TimeRoundEnds = self.m_flTimeRoundEnds,
		DireScore = self.m_nTeamScore[ _G.DOTA_TEAM_BADGUYS ],
		RadiantScore = self.m_nTeamScore[ _G.DOTA_TEAM_GOODGUYS ],
		DireExtraCandy = self:GetTeamExtraCandy( DOTA_TEAM_BADGUYS ),
		RadiantExtraCandy = self:GetTeamExtraCandy( DOTA_TEAM_GOODGUYS ),
		TrickOrTreatHeroID = nTrickOrTreatHeroID,
		TrickOrTreatTeam = nTrickOrTreatTeam,
		TrickOrTreatMode = nTrickOrTreatMode,
		RoshanNearPlayer = bRoshanNearPlayer,
		TrickOrTreatTargetEntIndex = nTrickOrTreatTargetEntIndex,
		RoshanCandy = nRoshanCandy,
		RadiantBucketHurt = nRadiantLosingCandy,
		DireBucketHurt = nDireLosingCandy,
	} )
	GameRules:GetGameModeEntity():SetCustomRadiantScore( self.m_nTeamScore[ _G.DOTA_TEAM_GOODGUYS ] )
	GameRules:GetGameModeEntity():SetCustomDireScore( self.m_nTeamScore[ _G.DOTA_TEAM_BADGUYS ] )
	
	self:ThinkCandyExpiry()
	self:ThinkAnnouncers()

	-- If we've advanced the game state, think once again
	if oldGameState ~= self.m_GameState then
		return self:OnThink()
	else
		return DIRETIDE_THINK_INTERVAL
	end
end

--------------------------------------------------------------------------------

function CDiretide:ThinkAnnouncers()
	if self.bHasAnnouncedHeroSelection == nil and GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self.bHasAnnouncedHeroSelection = true
		self:GetGlobalAnnouncer():OnHeroSelectionStarted()
	end
end

--------------------------------------------------------------------------------
function CDiretide:OnThink_Pregame()
	if not self.m_bHaveHeroesLoaded then
		local bAllHaveLoaded = true
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:IsValidTeamPlayerID( nPlayerID ) and PlayerResource:HasSelectedHero( nPlayerID ) then
				if PlayerResource:GetSelectedHeroEntity( nPlayerID ) == nil then
					bAllHaveLoaded = false
				end
			end
		end
		
		-- Once everyone has loaded in, move to round in progress.
		if ( bAllHaveLoaded ) then
			self.m_nRoundNumber = 1
			self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + ( ( self.m_bFastPlay and 5 ) or _G.DIRETIDE_FIRST_ROUND_SETUP_TIME )
			self.m_GameState = _G.DIRETIDE_GAMESTATE_INTERSTITIAL_ROUND_PHASE
			return
		end
	end
end

--------------------------------------------------------------------------------
function CDiretide:OnThink_InterstitialRoundPeriod()
	local flTime = GameRules:GetDOTATime( false, true )
	if self.m_nLastRoundStartSound < self:GetRoundNumber() and flTime >= self.m_flTimeRoundEnds - _G.DIRETIDE_PLAY_ROUND_START_EARLY_SECONDS then
		EmitGlobalSound( "RoundBegin.Default" )
		self.m_nLastRoundStartSound = self:GetRoundNumber()
	end
	if self.m_nLastRoundStartShown < self:GetRoundNumber() and flTime > self.m_flTimeRoundEnds - _G.DIRETIDE_SHOW_ROUND_START_EARLY_SECONDS then
		self:ShowRoundStart()
		self.m_nLastRoundStartShown = self:GetRoundNumber()
	end
	if flTime > self.m_flTimeRoundEnds then
		self:StartRound()
		return
	end
end

--------------------------------------------------------------------------------
function CDiretide:ShowRoundStart()
	-- Find round name
	local szRoundName = nil
	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		local waveManager = self._vWaveManagers[nTeam][self:GetRoundNumber()]
		if szRoundName == nil then
			szRoundName = waveManager._szRoundQuestTitle
		end
	end
	FireGameEvent( "round_start", {
		round_number = self:GetRoundNumber(),
		round_name = szRoundName,
	 } )
end

--------------------------------------------------------------------------------
function CDiretide:OnThink_DisplayFinalGameResults()
	local flTime = GameRules:GetDOTATime( false, true )
	if self.m_bFadedToBlack == nil then
		if flTime >= self.m_flTimeRoundEnds - 2.0 then
			FireGameEvent( "fade_to_black", {
				fade_down = 1,
				} )

			self.m_bFadedToBlack = true
		end
	end
	if flTime > self.m_flTimeRoundEnds then
		self:PlayEndGameCinematic( FlipTeamNumber( self.nWinningTeam ) )

		self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + _G.DIRETIDE_ENDING_CINEMATIC_TIME
		self.m_GameState = _G.DIRETIDE_GAMESTATE_ENDING_CINEMATIC
		return
	end
end

--------------------------------------------------------------------------------
function CDiretide:OnThink_EndingCinematic()
	local flTime = GameRules:GetDOTATime( false, true )
	if flTime > self.m_flTimeRoundEnds then	
		self:EndGame()
		self.m_GameState = _G.DIRETIDE_GAMESTATE_GAMEOVER
		return
	end
end

--------------------------------------------------------------------------------
function CDiretide:OnThink_RoundInProgress()
	if self._bDevMode and self._bDevNoRounds then
		return 1
	end

	local flRoundTime = GameRules:GetDOTATime( false, true ) - self.m_flTimeRoundStarted
	local flTimeRemaining = self.m_flTimeRoundEnds - GameRules:GetDOTATime( false, true )

	if flTimeRemaining < 0 then
		self:RoundTimeExpired()
		return
	end

	if self.nQueueRoshanForTeam ~= nil then
		local bIncrement = true
		if self.nQueueRoshanForTeam < 0 then
			bIncrement = false
			self.nQueueRoshanForTeam = -self.nQueueRoshanForTeam
		end
		local nAttackTeam = self.nQueueRoshanForTeam
		self.nQueueRoshanForTeam = nil
		self:TrickOrTreatToTeam( nAttackTeam, bIncrement )
	elseif self.bRoshanActive ~= true and flRoundTime >= _G.ROSHAN_UNLEASH_TIME_IF_NOT_ALREADY then
		self:TrickOrTreatToTeam( 0, true )
	end

	-- Respawn candy
	local bShowMessage = false

	if self.m_flCandySpawnTime <= GameRules:GetDOTATime( false, true ) then
		if self.m_vecMapCandyRespawnBuckets ~= nil then
			for nKey, bValue in pairs( self.m_vecMapCandyRespawnBuckets ) do
				local bSpawn = true
				for _, hItem in pairs( self.m_vecNeutralItemDrops ) do
					if hItem ~= nil and hItem:IsNull() == false and hItem.nMapCandyBucketIndex == nKey then
						hItem:SetAbsOrigin( hItem:GetAbsOrigin() + RandomVector( 150 ) )
					end
				end
				
				--print( "Respawning candy bucket at location " .. nKey )
			
				local vPos = self.m_vecMapCandySpawns[ nKey ]
				local hNewBucket = CreateUnitByName( "neutral_candy_bucket", vPos, false, nil, nil, DOTA_TEAM_NEUTRALS )
				if hNewBucket ~= nil then
					self:AddCandyBucketModifiers( hNewBucket, false, false )

					hNewBucket:AddNewModifier( nil, nil, "modifier_neutral_candy_bucket", { duration = -1 } )

					-- Knockback any units around where this unit spawns, since FindClearSpace isn't working
					local fKnockbackRadius = 150
					local nFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
					local hEnemies = FindUnitsInRadius( hNewBucket:GetTeamNumber(), hNewBucket:GetOrigin(), hNewBucket, fKnockbackRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, nFlags , 0, false )
					if #hEnemies > 0 then
						for _, hEnemy in pairs( hEnemies ) do
							if hEnemy ~= nil and hEnemy:IsNull() == false then
								local kv =
								{
									center_x = hNewBucket:GetAbsOrigin().x,
									center_y = hNewBucket:GetAbsOrigin().y,
									center_z = hNewBucket:GetAbsOrigin().z,
									should_stun = false,
									duration = 0.3,
									knockback_duration = 0.3,
									knockback_distance = 150,
									knockback_height = 50,
								}

								hEnemy:AddNewModifier( hNewBucket, nil, "modifier_knockback", kv )
							end
						end
					end

					--FindClearSpaceForUnit( hNewBucket, hNewBucket:GetAbsOrigin(), true )

					hNewBucket.nMapCandyBucketIndex = nKey

					MinimapEvent( DOTA_TEAM_GOODGUYS, hNewBucket, hNewBucket:GetAbsOrigin().x, hNewBucket:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
					MinimapEvent( DOTA_TEAM_BADGUYS, hNewBucket, hNewBucket:GetAbsOrigin().x, hNewBucket:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
					--GameRules:ExecuteTeamPing( DOTA_TEAM_GOODGUYS, vPos.x, vPos.y, hNewBucket, 0 )
					--GameRules:ExecuteTeamPing( DOTA_TEAM_BADGUYS, vPos.x, vPos.y, hNewBucket, 0 )

					local nSpawnFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hNewBucket )
					ParticleManager:SetParticleControl( nSpawnFXIndex, 0, hNewBucket:GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( nSpawnFXIndex )
				end
				
			end
			self.m_vecMapCandyRespawnBuckets = {}
		end

		self.m_flCandySpawnTime = _G.DIRETIDE_MAP_CANDY_SPAWN_INTERVAL + GameRules:GetDOTATime( false, true )

		FireGameEvent( "stash_respawn", {
			} )


		local gameEvent = {}
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_ScarecrowStashRespawn"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	-- Round Timer Countdown VO
	local nSecondsToSpeak = -1
	for k,v in pairs( self.vecRoundTimerCues ) do
		if v == true and k > nSecondsToSpeak and k >= flTimeRemaining - _G.DIRETIDE_ANNOUNCER_TIMER_OFFSET then
			nSecondsToSpeak = k
		end
	end

	if nSecondsToSpeak >= 0 then
		self.vecRoundTimerCues[nSecondsToSpeak] = false
		self:GetGlobalAnnouncer():OnCountdown( nSecondsToSpeak )
		FireGameEvent( "time_left", {
			time_left = nSecondsToSpeak,
		 } )
	end

	if self._flPrepTimeEnd ~= nil then
		self:ThinkPrepTime()
	elseif self._currentWaves ~= nil then
		for _,waveManager in pairs( self._currentWaves ) do
			waveManager:Think()
		end
	end
end
