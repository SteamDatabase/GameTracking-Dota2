require('minigames/minigame_base')

FurionTeleportGame = MiniGame:new()

function FurionTeleportGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("furion_teleport_lua", function(...) end)
		PrecacheItemByNameAsync("item_bag_of_gold", function(...) end)
	end
end

function FurionTeleportGame:GameStart()
	self:InitializeGame(self.duration)
	self:InitializeHighScoreGame()

	self.bot_left = Entities:FindByName(nil, "snow_large_bottom_left"):GetAbsOrigin()
	self.top_right = Entities:FindByName(nil, "snow_large_top_right"):GetAbsOrigin()

	local spawner = Entities:FindByName(nil, "snow_large_center")
	self:SpawnVisionDummies(spawner)

	local numSpawners = 2
	local spawnDelayMin = 1
	local spawnDelayMax = 3

	for i=1,numSpawners do
		Timers:CreateTimer(0, function()
			if not self.isRunning then return end
			self:SpawnRuneUniform("item_bag_of_gold")
			return RandomFloat(spawnDelayMin, spawnDelayMax)
		end)
	end
end

function FurionTeleportGame:GameEnd()
	_G.GameMode.OnItemPickedUp = function (empty, keys) end

	self:DestroyVisionDummies()
	self:HighScoreGameEndGame()
end

function FurionTeleportGame:OnCoinPickedUp(caster)
	self:AddHighScoreForPlayer(caster:GetTeam(), 1)
	--EmitSoundOn("ui.comp_coins_tick", caster)
	SendOverheadEventMessage(caster, OVERHEAD_ALERT_GOLD, caster, 1, nil)
end