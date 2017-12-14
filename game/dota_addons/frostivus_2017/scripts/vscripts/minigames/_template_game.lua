require('minigames/minigame_base')

TemplateGame = MiniGame:new()

function TemplateGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("ability_name", function(...) end)
		PrecacheUnitByNameAsync("unit_name", function(...) end)
	end
end

function TemplateGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)

	local maxDistanceFromSpawner = 1000
	local delay = 10.0
	Timers:CreateTimer(1,
    function()
		if not self.isRunning then return end
		self:SpawnUnit("taunt_game_creep", DOTA_TEAM_NEUTRALS, spawner, maxDistanceFromSpawner)
		delay = math.max(delay - .5, 3)
		return delay
    end)
	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:IsRealHero() then
			self:AddLoser(killedUnit:GetPlayerID())
		end
	end
end

function TemplateGame:GameEnd()
	-- Restore the event function
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end