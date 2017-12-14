require('minigames/minigame_base')

ChainFrostGame = MiniGame:new()

function ChainFrostGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("chain_frost_lua", function(...) end)
		PrecacheUnitByNameAsync("chain_frost_game_lich", function(...) end)
		PrecacheUnitByNameAsync("chain_frost_game_penguin", function(...) end)	
		PrecacheItemByNameAsync("conjure_image_lua", function(...) end)		
	end
end

function ChainFrostGame:GameStart()
	self:InitializeGame(self.duration)

	--this should be randomized throughout the area
	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)
	self:SpawnUnit("chain_frost_game_lich", DOTA_TEAM_NEUTRALS, spawner, 1)
	for i=1,10 do
		self:SpawnUnit("chain_frost_game_penguin", DOTA_TEAM_NOTEAM, spawner, 1800)
	end
	--override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:IsRealHero() and killedUnit:GetUnitName() == "npc_dota_hero_terrorblade" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function ChainFrostGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end
	-- Because the penguins are NOTEAM and not NEUTRALS, we have to kill them here
	self:KillAllPenguins()

	self:DestroyVisionDummies()
	self:CleanUp()
end

function ChainFrostGame:KillAllPenguins()
	local penguins = FindUnitsInRadius(DOTA_TEAM_NOTEAM,
									   Vector(0,0,0), 
									   nil, 
									   2*4000^2, 
									   DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
									   DOTA_UNIT_TARGET_ALL, 
									   0, 
									   0, 
									   false)

	for _,v in pairs(penguins) do
		v:ForceKill(false)
		v:AddNoDraw()
	end
end