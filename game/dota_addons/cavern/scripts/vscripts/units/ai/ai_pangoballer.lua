
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	BallAbility = thisEntity:FindAbilityByName( "creature_pangoballer_gyroshell" )
	StopBallAbility = thisEntity:FindAbilityByName( "pangolier_gyroshell_stop" )

	thisEntity:SetContextThink( "PangoballerThink", PangoballerThink, 1 )
end

--------------------------------------------------------------------------------

function PangoballerThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local nAggroRange = 1000
	local bRolling = thisEntity:FindModifierByName( "modifier_pangolier_gyroshell" ) 

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity, nAggroRange )

	if not hClosestPlayer or not BallAbility then
		if bRolling then
			--Stop()
		end
		return 1
	end

	if not bRolling then
		CastBallAbility()
	else
		SteerTowards( hClosestPlayer )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastBallAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = BallAbility:entindex(),
	})

	return 0.5
end

--------------------------------------------------------------------------------

function SteerTowards( hClosestPlayer )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hClosestPlayer:GetOrigin() + RandomVector( 75 )
	})

	return 0.5
end

--------------------------------------------------------------------------------

function Stop()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = StopBallAbility:entindex(),
	})

	return 0.5
end