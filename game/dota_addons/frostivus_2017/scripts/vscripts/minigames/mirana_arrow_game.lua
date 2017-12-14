require('minigames/minigame_base')
LinkLuaModifier("modifier_hidden_lua", 'heroes/modifiers/modifier_hidden_lua', LUA_MODIFIER_MOTION_NONE)

MiranaArrowGame = MiniGame:new()

function MiranaArrowGame:Precache()
	if not self.precached then
		print("Precaching")
		self.precached = true
		PrecacheItemByNameAsync("mirana_arrow_lua", function(...) end)
		PrecacheUnitByNameAsync("chain_frost_game_penguin", function(...) end)
		PrecacheUnitByNameAsync("mirana_game_bell", function(...) end)
	end
end

function MiranaArrowGame:GameStart()
	self:InitializeGame(self.duration)

	local vBoundaryNorth = Entities:FindByName(nil, "snow_long_top"):GetAbsOrigin()
	local vBoundarySouth = Entities:FindByName(nil, "snow_long_bottom"):GetAbsOrigin()

	local spawners1 = Entities:FindAllByName("snow_long_spawner1")
	local spawners2 = Entities:FindAllByName("snow_long_spawner2")

	self:SpawnVisionDummies(Entities:FindByName(nil, "snow_long_spawner1"))

	local maxDistanceFromSpawner = 600

	for _,spawner in pairs(spawners1) do
		for i=1,3 do		
			local unit = self:SpawnUnit("chain_frost_game_penguin", DOTA_TEAM_NEUTRALS, spawner, maxDistanceFromSpawner)
			unit:SetBaseMaxHealth(5)
			unit:SetMaxHealth(5)
			unit:SetHealth(5)
		end
	end

	for _,spawner in pairs(spawners2) do
		for i=1,3 do		
			local unit = self:SpawnUnit("chain_frost_game_penguin", DOTA_TEAM_NEUTRALS, spawner, maxDistanceFromSpawner)
			unit:SetBaseMaxHealth(3)
			unit:SetMaxHealth(3)
			unit:SetHealth(3)
		end
	end

	local bells = Entities:FindAllByName("bell_center")

	for _,spawner in pairs(bells) do
		local unit = self:SpawnUnit("mirana_game_bell", DOTA_TEAM_NEUTRALS, spawner, 0)
		unit:SetAngles(0, 90, 0)
	end

	local numWinners = 0
	local numPlayers = GameRules.num_players

	_G.GameMode.OnEntityHurt = function (empty, keys)
		if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
			local attacker = EntIndexToHScript(keys.entindex_attacker)
			local hurtUnit = EntIndexToHScript(keys.entindex_killed)
			local sound = "Visage_Familar.BellToll"

			if hurtUnit:GetUnitName() == "mirana_game_bell" then
				EmitGlobalSound(sound)
				EmitSoundOn(sound, hurtUnit)
				attacker:AddNewModifier(attacker, nil, "modifier_hidden_lua", {})
				attacker:AddNoDraw()
				if attacker:IsRealHero() then
					self:AddWinner(attacker:GetPlayerID())
					numWinners = numWinners + 1
					if numWinners == numPlayers - 1 then
						Timers:CreateTimer(3, function()
							if not self.isRunning then return end
							self:GameEnd()
						end)
					end
				end
			end
		end
	end
end

function MiranaArrowGame:GameEnd()
	self.isRunning = false

	_G.GameMode.OnEntityHurt = function(empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end