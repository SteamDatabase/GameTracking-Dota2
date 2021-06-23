print( "nemestice_game_confiruration.lua loaded." )


--------------------------------------------------------------------------------
require( "nemestice_constants" )

--------------------------------------------------------------------------------

function CNemestice:SetupGameConfiguration()
	
	self.m_bFillWithBots = GlobalSys:CommandLineCheck( "-nemestice_bots" ) or GameRules:GetGameSessionConfigValue("nemestice_bots", "false") == "true"
	self.m_bShortStrategyTime = GlobalSys:CommandLineCheck( "-nemestice_short_strategy_time" ) or GameRules:GetGameSessionConfigValue("nemestice_short_strategy_time", "false") == "true"
	self.m_bFastPlay = ( self.m_bShortStrategyTime == false ) and ( GlobalSys:CommandLineCheck( "-nemestice_fastplay" ) or GameRules:GetGameSessionConfigValue("nemestice_fastplay", "false") == "true" )

	GameRules:SetCustomGameSetupTimeout( 0 )
	GameRules:SetPreGameTime( 0 )
	GameRules:SetShowcaseTime( 0 )
	GameRules:SetStrategyTime( NEMESTICE_STRATEGY_PHASE_TIME )
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
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, NEMESTICE_PLAYERS_PER_TEAM )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, NEMESTICE_PLAYERS_PER_TEAM )
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true ) -- Disable the normal announcer.
	--GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true ) -- Disable the killstreak announcer
	GameRules:SetFilterMoreGold( true ) -- apply our gold filter to more than the usual set of stuff.
	GameRules:SetAllowOutpostBonuses( false )

	GameRules:SetHeroRespawnEnabled( true ) 
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:GetGameModeEntity():SetDaynightCycleAdvanceRate( 5.0 / 3.0 )
	GameRules:GetGameModeEntity():DisableClumpingBehaviorByDefault( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( true )

 	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetAllowNeutralItemDrops( false )
	GameRules:GetGameModeEntity():SetStickyItemDisabled( true )
	GameRules:GetGameModeEntity():SetFriendlyBuildingMoveToEnabled( false )
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled( true )
	GameRules:GetGameModeEntity():SetUseDefaultDOTARuneSpawnLogic( true )

	GameRules:GetGameModeEntity():SetUseTurboCouriers( true )
	GameRules:GetGameModeEntity():SetCanSellAnywhere( true )
	
	GameRules:SetGoldPerTick( 0 ) -- will be set normally on game start

	GameRules:SetCustomGameBansPerTeam( 5 )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( NEMESTICE_BAN_PHASE_TIME )
	if self.m_bShortStrategyTime then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 5.0 )
	elseif self.m_bFastPlay then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 1.0 )
	end
	GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride( NEMESTICE_PICK_PHASE_TIME )
	GameRules:SetIgnoreLobbyTeamsInCustomGame( false )

	GameRules:SetNextRuneSpawnTime( 999999999 )
	GameRules:SetNextBountyRuneSpawnTime( 999999999 )
end

--------------------------------------------------------------------------------

function CNemestice:AssignTeams()
	--print( "Assigning teams for " .. PlayerResource:NumTeamPlayers() .. " players" )

	local nActualPlayersPerTeam = math.ceil( PlayerResource:NumTeamPlayers() / 2 )
	--print( nActualPlayersPerTeam .. " players per team" )

	local nPlayerCount = 0
	local nRadiant = 0
	local nDire = 0
	local nUnassigned = 0
	local nTotal = 0
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			nTotal = nTotal + 1
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

	if self.m_bFillWithBots == true then
		GameRules:BotPopulate()
	end
end

--------------------------------------------------------------------------------

function CNemestice:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
			hPlayer:MakeRandomHeroSelection()
		end	
	end
end
