
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	thisEntity.hFishAttack = thisEntity:FindAbilityByName( "diregull_fish_attack" )
	if thisEntity.hFishAttack == nil then
		print( "Ability not found!" )
	end
	thisEntity.bPatrolled = false
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_phased", { duration = -1 } )

	thisEntity:SetContextThink( "DiregullThink", DiregullThink, 1 )
end

--------------------------------------------------------------------------------

function DiregullThink()
	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false
	)

	if #hEnemies == 0 then
		if thisEntity.bPatrolled == false then
			thisEntity.bPatrolled = true
			return Patrol()
		end
	end

	-- Fish Attack
	if thisEntity.hFishAttack and thisEntity.hFishAttack:IsFullyCastable() then
		-- Find enemy to target
		--print( "Found Fish Attack Ability" )
		local target = hEnemies[#hEnemies]
		if target ~= nil then
			local targetPoint = target:GetOrigin() + RandomVector( 100 )
			return CastFishAttack( targetPoint )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastFishAttack( vPos )
	--print( "Casting Fish Attack" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPos,
		AbilityIndex = thisEntity.hFishAttack:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function RunAway()
	--print( "Run Away" )
	local vRunTargetPos = nil
	local pullTargets = Entities:FindAllByName( "retreat_target" )
	if pullTargets ~= nil then
		--print( "Found pull target" )
		local hPullTarget = pullTargets[ RandomInt(1,2) ]
		vRunTargetPos = hPullTarget:GetAbsOrigin()
	else
		return Patrol()
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vRunTargetPos,
		Queue = true,
	})

	return 1
end

--------------------------------------------------------------------------------------------------------

function Patrol()
	if thisEntity:GetInitialGoalEntity() == nil then
		--local hWaypoint = Entities:FindByClassnameNearest( "path_track", thisEntity:GetOrigin(), 2000.0 )
		local EntityNames = 
			{
				"diregull_patrol_a_1",
				"diregull_patrol_b_1",
				"diregull_patrol_c_1",
			}	
		local nRandom = RandomInt(1,3)
		local szEntityName = EntityNames[nRandom]
		local hWaypoint = Entities:FindByName( nil, szEntityName )
		if hWaypoint ~= nil then
			--print( "Patrolling to " .. hWaypoint:GetName() )
			thisEntity:SetInitialGoalEntity( hWaypoint )
		end
	end

	return 1.0
end

--------------------------------------------------------------------------------
