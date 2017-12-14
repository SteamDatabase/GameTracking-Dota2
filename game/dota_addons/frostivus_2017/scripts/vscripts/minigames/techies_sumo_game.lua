require('minigames/minigame_base')

TechiesSumoGame = MiniGame:new()

function TechiesSumoGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("place_propulsion_mine_lua", function(...) end)
		PrecacheItemByNameAsync("detonate_propulsion_mine_lua", function(...) end)
		PrecacheUnitByNameAsync("propulsion_mine", function(...) end)		
	end
end

function TechiesSumoGame:GameStart()
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
		if killedUnit:GetUnitName() == "npc_dota_hero_techies" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function TechiesSumoGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end