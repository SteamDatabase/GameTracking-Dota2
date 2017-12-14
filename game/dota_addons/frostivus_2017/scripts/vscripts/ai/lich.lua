function Spawn()	
	Timers:CreateTimer(1,
      function()
        return thisEntity:AIThink()
      end)
end

function thisEntity:AIThink()
	if self:IsNull() then return end
	if not self:IsAlive() then
    	return
    end
	if GameRules:IsGamePaused() then
		return 0.1
	end
	
	thisEntity:CastChainFrost()
	return 30
end

function thisEntity:GetRandomTarget(acquisitionRange)
	local aggroTargets = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, acquisitionRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, 0, false)
	for _,target in pairs(aggroTargets) do
		return target
	end
	return nil
end

function thisEntity:CastChainFrost()
	-- print("Casting Chain Frost")
	local target = thisEntity:GetRandomTarget(2000)
	if not target then print("Could not find target for Chain Frost") return end
	local ability = thisEntity:FindAbilityByName("chain_frost_lua")
	thisEntity:CastAbilityOnTarget(target, ability, -1)
end