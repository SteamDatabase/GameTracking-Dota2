require('minigames/minigame_base')

BloodseekerGame = MiniGame:new()

function BloodseekerGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheUnitByNameAsync("bloodseeker_game_bloodseeker", function(...) end)
		PrecacheItemByNameAsync("shukuchi_lua", function(...) end)
	end
end

function BloodseekerGame:GameStart()
	self:InitializeGame(self.duration)

	local vRaceRight = Entities:FindByName(nil, "race_right_boundary"):GetAbsOrigin()
	local spawner = Entities:FindByName(nil, "race_spawner_center")
	local startDelay = 3

	local barriers = Entities:FindAllByName("race_barrier")
	for _,barrier in pairs(barriers) do
		barrier:SetEnabled(true, false)
	end

	self:SpawnVisionDummies(Entities:FindByName(nil, "race_spawner_center"))

	Timers:CreateTimer(startDelay - 1, function()		
		self:SpawnUnit("bloodseeker_game_bloodseeker", DOTA_TEAM_NEUTRALS, spawner, 0)
	end)

	local numWinners = 0
	local numPlayers = GameRules.num_players

	print("numPlayers: " .. numPlayers)

	-- Delay the start of the race to give people time to get ready
	Timers:CreateTimer(startDelay, function()
		local barriers = Entities:FindAllByName("race_barrier")
		for _,barrier in pairs(barriers) do
			barrier:SetEnabled(false, false)
		end
		
		-- When someone crosses the finish line
		Timers:CreateTimer(.1, function()
			if not self.isRunning then return end
			for _,hero in pairs(_G.GameMode.heroList) do
				if not hero.winner and hero:GetAbsOrigin().x > vRaceRight.x then
					self:AddWinner(hero:GetPlayerID())
					local distance = 200
					local newPosition = hero:GetAbsOrigin() + Vector(distance,0,0)
					FindClearSpaceForUnit(hero, newPosition, true)
					hero:AddNewModifier(hero, nil, "modifier_hidden_lua", {})
					hero.winner = true
					numWinners = numWinners + 1
					if numWinners == numPlayers - 1 then
						Timers:CreateTimer(3, function()
							if not self.isRunning then return end
							self:GameEnd()
						end)
					end
				end
			end
			return .03
		end)
	end)

	local respawnDelay = 3

	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_weaver" then
			Timers:CreateTimer(respawnDelay, function()
				if not self.isRunning then return end
				killedUnit:RespawnHero(false, false)
				FindClearSpaceForUnit(killedUnit, killedUnit.spawnLocation, true)
			end)
		end
	end
end

function BloodseekerGame:GameEnd()
	self.isRunning = false
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end