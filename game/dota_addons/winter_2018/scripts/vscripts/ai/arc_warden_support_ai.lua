
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hShieldAbility = thisEntity:FindAbilityByName( "arc_warden_magnetic_field" )
	thisEntity.hMachineGunAbility = thisEntity:FindAbilityByName( "fireball_machine_gun" )
	thisEntity.hRayGunAbility = thisEntity:FindAbilityByName( "fireball_ray_gun" )

	thisEntity:SetContextThink( "Arc_Warden_Support_Think", ArcWardenSupportThink, 0.5 )
end

--------------------------------------------------------------------------------

function ArcWardenSupportThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity.hMachineGunAbility and thisEntity.hMachineGunAbility:IsFullyCastable() and thisEntity:HasModifier( "modifier_fireball_ray_gun_thinker" ) == false then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return 1
		end

		local hRandomEnemy = hEnemies[ RandomInt( 1, #hEnemies ) ] 

		return CastMachineGun( hRandomEnemy )
	end

	if thisEntity.hRayGunAbility and thisEntity.hRayGunAbility:IsFullyCastable() and thisEntity:HasModifier( "modifier_fireball_machine_gun_thinker" ) == false then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return 1
		end

		local hRandomEnemy = hEnemies[ RandomInt( 1, #hEnemies ) ] 

		return CastRayGun( hRandomEnemy )
	end


	if thisEntity.hShieldAbility and thisEntity.hShieldAbility:IsFullyCastable() then
		local fRange = thisEntity.hShieldAbility:GetCastRange()
		thisEntity.hTarget = AICore:WeakestAllyHeroInRange( thisEntity, fRange )

		if thisEntity.hTarget == nil then 
			return 0.5
		end
		
		if thisEntity.hTarget:GetHealthPercent() >= 80 then
			return 0.5
		end

		return CastShield(hTarget)

	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastShield(hTarget)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = thisEntity.hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hShieldAbility:entindex(),
		Queue = false,					
	})

	return 1
end


function CastMachineGun( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hMachineGunAbility:entindex(),
		Queue = false,
	})

	return 0.5
end


function CastRayGun( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hRayGunAbility:entindex(),
		Queue = false,
	})

	return 0.5
end
--------------------------------------------------------------------------------
