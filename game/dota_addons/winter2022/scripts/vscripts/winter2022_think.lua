
--------------------------------------------------------------------------------
function CWinter2022:OnThink()
	local oldGameState = self.m_GameState
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME and self.m_GameState == _G.WINTER2022_GAMESTATE_PREGAME then
		self:OnThink_Pregame()
	elseif self.m_GameState == _G.WINTER2022_GAMESTATE_INTERSTITIAL_ROUND_PHASE or self.m_GameState == _G.WINTER2022_GAMESTATE_GAME_IN_PROGRESS_BETWEEN_ROUNDS then
		self:OnThink_InterstitialRoundPeriod()
	elseif self.m_GameState == _G.WINTER2022_GAMESTATE_PREP_TIME then
		self:OnThink_PrepTime()
	elseif self.m_GameState == _G.WINTER2022_GAMESTATE_GAME_IN_PROGRESS then
		self:OnThink_GameInProgress()
	elseif self.m_GameState == _G.WINTER2022_GAMESTATE_DISPLAY_FINAL_ROUND_RESULTS then
		self:OnThink_DisplayFinalGameResults()
	elseif self.m_GameState == _G.WINTER2022_GAMESTATE_ENDING_CINEMATIC then
		self:OnThink_EndingCinematic()
	elseif self.m_GameState == _G.WINTER2022_GAMESTATE_GAMEOVER then
		-- We're done thinking.
		return
	end

	local nTrickOrTreatHeroID = 0
	local nTrickOrTreatTeam = 0
	local nTrickOrTreatTargetEntIndex = -1
	local nRoshanCandy = 0
	local bRoshanNearPlayer = false
	local nTrickOrTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
	if self.hRoshan ~= nil and self.hRoshan:IsNull() == false then
		nTrickOrTreatMode = self.hRoshan.nTreatMode
		if self.hRoshan.hTrickOrTreatTarget ~= nil then
			nTrickOrTreatHeroID = ( self.hRoshan.hTrickOrTreatTarget:IsHero() and self.hRoshan.hTrickOrTreatTarget:GetHeroID() ) or -1
			nTrickOrTreatTeam = self.hRoshan.hTrickOrTreatTarget:GetTeamNumber()
			nTrickOrTreatTargetEntIndex = self.hRoshan.hTrickOrTreatTarget:entindex()
			bRoshanNearPlayer = self.hRoshan.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK
		end
		local hRoshaPassive = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
		if hRoshaPassive ~= nil then
			nRoshanCandy = hRoshaPassive:GetStackCount()
		end
	end

	local sCandyLeaderBuilding = ""
	if self.tCandyLeaderBuilding ~= nil and self.tCandyLeaderBuilding.hEntity:IsNull() == false then
		sCandyLeaderBuilding = self.tCandyLeaderBuilding.hEntity:GetName()
	end

	local nRadiantLosingCandy = 0
	if self.bForceLosingCandy[DOTA_TEAM_GOODGUYS] == true then
		nRadiantLosingCandy = 1
	elseif self:IsGameInProgress() and self._buildingHomeHurtTimerRadiant ~= nil and self._buildingHomeHurtTimerRadiant > GameRules:GetGameTime() then
		nRadiantLosingCandy = 1
	end

	local nDireLosingCandy = 0
	if self.bForceLosingCandy[DOTA_TEAM_BADGUYS] == true then
		nDireLosingCandy = 1
	elseif self:IsGameInProgress() and self._buildingHomeHurtTimerDire ~= nil and self._buildingHomeHurtTimerDire > GameRules:GetGameTime() then
		nDireLosingCandy = 1
	end

	local fGreevilHatchTime = -1
	local fGreevilDespawnTime = -1
	local tRoundSpawnData = self.tGreevilSpawnData[ self.m_nRoundNumber ]
	
	-- Assuming ordered sequence here
	if tRoundSpawnData ~= nil then
		local fStateTime = GameRules:GetDOTATime( false, true ) - self.m_flTimeStateStarted
		for _, spawnData in pairs ( tRoundSpawnData ) do
			local fSpawnTime = 5 -- spawnData.fTime
			local fDespawnTime = _G.WINTER2022_STATE_TIMES[ _G.WINTER2022_STATE_GREEVILS ] + _G.WINTER2022_STATE_TIMES[ _G.WINTER2022_STATE_ROSHAN_KILL_GREEVILS ] -- spawnData.fTime + spawnData.fDuration

			if fSpawnTime <= fStateTime and fDespawnTime >= fStateTime then
				fGreevilHatchTime = fSpawnTime
				fGreevilDespawnTime = fDespawnTime
				break
			elseif fStateTime < fSpawnTime then
				fGreevilHatchTime = fSpawnTime
				break
			elseif fStateTime > fDespawnTime then
				-- The hatch time is going to be in the next spawn data
				fGreevilDespawnTime = fDespawnTime
			end
		end
	end

	if fGreevilHatchTime == -1 then
		-- No more greevil hatching this round
		fGreevilDespawnTime = -1
	end

	CustomNetTables:SetTableValue( "globals", "values", { 
		GameState = self.m_GameState,
		State = self.m_nState,
		TimeStateStarted = self.m_flTimeStateStarted,
		TimeStateEnds = self.m_flTimeStateEnds,
		RoundNumber = self:GetRoundNumber(),
		TimeRoundStarted = self.m_flTimeRoundStarted,
		TimeRoundEnds = self.m_flTimeRoundEnds,
		TimeGameStarted = self.m_flTimeGameStarted or GameRules:GetDOTATime( false, true ),
		DireScore = self.m_nTeamScore[ _G.DOTA_TEAM_BADGUYS ],
		RadiantScore = self.m_nTeamScore[ _G.DOTA_TEAM_GOODGUYS ],
		TrickOrTreatHeroID = nTrickOrTreatHeroID,
		TrickOrTreatTeam = nTrickOrTreatTeam,
		TrickOrTreatMode = nTrickOrTreatMode,
		RoshanNearPlayer = bRoshanNearPlayer,
		TrickOrTreatTargetEntIndex = nTrickOrTreatTargetEntIndex,
		CandyLeaderBuilding = sCandyLeaderBuilding,
		RoshanCandy = nRoshanCandy,
		RadiantBucketHurt = nRadiantLosingCandy,
		DireBucketHurt = nDireLosingCandy,
		GreevilHatchTime = fGreevilHatchTime,
		GreevilDespawnTime = fGreevilDespawnTime,
		NumBucketsRadiant = self.tRemainingCandyBuckets[ DOTA_TEAM_GOODGUYS ],
		NumBucketsDire = self.tRemainingCandyBuckets[ DOTA_TEAM_BADGUYS ],
	} )
	GameRules:GetGameModeEntity():SetCustomRadiantScore( self.m_nTeamScore[ _G.DOTA_TEAM_GOODGUYS ] )
	GameRules:GetGameModeEntity():SetCustomDireScore( self.m_nTeamScore[ _G.DOTA_TEAM_BADGUYS ] )
	
	self:ThinkCandyExpiry()
	self:ThinkLootExpiry()
	self:ThinkAnnouncers()

	-- If we've advanced the game state, think once again
	if oldGameState ~= self.m_GameState then
		return self:OnThink()
	else
		return WINTER2022_THINK_INTERVAL
	end
end

--------------------------------------------------------------------------------

function CWinter2022:ThinkAnnouncers()
	if self.bHasAnnouncedHeroSelection == nil and GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self.bHasAnnouncedHeroSelection = true
		self:GetGlobalAnnouncer():OnHeroSelectionStarted()
	end

	if self.bHasAnnouncedStrategyTime == nil and GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self.bHasAnnouncedStrategyTime = true
		self:GetGlobalAnnouncer():OnStrategyTime()
	end
end

--------------------------------------------------------------------------------
function CWinter2022:OnThink_Pregame()
	if not self.m_bHaveHeroesLoaded then
		local bAllHaveLoaded = true
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:IsValidTeamPlayerID( nPlayerID ) and PlayerResource:HasSelectedHero( nPlayerID ) then
				if PlayerResource:GetSelectedHeroEntity( nPlayerID ) == nil then
					bAllHaveLoaded = false
				end
			end
		end
		
		-- Once everyone has loaded in, move to prep time
		if ( bAllHaveLoaded ) then
			self:StartPrepTime()
			return
		end
	end
end

--------------------------------------------------------------------------------
function CWinter2022:OnThink_InterstitialRoundPeriod()
	if GameRules:GetDOTATime( false, true ) >= self.m_flTimeRoundEnds then
		self:StartRound()
	end
end

--------------------------------------------------------------------------------
function CWinter2022:OnThink_PrepTime()
	local flTime = GameRules:GetDOTATime( false, true )
	if self.m_nLastRoundStartSound == 0 and flTime >= self.m_flTimeRoundEnds - _G.WINTER2022_PLAY_ROUND_START_EARLY_SECONDS then
		--EmitGlobalSound( "RoundBegin.Default" )
		self.m_nLastRoundStartSound = 1 --self:GetRoundNumber()
	end
	--[[if self.m_nLastRoundStartShown < self:GetRoundNumber() and flTime > self.m_flTimeRoundEnds - _G.WINTER2022_SHOW_ROUND_START_EARLY_SECONDS then
		self:ShowRoundStart()
		self.m_nLastRoundStartShown = self:GetRoundNumber()
	end--]]
	if flTime >= self.m_flTimeRoundEnds then
		self:EndPrepTime()
	end
end

--------------------------------------------------------------------------------
function CWinter2022:ShowRoundStart()
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
function CWinter2022:OnThink_DisplayFinalGameResults()
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

		self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + _G.WINTER2022_ENDING_CINEMATIC_TIME
		self.m_GameState = _G.WINTER2022_GAMESTATE_ENDING_CINEMATIC
		return
	end
end

--------------------------------------------------------------------------------
function CWinter2022:OnThink_EndingCinematic()
	local flTime = GameRules:GetDOTATime( false, true )
	if flTime > self.m_flTimeRoundEnds then	
		self:EndGame()
		self.m_GameState = _G.WINTER2022_GAMESTATE_GAMEOVER
		return
	end
end

--------------------------------------------------------------------------------
function CWinter2022:OnThink_GameInProgress()
	if self._bDevMode then
		return 1
	end

	local flGameTime = GameRules:GetDOTATime( false, true ) 
	local flRoundTime = flGameTime- self.m_flTimeRoundStarted
	local flTimeRemaining = self.m_flTimeRoundEnds - flGameTime

	if flTimeRemaining < 0 then
		self:RoundTimeExpired()
		return
	end

	-- Respawn candy
	local bShowMessage = false

	-- Try to spawn the golem
	--[[if self.m_flGolemSpawnTime > 0 and self.m_flGolemSpawnTime <= flGameTime then
		if self.m_vecGolemRespawns ~= nil then
			for nKey, bValue in pairs( self.m_vecGolemRespawns ) do
				self:SpawnGolem( nKey )
			end
			self.m_vecGolemRespawns = {}
		end

		-- shut off spawning until the golem is killed
		self.m_flGolemSpawnTime = -1.0

		FireGameEvent( "stash_respawn", {
			} )

		local gameEvent = {}
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_ScarecrowStashRespawn"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end--]]

	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer ~= nil then
			local hPlayerHero = hPlayer:GetAssignedHero()
			if hPlayerHero ~= nil and hPlayerHero:IsNull() == false and hPlayerHero:GetBuybackCooldownTime() - GameRules:GetGameTime() > _G.WINTER2022_BUYBACK_COOLDOWN then
				hPlayerHero:SetBuybackCooldownTime( _G.WINTER2022_BUYBACK_COOLDOWN )
			end
		end
	end


	if flGameTime >= self.m_flNextSpawnTime then
		self.m_nWave = self.m_nWave + 1
		self.m_nRoundWave = self.m_nRoundWave + 1
		printf( "spawning creep wave %d (%d within round %d) at %f", self.m_nWave, self.m_nRoundWave, self:GetRoundNumber(), flGameTime )
		self.m_flNextSpawnTime = self.m_flNextSpawnTime + _G.WINTER2022_SPAWN_DELAY
		self:CalculateWaveRewards()
		--self:SpawnAllWaves()
		-- instead, just grant the rewards.
		for nTeamNumber = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
			self:GrantGoldAndXPToTeam( nTeamNumber, self.nGoldPerWave, self.nXPPerWave )
		end
	end

	--[[if self.m_nState == _G.WINTER2022_STATE_GOHOME and self.hRoshan.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_RETURN and self:FindRoshanTarget() ~= nil then
		print( "Retarget: HOME INTERRUPT" )
		EmitGlobalSound( "RoshanDT.Scream" )
		self:GoToStateDirect( _G.WINTER2022_STATE_ROSHAN )
		self:RoshanRetarget()
		return
	end--]]

	--[[if self.m_nState == _G.WINTER2022_STATE_ROSHAN and self.tCandyLeaderBuilding ~= nil and self.tCandyLeaderBuilding.hEntity:IsNull() == false then
		local nCandy = self.tCandyLeaderBuilding.nCandy
		local nMapCandy = self.m_nCandyOnGround + self:GetCurrentCandyHeldByTeam( DOTA_TEAM_GOODGUYS ) + self:GetCurrentCandyHeldByTeam( DOTA_TEAM_BADGUYS )
		local nRunnerUpCandy = 0
		if self.tCandyBuildingOtherTeam ~= nil then
			nRunnerUpCandy = self.tCandyBuildingOtherTeam.nCandy
		end
		printf( "In state ROSHAN, compare %d candy in well to %d candy on map and %d candy in other well", nCandy, nMapCandy, nRunnerUpCandy )
		if nMapCandy + nRunnerUpCandy <= nCandy then
			if self:OnLastWellMaybeDestroyed( self.tCandyLeaderBuilding.hEntity ) == true then
				return
			end
		end
	end--]]

	if self.m_flTimeStateEnds > 0 and flGameTime >= self.m_flTimeStateEnds then
		print( '^^^TIME IS UP - STATE TRANSITION' )
		self:StateTransition()
	end

	self:StateThink()
end
