--[[ Gaoler AI ]]

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SmashAbility = thisEntity:FindAbilityByName( "gaoler_melee_smash" )
	ShockAbility = thisEntity:FindAbilityByName( "gaoler_shock" )
	thisEntity.bPatrolled = false
	thisEntity:SetInitialGoalEntity( nil )
	thisEntity:SetContextThink( "GaolerThink", GaolerThink, 1 )
end

--------------------------------------------------------------------------------------------------------

function GaolerThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:IsChanneling() then
		return 1
	end

	local nEnemiesRemoved = 0
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		if thisEntity.bPatrolled == false then
			thisEntity.bPatrolled = true
			return Patrol()
		end
		return 0.5
	end

	thisEntity:SetInitialGoalEntity( nil )

	for i = 1, #enemies do
		local enemy = enemies[i]
		if enemy ~= nil then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 300 then
				nEnemiesRemoved = nEnemiesRemoved + 1
				table.remove( enemies, i )
			end
		end
	end


	if ShockAbility ~= nil and ShockAbility:IsFullyCastable() and nEnemiesRemoved > 0 then
		return Shock()
	end

	if #enemies == 0 then
		return 1
	end

	if SmashAbility ~= nil and SmashAbility:IsFullyCastable() then
		return Smash( enemies[ 1 ] )
	end
	
	return 0.5
end

--------------------------------------------------------------------------------------------------------

function Shock()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ShockAbility:entindex(),
		Queue = false,
	})
	
	return 5.0
end

--------------------------------------------------------------------------------------------------------

function Smash( enemy )
	if enemy == nil then
		return
	end

	
	if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
		--print( "If player can't see me, provide brief vision to his team as I start my Smash" )
		thisEntity:AddNewModifier( enemy, nil, "modifier_provide_vision", { duration = 1.5 } )
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = SmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 3.0
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

--------------------------------------------------------------------------------------------------------
