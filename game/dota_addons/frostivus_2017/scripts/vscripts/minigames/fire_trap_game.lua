require('minigames/minigame_base')

FireTrapGame = MiniGame:new()

function FireTrapGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheUnitByNameAsync("trap_game_fire_trap", function(...) end)
	end
end

function FireTrapGame:CreateTrap(spawner, direction, pattern)
	local trap = self:SpawnUnit("trap_game_fire_trap", nil, spawner, 0)

	if direction == "north" then
		trap:SetAngles(0, 270, 0)
		trap.target = trap:GetAbsOrigin() - Vector(0, 900, 0)
	elseif direction == "south" then
		trap:SetAngles(0, 90, 0)
		trap.target = trap:GetAbsOrigin() + Vector(0, 900, 0)
	end

	trap.pattern = pattern
	trap.patternIndex = 1

	return trap
end

function FireTrapGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "race_spawner_center")
	self:SpawnVisionDummies(spawner)

	local vRaceRight = Entities:FindByName(nil, "race_right_boundary"):GetAbsOrigin()

	local patternTable = {
		{3},
		{2},
		{1,1,3},
		{1,1,1,3},
		{1,1,1,3,1,3}
	}

	local trapTable = {}

	for _,trap_north in pairs(Entities:FindAllByName("fire_trap_race_north")) do
		local trap = self:CreateTrap(trap_north, "north", GetRandomTableElement(patternTable))
		table.insert(trapTable, trap)
	end

	for _,trap_south in pairs(Entities:FindAllByName("fire_trap_race_south")) do
		local trap = self:CreateTrap(trap_south, "south", GetRandomTableElement(patternTable))
		table.insert(trapTable, trap)
	end

	for _,trap in pairs(trapTable) do
		Timers:CreateTimer(0,
	    function()
			if not self.isRunning then return end

			local ability = trap:FindAbilityByName("breathe_fire_trap_game")
			trap:CastAbilityOnPosition(trap.target, ability, -1)
			
			local timeToFire = trap.pattern[trap.patternIndex]

			trap.patternIndex = trap.patternIndex + 1
			if trap.patternIndex > #trap.pattern then
				trap.patternIndex = 1
			end

			return timeToFire
	    end)
	end

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:IsRealHero() then
			Timers:CreateTimer(5, function()
				if not self.isRunning then return end
				killedUnit:RespawnHero(false, false)
				FindClearSpaceForUnit(killedUnit, killedUnit.spawnLocation, true)
			end)
		end
	end

	local numWinners = 0
	local numPlayers = GameRules.num_players

	-- When someone crosses the finish line
	Timers:CreateTimer(.1, function()
		if not self.isRunning then return end
		for _,hero in pairs(_G.GameMode.heroList) do
			if not hero.winner and hero:GetAbsOrigin().x > vRaceRight.x then
				self:AddWinner(hero:GetPlayerID())
				local distance = 200
				local newPosition = hero:GetAbsOrigin() + Vector(distance,0,0)
				FindClearSpaceForUnit(hero, newPosition, true)
				hero:AddNewModifier(hero, nil, "modifier_stunned_lua", {})
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
end

function FireTrapGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	for _,hero in pairs(_G.GameMode.heroList) do
		hero.winner = false
	end

	self:DestroyVisionDummies()
	self:CleanUp()
end