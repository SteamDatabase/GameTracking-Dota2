require('minigames/minigame_base')

ShadowfiendWars = MiniGame:new()

function ShadowfiendWars:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("custom_shadowraze1", function(...) end)
		PrecacheItemByNameAsync("item_rune_full_heal", function(...) end)
		PrecacheItemByNameAsync("item_rune_haste", function(...) end)
		PrecacheItemByNameAsync("item_rune_double_damage", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_hero_nevermore", function(...) end)
	end
end

function ShadowfiendWars:GameStart()
	self.dontProvideDeathVision = true
	
	self:InitializeGame(self.duration)
	self:InitializeHighScoreGame()	

	local spawners = Entities:FindAllByName("snow_arena_spawner_hero")

	local respawnDelay = 5
	local runeDuration = 30
	local maxDistanceFromSpawner = 200
	local runeList = {"item_rune_full_heal", "item_rune_haste", "item_rune_double_damage"}

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
		if killedUnit:GetUnitName() == "npc_dota_hero_nevermore" then
			local killedTeam = killedUnit:GetTeam()
			local attackerTeam = killerEntity:GetTeam()
			self:AddHighScoreForPlayer(killedTeam, -1)
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

function ShadowfiendWars:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:HighScoreGameEndGame()
end