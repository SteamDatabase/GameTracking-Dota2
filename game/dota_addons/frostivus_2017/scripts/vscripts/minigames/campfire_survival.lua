require('minigames/minigame_base')

CampfireSurvivalGame = MiniGame:new()

function CampfireSurvivalGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("custom_cold_feet", function(...) end)
		PrecacheItemByNameAsync("custom_ice_vortex", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_weather_dummy", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_campfire", function(...) end)
	end
end

function CampfireSurvivalGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_large_center")
	self.bot_left = Entities:FindByName(nil, "snow_large_bottom_left"):GetAbsOrigin()
	self.top_right = Entities:FindByName(nil, "snow_large_top_right"):GetAbsOrigin()

	local weatherDummy = self:SpawnUnit("npc_dota_weather_dummy", DOTA_TEAM_NEUTRALS, spawner, 0)
	local weatherAbility = weatherDummy:FindAbilityByName("weather_snowstorm")

	-- Set time of day to midnight
	GameRules:SetTimeOfDay(0)

	_G.GameMode:DoToAllHeroes(function(hero)
		hero:AddNewModifier(weatherDummy, weatherAbility, "modifier_weather_snowstorm", {} )
		local player = hero:GetPlayerOwner()
		if player then
        	player:SetMusicStatus(DOTA_MUSIC_STATUS_EXPLORATION, 1)
        end
	end)

	local spawnDelay = 1
	Timers:CreateTimer(0,
    function()
		if not self.isRunning then return end
		self:SpawnUnitRandomUniform("npc_dota_campfire")
		spawnDelay = spawnDelay + .5
		return RandomFloat(1, spawnDelay)
    end)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_ancient_apparition" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function CampfireSurvivalGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end
	GameRules:SetTimeOfDay(1)

	self:CleanUp()
end