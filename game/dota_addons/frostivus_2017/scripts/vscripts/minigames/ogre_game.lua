require('minigames/minigame_base')

OgreGame = MiniGame:new()

function OgreGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("custom_puck_phase_shift", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_creature_ogre_tank", function(...) end)	
	end
end

function OgreGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_small_spawner_center")

	self:SpawnUnit("npc_dota_creature_ogre_tank", DOTA_TEAM_NEUTRALS, spawner, 0)
	self:SpawnVisionDummies(spawner)

	local delay = 15.0
	local hasteFactor = 1
	Timers:CreateTimer(delay,
    function()
		if not self.isRunning then return end
		local unit = self:SpawnUnit("npc_dota_creature_ogre_tank", DOTA_TEAM_NEUTRALS, spawner, 0)		
		unit.hasteFactor = hasteFactor
		unit:SetBaseMoveSpeed(unit:GetBaseMoveSpeed() * hasteFactor)

		hasteFactor = hasteFactor + .5
		return delay
    end)
	-- Override event function here
	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_puck" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function OgreGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end