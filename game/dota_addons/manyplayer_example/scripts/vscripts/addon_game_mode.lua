-- Rebalance the distribution of gold and XP to make for a better 10v10 game
local GOLD_SCALE_FACTOR_INITIAL = 1
local GOLD_SCALE_FACTOR_FINAL = 2.5
local GOLD_SCALE_FACTOR_FADEIN_SECONDS = (60 * 60) -- 60 minutes
local XP_SCALE_FACTOR_INITIAL = 2
local XP_SCALE_FACTOR_FINAL = 2
local XP_SCALE_FACTOR_FADEIN_SECONDS = (60 * 60) -- 60 minutes

if CMegaDotaGameMode == nil then
	_G.CMegaDotaGameMode = class({}) -- put CMegaDotaGameMode in the global scope
	--refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

function Activate()
	CMegaDotaGameMode:InitGameMode()
end

function CMegaDotaGameMode:InitGameMode()
	print( "10v10 Mode Loaded!" )

	self.m_bFillWithBots = false
	self.m_bFillWithBots = GlobalSys:CommandLineCheck( "-addon_bots" )

	-- Adjust team limits
	GameRules:SetIgnoreLobbyTeamsInCustomGame( false )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 10 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 10 )

	-- Draft
	GameRules:SetCustomGameSetupTimeout( 0 )
	GameRules:SetPreGameTime( 10.0 )
	GameRules:SetCustomGameBansPerTeam( 10 )
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 8.0 )
	GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride( 30.0 )
	GameRules:SetStrategyTime( 10.0 )
	GameRules:SetShowcaseTime( 0.0 )

	-- Hook up gold & xp filters
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( CMegaDotaGameMode, "FilterModifyGold" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap(CMegaDotaGameMode, "FilterModifyExperience" ), self )
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap(CMegaDotaGameMode, "FilterBountyRunePickup" ), self )
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )
	GameRules:SetGoldTickTime( 0.3 ) -- default is 0.6

	-- Couriers
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled( true )

	-- Dota Plus
	GameRules:SetSuggestAbilitiesEnabled( true )
	GameRules:SetSuggestItemsEnabled( true )

	self.m_CurrentGoldScaleFactor = GOLD_SCALE_FACTOR_INITIAL
	self.m_CurrentXpScaleFactor = XP_SCALE_FACTOR_INITIAL
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 5 ) 

	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( self, 'OnGameRulesStateChange' ), self )

	GameRules:SetPostGameLayout( DOTA_POST_GAME_LAYOUT_DOUBLE_COLUMN )
	GameRules:SetPostGameColumns( {
		DOTA_POST_GAME_COLUMN_LEVEL,
		DOTA_POST_GAME_COLUMN_ITEMS,
		DOTA_POST_GAME_COLUMN_KILLS,
		DOTA_POST_GAME_COLUMN_DEATHS,
		DOTA_POST_GAME_COLUMN_ASSISTS
	} )
end

function CMegaDotaGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- update the scale factor: 
	 	-- * SCALE_FACTOR_INITIAL at the start of the game
		-- * SCALE_FACTOR_FINAL after SCALE_FACTOR_FADEIN_SECONDS have elapsed
		local curTime = GameRules:GetDOTATime( false, false )
		local goldFracTime = math.min( math.max( curTime / GOLD_SCALE_FACTOR_FADEIN_SECONDS, 0 ), 1 )
		local xpFracTime = math.min( math.max( curTime / XP_SCALE_FACTOR_FADEIN_SECONDS, 0 ), 1 )
		self.m_CurrentGoldScaleFactor = GOLD_SCALE_FACTOR_INITIAL + (goldFracTime * ( GOLD_SCALE_FACTOR_FINAL - GOLD_SCALE_FACTOR_INITIAL ) )
		self.m_CurrentXpScaleFactor = XP_SCALE_FACTOR_INITIAL + (xpFracTime * ( XP_SCALE_FACTOR_FINAL - XP_SCALE_FACTOR_INITIAL ) )
--		print( "Gold scale = " .. self.m_CurrentGoldScaleFactor )
--		print( "XP scale = " .. self.m_CurrentXpScaleFactor )
		local tTeamScores = { GetTeamHeroKills( DOTA_TEAM_GOODGUYS ), GetTeamHeroKills( DOTA_TEAM_BADGUYS ) }
		GameRules:SetPostGameTeamScores( tTeamScores )
	end
	return 5
end


function CMegaDotaGameMode:FilterBountyRunePickup( filterTable )
--	print( "FilterBountyRunePickup" )
--  for k, v in pairs( filterTable ) do
--  	print("MG: " .. k .. " " .. tostring(v) )
--  end
	filterTable["gold_bounty"] = self.m_CurrentGoldScaleFactor * filterTable["gold_bounty"]
	filterTable["xp_bounty"] = self.m_CurrentXpScaleFactor * filterTable["xp_bounty"]
	return true
end

function CMegaDotaGameMode:FilterModifyGold( filterTable )
--	print( "FilterModifyGold" )
--	print( self.m_CurrentGoldScaleFactor )
	filterTable["gold"] = self.m_CurrentGoldScaleFactor * filterTable["gold"]
	return true
end

function CMegaDotaGameMode:FilterModifyExperience( filterTable )
--	print( "FilterModifyExperience" )
--	print( self.m_CurrentXpScaleFactor )
	filterTable["experience"] = self.m_CurrentXpScaleFactor * filterTable["experience"]
	return true
end


function CMegaDotaGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:AssignTeams()
	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:ForceAssignHeroes()
	end
end

function CMegaDotaGameMode:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
			hPlayer:MakeRandomHeroSelection()
		end	
	end
end

function CMegaDotaGameMode:AssignTeams()
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

	if self.m_bFillWithBots == true then
		GameRules:BotPopulate()
	end
end