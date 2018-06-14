require("units/ai/ai_cavern_shared")

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	PendulumTrap = thisEntity:FindAbilityByName( "pendulum_trap" )

	thisEntity:SetContextThink( "PendulumTrapThink", PendulumTrapThink, RandomFloat( 0.1, 1.0 ) )
end

function PendulumTrapThink()
	if IsServer() then
		local flEarlyReturn = InitialRoomMobLogic( thisEntity )
		if flEarlyReturn == nil then
			return nil
		elseif flEarlyReturn > 0 then
			return flEarlyReturn
		end

		local enemies = GetEnemyHeroesInRoom( thisEntity )
		if not enemies or #enemies == 0 then
			--print( "no enemies" )
			thisEntity:InterruptChannel()
			return RandomFloat( 0.1, 1.0 )
		end
		
		if not thisEntity:IsChanneling() then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = PendulumTrap:entindex(),
				Queue = false,
			})
		end
	end
	return 1
end