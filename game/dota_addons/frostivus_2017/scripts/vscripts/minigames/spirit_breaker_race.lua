require('minigames/minigame_base')
-- LinkLuaModifier("modifier_stunned_lua", 'heroes/modifiers/modifier_stunned_lua', LUA_MODIFIER_MOTION_NONE)

SpiritBreakerRaceGame = MiniGame:new()

function SpiritBreakerRaceGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("race_charge_lua", function(...) end)
	end
end

function SpiritBreakerRaceGame:GameStart()
	self:InitializeGame(self.duration)

	local vRaceRight = Entities:FindByName(nil, "race_lanes_right_boundary"):GetAbsOrigin()

	local race_spawner_center = Entities:FindByName(nil, "race_lanes_center")
	self:SpawnVisionDummies(race_spawner_center)

	local chargeParticleThreshold = 8
	local speedRatio = 5

	-- Initialize the heroes
	GameMode:DoToAllHeroes(function(hero)
		hero:SetAngles(0, 0, 0)
		hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
		PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
		hero.speed = 0
		hero.target = hero:GetAbsOrigin()
	end)

	local numWinners = 0
	local numPlayers = GameRules.num_players

	-- Update the heroes position every frame
	GameMode:DoToAllHeroes(function(hero)	
		Timers:CreateTimer(.03, function()
			if not self.isRunning then return end
			if GameRules:IsGamePaused() then
				return 0.1
			end

			if not hero.winner then
				hero.speed = (hero.target - hero:GetAbsOrigin()):Length2D() / speedRatio
				-- Update the animation
				if not hero.running and hero.speed > 0 then
			    	hero:StartGesture(ACT_DOTA_RUN)
			    	-- caster:StartGestureWithPlaybackRate( ACT_DOTA_RUN, 2 )
			    	hero.running = true
			    elseif hero.running and hero.speed == 0 then
			    	hero:StartGesture(ACT_DOTA_IDLE)
			    	hero.running = false
			    end

			    -- Add the charge particle if they're going fast enough
				if hero.speed > chargeParticleThreshold and not hero.chargeParticle then
					local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
					hero.chargeParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hero)
				else
					if hero.chargeParticle then
						ParticleManager:DestroyParticle(hero.chargeParticle, false)
						hero.chargeParticle = nil
					end
				end

				-- Move the hero right according to their speed
				local nextPos = hero:GetAbsOrigin() + Vector(hero.speed, 0, 0)
				hero:SetAbsOrigin(GetGroundPosition(nextPos, ball))

				-- Check to see if we've crossed the finish line
				if hero:GetAbsOrigin().x > vRaceRight.x then
					self:AddWinner(hero:GetPlayerID())
					local distance = 200
					local newPosition = hero:GetAbsOrigin() + Vector(distance,0,0)
					FindClearSpaceForUnit(hero, newPosition, true)
					hero:AddNewModifier(hero, nil, "modifier_stunned_lua", {})
					hero.winner = true
					hero.speed = 0
					PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)
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
	end)
end

function SpiritBreakerRaceGame:GameEnd()
	self.isRunning = false

	for _,hero in pairs(_G.GameMode.heroList) do
		hero.winner = false
	end

	self:DestroyVisionDummies()
	self:CleanUp()
end