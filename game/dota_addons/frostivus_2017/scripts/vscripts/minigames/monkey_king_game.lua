require('minigames/minigame_base')
LinkLuaModifier("modifier_stunned_lua", 'heroes/modifiers/modifier_stunned_lua', LUA_MODIFIER_MOTION_NONE)

MonkeyKingGame = MiniGame:new()

function MonkeyKingGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("lion_finger_lua", function(...) end)

		PrecacheUnitByNameAsync("monkey_king_real", function(...) end)
		PrecacheUnitByNameAsync("monkey_king_fake", function(...) end)	
	end
end

function MonkeyKingGame:GameStart()
	self:InitializeGame(self.duration)
	self:InitializeHighScoreGame()

	local center = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(center)

	self.top_right = Entities:FindByName(nil, "snow_small_top_right"):GetAbsOrigin()
	self.bot_left = Entities:FindByName(nil, "snow_small_bot_left"):GetAbsOrigin()

	--tree, rune, aegis/cheese, courier, iron branch, clarity, healing salve, tp scroll, banana, tango
	local transformTable = {		
		-- "models/props_tree/tree_pine_01.vmdl",
		--"models/props_tree/tree_pinestatic_02.vmdl",
		--"models/props_tree/tree_pinestatic_03b.vmdl",
		"models/props_gameplay/rune_goldxp.vmdl",
		"models/props_gameplay/aegis.vmdl",
		"models/props_gameplay/cheese.vmdl",
		"models/props_gameplay/donkey.vmdl",
		"models/props_gameplay/branch.vmdl",
		--"models/props_gameplay/banana_prop_open.vmdl",
		--"models/props_gameplay/banana_prop_closed.vmdl",
		"models/props_gameplay/tango.vmdl",
	}

	local numDecoy = 80
	local numMonkeys = 15

	-- Keep everyone stunned until the game begins
	_G.GameMode:DoToAllHeroes(function(hero)
		hero:AddNewModifier(unit, nil, "modifier_stunned_lua", {duration = 4})
	end)

	-- Spawn the real items
	local numSpawned = 0
	local batchSize = 5
	Timers:CreateTimer(0, function()
		if not self.isRunning then return end
		for i=1, batchSize do
			local unit = self:SpawnUnitRandomUniform("monkey_king_fake", DOTA_TEAM_NEUTRALS)
			local model = GetRandomTableElement(transformTable)
			unit:SetOriginalModel(model)
			unit:SetModel(model)
			unit:StartGesture(ACT_DOTA_IDLE)
			unit:SetAngles(0, RandomInt(0, 359), 0)
		end
		numSpawned = numSpawned + batchSize
		if numSpawned >= numDecoy then return end
		return .03
	end)

	-- Spawn the Monkey Kings
	Timers:CreateTimer(1, function()
		if not self.isRunning then return end
		EmitGlobalSound("monkey_king_Monkey_ability4_03")
		-- Spawn the monkeys that will transform into the fakes
		local monkeyKingTable = {}
		for i=1, numMonkeys do
			local unit = self:SpawnUnitRandomUniform("monkey_king_real", DOTA_TEAM_NEUTRALS)
			unit:SetAngles(0, RandomInt(0, 359), 0)
			table.insert(monkeyKingTable, unit)
		end

		-- After a couple seconds, have all the monkey kings transform into their disguises
		local timeToDisguise = 3
		Timers:CreateTimer(timeToDisguise, function()
			if not self.isRunning then return end
			for _,unit in pairs(monkeyKingTable) do
				self:RemoveWearables(unit)
				local model = GetRandomTableElement(transformTable)
				unit:SetOriginalModel(model)
				unit:SetModel(model)
				unit:StartGesture(ACT_DOTA_IDLE)
				unit.isMonkeyKing = true
			end
		end)
	end)

    _G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		local killerEntity
		if keys.entindex_attacker ~= nil then
			killerEntity = EntIndexToHScript( keys.entindex_attacker )
		end

		if killedUnit:GetUnitName() == "monkey_king_real" and killedUnit.isMonkeyKing then
			-- make a corpse
			local monkeyKing = CreateUnitByName("monkey_king_real", killedUnit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
			
			local soundName = "monkey_king_monkey_pain_0" .. RandomInt(2, 9)
        	EmitSoundOn(soundName, killerEntity)

			Timers:CreateTimer(.1, function()
				monkeyKing:ForceKill(false)
			end)

	        self:AddHighScoreForPlayer(killerEntity:GetTeam(), 1)
			numMonkeys = numMonkeys - 1

			if numMonkeys == 0 then
				self:GameEnd()
			end
		end
	end
end

function MonkeyKingGame:RemoveWearables(hero)
    local model = hero:FirstMoveChild()
    while model ~= nil do
    	if model:GetClassname() == "dota_item_wearable" then
    		model:AddEffects(EF_NODRAW)
    	end
    	model = model:NextMovePeer()
    end
end

function MonkeyKingGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) return end
	self:DestroyVisionDummies()
	self:HighScoreGameEndGame()
end

-- function MonkeyKingGame:GameStart()
-- 	self:InitializeGame(self.duration)

-- 	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
-- 	self:SpawnVisionDummies(spawner)

-- 	self.top_right = Entities:FindByName(nil, "snow_small_top_right"):GetAbsOrigin()
-- 	self.bot_left = Entities:FindByName(nil, "snow_small_bot_left"):GetAbsOrigin()

-- 	--tree, rune, aegis/cheese, courier, iron branch, clarity, healing salve, tp scroll, banana, tango
-- 	self.transformTable = {		
-- 		-- "models/props_tree/tree_pine_01.vmdl",
-- 		--"models/props_tree/tree_pinestatic_02.vmdl",
-- 		--"models/props_tree/tree_pinestatic_03b.vmdl",
-- 		"models/props_gameplay/rune_goldxp.vmdl",
-- 		"models/props_gameplay/aegis.vmdl",
-- 		"models/props_gameplay/cheese.vmdl",
-- 		"models/props_gameplay/donkey.vmdl",
-- 		"models/props_gameplay/branch.vmdl",
-- 		--"models/props_gameplay/banana_prop_open.vmdl",
-- 		--"models/props_gameplay/banana_prop_closed.vmdl",
-- 		"models/props_gameplay/tango.vmdl",
-- 	}

-- 	--monkey_pain_01-22
-- 	--monkey_death09,11,1302

-- 	self.center = Entities:FindByName(nil, "snow_small_spawner_center")
-- 	self.numDecoy = 40
-- 	self.numMonkeys = TableCount(self.remainingTeams) - 1
-- 	self.currentRound = 0
-- 	self.roundComplete = false
-- 	self.roundDuration = 30

-- 	-- This game has multiple rounds, each round at least one player is eliminated, until all players are eliminated
-- 	self:StartNextRound()

-- 	-- Make the timer start ticking
-- 	Timers:CreateTimer(0, function()    	
-- 		if not self.isRunning then return end
-- 		CountdownTimer()
-- 		return 1
--     end)

--     _G.GameMode.OnEntityKilled = function (empty, keys)
-- 		local killedUnit = EntIndexToHScript( keys.entindex_killed )
-- 		local killerEntity
-- 		if keys.entindex_attacker ~= nil then
-- 			killerEntity = EntIndexToHScript( keys.entindex_attacker )
-- 		end

-- 		-- We only care if it was a player that killed the monkey (As opposed to them being cleaned up)
-- 		if not killerEntity or not killerEntity:IsRealHero() then return end

-- 		if killedUnit:GetUnitName() == "monkey_king_fake" and killedUnit.isMonkeyKing then
-- 			-- Spawn a real monkey king to show it was real
-- 			local monkeyKing = CreateUnitByName("monkey_king_real", killedUnit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)

-- 	        Timers:CreateTimer(.1,function() 
-- 	        	monkeyKing:ForceKill(false)
-- 	        	-- Play a death sound for the monkey

-- 				killerEntity:ForceKill(false)
-- 	        end)        

-- 			self.numMonkeys = self.numMonkeys - 1

-- 			if self.numMonkeys == 0 then
-- 				self:EndRound()
-- 			end
-- 		end
-- 	end
-- end

-- function MonkeyKingGame:GameEnd()
-- _G.GameMode.OnEntityKilled = function (empty, keys) return end
-- 	self:DestroyVisionDummies()
-- 	self:CleanUp()
-- end

-- -- Override CleanUp because we're doing some of this stuff when we end a round
-- function MonkeyKingGame:CleanUp()
-- 	self.isRunning = false

-- 	--Clean up all remaining units
-- 	self:KillAllNeutrals()

-- 	CustomGameEventManager:Send_ServerToAllClients("game_end", {})

-- 	--Reset the Timer
-- 	SetTimer(1)
-- 	CountdownTimer()

-- 	local nextGameDelay = 5
-- 	-- Show the scores for this round
-- 	Notifications:TopToAll({text="Round Over", duration=nextGameDelay - .5})

-- 	Timers:CreateTimer(nextGameDelay, function()    	
-- 		_G.GameMode:StartRandomGame()
--     end)	
-- end

-- function MonkeyKingGame:StartNextRound()
-- 	self.numMonkeys = TableCount(self.remainingTeams) - 1
-- 	print("Spawning " .. self.numMonkeys .. " Monkeys")

-- 	-- Set the time until the round starts
-- 	SetTimer(6)

-- 	-- Respawn all players who haven't been eliminated yet
-- 	_G.GameMode:DoToAllHeroes(function(hero)		
-- 		if self:PlayerNotEliminated(hero:GetPlayerID()) then
-- 			hero:RespawnHero(false, false)
-- 			FindClearSpaceForUnit(hero, hero.spawnLocation, false)
-- 			hero:AddNewModifier(unit, nil, "modifier_stunned_lua", {duration = 5})
-- 		end
-- 	end)

-- 	-- Spawn the originals, offset the spawns by a frame so the animations aren't synced
-- 	self.numDecoy = 15 + self.numMonkeys * 3
-- 	local spawnCount = 0
-- 	local batchSize = 5
-- 	Timers:CreateTimer(0,function()
-- 		if not self.isRunning then return end
-- 		for i=1,batchSize do
-- 			local unit = self:SpawnUnitRandomUniform("monkey_king_fake", DOTA_TEAM_NEUTRALS)
-- 			local model = GetRandomTableElement(self.transformTable)
-- 			unit:SetOriginalModel(model)
-- 			unit:SetModel(model)
-- 			unit:StartGesture(ACT_DOTA_IDLE)
-- 			unit:SetAngles(0, RandomInt(0, 359), 0)
-- 		end
-- 		spawnCount = spawnCount + batchSize
-- 		if spawnCount >= self.numDecoy then return end
-- 		return .03
-- 	end)

-- 	-- Spawn the Monkey Kings
-- 	Timers:CreateTimer(1,function()
-- 		if not self.isRunning then return end
-- 		-- Spawn monkey kings in the center, that then appear to transform into the fakes
-- 		local monkeyKingTable = {}
-- 		for i=1,self.numMonkeys do
-- 			local unit = self:SpawnUnit("monkey_king_real", DOTA_TEAM_NEUTRALS, self.center, 150)
-- 			unit:SetAngles(0, RandomInt(0, 359), 0)
-- 			table.insert(monkeyKingTable, unit)
-- 		end
-- 		Timers:CreateTimer(4,function()
-- 			if not self.isRunning then return end
-- 			-- Create the transformed Monkey Kings
-- 			-- Play some Monkey King sound
-- 			for _,unit in pairs(monkeyKingTable) do
-- 				unit:RemoveSelf()
-- 			end
-- 			for i=1,self.numMonkeys do
-- 				local unit = self:SpawnUnitRandomUniform("monkey_king_fake", DOTA_TEAM_NEUTRALS)
-- 				local model = GetRandomTableElement(self.transformTable)
-- 				unit:SetOriginalModel(model)
-- 				unit:SetModel(model)
-- 				unit:StartGesture(ACT_DOTA_IDLE)
-- 				unit.isMonkeyKing = true
-- 			end

-- 			-- Start the round timer
-- 			SetTimer(self.roundDuration)
-- 			local round = self.currentRound	
-- 			Timers:CreateTimer(self.roundDuration,function()		
-- 				if not self.isRunning then return end
-- 				-- If the current round hasn't ended yet
-- 				if round == self.currentRound then
-- 					print("Ending Round Through Time Out")
-- 					self:EndRound()
-- 				end
-- 				return
-- 		    end)
-- 		end)
-- 	end)
-- end

-- function MonkeyKingGame:EndRound()
-- 	print("Monkey King Game Round Ended")
-- 	-- Kill everyone still alive and have them tie for last
-- 	local playerIDs = {}
-- 	for _,hero in pairs(_G.GameMode.heroList) do
-- 		table.insert(playerIDs, hero:GetPlayerID())
-- 		hero:ForceKill(false)
-- 	end
-- 	self:AddGroupOfLosers(playerIDs)
-- 	-- Clear all this round's monkeys
-- 	self:KillAllNeutrals()
-- 	-- Start the next round
-- 	if self.isRunning then
-- 		self:StartNextRound()
-- 	end
-- end

-- function MonkeyKingGame:PlayerNotEliminated(playerID)
-- 	if TableFindKey(self.remainingTeams, playerID) then return true end
-- 	return false
-- end