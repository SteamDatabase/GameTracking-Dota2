-- game end states
NOT_ENDED = 0
VICTORIOUS = 1
DEFEATED = 2

function CHoldoutGameMode:_SendRoundDataToClient()
	local netTable = {}

	netTable["round_number"] = self._nRoundNumber
	netTable["prep_time_left"] = 0
	if self._flPrepTimeEnd then
		netTable["prep_time_left"] = self._flPrepTimeEnd - GameRules:GetGameTime()
	end
	
	netTable["enemies_killed"] = 0
	netTable["enemies_total"] = 1
	netTable["invoker_hp"] = 0
	netTable["ancient_hp"] = -1

	if self._currentRound then
		netTable["enemies_killed"] = self._currentRound:GetTotalUnitsKilled()
		netTable["enemies_total"] = self._currentRound:GetTotalUnits()

		local nAncientHealth = self._hAncient:GetHealth()
		if nAncientHealth ~= self._hAncient:GetMaxHealth() then
			netTable["ancient_hp"] = nAncientHealth
		else
			netTable["ancient_hp"] = -1
		end

		netTable["invoker_hp"] = 0;
		if self:HasBossSpawned() and not self:HasBossDied() then
			netTable["invoker_hp"] = self._hInvoker:GetHealthPercent()
		end
		self:_SendScoresToClient( false )
	end

	CustomNetTables:SetTableValue( "round_data", string.format( "%d", 0 ), netTable )
end

function CHoldoutGameMode:_SendScoresToClient( bRoundOver )
	local netTable = {}
	netTable["GoldBagsCollected"] = 0
	for i = 1, DOTA_MAX_TEAM_PLAYERS do
		local nPlayerID = i-1
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local playerStatsForRound = self._currentRound:GetPlayerStats( nPlayerID )
			local szPlayerID = string.format( "%d", nPlayerID )

			netTable[ szPlayerID .. "Kills" ] = playerStatsForRound.nCreepsKilled
			netTable[ szPlayerID .. "Deaths" ] = playerStatsForRound.nDeathsThisRound
			netTable[ szPlayerID .. "Bags" ] = playerStatsForRound.nGoldBagsCollected
			netTable[ szPlayerID .. "Saves" ] = playerStatsForRound.nPlayersResurrected

			netTable["GoldBagsCollected"] = netTable["GoldBagsCollected"] + playerStatsForRound.nGoldBagsCollected
		end
	end

	netTable["TowersRemaining"] = self._currentRound:GetTowersRemaining()
	netTable["GoldBagsExpired"] = self._currentRound:GetGoldBagsExpired()
	netTable["RoundOver"] = bRoundOver

	if bRoundOver == true and not self:HasBossDied() then
		netTable["TowersReward"] = self:ComputeTowerBonusGold( self._currentRound:GetTotalTowers(), self._currentRound:GetTowersRemaining() )
		netTable["PointReward"] = self._currentRound:GetPointReward()	
		netTable["PointTotal"] = self._nAccumulatedPoints
		netTable["StarLevel"] = self._currentRound:GetStarRanking()
		netTable["TotalDeaths"] = self._currentRound:GetTotalDeaths()

		CustomGameEventManager:Send_ServerToAllClients( "round_over", {} )

		local award = self._currentRound:GetRoundAward()
		if award ~= nil then
			CustomGameEventManager:Send_ServerToAllClients( "display_award", award )
		end
	end

	CustomNetTables:SetTableValue( "holdout_scores", string.format( "%d", 0 ), netTable )
end


function CHoldoutGameMode:_NotifyClientOfRoundStart()
	local netTable = {}
	if self._currentRound then
		netTable["round_number"] = self._currentRound:GetRoundNumber()
		netTable["round_name"] = self._currentRound:GetRoundTitle()
	end
	CustomGameEventManager:Send_ServerToAllClients( "round_started", netTable )
	self:_SendRoundDataToClient( false )
end

function CHoldoutGameMode:_CheckRestartVotes()
	if self._flEndTime == nil then
		self._flEndTime = Time() + self._flVoteDuration
	end

	if self._flEndTime then
		local bTimesUp = Time() > self._flEndTime

		if bTimesUp or ( ( self._nRestartVoteYes + self._nRestartVoteNo ) == 5 ) then
			if self._nRestartVoteYes == 5 then
				self:_ChoseExitGame()
			else
				self:_ChoseExitGame()
			end
			self._nRestartVoteYes = 0
			self._nRestartVoteNo = 0
			return -1
		end

		local netTable = {}
	
		netTable["yes"] = self._nRestartVoteYes
		netTable["no"] = self._nRestartVoteNo
		netTable["time_left"] = self._flEndTime - Time()
		
		CustomNetTables:SetTableValue( "restart_votes", string.format( "%d", 0 ), netTable )
	end

	return 0.25
end

function CHoldoutGameMode:_DisplayGameEnd()
	self._bDisplayingGameEnd = true

	local holdoutEndData = 
	{
		victory = (self._nGameEndState == VICTORIOUS),
		nRoundNumber = self._nRoundNumber,
		--nRoundDifficulty = self.nDifficulty,
		--roundName = self.roundTitle,
	}

	Convars:SetBool( "dota_pause_game_pause_silently", true )
	--PauseGame( true )
	GameRules:SetSafeToLeave( true )
	self._nRestartVoteYes = 0
	self._nRestartVoteNo = 0
	self._votes = {}

	local netTable = {}
	for i = 1, 5 do
		local nPlayerID = i-1
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local szPlayerID = string.format( "%d", nPlayerID )
			netTable[ szPlayerID .. "Kills" ] = 0
			netTable[ szPlayerID .. "Deaths" ] = PlayerResource:GetDeaths( nPlayerID )
			netTable[ szPlayerID .. "Bags" ] = 0
			netTable[ szPlayerID .. "Saves" ] = 0

			for j = 1, #self._vRounds do
				local round = self._vRounds[j]
				if round ~= nil then
					local playerStatsForRound = round:GetPlayerStats( nPlayerID )
					netTable[ szPlayerID .. "Kills" ] = netTable[ szPlayerID .. "Kills" ] + playerStatsForRound.nCreepsKilled
					netTable[ szPlayerID .. "Bags" ] = netTable[ szPlayerID .. "Bags" ] + playerStatsForRound.nGoldBagsCollected
					netTable[ szPlayerID .. "Saves" ] = netTable[ szPlayerID .. "Saves" ] + playerStatsForRound.nPlayersResurrected
				end
			end
		end
	end

	CustomNetTables:SetTableValue( "game_end", string.format( "%d", 0 ), netTable )

	-- This is what populates the custom interface on the
	-- post-game screen.
	local metadataTable = {}
	metadataTable[ "event_name" ] = "new_bloom_2017"
	metadataTable[ "player_stats" ] = netTable
	metadataTable[ "round_number" ] = self._nRoundNumber
	GameRules:SetEventMetadataCustomTable( metadataTable )
	print( "metadata set")
	if self._playerPointsData == nil then
		self._playerPointsData = {}
	end
	self._playerPointsData['event_score'] = self._nRoundNumber
	UpdateEventPoints( self._playerPointsData )
	self:_ChoseExitGame()
end

------------------------------------------------------------

function CHoldoutGameMode:_ProcessVoteButtonClick( eventSourceIndex, args )
	local nPlayerID = args["player_id"]
	local bPlayAgain = args["play_again"]

	if self._votes[nPlayerID] == nil and ( self._nGameEndState == DEFEATED or self._nGameEndState == VICTORIOUS ) then
		self._votes[nPlayerID] = bPlayAgain
		if bPlayAgain == 1 then
			self._nRestartVoteYes = self._nRestartVoteYes + 1
		else
			self._nRestartVoteNo = self._nRestartVoteNo + 1
		end

		self:_CheckRestartVotes()
	end
end

function CHoldoutGameMode:_ChoseExitGame()
	Convars:SetBool( "dota_pause_game_pause_silently", false )
	--PauseGame( false )


	if self._nGameEndState == DEFEATED then
		if not self._hAncient:IsNull() and self._hAncient:IsAlive() then
			self._hAncient:RemoveAbility( "ability_ancient_buddha" )
			self._hAncient:RemoveModifierByName( "buddha" )
		end
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
	end

	if self._nGameEndState == VICTORIOUS then
		GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
	end
end

function CHoldoutGameMode:_ChoseRestartGame()
	self._hAncient:SetHealth( self._hAncient:GetMaxHealth() )
	GameRules:SetSafeToLeave( false )

	if self.nGameEndState == VICTORIOUS then
		-- increase difficulty
		self.nDifficulty = self.nDifficulty + 1
		local eventData = {
			nRoundDifficulty = self.nDifficulty
		}
	end
	
	self:_RestartGame()
	Convars:SetBool( "dota_pause_game_pause_silently", false )
	--PauseGame( false )
end

function CHoldoutGameMode:_AwardPoints( nPointAmount )
	if self._playerPointsData == nil then
		self._playerPointsData = {}
	end

	local nCount = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )

	for i=0,nCount do
		local nPlayerID = PlayerResource:GetNthPlayerIDOnTeam( DOTA_TEAM_GOODGUYS, i )
		if nPlayerID ~= -1 then
			if not self._playerPointsData["Player"..nPlayerID] then 
				self._playerPointsData["Player"..nPlayerID] = {} 
				self._playerPointsData["Player"..nPlayerID]["total_event_points"] = 0
			end

			self._playerPointsData["Player"..nPlayerID]["total_event_points"] = self._playerPointsData["Player"..nPlayerID]["total_event_points"] + nPointAmount
		end
	end

	self._nAccumulatedPoints = self._nAccumulatedPoints + nPointAmount
	print ( "Awarded " .. nPointAmount )
end
