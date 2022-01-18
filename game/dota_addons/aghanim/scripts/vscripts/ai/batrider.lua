
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	thisEntity.nArrivedAtRunPosRange = 200

	thisEntity.hFlameBreakAbility = thisEntity:FindAbilityByName( "aghslab_batrider_flamebreak" )
	thisEntity.hFirefly = thisEntity:FindAbilityByName( "batrider_firefly" )
	thisEntity.hLassoAbility = thisEntity:FindAbilityByName( "batrider_flaming_lasso" )


	thisEntity.bPatrolled = false
	thisEntity.flLassoDelayTime = GameRules:GetGameTime() + RandomFloat( 4, 8 )	-- need to live for this long before we can think about casting lasso

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_phased", { duration = -1 } )

	thisEntity:SetContextThink( "BatriderThink", BatriderThink, 1 )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( "particle", "particles/creatures/catapult/catapult_projectile.vpcf", context )
end

--------------------------------------------------------------------------------

function BatriderThink()
	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	-- This script was being broken by SetInitialGoalEntity in the encounter's OnSpawnerFinished
	if not thisEntity.bGoalEntCleared then
		thisEntity:SetInitialGoalEntity( nil )
		thisEntity.bGoalEntCleared = true
	end

	if thisEntity:HasModifier( "modifier_batrider_flaming_lasso_self" ) then
		--print( "Batrider has lasso victim" )
		
		if thisEntity.vRunTargetPos ~= nil then
			local flDist = ( thisEntity.vRunTargetPos - thisEntity:GetAbsOrigin() ):Length2D()
			--print( 'DISTANCE FROM RUN POS = ' .. flDist )
			if flDist < thisEntity.nArrivedAtRunPosRange then
				--print( 'MADE IT TO RUN POS! SEARCHING FOR ANOTHER!' )
				thisEntity.vRunTargetPos = nil -- clear run pos - RunAway() will scoop a new one
			end
			return RunAway()
		end

		return RunAway()
	else
		-- not lassoing
		thisEntity.vRunTargetPos = nil
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false
	)

	if #hEnemies == 0 then
		if thisEntity.bPatrolled == false then
			thisEntity.bPatrolled = true
			return Patrol()
		end
		return 0.5
	end

	-- Flame Break
	if thisEntity.hFlameBreakAbility and thisEntity.hFlameBreakAbility:IsFullyCastable() then
		-- Find enemy to target
		local target = hEnemies[#hEnemies]
		if target ~= nil then
			local targetPoint = target:GetOrigin() + RandomVector( 100 )
			return CastFlameBreak( targetPoint )
		end
	end

	-- Try to Lasso
	local bLassoReady = false
	if GameRules:GetGameTime() > thisEntity.flLassoDelayTime and thisEntity.hLassoAbility ~= nil and thisEntity.hLassoAbility:IsFullyCastable() then
		--print( 'Lasso ready' )
		bLassoReady = true
	end	

	if thisEntity.hLassoAbility and thisEntity.hLassoAbility:IsFullyCastable() and bLassoReady then
		for _, hEnemy in pairs( hEnemies ) do
			if hEnemy ~= nil and hEnemy:IsRealHero() and hEnemy:IsAlive() and ( not hEnemy:HasModifier( "modifier_batrider_flaming_lasso" ) ) then
				-- Ensure I have vision
				local hVisionBuff = hEnemy:FindModifierByName( "modifier_provide_vision" )
				if hVisionBuff == nil then
					hVisionBuff = hEnemy:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 15 } )
				end
				-- Firefly
				if thisEntity.hFirefly and thisEntity.hFirefly:IsFullyCastable() then
					CastFirefly()
				end
				return CastLasso( hEnemy )
			end
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastFlameBreak( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPos,
		AbilityIndex = thisEntity.hFlameBreakAbility:entindex(),
		Queue = false,
	})

	local fReturnTime = thisEntity.hFlameBreakAbility:GetCastPoint() + 0.2
	return fReturnTime
end

--------------------------------------------------------------------------------

function CastFirefly()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hFirefly:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CastLasso( unit )
	--print( "Casting Lasso" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = unit:entindex(),
		AbilityIndex = thisEntity.hLassoAbility:entindex(),
		Queue = false,
	})

	return thisEntity.hLassoAbility:GetCastPoint() + 0.2
end

--------------------------------------------------------------------------------

function RunAway()
	--print( "Run Away" )

	-- continue running to the destination if we have one
	if thisEntity.vRunTargetPos ~= nil then
		--print( 'CONTINUE TO RUN TOWARDS POSITION!' )
		thisEntity:SetInitialGoalEntity( nil )
		--DebugDrawSphere( thisEntity.vRunTargetPos, Vector( 255, 255, 0 ), 1.0, 50, false, 1.25 )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = thisEntity.vRunTargetPos,
			Queue = true,
		})
		return 1
	end

	local vRunTargetPos = nil
	local pullTargets = Entities:FindAllByName( "batrider_retreat_target" )
	if pullTargets ~= nil and #pullTargets > 0 then
		--print( "FOUND RETREAT TARGET" )
		local hPullTarget = pullTargets[ RandomInt(1,#pullTargets) ]
		thisEntity.vRunTargetPos = hPullTarget:GetAbsOrigin()
		--DebugDrawSphere( thisEntity.vRunTargetPos, Vector( 255, 255, 0 ), 1.0, 50, false, 1.25 )
		thisEntity:SetInitialGoalEntity( nil )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = thisEntity.vRunTargetPos,
			Queue = true,
		})
	else
		--print( 'ERROR - NO RETREAT TARGETS FOUND!' )
		return Patrol()
	end

	return 1
end

--------------------------------------------------------------------------------------------------------

function Patrol()
	if thisEntity:GetInitialGoalEntity() == nil then
		--local hWaypoint = Entities:FindByClassnameNearest( "path_track", thisEntity:GetOrigin(), 2000.0 )
		local EntityNames = 
			{
				"batrider_patrol_a_1",
				"batrider_patrol_b_1",
				"batrider_patrol_c_1",
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
