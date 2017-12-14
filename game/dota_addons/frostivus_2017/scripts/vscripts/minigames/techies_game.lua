require('minigames/minigame_base')

RemoteMineGame = MiniGame:new()

function RemoteMineGame:Precache()
	if not self.precached then
		print("Precaching")
		self.precached = true
		--PrecacheItemByNameAsync("ability_name", function(...) end)
		PrecacheUnitByNameAsync("techies_game_remote_mine", function(...) end)
	end
end

function RemoteMineGame:GameStart()
	self:InitializeGame(self.duration)

	self.top_right = Entities:FindByName(nil, "snow_small_top_right"):GetAbsOrigin()
	self.bot_left = Entities:FindByName(nil, "snow_small_bot_left"):GetAbsOrigin()

	local spawner = Entities:FindByName(nil, "info_target_spawner_name")
	self:SpawnVisionDummies(spawner)

	local delayMin = 6.0
	Timers:CreateTimer(1,
    function()
		if not self.isRunning then return end
		self:SpawnUnitRandomUniform("techies_game_remote_mine", DOTA_TEAM_NEUTRALS)

		delayMin = math.max(delayMin - .5, 1)
		return RandomFloat(delayMin, delayMin + 2)
    end)

	do
		local oldFunction = _G.GameMode.OnEntityKilled
		_G.GameMode.OnEntityKilled = function (empty, keys)
			local killedUnit = EntIndexToHScript( keys.entindex_killed )
			if killedUnit:GetUnitName() == "npc_dota_hero_techies" then
				self:AddLoser(killedUnit:GetPlayerID())
				self:CheckForLoneSurvivor()
			end
		end
	end
end

function RemoteMineGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end