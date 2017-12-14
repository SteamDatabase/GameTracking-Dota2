require('minigames/minigame_base')

NecroGame = MiniGame:new()

function NecroGame:Precache()
	if not self.precached then
		print("Precaching")
		self.precached = true
		PrecacheItemByNameAsync("item_rune_heal", function(...) end)
		PrecacheUnitByNameAsync("custom_necrophos", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_weather_dummy", function(...) end)
	end
end

function NecroGame:GameStart()
	self:InitializeGame(self.duration)
	
	local spawner = Entities:FindByName(nil, "snow_arena_center")
	-- self:SpawnUnit("custom_necrophos", DOTA_TEAM_NEUTRALS, spawner, 0)

	self.bot_left = Entities:FindByName(nil, "snow_arena_bottom_left"):GetAbsOrigin()
	self.top_right = Entities:FindByName(nil, "snow_arena_top_right"):GetAbsOrigin()

	self:SetMusicStatus(DOTA_MUSIC_STATUS_EXPLORATION, .5)
	self:StartWeatherEffect("particles/rain_fx/econ_snow.vpcf")

	local weatherDummy = self:SpawnUnit("npc_dota_weather_dummy", DOTA_TEAM_NEUTRALS, spawner, 0)
	local weatherAbility = weatherDummy:FindAbilityByName("weather_snowstorm")

	_G.GameMode:DoToAllHeroes(function(hero)
		hero:AddNewModifier(weatherDummy, weatherAbility, "modifier_weather_snowstorm", {} )
	end)

	local maxDistanceFromSpawner = 4500
	local delay = 0

	-- For some reason, I can't put these in a function or it will lose self.isRunning
	Timers:CreateTimer(function()
		if not self.isRunning then return end
		self:SpawnRuneUniform("item_rune_heal", duration)
		delay = delay + .5
		return RandomFloat(delay, delay + 1)
    end)

	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_queenofpain" then
			self:AddLoser(killedUnit:GetPlayerID())
		end
	end
end

function NecroGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end
	self:StartWeatherEffect("None")

	self:CleanUp()
end