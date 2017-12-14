require('minigames/minigame_base')
LinkLuaModifier("modifier_stunned_lua", 'heroes/modifiers/modifier_stunned_lua', LUA_MODIFIER_MOTION_NONE)


ZuusRaceGame = MiniGame:new()

function ZuusRaceGame:Precache()
	if not self.precached then
		print("Precaching")
		self.precached = true
		PrecacheItemByNameAsync("lightning_bolt_lua", function(...) end)
		PrecacheUnitByNameAsync("zuus_race_stasis_trap", function(...) end)
		PrecacheUnitByNameAsync("zuus_race_land_mine", function(...) end)
	end
end

function ZuusRaceGame:GameStart()
	self:InitializeGame(self.duration)

	local vRaceLeft = Entities:FindByName(nil, "race_left_boundary"):GetAbsOrigin()
	local vRaceRight = Entities:FindByName(nil, "race_right_boundary"):GetAbsOrigin()
	local race_spawner_left = Entities:FindByName(nil, "race_spawner_left")
	local race_spawner_center = Entities:FindByName(nil, "race_spawner_center")
	local race_spawner_right = Entities:FindByName(nil, "race_spawner_right")

	self:SpawnVisionDummies(race_spawner_center)

	self.top_right = Entities:FindByName(nil, "race_top_right"):GetAbsOrigin()
	self.bot_left = Entities:FindByName(nil, "race_bot_left"):GetAbsOrigin()

	--local center = race_spawner_center:GetAbsOrigin()
	--self.fow_revealer = SpawnEntityFromTableSynchronous("ent_fow_revealer", {origin = center, visionrange = 2000, teamnumber = 0})

	local maxDistanceFromSpawner = 1000
	local respawnDelay = 5

	local numPlayers = TableCount(self.remainingTeams) 
	local numMines = 60

	for i=1,numMines do		
		self:SpawnUnitRandomUniform("zuus_race_land_mine", DOTA_TEAM_NEUTRALS)
	end
	for i=1,40 do
		self:SpawnUnitRandomUniform("zuus_race_stasis_trap", DOTA_TEAM_NEUTRALS)
	end

	-- Throw in some extra mines at the end to mess with people
	for i=1,10 do
		self:SpawnMine("zuus_race_land_mine", race_spawner_right, 1500, vRaceLeft, vRaceRight)
	end
	
	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_zuus" then
			---respawn at the start
			Timers:CreateTimer(respawnDelay, function()
				if not self.isRunning then return end
				killedUnit:RespawnHero(false, false)
				FindClearSpaceForUnit(killedUnit, killedUnit.spawnLocation, true)
			end)
		end
	end

	local numWinners = 0
	local numPlayers = GameRules.num_players

	-- When someone crosses the finish line
	Timers:CreateTimer(.1, function()
		if not self.isRunning then return end
		for _,hero in pairs(_G.GameMode.heroList) do
			if not hero.winner and hero:GetAbsOrigin().x > vRaceRight.x then
				self:AddWinner(hero:GetPlayerID())
				--move the winner to the right a bit and stun them while they wait
				--also might want to consider turn them so they face left
				local distance = 200
				local newPosition = hero:GetAbsOrigin() + Vector(distance,0,0)
				FindClearSpaceForUnit(hero, newPosition, true)
				hero:AddNewModifier(hero, nil, "modifier_stunned_lua", {})
				hero:AddNewModifier(hero, nil, "modifier_truesight_aura", {radius = 6000})
				hero.winner = true
				numWinners = numWinners + 1
				if numWinners == numPlayers - 1 then
					Timers:CreateTimer(3, function()
						if not self.isRunning then return end
						self:GameEnd()
					end)
				end
			end
		end
		return .03
	end)
end

function ZuusRaceGame:GameEnd()
	self.isRunning = false
	--restore the event function
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	for _,hero in pairs(_G.GameMode.heroList) do
		hero.winner = false
	end

	self:DestroyVisionDummies()
	self:CleanUp()
end

--overload this to make mines spawn more spread out
function ZuusRaceGame:SpawnMine(sUnitName, hSpawner, nMaxDistanceFromSpawner, vLeft, vRight)
	if hSpawner == nil then print("Spawner not found") end

	local vSpawnLoc = nil
	while vSpawnLoc == nil do
		vSpawnLoc = hSpawner:GetOrigin() + RandomVector( RandomFloat( 0, nMaxDistanceFromSpawner ) )
		local pathLength = GridNav:FindPathLength( hSpawner:GetOrigin(), vSpawnLoc )
	    if ( pathLength < 0 or vSpawnLoc.x < vLeft.x or vSpawnLoc.x > vRight.x) then	    	
	        --print( "Choosing new unit spawnloc.  Bad spawnloc was: " .. tostring( vSpawnLoc ) )
	        vSpawnLoc = nil
	    end
	end

	local unit = CreateUnitByName(sUnitName, vSpawnLoc, true, nil, nil, DOTA_TEAM_NEUTRALS)
	unit.hSpawner = hSpawner

	self:LevelAllAbilities(unit)

    return unit
end
