
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hGroundBlastsAbility = thisEntity:FindAbilityByName( "tinker_turret_ground_blasts" )

	thisEntity:SetContextThink( "TinkerTurretThink", TinkerTurretThink, 0.1 )
end

--------------------------------------------------------------------------------

function TinkerTurretThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local nSearchRange = 4000
	local hHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(),
			nil, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_CLOSEST, false
	)

	if #hHeroes == 0 then
		return 0.1
	end


	if thisEntity.hGroundBlastsAbility and thisEntity.hGroundBlastsAbility:IsFullyCastable() then
		local hRandomHero = hHeroes[ RandomInt( 1, #hHeroes ) ]
		return CastGroundBlasts( hRandomHero )
	end

	return 0.1
end

--------------------------------------------------------------------------------

function CastGroundBlasts( hTarget )
	--printf( "tinker_turret - CastGroundBlastsAbility; target: %s", hTarget:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hGroundBlastsAbility:entindex(),
		Queue = false,
	})

	local fTimeToWait = thisEntity.hGroundBlastsAbility:GetCastPoint() + 0.2

	return fTimeToWait
end

--------------------------------------------------------------------------------
