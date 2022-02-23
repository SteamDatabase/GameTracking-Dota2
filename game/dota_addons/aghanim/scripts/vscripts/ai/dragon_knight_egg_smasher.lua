
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	-- thisEntity.hGroundBlastAbility = thisEntity:FindAbilityByName( "dragon_knight_egg_smasher_ground_blast" )
	thisEntity:SetContextThink( "DragonKnightEggSmasherThink", DragonKnightEggSmasherThink, 0.25 )
end

--------------------------------------------------------------------------------

function DragonKnightEggSmasherThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	thisEntity:SetInitialGoalEntity( nil )

	local vecEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )

	if #vecEnemies == 0 then
		return FindStuffToSmash()
	end

	-- if thisEntity.hGroundBlastAbility:IsFullyCastable() then
	-- 	local flRange = thisEntity.hGroundBlastAbility:GetCastRange( thisEntity:GetOrigin(), nil )
	-- 	local flFurthestDistance = 0
	-- 	local hFurthestEnemy = nil
	-- 	for _, hEnemy in pairs( vecEnemies ) do
	-- 		local flDistance = (thisEntity:GetOrigin() - hEnemy:GetOrigin()):Length2D()
	-- 		if flDistance <= flRange and flDistance > flFurthestDistance then
	-- 			hFurthestEnemy = hEnemy
	-- 			flFurthestDistance = flDistance
	-- 			printf( "Found enemy" )
	-- 		end
	-- 	end

	-- 	if hFurthestEnemy ~= nil then
	-- 		return CastGroundBlast( hFurthestEnemy )
	-- 	end
	-- end
	
	return Attack( vecEnemies[1] )
end

--------------------------------------------------------------------------------

function FindStuffToSmash()

	local hTarget = nil

	local vecEggs = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _, hEgg in pairs( vecEggs ) do 
		if hEgg:IsAlive() and hEgg:GetUnitName() == "npc_dota_creature_dragon_egg" then
			hTarget = hEgg
			break
		end
	end

	if hTarget == nil then
		local vecHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _, hHero in pairs( vecHeroes ) do
			if hHero:IsAlive() then
				hTarget = hHero
			end
		end
	end

	if hTarget ~= nil then
		thisEntity:SetInitialGoalEntity( hTarget )
	end

	return 1.0
end

--------------------------------------------------------------------------------

function CastGroundBlast( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hGroundBlastAbility:entindex(),
		TargetIndex = hEnemy:entindex(),
		Queue = false,
	})

	local fReturnTime = thisEntity.hGroundBlastAbility:GetCastPoint() + 1
	return fReturnTime
end

--------------------------------------------------------------------------------

function Attack( hEnemy )
	printf( "Attacking enemy %s", hEnemy:GetUnitName() )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hEnemy:entindex(),
		Queue = false,
	})

	return 2.0
end
