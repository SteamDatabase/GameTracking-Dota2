require('minigames/minigame_base')

AntimageGame = MiniGame:new()

function AntimageGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheUnitByNameAsync("custom_invoker_antimage_game", function(...) end)
		PrecacheItemByNameAsync("custom_antimage_blink", function(...) end)
	end
end

function AntimageGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_tiny_center")
	self:SpawnVisionDummies(spawner)

	local IDLE = 0
	local TORNADO = 1
	local DEAFENING_BLAST = 2
	local TORNADO_DEAFENING = 3
	local SUNSTRIKE = 4
	local CHAOS_METEOR = 5
	local SUNSTRIKE_CHAOS_METEOR = 6
	local ROTATE_TORNADO = 7
	local ROTATE_TORNADO_DEAFENING = 8

	local TORNADO_SUNSTRIKE = 10
	local DEAFENING_METEOR = 11
	local EVERYTHING = 12

	local NORTH = 0
	local EAST  = 1
	local SOUTH = 2
	local WEST  = 3

	local directions = {NORTH, EAST, SOUTH, WEST}
	local directionBucket = {}

	local invoker = self:SpawnUnit("custom_invoker_antimage_game", nil, Entities:FindByName(nil, "invoker_spawn_north"), 0)
	invoker.castRate = 1.6

	local rotateDelay = 9

	-- Time some sounds and state changes
	Timers:CreateTimer(0, function()
		EmitGlobalSound("invoker_invo_attack_10")
		Timers:CreateTimer(3, function()
			invoker.state = DEAFENING_BLAST
			Timers:CreateTimer(8, function()
				invoker.castRate = math.max(invoker.castRate - .05, .5)
				invoker.cardinality = PickRandomShuffle(directions, directionBucket)
				rotateDelay = math.max(rotateDelay - .3, 3)

				return rotateDelay
			end)
		end)
	end)

	-- Set people who fall into the lava on fire
	Timers:CreateTimer(0, function()
		if not self.isRunning then return end
		_G.GameMode:DoToAllHeroes(function(hero)
			if hero:GetAbsOrigin().z <= 10 then
				hero:ForceKill(false)
			end
		end)
		return .1
    end)	
	
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:IsRealHero() then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function AntimageGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end