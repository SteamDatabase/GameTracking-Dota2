timestamp = GetSystemDate() .. " " .. GetSystemTime()

function LogGameStart( args )
	InitLogFile( "nb2017_logs/" .. GetMapName() .. "/overview.csv",
		"timestamp,final round,total deaths,gold bags,hero 1, hero 1 steamID, hero 1 level,hero 2, hero 2 steamID, hero 2 level,hero 3, hero 3 steamID, hero 3 level,hero 4, hero 4 steamID, hero 4 level,hero 5, hero 5 steamID, hero 5 level\n" )
	InitLogFile( "nb2017_logs/" .. GetMapName() .. "/heroes.csv",
		"timestamp,hero,hero steamID,hero level,final round,gold bags,kills,deaths,damage taken,damage dealt,damage healed,item 1,item 2,item 3,item 4,item 5,item 6\n" )
	InitLogFile( "nb2017_logs/" .. GetMapName() .. "/rounds.csv",
		"timestamp,round number,success,deaths,gold bags,tower damage,tower count,hero 1,hero 1 steamID,hero 1 level,hero 2,hero 2 steamID,hero 2 level,hero 3,hero 3 steamID,hero 3 level,hero 4,hero 4 steamID,hero 4 level,hero 5,hero 5 steamID,hero 5 level,time end\n" )
end

function LogGameEnd( args )
	local vHeroData = args.gamemode.vPlayerHeroData

	local vHeroDescriptions = FillHeroDescriptions( vHeroData )

	local nGoldBags = 0
	local nDeaths = 0
	for i=1,5 do
		if vHeroData[i] then
			nGoldBags = nGoldBags + vHeroData[i].nGoldBagsCollected
			nDeaths = nDeaths + PlayerResource:GetDeaths( vHeroData[i].nPlayerID )
		end
	end

	AppendToLogFile( "nb2017_logs/" .. GetMapName() .. "/overview.csv",
		timestamp .. "," ..
		args.gamemode.nRoundNumber .. "," ..
		nDeaths .. "," ..
		nGoldBags .. "," ..
		vHeroDescriptions[1] .. "," ..
		vHeroDescriptions[2] .. "," ..
		vHeroDescriptions[3] .. "," ..
		vHeroDescriptions[4] .. "," ..
		vHeroDescriptions[5] ..
		"\n" );

	for i=1,5 do
		if vHeroData[i] then
			local vItems = {}
			for j=0,5 do
				vItems[j] = vHeroData[i].hero:GetItemInSlot( j )
			end
			AppendToLogFile( "nb2017_logs/" .. GetMapName() .. "/heroes.csv",
				timestamp .. "," .. 
				vHeroDescriptions[i] .. "," ..
				args.gamemode.nRoundNumber .. "," ..
				vHeroData[i].nGoldBagsCollected .. "," ..
				vHeroData[i].nCreepKills .. "," ..
				PlayerResource:GetDeaths( vHeroData[i].nPlayerID ) .. "," ..
				PlayerResource:GetCreepDamageTaken( vHeroData[i].nPlayerID ) .. "," ..
				PlayerResource:GetRawPlayerDamage( vHeroData[i].nPlayerID ) .. "," ..
				"?," .. -- healing
				(vItems[0] and vItems[0]:GetAbilityName() or "none") .. "," ..
				(vItems[1] and vItems[1]:GetAbilityName() or "none") .. "," ..
				(vItems[2] and vItems[2]:GetAbilityName() or "none") .. "," ..
				(vItems[3] and vItems[3]:GetAbilityName() or "none") .. "," ..
				(vItems[4] and vItems[4]:GetAbilityName() or "none") .. "," ..
				(vItems[5] and vItems[5]:GetAbilityName() or "none") ..
				"\n" );
		end
	end
end

function LogRoundEnd( args )
	local vHeroData = args.gamemode.vPlayerHeroData

	local vHeroDescriptions = FillHeroDescriptions( vHeroData )
	
	local nGoldBags = 0
	local nDeaths = 0
	for i=1,5 do
		if vHeroData[i] then
			nGoldBags = nGoldBags + vHeroData[i].nGoldBagsCollectedThisRound
			nDeaths = nDeaths + (PlayerResource:GetDeaths( vHeroData[i].nPlayerID ) - vHeroData[i].nPriorRoundDeaths)
		end
	end

	AppendToLogFile( "nb2017_logs/" .. GetMapName() .. "/rounds.csv", 
		timestamp .. "," ..
		args.gamemode.nRoundNumber .. "," ..
		tostring( args.success ) .. "," ..
		nDeaths .. "," ..
		nGoldBags .. "," ..
		"?," .. -- tower damage
		args.nTowersStanding .. "," .. -- tower count
		vHeroDescriptions[1] .. "," ..
		vHeroDescriptions[2] .. "," ..
		vHeroDescriptions[3] .. "," ..
		vHeroDescriptions[4] .. "," ..
		vHeroDescriptions[5] .. "," ..
		GetSystemTime() ..
		"\n" );
end

function FillHeroDescriptions( vHeroData )
	local vDescriptions = {}
	for i=1,5 do
		vDescriptions[i] =
			(vHeroData[i] and PlayerResource:GetSelectedHeroName( vHeroData[i].nPlayerID ) or "none") .. "," ..
			(vHeroData[i] and PlayerResource:GetSteamAccountID( vHeroData[i].nPlayerID ) or "0") .. "," ..
			(vHeroData[i] and PlayerResource:GetLevel( vHeroData[i].nPlayerID ) or "0")
	end
	return vDescriptions
end
