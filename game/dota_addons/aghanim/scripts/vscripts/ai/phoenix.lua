
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hIcarusDiveAbility = thisEntity:FindAbilityByName( "aghsfort_creature_phoenix_icarus_dive" )
	thisEntity.hIcarusDiveStopAbility = thisEntity:FindAbilityByName( "aghsfort_creature_phoenix_icarus_dive_stop" )
	thisEntity.hActivateSpiritsAbility = thisEntity:FindAbilityByName( "aghsfort_creature_phoenix_fire_spirits" )
	thisEntity.hLaunchSpiritsAbility = thisEntity:FindAbilityByName( "aghsfort_creature_phoenix_launch_fire_spirit" )
	thisEntity.hSupernovaAbility = thisEntity:FindAbilityByName( "aghsfort_creature_phoenix_supernova" )

	thisEntity.fDiveRange = 1400
	thisEntity.fSupernovaRange = thisEntity.hSupernovaAbility:GetCastRange( thisEntity:GetOrigin(), nil )
	thisEntity.bReapplyNoCCAfterAbility = false

	thisEntity:SetContextThink( "PhoenixThink", PhoenixThink, 0.5 )
end

--------------------------------------------------------------------------------

function PhoenixThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	-- Reapply the no CC after abilities used
	if thisEntity.bReapplyNoCCAfterAbility == true then
		print( 'ADDING NO CC BACK IN!' )
		thisEntity.bReapplyNoCCAfterAbility = false
		thisEntity:AddNewModifier( thisEntity, nil, 'modifier_absolute_no_cc', { duration = -1 } )
	end

	local hDiveRangeEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fDiveRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hDiveRangeEnemies == 0 then
		-- thisEntity.fDiveRange is our max ability range so just don't think if there are no enemies within that range
		return 0.1
	end

	local hRandomSpiritsTarget = hDiveRangeEnemies[ RandomInt( 1, #hDiveRangeEnemies ) ]

	if thisEntity.hActivateSpiritsAbility then
		if thisEntity.hActivateSpiritsAbility:IsHidden() == false and thisEntity.hActivateSpiritsAbility:IsFullyCastable() then
			return CastActivateSpirits()
		end
	end

	if thisEntity.hLaunchSpiritsAbility then
		if thisEntity.hLaunchSpiritsAbility:IsHidden() == false and thisEntity.hLaunchSpiritsAbility:IsFullyCastable() then
			return CastLaunchSpirits( hRandomSpiritsTarget:GetAbsOrigin() )
		end
	end

	local fHealthThresholdPctIcarus = 90
	if thisEntity:GetHealthPercent() <= fHealthThresholdPctIcarus and thisEntity.hIcarusDiveAbility and thisEntity.hIcarusDiveAbility:IsFullyCastable() then
		local hRandomDiveTarget = hDiveRangeEnemies[ RandomInt( 1, #hDiveRangeEnemies ) ]
		return CastIcarusDive( hRandomDiveTarget:GetAbsOrigin() )
	end

	local hSupernovaRangeEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSupernovaRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	if #hSupernovaRangeEnemies > 0 then
		local fHealthThresholdPctSupernova = 40
		if thisEntity:GetHealthPercent() <= fHealthThresholdPctSupernova and thisEntity.hSupernovaAbility and thisEntity.hSupernovaAbility:IsFullyCastable() then
			local hNearestTarget = hSupernovaRangeEnemies[ 1 ]
			return CastSupernova( hNearestTarget )
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------

function CastIcarusDive( vTargetPos )
	--print( "CastIcarusDive" )
	thisEntity.bReapplyNoCCAfterAbility = true
	thisEntity:RemoveAbility( 'ability_absolute_no_cc' )
	thisEntity:RemoveModifierByName( 'modifier_absolute_no_cc' )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hIcarusDiveAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})

	local fReturnTime = thisEntity.hIcarusDiveAbility:GetCastPoint() + 0.2
	return fReturnTime
end

--------------------------------------------------------------------------------

function CastActivateSpirits( vTargetPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hActivateSpiritsAbility:entindex(),
		Queue = false,
	})

	return 0.0
end

--------------------------------------------------------------------------------

function CastLaunchSpirits( vTargetPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hLaunchSpiritsAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})

	return 1.0
end

--------------------------------------------------------------------------------

function CastSupernova( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hSupernovaAbility:entindex(),
		TargetIndex = hTarget:entindex(),
		Queue = false,
	})

	local fReturnTime = thisEntity.hSupernovaAbility:GetCastPoint() + 0.2
	return fReturnTime
end

--------------------------------------------------------------------------------
