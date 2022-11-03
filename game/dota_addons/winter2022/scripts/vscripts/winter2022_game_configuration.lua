--------------------------------------------------------------------------------
require( "winter2022_constants" )
require( "winter2022_waves" )
require( "winter2022_wave_manager" )

--------------------------------------------------------------------------------

function CWinter2022:SetupGameConfiguration()
	self.m_bFillWithBots = false
	self.m_bFillWithBots = GlobalSys:CommandLineCheck( "-addon_bots" )
	self.m_bShortStrategyTime = false
	self.m_bShortStrategyTime = GlobalSys:CommandLineCheck( "-addon_short_strategy_time" )
	self.m_bFastPlay = ( self.m_bShortStrategyTime == false ) and GlobalSys:CommandLineCheck( "-addon_fastplay" )
	self.m_nRoundNumber = 0

	GameRules:SetCustomGameSetupTimeout( 0 )
	GameRules:SetPreGameTime( 0 )
	if self.m_bShortStrategyTime then
		GameRules:SetStrategyTime( 5.0 )
	else
		GameRules:SetStrategyTime( GlobalSys:CommandLineInt( "-winter2022_strategy_time_override", 20 ) )
	end
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetStartingGold( 1000 )
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			PlayerResource:SetGold( nPlayerID, 1000, false )
		end
	end

	--GameRules:SetCustomGameSetupAutoLaunchDelay( 10 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, WINTER2022_PLAYERS_PER_TEAM )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, WINTER2022_PLAYERS_PER_TEAM )
	GameRules:SetHeroRespawnEnabled( true ) 
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true ) -- Disable the normal announcer.
	GameRules:GetGameModeEntity():SetKillingSpreeAnnouncerDisabled( true ) -- Disable the killstreak announcer
	GameRules:SetFilterMoreGold( true ) -- apply our gold filter to more than the usual set of stuff.
	GameRules:SetCustomGameAllowSecondaryAbilitiesOnOtherUnits( true )

	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	--GameRules:GetGameModeEntity():SetDaynightCycleAdvanceRate( 5.0 / 3.0 )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:GetGameModeEntity():DisableClumpingBehaviorByDefault( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( true )
 	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetAllowNeutralItemDrops( true )
	GameRules:GetGameModeEntity():SetDefaultStickyItem( "item_flask" )
	GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath( false )
	GameRules:GetGameModeEntity():SetDeathTipsDisabled( true )

	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled( true )
	GameRules:GetGameModeEntity():SetUseTurboCouriers( true )
	GameRules:GetGameModeEntity():SetCanSellAnywhere( true )

	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 15 )	-- base is 5
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 18 )		-- base is 6 
	--GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )	-- this one isn't hooked up?

	GameRules:SetCustomGameBansPerTeam( 5 )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( WINTER2022_BAN_PHASE_TIME )
	if self.m_bShortStrategyTime then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 5.0 )
	elseif self.m_bFastPlay then
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 1.0 )
	end
	GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride( WINTER2022_PICK_PHASE_TIME )
	GameRules:SetIgnoreLobbyTeamsInCustomGame( false )
	GameRules:SetShowcaseTime( 0.0 )

	local flGameStartOffset = ( ( self.m_bFastPlay and 5 ) or _G.WINTER2022_PREGAME_TIME )
	GameRules:SetNeutralInitialSpawnOffset( flGameStartOffset + _G.WINTER2022_NEUTRAL_CREEP_SPAWN_DELAY - Convars:GetFloat( "dota_neutral_initial_spawn_delay" ) )
end

--------------------------------------------------------------------------------

function CWinter2022:AssignTeams()
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
end

--------------------------------------------------------------------------------

function CWinter2022:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
			hPlayer:MakeRandomHeroSelection()
		end	
	end
end
