
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	ChargeAbility = thisEntity:FindAbilityByName( "creature_spirit_breaker_charge_of_darkness" )

	thisEntity:SetContextThink( "SpiritBreakerChargerThink", SpiritBreakerChargerThink, 1 )
end

--------------------------------------------------------------------------------

function SpiritBreakerChargerThink()

	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn ~= nil then 
		return flEarlyReturn
	end

	local nAggroRange = 1000

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity, nAggroRange )

	if not hClosestPlayer or not ChargeAbility then
		return 1
	end

	bCharging = thisEntity:HasModifier("modifier_spirit_breaker_charge_of_darkness")

	if bCharging then
		local fDistance = ( thisEntity.hChargedTarget:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()
		if ( fDistance < thisEntity:GetAttackRange() ) then
			AttackOrder( thisUnit, hClosestPlayer )
		end
	else 	

		if ChargeAbility:IsChanneling() then
			return 0.5
		end

		if ChargeAbility:IsFullyCastable() then
			Charge( hClosestPlayer )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Charge( hUnit )
	--print( "Casting charge on " .. hUnit:GetUnitName() )

	thisEntity.hChargedTarget = hUnit

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = ChargeAbility:entindex(),
		TargetIndex = hUnit:entindex(),	
		Queue = false,
	})

	bCharging = true

	return 0.5
end

--------------------------------------------------------------------------------
