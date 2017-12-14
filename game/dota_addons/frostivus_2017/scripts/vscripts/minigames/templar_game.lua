require('minigames/minigame_base')

TemplarGame = MiniGame:new()

function TemplarGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("refraction_lua", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_fire_trap_ward", function(...) end)
	end
end

function TemplarGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_stage_center")
	self:SpawnVisionDummies(spawner)

	local leader = CreateUnitByName("npc_dota_fire_trap_ward", spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
	leader.target = Entities:FindByName(nil, "invoker_leader_ability_target"):GetAbsOrigin()
	leader:SetAngles(0, 270, 0)
	leader:FindAbilityByName("breathe_fire"):UpgradeAbility(true)
	local shooters = {}
	_G.GameMode:DoToAllHeroes(function(hero)
		local heroPosition = hero:GetAbsOrigin()
		local shooterPosition = heroPosition + Vector(0, 700, 0)
		local shooter = CreateUnitByName("npc_dota_fire_trap_ward", shooterPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
		shooter:FindAbilityByName("breathe_fire"):UpgradeAbility(true)
		shooter:SetAngles(0, 270, 0)
		shooter.target = heroPosition
		table.insert(shooters, shooter)
	end)
	
	Timers:CreateTimer(2,
    function()
		if not self.isRunning then return end

		for _,shooter in pairs(shooters) do
			local ability = shooter:FindAbilityByName("breathe_fire")
			shooter:CastAbilityOnPosition(shooter.target, ability, -1)
		end

		return RandomInt(1,3)
    end)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_templar_assassin" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function TemplarGame:GameEnd()
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end