require('minigames/minigame_base')

StoreggaGame = MiniGame:new()

function StoreggaGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheUnitByNameAsync("npc_dota_creature_elder_tiny", function(...) end)
	end
end

function StoreggaGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_medium_center")
	self:SpawnVisionDummies(spawner)

	local storegga = self:SpawnUnit("npc_dota_creature_elder_tiny", nil, spawner, 0)
	storegga:SetAngles(0, 90, 0)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:IsRealHero() then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function StoreggaGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end