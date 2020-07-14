
require("ai/shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() == false then
		return
	end

	--printf( "thisEntity:GetUnitName() == %s", thisEntity:GetUnitName() )

	thisEntity.hSwingAbility = thisEntity:FindAbilityByName( "pendulum_swing" )
	thisEntity:SetContextThink( "PendulumTrapThink", PendulumTrapThink, RandomFloat( 0.1, 1.0 ) )
end

--------------------------------------------------------------------------------

function PendulumTrapThink()
	if IsServer() then
		local enemies = GetEnemyHeroesInRange( thisEntity, 2048 ) -- will need to search just in room
		if not enemies or #enemies == 0 then
			--print( "no enemies" )
			thisEntity:InterruptChannel()
			return RandomFloat( 0.1, 1.0 )
		end

		if not thisEntity:IsChanneling() then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = thisEntity.hSwingAbility:entindex(),
				Queue = false,
			})
		end
	end

	return 1
end

--------------------------------------------------------------------------------
