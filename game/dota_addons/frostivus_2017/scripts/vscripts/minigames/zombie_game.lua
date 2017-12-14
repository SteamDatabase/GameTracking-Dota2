require('minigames/minigame_base')

ZombieGame = MiniGame:new()

function ZombieGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("sniper_ground_shot_lua", function(...) end)
		PrecacheUnitByNameAsync("custom_undying_tombstone", function(...) end)
	end
end

function ZombieGame:GameStart()
	self:InitializeGame(self.duration)

    self:SpawnUnit("custom_undying_tombstone", nil, Entities:FindByName(nil, "snow_arena_center"), 0)
    self:SpawnUnit("custom_undying_tombstone", nil, Entities:FindByName(nil, "snow_arena_bottom_left"), 0)
    self:SpawnUnit("custom_undying_tombstone", nil, Entities:FindByName(nil, "snow_arena_top_right"), 0)

	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_sniper" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		elseif killedUnit:GetUnitName() == "custom_creature_zombie" then
			killedUnit.spawner.numSpawned = killedUnit.spawner.numSpawned - 1
		end
	end
end

function ZombieGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:CleanUp()
end