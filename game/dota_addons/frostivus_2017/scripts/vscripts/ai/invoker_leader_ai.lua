LinkLuaModifier("modifier_invoked_spell_to_cast", "heroes/invoker_leader.lua", LUA_MODIFIER_MOTION_NONE)

function Spawn()	
	thisEntity.target = Entities:FindByName(nil, "invoker_leader_ability_target"):GetAbsOrigin()
	thisEntity.invocationDelay = 5
	thisEntity.invocationDelayTable = {5,
									   5,
									   5,
									   4,
									   5, 2, 
									   4, 2, 
									   4, 2,
									   4, 2,
									   4, 2,
									   4, 2, 2, 
									   4, 2, 2,
									   4, 1, 1,
									   4, 2, 2, 2, 
									   4, 2, 2, 2, 
									   4, 2, 1, 1,
									   4, 1, 1, 1,
									   4, 1, 1, 1,
									   4, 1, 1, 1, 1,
									   4, 1, 1, 1, 1, 1,
									   4, 1, 1, 1, 1, 1, 1,
									   4, 1, 1, 1, 1, 1, 1, 1,
									   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	}

	Timers:CreateTimer(2,
      function()
        return thisEntity:AIThink()
      end)
end

function thisEntity:AIThink()
	if thisEntity:IsNull() then return end
	if ( not thisEntity:IsAlive() ) then
		return
	end

	-- Invoke and get a random ability
	local ability_invoke = thisEntity:FindAbilityByName("invoker_leader_invoke")
	thisEntity:CastAbilityNoTarget(ability_invoke, -1)

	-- Cast the ability, after we've invoked it
	Timers:CreateTimer(0.1, function()
		-- Get the ability we just invoked
		local abilityToCast = thisEntity.currentInvocation
		if not abilityToCast then
			print("AbilityToCast not found")
			return
		end
		local abilityToCastName = abilityToCast:GetAbilityName()
		local castPosition = thisEntity.target + RandomVector(100)

		if abilityToCastName == "invoker_leader_alacrity" then
			thisEntity:CastAbilityOnTarget(thisEntity, abilityToCast, -1)
		elseif abilityToCastName == "invoker_leader_forge_spirit" then
			thisEntity:CastAbilityNoTarget(abilityToCast, -1)
		else
			thisEntity:CastAbilityOnPosition(castPosition, abilityToCast, -1)
		end

		-- Add a modifier associated with the ability we just cast
		local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(),
	                                      thisEntity:GetAbsOrigin(),
	                                      nil,
	                                      5000, -- This is just a really big number to get everyone nearby
	                                      DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                      DOTA_UNIT_TARGET_HERO,
	                                      DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
	                                      FIND_ANY_ORDER,
	                                      false)
		for _,enemy in pairs(enemies) do
			local modifier = enemy:AddNewModifier(thisEntity, abilityToCast, "modifier_invoked_spell_to_cast", {duration = 4})
			-- trim off the "invoker_leader_" part
			local spellToCast = string.sub(abilityToCastName, 16, -1)
			modifier.spellToCast = spellToCast
		end
	end)

	return table.remove(thisEntity.invocationDelayTable, 1)
end