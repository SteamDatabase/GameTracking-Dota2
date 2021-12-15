--[[ Nightstalker Miniboss AI ]]

--------------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hVoidAbility = thisEntity:FindAbilityByName( "aghslab_night_stalker_void" )
	thisEntity.hCripplingFearAbility = thisEntity:FindAbilityByName( "night_stalker_crippling_fear" )
	thisEntity.hDarknessAbility = thisEntity:FindAbilityByName( "night_stalker_darkness" )

	thisEntity:SetContextThink( "NightstalkerThink", NightstalkerThink, 1 )
end

--------------------------------------------------------------------------------------------------------

function NightstalkerThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then 
		return 0.1 
	end
	
	if ( thisEntity:GetHealthPercent() < 75 ) then
		return CastDarkness()
	end

	for _,hEnemy in pairs ( enemies ) do
		local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
		if flDist > 400 then 
			if thisEntity.hVoidAbility and thisEntity.hVoidAbility:IsFullyCastable() then
				return CastVoid(hEnemy)
			end
		else
			if thisEntity.hCripplingFearAbility and thisEntity.hCripplingFearAbility:IsFullyCastable() then
				return CastCripplingFear()
			end
		end
	end

	local hTarget = enemies[RandomInt(1,#enemies)]
	return Approach( hTarget )
end

--------------------------------------------------------------------------------------------------------

function CastVoid(unit)

	local targetPoint = unit:GetOrigin() + RandomVector( 50 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = targetPoint,
		AbilityIndex = thisEntity.hVoidAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------------------------------

function CastCripplingFear()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hCripplingFearAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------------------------------

function CastDarkness()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hDarknessAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------------------------------

function Approach(unit)
	--print( "Nightstalker - Approach" )

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})

	return 1.0
end

--------------------------------------------------------------------------------------------------------
