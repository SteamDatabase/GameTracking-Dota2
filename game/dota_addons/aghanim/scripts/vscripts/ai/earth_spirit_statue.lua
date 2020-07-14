
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.fMaxSearchRange = 5000

	thisEntity.hStoneCallerAbility = thisEntity:FindAbilityByName( "aghsfort_earth_spirit_boss_stone_caller" )
	thisEntity.hBoulderSmashAbility = thisEntity:FindAbilityByName( "aghsfort_earth_spirit_boss_boulder_smash" )

	thisEntity:SetContextThink( "EarthSpiritStatueThink", EarthSpiritStatueThink, 0.5 )
end

--------------------------------------------------------------------------------

function EarthSpiritStatueThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.05
	end

	--printf( "EarthSpiritStatueThink - before stoneform modifier check" )

	if thisEntity:HasModifier( "modifier_earth_spirit_statue_stoneform" ) then
		return 0.05
	end

	--printf( "EarthSpiritStatueThink" )

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fMaxSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		--printf( "EarthSpiritStatueThink - hEnemies is empty" )
		return 1
	end

	local hStone = nil
	local hAllies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _, hAlly in pairs( hAllies ) do
		if hAlly:GetUnitName() == "npc_dota_aghsfort_earth_spirit_boss_stone" then
			hStone = hAlly
			--printf( "earth_spirit_statue - found a stone" )
		end
	end

	if hStone == nil then
		if thisEntity.hStoneCallerAbility and thisEntity.hStoneCallerAbility:IsFullyCastable() then
			local hRandomEnemy = hEnemies[ RandomInt( 1, #hEnemies ) ]
			local vDir = hRandomEnemy:GetOrigin() - thisEntity:GetOrigin()
			vDir.z = 0.0
			vDir = vDir:Normalized()

			local nStoneDistance = 100
			local vStonePos = thisEntity:GetAbsOrigin() + ( vDir * nStoneDistance )

			return CastStoneCaller( vStonePos )
		end
	else
		if thisEntity.hBoulderSmashAbility and thisEntity.hBoulderSmashAbility:IsFullyCastable() then
			return CastBoulderSmash( hStone )
		end
	end

	return 0.05
end

--------------------------------------------------------------------------------

function CastStoneCaller( vPosition )
	--printf( "CastStoneCaller" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hStoneCallerAbility:entindex(),
		Position = vPosition,
		Queue = false,
	})

	return 0.5
end

-------------------------------------------------------------------------------

function CastBoulderSmash( hStone )
	--printf( "CastBoulderSmash on position: %s", hStone:GetAbsOrigin() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hBoulderSmashAbility:entindex(),
		TargetIndex = hStone:entindex(),	
		Queue = false,
	})

	return 2.0
end

-------------------------------------------------------------------------------
