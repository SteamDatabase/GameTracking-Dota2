require('minigames/minigame_base')

DrowArcherGame = MiniGame:new()

function DrowArcherGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("drow_shoot_arrow_lua", function(...) end)
		PrecacheUnitByNameAsync("chain_frost_game_penguin", function(...) end)
		PrecacheItemByNameAsync("item_rune_haste", function(...) end)
	end
end

function DrowArcherGame:GameStart()
	self:InitializeGame(self.duration)

	local rune1Spawner = Entities:FindByName(nil, "snow_arena_bottom_left")
	local rune2Spawner = Entities:FindByName(nil, "snow_arena_top_right")
	local runeDuration = 30
	local maxDistanceFromSpawner = 200
	local runeList = {"item_rune_haste"}

	Timers:CreateTimer(15,function()
		if not self.isRunning then return end
		self:SpawnRune(GetRandomTableElement(runeList), runeDuration, rune1Spawner, maxDistanceFromSpawner)
		self:SpawnRune(GetRandomTableElement(runeList), runeDuration, rune2Spawner, maxDistanceFromSpawner)
		
		return runeDuration
    end)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_drow_ranger" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function DrowArcherGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:CleanUp()
end