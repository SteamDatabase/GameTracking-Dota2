require('minigames/minigame_base')

EarthSpiritGame = MiniGame:new()

function EarthSpiritGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("earth_spirit_kick_lua", function(...) end)
		PrecacheUnitByNameAsync("earth_spirit_soccer_ball", function(...) end)
		PrecacheUnitByNameAsync("earth_spirit_soccer_goal", function(...) end)
	end
end

function EarthSpiritGame:GameStart()
	self:InitializeGame(self.duration)

	self.goalTable = {}

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")
	self:SpawnVisionDummies(spawner)

	_G.GameMode:DoToAllHeroes(function(hero)
		local goal = CreateUnitByName("earth_spirit_soccer_goal", hero:GetAbsOrigin(), true, nil, nil, hero:GetTeam())
		local renderColor = TEAM_COLORS[hero:GetTeam()]		
		goal:SetRenderColor(renderColor[1], renderColor[2], renderColor[3])

		table.insert(self.goalTable, goal)
		-- Check of the ball has come near the goal
		hero.goal = goal
		local goal_radius = goal:GetModelRadius() - 5
		local goal_center = hero:GetAbsOrigin()
		Timers:CreateTimer(.03, function()
			if not hero:IsAlive() then return end
			local enemies = FindUnitsInRadius(hero:GetTeamNumber(),
											  goal_center,
											  nil,
											  goal_radius, 
											  DOTA_UNIT_TARGET_TEAM_ENEMY, 
											  DOTA_UNIT_TARGET_BASIC, 
											  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 
											  0, 
											  false)
			for _,enemy in pairs(enemies) do
				if enemy:GetUnitName() == "earth_spirit_soccer_ball" then
					local damageTable = {victim = hero,
                                 		 attacker = enemy,
                                 		 damage = 1.5,
                                 		 damage_type = DAMAGE_TYPE_MAGICAL,}

            		ApplyDamage(damageTable)
				end
			end

			return .03
    	end)
	end)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_earth_spirit" then
			local goal = killedUnit.goal
			goal:ForceKill(false)
			goal:AddNoDraw()
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end

	local ball = self:SpawnUnit("earth_spirit_soccer_ball", DOTA_TEAM_NEUTRALS, spawner, 0)

	ball.velocity = Vector(0,0,0)
	ball.speed = 0

	local friction = .2

	Timers:CreateTimer(.03, function()
		if not self.isRunning then return end
		if GameRules:IsGamePaused() then
			return 0.1
		end
		--update soccer ball's location
		ball.speed = math.max(0, ball.speed - friction)
		local currentPos = ball:GetAbsOrigin()
		local nextPos = currentPos + ball.velocity * ball.speed
		local dir = nextPos - currentPos

		if not GridNav:IsTraversable(nextPos) or GridNav:IsBlocked(nextPos) then
			local newVelocity = -1 * ball.velocity
			local normal = EarthSpiritGame:GetNormalVector(currentPos)
			if normal then
				newVelocity = (-2 * (ball.velocity):Dot(normal) * normal) + ball.velocity
			end

			ball.velocity = newVelocity

			nextPos = currentPos + ball.velocity * ball.speed
		end

		--FindClearSpaceForUnit(ball, nextPos, false)
		ball:SetAbsOrigin(GetGroundPosition(nextPos, ball))

		-- Check if the ball went into a goal
		return .03
    end)
end

function EarthSpiritGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	for _,v in pairs(self.goalTable) do
		if not v:IsNull() and v then
			v:ForceKill(false)
			v:AddNoDraw()
		end
	end
	self:DestroyVisionDummies()
	self:CleanUp()
end

function EarthSpiritGame:GetNormalVector(currentPos)
	-- Return nil at a corner so it defaults to just bouncing back in the direction it came from
	-- Yeah this awful, but in my defense, fuck physics, I'm just trying to make a fucking minigame
	local normal

	local navPos2 = currentPos + Vector(-64,0,0)
	if not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2) then
		normal = Vector(-1,0,0)
	end
	navPos2 = currentPos + Vector(64,0,0)
	if not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2) then
		if normal then return nil end
		normal = Vector(1,0,0)
	end
	navPos2 = currentPos + Vector(0,-64,0)
	if not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2) then
		if normal then return nil end
		normal = Vector(0,-1,0)
	end
	navPos2 = currentPos + Vector(0,64,0)
	if not GridNav:IsTraversable(navPos2) or GridNav:IsBlocked(navPos2) then
		if normal then return nil end
		normal = Vector(0,1,0)
	end
  
  return normal
end