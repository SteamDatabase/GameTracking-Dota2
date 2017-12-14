require('minigames/minigame_base')

PudgeWars = MiniGame:new()

function PudgeWars:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("custom_pudge_meat_hook", function(...) end)
		PrecacheItemByNameAsync("pudge_rot_lua", function(...) end)
		PrecacheItemByNameAsync("item_rune_haste", function(...) end)
	end
end

function PudgeWars:GameStart()
	self.dontProvideDeathVision = true

	self:InitializeGame(self.duration)
	self:InitializeHighScoreGame()

	local spawners = Entities:FindAllByName("snow_arena_spawner_hero")

	local respawnDelay = 5
	local runeDuration = 45
	local maxDistanceFromSpawner = 0
	local runeList = {"item_rune_haste"}

	Timers:CreateTimer(15,function()
		if not self.isRunning then return end
		self:SpawnRune(GetRandomTableElement(runeList), runeDuration, Entities:FindByName(nil, "snow_arena_bottom_left"), maxDistanceFromSpawner)
		self:SpawnRune(GetRandomTableElement(runeList), runeDuration, Entities:FindByName(nil, "snow_arena_top_right"), maxDistanceFromSpawner)
		
		return runeDuration
    end)

	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killerEntity = nil

		if keys.entindex_attacker ~= nil then
		  killerEntity = EntIndexToHScript( keys.entindex_attacker )
		end

		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_pudge" then
			local killedTeam = killedUnit:GetTeam()
			local attackerTeam = killerEntity:GetTeam()
			-- self:AddHighScoreForPlayer(killedTeam, -1)			
			self:AddHighScoreForPlayer(attackerTeam, 1)

			Timers:CreateTimer(respawnDelay, function()
				if not self.isRunning then return end
				local spawnLocation = GetRandomTableElement(spawners):GetAbsOrigin()
				killedUnit:RespawnHero(false, false)
				FindClearSpaceForUnit(killedUnit, spawnLocation, true)
			end)
		end
	end
end

function PudgeWars:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:HighScoreGameEndGame()
end