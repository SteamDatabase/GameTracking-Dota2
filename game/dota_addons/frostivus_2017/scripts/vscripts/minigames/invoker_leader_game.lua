require('minigames/minigame_base')

InvokerLeaderGame = MiniGame:new()

function InvokerLeaderGame:Precache()
	if not self.precached then
		self.precached = true
		PrecacheItemByNameAsync("invoker_quas_lua", function(...) end)
		PrecacheItemByNameAsync("invoker_wex_lua", function(...) end)
		PrecacheItemByNameAsync("invoker_exort_lua", function(...) end)
		PrecacheItemByNameAsync("invoker_invoke_lua", function(...) end)

		PrecacheUnitByNameAsync("custom_invoker", function(...) end)
		
		PrecacheItemByNameAsync("invoker_leader_deafening_blast", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_tornado", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_sunstrike", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_chaos_meteor", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_ice_wall", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_emp", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_alacrity", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_forge_spirit", function(...) end)
		PrecacheItemByNameAsync("invoker_leader_cold_snap", function(...) end)
		-- PrecacheItemByNameAsync("invoker_leader_ghost_walk", function(...) end)
	end
end

function InvokerLeaderGame:GameStart()
	self:InitializeGame(self.duration)

	local spawner = Entities:FindByName(nil, "snow_stage_center")
	self:SpawnVisionDummies(spawner)

	self:SpawnUnit("custom_invoker", nil, spawner, 0)

	Timers:CreateTimer(1,
    function()
		if not self.isRunning then return end
    end)

	_G.GameMode.OnEntityKilled = function (empty, keys)
		local killedUnit = EntIndexToHScript( keys.entindex_killed )
		if killedUnit:GetUnitName() == "npc_dota_hero_invoker" then
			self:AddLoser(killedUnit:GetPlayerID())
			self:CheckForLoneSurvivor()
		end
	end
end

function InvokerLeaderGame:GameEnd()
	-- Restore the event function
	_G.GameMode.OnEntityKilled = function (empty, keys) end

	self:DestroyVisionDummies()
	self:CleanUp()
end