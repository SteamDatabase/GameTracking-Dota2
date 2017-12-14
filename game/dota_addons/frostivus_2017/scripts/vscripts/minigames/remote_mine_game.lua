require('minigames/minigame_base')

RemoteMineGame = MiniGame:new()

function RemoteMineGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheUnitByNameAsync("techies_game_remote_mine", function(...) end)
	end
end

function RemoteMineGame:GameStart()
	self:InitializeGame(self.duration)

	self.top_right = Entities:FindByName(nil, "snow_small_top_right"):GetAbsOrigin()
	self.bot_left = Entities:FindByName(nil, "snow_small_bot_left"):GetAbsOrigin()

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)
	local maxDelay = 4.0
	Timers:CreateTimer(1,
    function()
		if not self.isRunning then return end
		self:SpawnUnitRandomUniform("techies_game_remote_mine", DOTA_TEAM_NEUTRALS)
		maxDelay = math.max(maxDelay - .2, .6)
		return RandomFloat(.1, maxDelay)
    end)

	local cornerTable = {
		Entities:FindByName(nil, "snow_small_bot_left"),
		Entities:FindByName(nil, "snow_small_top_right"),
		Entities:FindByName(nil, "snow_small_top_left"),
		Entities:FindByName(nil, "snow_small_top_right"),
	}

    Timers:CreateTimer(RandomFloat(5, 9),
    function()
		if not self.isRunning then return end
		self:SpawnUnit("techies_game_remote_mine", DOTA_TEAM_NEUTRALS, GetRandomTableElement(cornerTable), 100)
		return RandomFloat(5, 9)
    end)
    
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_techies" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function RemoteMineGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end