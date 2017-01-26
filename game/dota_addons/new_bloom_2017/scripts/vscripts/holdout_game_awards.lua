--[[
	CHoldoutGameAwards - System that gives out post game awards
]]

if CHoldoutGameAwards == nil then
	CHoldoutGameAwards = class({})
end

function CHoldoutGameAwards:Init( gameMode, round )
	self._gameMode = gameMode
	self._round = round 

	local kv = LoadKeyValues( "scripts/awards.txt" )
	kv = kv or {} 

	self._AwardDefs = {}
	self._AwardsThisRound = {}

	self:ReadAwardDescriptions( kv["Awards"] )
end

function CHoldoutGameAwards:ReadAwardDescriptions( kv )
	print ( "Reading Award Descriptions" )
	
	if type( kv ) ~= "table" then
		return
	end
	for _,award in pairs( kv ) do
		local newAward = {}
		newAward["Title"] = award.Title or ""
		newAward["Icon"] = award.Icon or ""
		newAward["Desc"] = award.Desc or ""
		newAward["Value"] = award.Value or ""
		newAward["Comparison"] = award.Comparison or ""
		newAward["Type"] 	= award.Type or ""
		newAward["Margin"] = tonumber( award.Margin or 0 )
		newAward["MarginType"] = award.MarginType or ""
		newAward["Rare"] = tonumber( award.Rare or 0 )

		table.insert( self._AwardDefs, newAward )
	end
end

function CHoldoutGameAwards:EvaluateRoundForAwards( playerStats )
	print ( "EvaluateRoundForAwards" )
	for _,award in pairs( self._AwardDefs ) do
		print( "Process award " .. award["Title"] )
		local values = self:ProcessValues( award )
		local nWinnerID = self:GetWinnerPlayerID( values, award )
		if nWinnerID ~= -1 then
			award["PlayerID"] = nWinnerID
			award["SteamID"] = tostring( PlayerResource:GetSteamID( nWinnerID ) )
			award["ResultValue"] = values[nWinnerID+1]
			table.insert( self._AwardsThisRound, award )
			print( "Player " .. nWinnerID .. " won " .. award["Title"] )
		end
	end

	return self:GetRandomWonOrRareAward()
end

function CHoldoutGameAwards:GetRandomWonOrRareAward()
	if #self._AwardsThisRound == 0 or self._AwardsThisRound == nil then
		print( "No Awards won" )
		return nil
	end

	local rarestAward = self._AwardsThisRound[1]
	for _,award in pairs( self._AwardsThisRound ) do
		if award ~= nil and award["Rare"] > rarestAward["Rare"] then
			rarestAward = award
		end
	end

	if rarestAward["Rare"] == 0 then
		local randomAward = self._AwardsThisRound[RandomInt( 1, #self._AwardsThisRound )]
		print( "Player " .. randomAward["PlayerID"] .. " got selected as the winner!")
		return randomAward
	end

	return rarestAward
end

function CHoldoutGameAwards:ProcessValues( award )
	local values = {}
	for i = 0, DOTA_DEFAULT_MAX_TEAM-1 do
		local nPlayerID = i 
		local playerStatsForRound = self._round:GetPlayerStats( nPlayerID )
		if award["Value"] == "kills" then
			table.insert( values, playerStatsForRound.nCreepsKilled )
		end
		if award["Value"] == "deaths" then
			table.insert( values, playerStatsForRound.nDeathsThisRound )
		end
		if award["Value"] == "bags" then
			table.insert( values, playerStatsForRound.nGoldBagsCollected )
		end
		if award["Value"] == "saves" then
			table.insert( values, playerStatsForRound.nPlayersResurrected )
		end
		if award["Value"] == "potions" then
			table.insert( values, playerStatsForRound.nPotionsTaken )
		end
		if award["Value"] == "clutches" then
			table.insert( values, playerStatsForRound.nClutches )
		end
		if award["Value"] == "kills_without_dying" then
			table.insert( values, playerStatsForRound.nKillsWithoutDying )
		end
		if award["Value"] == "kills_in_window" then
			table.insert( values, playerStatsForRound.nKillsInWindow )
		end
	end
	return values
end

function CHoldoutGameAwards:CalculateMargin( value, margin, marginType )
	if margin == 0 or marginType == "flat" then
		return margin
	end

	return ( value * margin ) / 100
end

function CHoldoutGameAwards:GetWinnerPlayerID( values, award )
	local nPlayerIDWinner = -1
	if award["Comparison"] == "greater_than" then
		if award["Type"] == "between_players" then
			nPlayerIDWinner = self:GetPlayerIDWithGreatestValue( values, award["Margin"], award["MarginType"] )
		end

		if award["Type"] == "total" then
		 	local winningIDs = self:GetPlayerIDsAboveValue( values, award["Margin"], award["MarginType"] )
		 	if #winningIDs > 0 then
		 		nPlayerIDWinner = winningIDs[RandomInt(1,#winningIDs)]
		 	end
		 	
		end
	end

	if award["Comparison"] == "less_than" then
		if award["Type"] == "between_players" then
			nPlayerIDWinner = self:GetPlayerIDWithLowestValue( values, award["Margin"], award["MarginType"] )
		end

		if award["Type"] == "total" then
		 	local winningIDs = self:GetPlayerIDsBelowValue( values, award["Margin"], award["MarginType"] ) 
		 	if #winningIDs > 0 then
		 		nPlayerIDWinner = winningIDs[RandomInt(1,#winningIDs)]
		 	end
		end
	end

	return nPlayerIDWinner
end

function CHoldoutGameAwards:GetPlayerIDWithGreatestValue( values, margin, marginType )
	local nHighestValue = 0
	local nWinningPlayerID = -1
	local nCurrentPlayerID = -1
	for _,value in pairs( values ) do
		nCurrentPlayerID = nCurrentPlayerID + 1
		local nMarginDiffRequired = self:CalculateMargin( nHighestValue, margin, marginType )
		if value > nHighestValue and ( ( value - nHighestValue ) >= nMarginDiffRequired ) then
			nHighestValue = value
			nWinningPlayerID = nCurrentPlayerID
		end
	end

	return nWinningPlayerID
end

function CHoldoutGameAwards:GetPlayerIDsAboveValue( values, margin, marginType )
	local playersIDs = {}
	local nCurrentPlayerID = -1
	for _,value in pairs( values ) do
		nCurrentPlayerID = nCurrentPlayerID + 1
		local nMarginDiffRequired = self:CalculateMargin( nHighestValue, margin, marginType )
		if value > nMarginDiffRequired then
			table.insert( playersIDs, nCurrentPlayerID )
		end
	end

	return playersIDs
end

function CHoldoutGameAwards:GetPlayerIDWithLowestValue( values, margin, marginType )
	local nLowestValue = 99999
	local nWinningPlayerID = -1
	local nCurrentPlayerID = -1
	for _,value in pairs( values ) do
		nCurrentPlayerID = nCurrentPlayerID + 1
		local nMarginDiffRequired = self:CalculateMargin( nHighestValue, margin, marginType )
		if value < nLowestValue and ( ( nLowestValue - value  ) >= nMarginDiffRequired ) then
			nLowestValue = value
			nWinningPlayerID = nCurrentPlayerID
		end
	end

	return nWinningPlayerID
end

function CHoldoutGameAwards:GetPlayerIDsBelowValue( values, margin, marginType )
	local playersIDs = {}
	local nCurrentPlayerID = -1
	for _,value in pairs( values ) do
		nCurrentPlayerID = nCurrentPlayerID + 1
		local nMarginDiffRequired = self:CalculateMargin( 0, margin, marginType )
		if value < nMarginDiffRequired then
			table.insert( playersIDs, nCurrentPlayerID )
		end
	end

	return playersIDs
end
