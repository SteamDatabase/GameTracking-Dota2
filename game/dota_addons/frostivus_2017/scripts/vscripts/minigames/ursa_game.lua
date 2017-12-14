require('minigames/minigame_base')

UrsaGame = MiniGame:new()

function UrsaGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("custom_overpower", function(...) end)
		PrecacheItemByNameAsync("custom_fury_swipes", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_creature_ogre_tank_boss", function(...) end)
	end
end

function UrsaGame:GameStart()
	self:InitializeGame(self.duration)
	self:InitializeHighScoreGame()

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)

	local boss = self:SpawnUnit("npc_dota_creature_ogre_tank_boss", DOTA_TEAM_NEUTRALS, spawner, 0)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_ursa" then
			-- If everyone is dead, end the round
			local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,
                                      		 boss:GetAbsOrigin(),
                                      		 nil,
                                      		 5000,
                                      		 DOTA_UNIT_TARGET_TEAM_ENEMY,
                                      		 DOTA_UNIT_TARGET_HERO,
                                      		 DOTA_UNIT_TARGET_FLAG_NONE,
                                      		 FIND_ANY_ORDER,
                                      		 false)
			if #enemies == 0 then
				self:GameEnd()
			end
		end
	end

	_G.GameMode.OnEntityHurt = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
			local entCause = EntIndexToHScript(keys.entindex_attacker)
			local entVictim = EntIndexToHScript(keys.entindex_killed)
			if entVictim:GetUnitName() == "npc_dota_creature_ogre_tank_boss" then
				local team = entCause:GetTeam()
				self:AddHighScoreForPlayer(team, keys.damage)
			end
		end
	end
end

function UrsaGame:GameEnd()
	-- Restore the event function
	_G.GameMode.OnEntityKilled = function (empty, keys) end
	_G.GameMode.OnEntityHurt   = function (empty, keys) end

	self:DestroyVisionDummies()
	self:HighScoreGameEndGame()
end