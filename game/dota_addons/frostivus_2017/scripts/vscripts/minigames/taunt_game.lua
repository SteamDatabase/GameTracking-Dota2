require('minigames/minigame_base')

TauntGame = MiniGame:new()

function TauntGame:Precache()
	if not self.precached then
		print("Precaching")
		self.precached = true
		PrecacheItemByNameAsync("custom_berserkers_call", function(...) end)
		PrecacheUnitByNameAsync("taunt_game_creep", function(...) end)
	end
end

function TauntGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)
	
	local maxDistanceFromSpawner = 1800
	local delay = 8.0
	Timers:CreateTimer(1,
    function()
		if not self.isRunning then return end
		self:SpawnUnit("taunt_game_creep", DOTA_TEAM_NEUTRALS, spawner, maxDistanceFromSpawner)
		delay = math.max(delay - .5, 3)
		return delay
    end)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_axe" then
			self:AddWinner(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function TauntGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end