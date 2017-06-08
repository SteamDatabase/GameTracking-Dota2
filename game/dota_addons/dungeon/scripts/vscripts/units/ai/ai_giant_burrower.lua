
----------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.GIANT_BURROWER_SUMMONED_UNITS = { }
		thisEntity.GIANT_BURROWER_MAX_SUMMONS = 20

		hImpaleAbility = thisEntity:FindAbilityByName( "giant_burrower_impale" )
		hCarapaceAbility = thisEntity:FindAbilityByName( "nyx_assassin_spiked_carapace" )
		hBurrowAbility = thisEntity:FindAbilityByName( "nyx_assassin_burrow" )
		hUnburrowAbility = thisEntity:FindAbilityByName( "nyx_assassin_unburrow" )
		hMinionSpawnerAbility = thisEntity:FindAbilityByName( "giant_burrower_minion_spawner" )
		hExplosionAbility = thisEntity:FindAbilityByName( "giant_burrower_explosion" )

		hBurrowAbility:SetHidden( false )

		thisEntity:SetContextThink( "GiantBurrowerThink", GiantBurrowerThink, 1 )
	end
end

----------------------------------------------------------------------------------------------

function GiantBurrowerThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	-- Check that the children we have in our list are still alive
	for i, hSummonedUnit in ipairs( thisEntity.GIANT_BURROWER_SUMMONED_UNITS ) do
		if hSummonedUnit:IsNull() or ( not hSummonedUnit:IsAlive() ) then
			table.remove( thisEntity.GIANT_BURROWER_SUMMONED_UNITS, i )
		end
	end

	-- Are we too far from our initial spawn position?
	local fDist = ( thisEntity:GetOrigin() - thisEntity.vInitialSpawnPos ):Length2D()
	if fDist > 1500 then
		--print( "thisEntity.vInitialSpawnPos == ( " .. thisEntity.vInitialSpawnPos.x .. ", " .. thisEntity.vInitialSpawnPos.y .. " )" )
		--print( "thisEntity:GetOrigin() == ( " .. thisEntity:GetOrigin().x .. ", " .. thisEntity:GetOrigin().y .. " )" )
		--print( "fDist == " .. fDist )
		return RetreatHome()
	end

	--[[
	local hNearbyEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if ( #hNearbyEnemies == 0 ) then
		if ( thisEntity:FindModifierByName( "modifier_nyx_assassin_burrow" ) == nil ) then
			return CastBurrow()
		end
	end
	]]

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1050, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		-- Make minions in preparation
		if #thisEntity.GIANT_BURROWER_SUMMONED_UNITS < thisEntity.GIANT_BURROWER_MAX_SUMMONS then
			if hMinionSpawnerAbility ~= nil and hMinionSpawnerAbility:IsFullyCastable() then
				return CastMinionSpawner()
			end
		end

		-- Burrow ourselves while we wait for hEnemies
		if thisEntity:FindModifierByName( "modifier_nyx_assassin_burrow" ) == nil then
			if hBurrowAbility ~= nil and hBurrowAbility:IsFullyCastable() then
				--print( "Burrow ourselves while we wait for hEnemies" )
				return CastBurrow()
			end
		end
		return 1
	end

	-- Are we getting low on minions?
	--print( "#thisEntity.GIANT_BURROWER_SUMMONED_UNITS == " .. #thisEntity.GIANT_BURROWER_SUMMONED_UNITS )
	if #thisEntity.GIANT_BURROWER_SUMMONED_UNITS < ( RandomInt( 4, 6 ) ) then
		if hMinionSpawnerAbility ~= nil and hMinionSpawnerAbility:IsFullyCastable() then
			return CastMinionSpawner()
		end
	end

	if hImpaleAbility ~= nil and hImpaleAbility:IsFullyCastable() then
		return CastImpale( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	else
		if thisEntity:FindModifierByName( "modifier_nyx_assassin_burrow" ) == nil then
			local nResult = RandomInt( 0, 1 )
			if nResult == 0 then
				--Just fight
				return 3
			else
				return RetreatFromUnit( hEnemies[1] )
			end
		else
			return CastUnburrow( hEnemies )
		end
	end

	return 0.5
end

----------------------------------------------------------------------------------------------

function CastBurrow()
	--print( "GiantBurrower - CastBurrow()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hBurrowAbility:entindex(),
	})

	-- Delay creation of our mound model by Burrow's cast point
	local fDelay = hBurrowAbility:GetCastPoint()
	thisEntity:SetContextThink( "GiantBurrowerMoundThink", GiantBurrowerMoundThink, fDelay )

	return 2
end

----------------------------------------------------------------------------------------------

function GiantBurrowerMoundThink()
	thisEntity.hMoundUnit = CreateUnitByName( "npc_dota_burrower_mound", thisEntity:GetAbsOrigin(), false, thisEntity, thisEntity, thisEntity:GetTeamNumber() )

	return -1
end

----------------------------------------------------------------------------------------------

function CastUnburrow( hEnemies )
	--print( "GiantBurrower - CastUnburrow()" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hUnburrowAbility:entindex(),
		Queue = false,
	})

	UTIL_RemoveImmediate( thisEntity.hMoundUnit )

	--[[
	-- Explode
	if hExplosionAbility and hExplosionAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hExplosionAbility:entindex(),
			Queue = true,
		})
	end
	]]

	--[[
	-- Apply knockback
	local vLocation = thisEntity:GetAbsOrigin()
	local modifierKnockback =
	{
		center_x = vLocation.x,
		center_y = vLocation.y,
		center_z = vLocation.z,
		duration = 0.3,
		knockback_duration = 0.3,
		knockback_distance = 200,
		knockback_height = 50,
	}
	print( "#hEnemies == " .. #hEnemies )
	for _, hEnemy in pairs( hEnemies ) do
		hEnemy:AddNewModifier( hEnemy, nil, "modifier_knockback", modifierKnockback )
	end
	]]

	return 1
end

----------------------------------------------------------------------------------------------

function CastImpale( unit )
	--print( "GiantBurrower - CastImpale()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hImpaleAbility:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})

	-- Tell some of our children about our Impale target so they can run at it
	for i, hMinion in ipairs( thisEntity.GIANT_BURROWER_SUMMONED_UNITS ) do
		if hMinion and ( not hMinion:IsNull() ) and hMinion:IsAlive() then
			local fDist = ( hMinion:GetOrigin() - unit:GetOrigin() ):Length2D()
			if fDist < 600 then
				hMinion.hParentImpaleTarget = unit
				hMinion.timeTargetAssigned = GameRules:GetGameTime()
			end
		end
	end

	return 3
end

----------------------------------------------------------------------------------------------

function CastMinionSpawner()
	--print( "GiantBurrower - CastMinionSpawner()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hMinionSpawnerAbility:entindex(),
	})
	return 2
end

----------------------------------------------------------------------------------------------

function RetreatFromUnit( unit )
	--print( "GiantBurrower - RetreatFromUnit()" )
	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()

	--[[
	if hCarapaceAbility ~= nil and hCarapaceAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hCarapaceAbility:entindex(),
		})
	end
	]]
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()
	})
	return 3
end

----------------------------------------------------------------------------------------------

function RetreatHome()
	--print( "GiantBurrower - RetreatHome()" )
	if hCarapaceAbility ~= nil and hCarapaceAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hCarapaceAbility:entindex(),
		})
	end
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vInitialSpawnPos + RandomVector( RandomFloat( -300, 300 ) )
	})
	return 5
end

----------------------------------------------------------------------------------------------

