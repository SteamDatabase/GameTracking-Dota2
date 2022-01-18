
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hFlop = thisEntity:FindAbilityByName( "ogreseal_flop" )
	thisEntity.flSearchRadius = 700
	thisEntity.bPatrolled = false

	thisEntity:SetContextThink( "OgreSealThink", OgreSealThink, 0.5 )
end

--------------------------------------------------------------------------------

function OgreSealThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.flSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		if thisEntity.bPatrolled == false then
			thisEntity.bPatrolled = true
			return Patrol()
		end
		return 0.5
	end

	if thisEntity.hFlop ~= nil and thisEntity.hFlop:IsFullyCastable() then
		return CastBellyFlop( hEnemies[ #hEnemies ] )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastBellyFlop( enemy )
	local vToTarget = enemy:GetOrigin() - thisEntity:GetOrigin()
	vToTarget = vToTarget:Normalized()
	local vTargetPos = thisEntity:GetOrigin() + vToTarget * 50

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hFlop:entindex(),
		Position = vTargetPos,
		Queue = false,
	})

	return 4
end

--------------------------------------------------------------------------------------------------------

function Patrol()
	if thisEntity:GetInitialGoalEntity() == nil then
		local hWaypoint = Entities:FindByClassnameNearest( "path_track", thisEntity:GetOrigin(), 2000.0 )
		if hWaypoint ~= nil then
			--print( "Patrolling to " .. hWaypoint:GetName() )
			thisEntity:SetInitialGoalEntity( hWaypoint )
		end
	end

	return 1.0
end

--------------------------------------------------------------------------------
