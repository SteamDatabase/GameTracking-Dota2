require('minigames/minigame_base')

OgreSealGame = MiniGame:new()

function OgreSealGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheUnitByNameAsync("npc_dota_creature_ogre_seal", function(...) end)
		PrecacheItemByNameAsync("custom_nether_swap", function(...) end)
		
	end
end

function OgreSealGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)
	self:SpawnUnit("npc_dota_creature_ogre_seal", DOTA_TEAM_NEUTRALS, spawner, 0)

	local delay = 20.0
	Timers:CreateTimer(delay,
    function()
		if not self.isRunning then return end
		delay = math.max(12, delay - 3)
		self:SpawnUnit("npc_dota_creature_ogre_seal", DOTA_TEAM_NEUTRALS, spawner, 0)
		return delay
    end)

	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_vengefulspirit" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function OgreSealGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end