
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hMeleeAbility = thisEntity:FindAbilityByName( "storegga_melee_smash" )
	thisEntity.hGroundPoundAbility = thisEntity:FindAbilityByName( "storegga_ground_pound" )
	thisEntity.hThrowAbility = thisEntity:FindAbilityByName( "storegga_throw_rock" )

	thisEntity.nHeroFlags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	thisEntity.nBuildingFlags = DOTA_UNIT_TARGET_FLAG_NONE

	thisEntity:SetContextThink( "StoreggaThink", StoreggaThink, 0.5 )
end

--------------------------------------------------------------------------------

function StoreggaThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity:IsChanneling() then
		return 0.1
	end

	if thisEntity.hThrowAbility and thisEntity.hThrowAbility:IsFullyCastable() then
		local fThrowRockAtPlayerChance = 0.75
		local bThrowRockAtPlayer = RandomFloat( 0, 1 ) > ( 1 - fThrowRockAtPlayerChance )
		local fThrowRockSearchRadius = 15000
		if bThrowRockAtPlayer then
			local nFlags = thisEntity.nHeroFlags
			local hEnemyPlayers = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fThrowRockSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, nFlags, FIND_CLOSEST, false )
			if #hEnemyPlayers > 0 then
				local hRandomEnemyPlayer = hEnemyPlayers[ RandomInt( 1, #hEnemyPlayers ) ]

				return CastRockThrow( hRandomEnemyPlayer )
			end
		else
			-- Throw rock at a structure
			local nFlags = thisEntity.nBuildingFlags
			local hEnemyStructures = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fThrowRockSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, nFlags, FIND_CLOSEST, false )
			if #hEnemyStructures > 0 then
				local hRandomEnemyStructure = hEnemyStructures[ RandomInt( 1, #hEnemyStructures ) ]

				return CastRockThrow( hRandomEnemyStructure )
			end
		end
	end

	if thisEntity.hGroundPoundAbility and thisEntity.hGroundPoundAbility:IsFullyCastable() then
		local fGroundPoundSearchRadius = 300
		local nFlags = thisEntity.nHeroFlags
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fGroundPoundSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, nFlags, FIND_CLOSEST, false )
		if #hEnemies > 0 then
			return CastGroundPound()
		end
	end

	if thisEntity.hMeleeAbility and thisEntity.hMeleeAbility:IsFullyCastable() then
		-- Prioritize targeting heroes but can also target buildings
		local fMeleeSmashSearchRadius = 490
		local nFlags = thisEntity.nHeroFlags
		local hEnemyHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fMeleeSmashSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, nFlags, FIND_CLOSEST, false )
		if #hEnemyHeroes > 0 then
			local hRandomEnemyHero = hEnemyHeroes[ RandomInt( 1, #hEnemyHeroes ) ]

			return CastMeleeSmash( hRandomEnemyHero )
		else
			local nFlags = thisEntity.nBuildingFlags
			local hEnemyBuildings = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fMeleeSmashSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, nFlags, FIND_CLOSEST, false )
			if #hEnemyBuildings > 0 then
				local hRandomEnemyBuilding = hEnemyBuildings[ RandomInt( 1, #hEnemyBuildings ) ]

				return CastMeleeSmash( hRandomEnemyBuilding )
			end
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastRockThrow( hTarget )
	if hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hThrowAbility:entindex(),
		Queue = false,
	})

	return 2.0
end

--------------------------------------------------------------------------------

function CastGroundPound()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hGroundPoundAbility:entindex(),
		Queue = false,
	})

	return 3.0
end

--------------------------------------------------------------------------------

function CastMeleeSmash( hTarget )
	if hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hMeleeAbility:entindex(),
		Queue = false,
	})

	return 2.5
end

--------------------------------------------------------------------------------

