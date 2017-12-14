require('minigames/minigame_base')

SuicidalPudgeGame = MiniGame:new()

function SuicidalPudgeGame:Precache()
	if not self.precached then
		print("Precaching")
		self.precached = true
		PrecacheItemByNameAsync("custom_frostbite", function(...) end)
		PrecacheItemByNameAsync("pudge_rot_lua", function(...) end)
		PrecacheUnitByNameAsync("suicidal_pudge", function(...) end)		
	end
end

function SuicidalPudgeGame:GameStart()
	self:InitializeGame(self.duration)

	--this should be randomized throughout the area
	local center = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(center)

	local spawnerList = {
		center,
		Entities:FindByName(nil, "snow_small_top_right"),
		Entities:FindByName(nil, "snow_small_bot_left"),
		Entities:FindByName(nil, "snow_small_bot_right"),
		Entities:FindByName(nil, "snow_small_top_left"),
	}

	local maxDistanceFromSpawner = 500
	local minDelay = 8.0
	Timers:CreateTimer(1,
    function()
		if not self.isRunning then return end
		local spawner = GetRandomTableElement(spawnerList)
		local unit = self:SpawnUnit("suicidal_pudge", DOTA_TEAM_NEUTRALS, spawner, maxDistanceFromSpawner)
		minDelay = math.max(minDelay - .5, 2)
		return RandomFloat(minDelay, minDelay + 2)
    end)
    
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_crystal_maiden" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function SuicidalPudgeGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end
	self:DestroyVisionDummies()
	self:CleanUp()
end