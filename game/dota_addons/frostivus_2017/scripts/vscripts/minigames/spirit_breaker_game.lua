require('minigames/minigame_base')

SpiritBreakerGame = MiniGame:new()

function SpiritBreakerGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("greater_bash_lua", function(...) end)
	end
end

function SpiritBreakerGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_tiny_center")
	self:SpawnVisionDummies(spawner)

	-- Set people who fall into the lava on fire
	Timers:CreateTimer(0, function()
		if not self.isRunning then return end
		_G.GameMode:DoToAllHeroes(function(hero)
			if hero:GetAbsOrigin().z <= 10 then
				hero:ForceKill(false)
			end
		end)
		return .1
    end)	
	
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_spirit_breaker" then
			self:AddLoser(killedUnit:GetPlayerID())
			-- If everyone is dead, end the round
			self:CheckForLoneSurvivor()
		end
	end
end

function SpiritBreakerGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end