MiniGame = {}

function MiniGame:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
    return o
end

function MiniGame:Precache()
	print("In MiniGame_Base Precache")
end

function MiniGame:UpdateScore(playerID, score)
	-- literally the only thing we need playerID for is the name here
	-- and you can get team from playerID but not the other way around
	-- at least without some finagling
	local team = PlayerResource:GetTeam(playerID)
	GameRules.score[team] = GameRules.score[team] + score

	local score_event =
	{
		team_id = team,
		team_score = GameRules.score[team],
		game_score = score,
	}
	print("team: " .. team .. " score: " .. score_event.team_score)
	CustomGameEventManager:Send_ServerToAllClients("score_change", score_event)
end

-- this function exists for that one time I couldn't get a playerid but could get a teamid
function MiniGame:UpdateScoreByTeam(team, score)
	GameRules.score[team] = GameRules.score[team] + score
	local score_event =
	{
		team_id = team,
		team_score = GameRules.score[team],
		game_score = score,
	}
	print("team: " .. team .. " score: " .. score_event.team_score)
	CustomGameEventManager:Send_ServerToAllClients("score_change", score_event)
end

function MiniGame:RemoveElementFromTable(myTable, val)
	local key = TableFindKey(myTable, val)
	table.remove(myTable, key)
end

function MiniGame:EndGameForPlayer(playerID, score)
	local team = PlayerResource:GetTeam(playerID)

	self:UpdateScore(playerID, score)

	if GameRules.num_players == score then
		self.winner = playerID
	end

	self:RemoveElementFromTable(self.remainingTeams, team)
	if TableCount(self.remainingTeams) == 0 and self.isRunning then
		self:GameEnd()
	end
end

function MiniGame:AddWinner(playerID)
	if not self.winner then
		self.winner = playerID
	end
	local score = table.remove(self.pointsTable)
	self:EndGameForPlayer(playerID, score)
end

function MiniGame:AddLoser(playerID)
	local score = table.remove(self.pointsTable, 1)	
	self:EndGameForPlayer(playerID, score)
end

function MiniGame:AddGroupOfLosers(playerIDs)
	-- Give all these people the lowest score available
	local score
	if not self.pointsTable then
		print("CleanUp(): Points Table is nil")
		score = 1
	else
		-- Everyone ties with the lowest score available
		score = table.remove(self.pointsTable, 1)
	end

	-- Empty the score table for each player left
	if TableCount(playerIDs) > 1 then
		for i=2,TableCount(playerIDs) do
			table.remove(self.pointsTable)
		end
	end

	for _,playerID in pairs(playerIDs) do
		self:EndGameForPlayer(playerID, score)		
	end
end

function MiniGame:StartTimer(duration)
	if duration < 0 then return end
	-- if IsInToolsMode() then
	-- 	duration = 10
	-- end
	Timers:CreateTimer(duration, function()    	
		if not self.isRunning then return end
		print("Round Timer Expired")
		self:GameEnd()
		return
    end)

    -- Set the timer in panorama
    SetTimer(duration)
    Timers:CreateTimer(0, function()    	
		if not self.isRunning then 
			SetTimer(0)
			return 
		end
		CountdownTimer()
		return 1
    end)
end

function MiniGame:InitializePoints()
	self.pointsTable = {}
	for i=1,GameRules.num_players do
		table.insert(self.pointsTable, i)
	end
end


function MiniGame:InitializeGame(duration)	
	self.isRunning = true
	self.winner = nil
	-- TODO: Disconnected players should automatically lose at the beginning of a round
	self.remainingTeams = {}
	for team,_ in pairs(GameRules.teams) do
		table.insert(self.remainingTeams, team)
	end
	self:InitializePoints()
	self:StartTimer(duration)
	self:ProvideDeathVision()
	self:Precache()
end

function MiniGame:GameStart(duration)
	self:InitializeGame(duration)
end

function MiniGame:GameEnd()
	-- You usually want to override this, normally to restore an event function
	print("Game End: MiniGame")
	print(self.isRunning)

	self:CleanUp()
end

function MiniGame:CleanUp()
	self.isRunning = false

	-- Clean up all remaining units
	self:DestroyAllItems()
	self:KillAllUnits()

	-- Everyone left ties for last
	local playerIDs = {}
	_G.GameMode:DoToAllHeroes(function(hero)
		if TableFindKey(self.remainingTeams, hero:GetTeam()) then
			table.insert(playerIDs, hero:GetPlayerID())
		end
	end)
	self:AddGroupOfLosers(playerIDs)

	self:StartNextGame()
end

-- Utility Functions

function MiniGame:DestroyAllItems()
	for _,item in pairs(Entities:FindAllByClassname("dota_item_drop")) do
		item:RemoveSelf()
	end
	_G.GameMode:DoToAllHeroes(function(hero)
		for i=0,8 do
			if hero:GetItemInSlot(i) ~= nil then
				item = hero:GetItemInSlot(i)
				--hero:RemoveItem(item)
				item:RemoveSelf()
			end
		end
	end)
end

function MiniGame:KillAllUnits()
	local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,
									Vector(0,0,0), 
									nil, 
									FIND_UNITS_EVERYWHERE, 
									DOTA_UNIT_TARGET_TEAM_BOTH, 
									DOTA_UNIT_TARGET_ALL, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
									0, 
									false)

	for _,unit in pairs(units) do
		unit:ForceKill(false)
		unit:AddNoDraw()
	end
end

-- Checks to see if there is only one player left. If there is, kills the player after a duration
function MiniGame:CheckForLoneSurvivor()
	local survivors = self:FindAllAliveHeroes()
	local duration = 3

	if #survivors == 1 then
		-- Wait 3 seconds and kill the winner
		Timers:CreateTimer(duration, function()
			if not self.isRunning then return end
			local winner = table.remove(survivors)
			if winner:IsAlive() then
				winner:ForceKill(false)
			end
		end)
	end
end

function MiniGame:FindAllAliveHeroes()
	local heroes = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,
                                     Vector(0,0,0),
                                     nil,
                                     2*4000^2,
                                     DOTA_UNIT_TARGET_TEAM_ENEMY,
                                     DOTA_UNIT_TARGET_HERO,
                                     DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
                                     FIND_ANY_ORDER,
                                     false)

	return heroes
end

function MiniGame:SpawnUnit(sUnitName, nTeam, hSpawner, nMaxDistanceFromSpawner)
	if nTeam == nil then nTeam = DOTA_TEAM_NEUTRALS end

	local vSpawnLoc = self:FindPathablePositionInRange(hSpawner:GetAbsOrigin(), nMaxDistanceFromSpawner)
	local unit = CreateUnitByName( sUnitName, vSpawnLoc, true, nil, nil, nTeam )
	unit.hSpawner = hSpawner

	self:LevelAllAbilities(unit)

    return unit
end

function MiniGame:SpawnUnitRandomUniform(unitName, team)
	if not self.bot_left or not self.top_right then
		print("Missing Corner Entities For Spawning")
		return
	end

	if team == nil then team = DOTA_TEAM_NEUTRALS end

	local spawnX = RandomFloat(self.bot_left.x, self.top_right.x)
	local spawnY = RandomFloat(self.bot_left.y, self.top_right.y)
	local spawnLocation = Vector(spawnX, spawnY, 128)

	local unit = CreateUnitByName(unitName, spawnLocation, true, nil, nil, team)

	self:LevelAllAbilities(unit)

	return unit
end

function MiniGame:SpawnRune(itemName, duration, spawner, maxDistanceFromSpawner)
	local rune = CreateItem(itemName, nil, nil)
	local position = self:FindPathablePositionInRange(spawner:GetAbsOrigin(), maxDistanceFromSpawner)
	local item = CreateItemOnPositionSync(position, rune)

	Timers:CreateTimer(duration,function()
      if not item:IsNull() then
		item:RemoveSelf()
	  end
    end)
end

function MiniGame:SpawnRuneUniform(itemName, duration)
	if not self.bot_left or not self.top_right then
		print("Missing Corner Entities For Spawning")
		return
	end

	local spawnX = RandomFloat(self.bot_left.x, self.top_right.x)
	local spawnY = RandomFloat(self.bot_left.y, self.top_right.y)
	local spawnLocation = Vector(spawnX, spawnY, 128)

	local rune = CreateItem(itemName, nil, nil)
	local item = CreateItemOnPositionSync(spawnLocation, rune)

	if duration then
		Timers:CreateTimer(duration,function()
	      if not item:IsNull() then
			item:RemoveSelf()
		  end
	    end)
	end
end

function MiniGame:FindPathablePositionInRange(center, maxDistanceFromSpawner)
	-- if not GridNav:IsTraversable(center) then
	-- 	print("Invalid Location " .. center .. " for center in FindPathablePositionInRange")
	-- 	return nil
	-- end

	local position = nil
	while position == nil do
		position = center + RandomVector( RandomFloat( 0, maxDistanceFromSpawner ) )
		local pathLength = GridNav:FindPathLength( center, position )
		if ( pathLength < 0 or pathLength > maxDistanceFromSpawner ) then	    	
			position = nil
		end
	end
	return position
end

function MiniGame:LevelAllAbilities(unit)
	-- levelup all of ther abilities
	for i=0,unit:GetAbilityCount() - 1 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			ability:UpgradeAbility(true)
		end
	end
end

function MiniGame:SetMusicStatus(nMusicStatus, flIntensity)
	_G.GameMode:DoToAllHeroes(function(hero)
		local player = hero:GetPlayerOwner()
		if player then
        	player:SetMusicStatus(nMusicStatus, flIntensity)
        end
	end)
end

function MiniGame:StartWeatherEffect(weatherEffect)
	_G.GameMode:DoToAllHeroes(function(hero)
		if hero.weatherEffect then
			ParticleManager:DestroyParticle(hero.weatherEffect, true)
		end

		if weatherEffect == "None" then
			hero.weatherEffect = nil
			return
		end

		local owner = hero:GetPlayerOwner()
		local weatherParticle = nil
		if owner then
			weatherParticle = ParticleManager:CreateParticleForPlayer(weatherEffect, PATTACH_EYES_FOLLOW, hero, owner)
		end
		hero.weatherEffect = weatherParticle
	end)
end

function MiniGame:SpawnVisionDummies(spawner)
	self.visionDummyTable = {}
	for team=DOTA_TEAM_GOODGUYS,DOTA_TEAM_CUSTOM_MAX do
		local unit = CreateUnitByName("vision_dummy", spawner:GetAbsOrigin(), true, nil, nil, team)
		--unit:AddNoDraw()
		table.insert(self.visionDummyTable, unit)
	end
end

function MiniGame:DestroyVisionDummies()
	if not self.visionDummyTable then
		print("Attempting to delete Vision Dummies, not created.")
		return
	end
	for _,dummy in pairs(self.visionDummyTable) do
		if dummy:IsNull() then
			print("Vision Dummy Was Null")
		else
			dummy:RemoveSelf()
		end
	end
end

function MiniGame:ProvideDeathVision()
	if self.dontProvideDeathVision then
		return
	end
	_G.GameMode:DoToAllHeroes(function(sourceHero)
		_G.GameMode:DoToAllHeroes(function(targetHero)
			if sourceHero ~= targetHero then
				-- print("Source: " .. sourceHero:GetTeam() .. " Target: " .. targetHero:GetTeam())
				targetHero:AddNewModifier(sourceHero, nil, "modifier_provide_vision_lua", {duration = -1})
			end
		end)
	end)
end

function MiniGame:StartNextGame()
	--Reset the Timer
	SetTimer(1)
	CountdownTimer()

	local nextGameDelay = 5
	local roundEndMessage = "Round " .. GameRules.round .. "/" .. GameRules.MAX_ROUNDS .. " Over"
	
	Notifications:TopToAll({text=roundEndMessage, duration=nextGameDelay - .5})

	if self.winner then
		local winnerMessage = PlayerResource:GetPlayerName(self.winner)  .. " is this round's winner!"
		print(winnerMessage)
		Notifications:TopToAll({text=winnerMessage, duration=nextGameDelay - .5})	
	end

	Timers:CreateTimer(nextGameDelay, function()    	
		_G.GameMode:StartRandomGame()
    end)	
end

-- High Score Game Functions
function MiniGame:InitializeHighScoreGame()
	self.scores = {}
	for team,_ in pairs(GameRules.teams) do
		self.scores[team] = 0
	end
end

function MiniGame:AddHighScoreForPlayer(team, score)
	if not self.scores[team] then
		print("team " .. team .. " not in scores")
		return
	end
	self.scores[team] = self.scores[team] + score

	local score_event =
	{
		team_id = team,
		game_score = math.floor(self.scores[team]),
	}
	CustomGameEventManager:Send_ServerToAllClients("high_score_change", score_event)
end

function MiniGame:SubmitMaxHighScore(team, score)
	-- Instead of constantly adding to the score, this checks to see if the new score
	-- is higher than the previous high score
	if not self.scores[team] then
		print("team " .. team .. " not in scores")
		return
	end

	if score > self.scores[team] then
		self.scores[team] = score
	end

	local score_event =
	{
		team_id = team,
		game_score = math.floor(self.scores[team]),
	}
	CustomGameEventManager:Send_ServerToAllClients("high_score_change", score_event)
end

function MiniGame:HighScoreGameEndGame()
	-- This function replaces CleanUp() for ending the game
	self.isRunning = false

	-- Clean up all remaining units
	self:DestroyAllItems()
	self:KillAllUnits()

	-- Sort the teams by score, least to greatest
	local tableToSort = {}
	for team, score in pairs(self.scores) do
		local tableRow = {}
		tableRow.team = team
		tableRow.score = score
		table.insert(tableToSort, tableRow)
	end

	function compare(a,b)
		return a.score < b.score
	end

	table.sort(tableToSort, compare)

	local tie
	previousRoundScore = 0
	previousGameScore = 1
	-- Rank the players by score, and update their ranks accordingly
	-- This goes from last to first
	for _,tableRow in ipairs(tableToSort) do
		local team = tableRow.team
		local roundScore = tableRow.score
		print("Team: " .. team .. " HighScore: " .. roundScore)

		gameScore = table.remove(self.pointsTable, 1)
		-- Check for ties
		tie = false
		if roundScore == previousRoundScore then
			gameScore = previousGameScore
			tie = true
		end
		
		self:RemoveElementFromTable(self.remainingTeams, team)
		self:UpdateScoreByTeam(team, gameScore)

		previousRoundScore = roundScore
		previousGameScore = gameScore

		if tie then
			self.winner = nil
		else
			self.winner = GameRules.teamToPlayer[team]
		end
	end	

	CustomGameEventManager:Send_ServerToAllClients("game_end", {})

	self:StartNextGame()
end