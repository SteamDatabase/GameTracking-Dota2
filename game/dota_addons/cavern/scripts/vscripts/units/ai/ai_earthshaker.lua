
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hFissureAbility = thisEntity:FindAbilityByName( "creature_earthshaker_fissure" )
	hTotemAbility = thisEntity:FindAbilityByName( "creature_earthshaker_enchant_totem" )
	hEchoSlamAbility = thisEntity:FindAbilityByName( "creature_earthshaker_echo_slam" )

	thisEntity:SetContextThink( "EarthshakerThink", EarthshakerThink, 1 )
end

--------------------------------------------------------------------------------

function EarthshakerThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )
	if hClosestPlayer == nil then
		return 0.5
	end

	if hEchoSlamAbility and hEchoSlamAbility:IsCooldownReady() then
		local nSearchRange = hEchoSlamAbility:GetSpecialValueFor( "echo_slam_damage_range" ) - 300
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies > 2 then
			CastEchoSlamAbility()

			return 2.5
		end
	end

	if hFissureAbility and hFissureAbility:IsCooldownReady() then
		local nSearchRange = hFissureAbility:GetCastRange() - 100
		local hFarthestPlayer = GetFarthestPlayerInRoomOrReturnToSpawn( thisEntity, nSearchRange )

		if hFarthestPlayer and hFarthestPlayer:IsAlive() then
			CastFissureAbility( hFarthestPlayer:GetAbsOrigin() )

			return 1.5
		end
	end

	if hTotemAbility and hTotemAbility:IsCooldownReady() then
		local nSearchRange = hTotemAbility:GetCastRange() - 100

		local nSearchRange = hTotemAbility:GetCastRange() - 100
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, hEnemy in pairs( hEnemies ) do
			if hEnemy and hEnemy:IsAlive() then
				local vTargetPos = hEnemy:GetAbsOrigin() + ( hEnemy:GetForwardVector() * 150 )
				CastTotemAbility( vTargetPos )

				return 1.0
			end
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastFissureAbility( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hFissureAbility:entindex(),
		Position = vPos,
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CastTotemAbility( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hTotemAbility:entindex(),
		Position = vPos,
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CastEchoSlamAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hEchoSlamAbility:entindex()
	})
end

--------------------------------------------------------------------------------
