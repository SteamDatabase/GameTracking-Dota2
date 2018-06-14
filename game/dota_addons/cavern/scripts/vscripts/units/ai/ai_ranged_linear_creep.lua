require("units/ai/ai_cavern_shared")

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	LinearAttack = thisEntity:FindAbilityByName( "ranged_linear_creep_attack" )

	local fInitialDelay = RandomFloat( 0, 1.5 ) -- separating out the timing of all the ranged creeps' thinks

	thisEntity:SetContextThink( "RangedCreepThink", RangedCreepThink, fInitialDelay )
end

function RangedCreepThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )

	if hClosestPlayer then
		if hClosestPlayer ~= nil and LinearAttack ~= nil and LinearAttack:IsCooldownReady() then
			return Attack( hClosestPlayer )
		end

		thisEntity:FaceTowards( hClosestPlayer:GetOrigin() )

		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP,
		})
	end

	return 0.5
end

function Attack( unit )
	thisEntity.bMoving = false

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = LinearAttack:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})

	local fAttackCD = RandomFloat( 1.5, 3.0 )

	return fAttackCD
end
