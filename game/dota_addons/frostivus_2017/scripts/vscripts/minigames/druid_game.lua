require('minigames/minigame_base')

DruidGame = MiniGame:new()

function DruidGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("lone_druid_rabid_lua", function(...) end)
		PrecacheItemByNameAsync("custom_entangling_roots", function(...) end)
		PrecacheItemByNameAsync("arcane_bolt_lua", function(...) end)
		PrecacheItemByNameAsync("custom_boar_poison", function(...) end)
		
		PrecacheItemByNameAsync("shapeshift_boar_lua", function(...) end)
		PrecacheItemByNameAsync("shapeshift_bear_lua", function(...) end)
		PrecacheItemByNameAsync("shapeshift_hawk_lua", function(...) end)		
	end
end

function DruidGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)

	-- Override event function
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:IsRealHero() then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function DruidGame:GameEnd()
	-- Restore the event function
	_G.GameMode.OnEntityKilled = function (empty, keys) end
	self:DestroyVisionDummies()
	self:CleanUp()
end