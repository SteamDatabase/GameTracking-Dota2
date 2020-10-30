--------------------------------------------------------------------------------
require( "diretide_constants" )
require( "diretide_waves" )
require( "diretide_wave_manager" )
require( "diretide_game_spawner" )

--------------------------------------------------------------------------------

function CDiretide:SetupGameConfiguration()
	self.m_bFillWithBots = false
	self.m_bFillWithBots = GlobalSys:CommandLineCheck( "-diretide_bots" )
	self.m_bShortStrategyTime = false
	self.m_bShortStrategyTime = GlobalSys:CommandLineCheck( "-diretide_short_strategy_time" )
	self.m_bFastPlay = false
	self.m_bFastPlay = ( self.m_bShortStrategyTime == false ) and GlobalSys:CommandLineCheck( "-diretide_fastplay" )
	self.m_nRoundNumber = 0
	self.m_hSavedHeroStates = {}

	GameRules:SetCustomGameSetupTimeout( 0 )
	GameRules:SetPreGameTime( 0 )
	if self.m_bShortStrategyTime then
		GameRules:SetStrategyTime( 5.0 )
	end
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetStartingGold( 1000 )
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			PlayerResource:SetGold( nPlayerID, 1000, false )
		end
	end

	--GameRules:SetCustomGameSetupAutoLaunchDelay( 10 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, DIRETIDE_PLAYERS_PER_TEAM )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, DIRETIDE_PLAYERS_PER_TEAM )
	GameRules:SetHeroRespawnEnabled( true ) 
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true ) -- Disable the normal announcer.
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true ) -- Disable the killstreak announcer
	GameRules:SetFilterMoreGold( true ) -- apply our gold filter to more than the usual set of stuff.
	GameRules:SetCustomGameAllowSecondaryAbilitiesOnOtherUnits( true )

	GameRules:GetGameModeEntity():SetFixedRespawnTime( DIRETIDE_HERO_RESPAWN_TIMER )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:GetGameModeEntity():DisableClumpingBehaviorByDefault( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( true )
 	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetAllowNeutralItemDrops( false )
	GameRules:GetGameModeEntity():SetDefaultStickyItem( "item_tpscroll" )

	GameRules:SetCustomGameBansPerTeam( 5 )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( DIRETIDE_BAN_PHASE_TIME )
	if self.m_bShortStrategyTime then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 5.0 )
	elseif self.m_bFastPlay then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 1.0 )
	end
	GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride( DIRETIDE_PICK_PHASE_TIME )
	GameRules:SetIgnoreLobbyTeamsInCustomGame( false )

	self:_ReadGameConfiguration()
end

--------------------------------------------------------------------------------

-- Read and assign configurable keyvalues if applicable
function CDiretide:_ReadGameConfiguration()
	--local kv = LoadKeyValues( "scripts/maps/diretide_waves.txt" )
	--DeepPrintTable( DIRETIDE_WAVES )

	self._flItemExpireTime = tonumber( DIRETIDE_WAVES.ItemExpireTime or 10.0 )

	--if self._bDevMode then
	--	self._flPrepTimeBetweenRounds = self._nDevRoundDelay
	--end

	self:_ReadRandomSpawnsConfiguration( DIRETIDE_RANDOM_SPAWNS )
	self:_ReadRoundConfigurations( DIRETIDE_WAVES )
end

--------------------------------------------------------------------------------

-- Verify valid spawns are defined and build a table with them from the keyvalues file
function CDiretide:_ReadRandomSpawnsConfiguration( kvSpawns )
	self._vRandomSpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end

	--print( "_ReadRandomSpawnsConfiguration - " .. #kvSpawns )
	for _, sp in pairs( kvSpawns ) do
		table.insert( self._vRandomSpawnsList, {
			szSpawnerName = sp.SpawnerName or "",
			szFirstWaypoint = sp.Waypoint or ""
		} )
	end

	--print( "Random Spawn Table" )
	--DeepPrintTable( self._vRandomSpawnsList )
end

--------------------------------------------------------------------------------

-- Set number of rounds without requiring index in text file
function CDiretide:_ReadRoundConfigurations( kv )
	--print( "CDiretide:_ReadRoundConfigurations" )
	--DeepPrintTable( kv )
	self._vWaveManagers = {}

	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		--print( "***CDiretide:_ReadRoundConfigurations*** for team " .. nTeam )
		self._vWaveManagers[nTeam] = {}

		while true do
			local szRoundName = string.format("Round%d", #self._vWaveManagers[nTeam] + 1 )
			local kvRoundData = kv[ szRoundName ]
			if kvRoundData == nil then
				break
			end
			local waveManager = CDiretideWaveManager()
			waveManager:ReadConfiguration( kvRoundData, #self._vWaveManagers[nTeam] + 1, nTeam )
			table.insert( self._vWaveManagers[nTeam], waveManager )
		end
	end

	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		--print( "***CDiretide:_ReadRoundConfigurations*** for team " .. nTeam )
		--DeepPrintTable( self._vWaveManagers[nTeam] )
	end

	self.m_nTotalRounds = #self._vWaveManagers[DOTA_TEAM_GOODGUYS]
	print( "TOTAL ROUNDS = " .. self.m_nTotalRounds )
end

--------------------------------------------------------------------------------

function CDiretide:AssignTeams()
	--print( "Assigning teams for " .. PlayerResource:NumTeamPlayers() .. " players" )

	local nActualPlayersPerTeam = math.ceil( PlayerResource:NumTeamPlayers() / 2 )
	--print( nActualPlayersPerTeam .. " players per team" )

	local nPlayerCount = 0
	local nRadiant = 0
	local nDire = 0
	local nUnassigned = 0
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local nTeam = PlayerResource:GetTeam( nPlayerID )
			local nTeamCustom = PlayerResource:GetCustomTeamAssignment( nPlayerID )			
			if nTeamCustom == DOTA_TEAM_GOODGUYS then
				nRadiant = nRadiant + 1
			elseif nTeamCustom == DOTA_TEAM_BADGUYS then
				nDire = nDire + 1
			elseif nTeam == DOTA_TEAM_GOODGUYS then
				nRadiant = nRadiant + 1
			elseif nTeam == DOTA_TEAM_BADGUYS then
				nDire = nDire + 1
			else
				nUnassigned = nUnassigned + 1
			end
		end
	end

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if ( nRadiant >= nActualPlayersPerTeam and nDire >= nActualPlayersPerTeam ) or nUnassigned == 0 then
			break
		end
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local nTeam = PlayerResource:GetTeam( nPlayerID )
			local nTeamCustom = PlayerResource:GetCustomTeamAssignment( nPlayerID )
			if nTeam ~= DOTA_TEAM_GOODGUYS and nTeam ~= DOTA_TEAM_BADGUYS and nTeamCustom ~= DOTA_TEAM_GOODGUYS and nTeamCustom ~= DOTA_TEAM_BADGUYS then
				local nTeamNumber = ( nRadiant > nDire and DOTA_TEAM_BADGUYS ) or DOTA_TEAM_GOODGUYS
				
				print( "Assigning player " .. nPlayerID .. " to " .. nTeamNumber )
				PlayerResource:SetCustomTeamAssignment( nPlayerID, nTeamNumber )
				
				if nTeamNumber == DOTA_TEAM_GOODGUYS then
					nRadiant = nRadiant + 1
				else
					nDire = nDire + 1
				end
				nUnassigned = nUnassigned - 1
			end
		end
	end

	--[[
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		local bAssigned = false
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			nPlayerCount = nPlayerCount + 1
			local nTeamNumber = 0
			if ( nPlayerCount <= nActualPlayersPerTeam ) then
				nTeamNumber = DOTA_TEAM_GOODGUYS
			else
				nTeamNumber = DOTA_TEAM_BADGUYS
			end

			print( "Assigning player " .. nPlayerID .. " to " .. nTeamNumber )
			PlayerResource:SetCustomTeamAssignment( nPlayerID, nTeamNumber )
		end
	end
	--]]

	if self.m_bFillWithBots == true then
		GameRules:BotPopulate()
	end
end

--------------------------------------------------------------------------------

function CDiretide:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
			hPlayer:MakeRandomHeroSelection()
		end	
	end
end
