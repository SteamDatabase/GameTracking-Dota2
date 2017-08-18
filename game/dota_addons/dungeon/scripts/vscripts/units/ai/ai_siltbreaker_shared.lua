
--------------------------------------------------------------------------------

function UpdatePositionalInfo( hUnit, hEnemies )
	local vDirection = hUnit:GetForwardVector()
	local vRight = hUnit:GetRightVector()
	local vLeft = -vRight
	local flQuadrantDistance = 200

	local vFrontRightQuadrant = hUnit:GetOrigin() + ( ( vDirection + vRight ) * flQuadrantDistance )
	local vFrontLeftQuadrant = hUnit:GetOrigin() + ( ( vDirection + vLeft ) * flQuadrantDistance )
	local vBackRightQuadrant = hUnit:GetOrigin() + ( ( -vDirection + vRight ) * flQuadrantDistance )
	local vBackLeftQuadrant = hUnit:GetOrigin() + ( ( -vDirection + vLeft ) * flQuadrantDistance )
	local frontRightEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vFrontRightQuadrant, hEnemies[1], 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local frontLeftEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vFrontLeftQuadrant, hEnemies[1], 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local backRightEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vBackRightQuadrant, hEnemies[1], 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local backLeftEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vBackLeftQuadrant, hEnemies[1], 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

	if #backRightEnemies > 0 or #backLeftEnemies > 0 then
		hUnit.bEnemiesBehind = true
	else
		hUnit.bEnemiesBehind = false
	end

	if #frontRightEnemies > 0 or #frontLeftEnemies > 0 then
		hUnit.bEnemiesInFront = true
	else
		hUnit.bEnemiesInFront = false
	end
end

--------------------------------------------------------------------------------

function MoveOrder( hUnit, vPos )
	ExecuteOrderFromTable({
		UnitIndex = hUnit:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
	})

	return 1.0
end

--------------------------------------------------------------------------------
function AttackMoveOrder( hAttacker, hEnemy )
	if ( not hAttacker:HasAttackCapability() ) then
		return 1.0
	end

	ExecuteOrderFromTable({
		UnitIndex = hAttacker:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = hEnemy:GetOrigin(),
	})

	return 1.0
end

--------------------------------------------------------------------------------

function AttackTargetOrder( hAttacker, hEnemy )
	if ( not hAttacker:HasAttackCapability() ) then
		return 1.0
	end

	--print( string.format( "AttackTargetOrder, target is %s", hEnemy:GetUnitName() ) )
	ExecuteOrderFromTable({
		UnitIndex = hAttacker:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hEnemy:entindex(),
	})

	return 1.0
end

--------------------------------------------------------------------------------

function SprintIsReady( hCaster )
	local hAbility = hCaster.abilities.hSprint
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastSprint( hCaster )
	local hAbility = hCaster.abilities.hSprint
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 5.0
end

--------------------------------------------------------------------------------

function TailIsReady( hCaster )
	local hAbility = hCaster.abilities.hTailSpinCCW
	if hCaster.bEnemiesInFront and hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastTailSpinCCW( hCaster )
	local hAbility = hCaster.abilities.hTailSpinCCW
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex()
	})

	return 5.0
end

--------------------------------------------------------------------------------

function MindControlIsReady( hCaster, hEnemies )
	local nEnemiesAlive = 0
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy:IsAlive() then
			nEnemiesAlive = nEnemiesAlive + 1
		end
	end
	if nEnemiesAlive <= 1 then
		return false
	end

	local hAbility = hCaster.abilities.hMindControl
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastMindControl( hCaster, hEnemies )
	local hAbility = hCaster.abilities.hMindControl
	local hTarget = hEnemies[ RandomInt( 1, #hEnemies ) ]
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 4.0
end

--------------------------------------------------------------------------------

function TorrentsIsReady( hCaster )
	local hAbility = hCaster.abilities.hTorrents
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastTorrents( hCaster )
	local hAbility = hCaster.abilities.hTorrents
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 10
end

--------------------------------------------------------------------------------

function LineWaveIsReady( hCaster )
	local hAbility = hCaster.abilities.hLineWave
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastLineWave( hCaster, hEnemies )
	local hAbility = hCaster.abilities.hLineWave
	local hTarget = hEnemies[ RandomInt( 1, #hEnemies ) ]

	local fDist = -1
	local fHighestDist = 0
	local hFarthestEnemy = nil
	for _, hEnemy in pairs( hEnemies ) do
		fDist = ( hEnemy:GetOrigin() - hCaster:GetOrigin() ):Length2D()
		if fDist > fHighestDist then
			fHighestDist = fDist
			hFarthestEnemy = hEnemy
		end
	end

	if hFarthestEnemy == nil then
		return 0.5
	end

	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hFarthestEnemy:entindex(),
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 4
end

--------------------------------------------------------------------------------

function WavesIsReady( hCaster )
	local hAbility = hCaster.abilities.hWaves
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastWaves( hCaster )
	local hAbility = hCaster.abilities.hWaves
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 14
end

--------------------------------------------------------------------------------

function SummonMinionsIsReady( hCaster )
	local hAbility = hCaster.abilities.hSummonMinions
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastSummonMinions( hCaster )
	local hAbility = hCaster.abilities.hSummonMinions
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 7
end

--------------------------------------------------------------------------------

function SummonMinionsMediumIsReady( hCaster )
	local hAbility = hCaster.abilities.hSummonMinionsMedium
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastSummonMinionsMedium( hCaster )
	local hAbility = hCaster.abilities.hSummonMinionsMedium
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 7
end

--------------------------------------------------------------------------------

function SummonCloneIsReady( hCaster )
	local hAbility = hCaster.abilities.hSummonClone
	if hAbility ~= nil and hAbility:IsFullyCastable() and hCaster.nSummonCloneCasts < ( hCaster.Phase - 1 ) then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastSummonClone( hCaster )
	local hAbility = hCaster.abilities.hSummonClone
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 2
end

--------------------------------------------------------------------------------

function MouthBeamIsReady( hCaster )
	local hAbility = hCaster.abilities.hMouthBeam
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastMouthBeam( hCaster, hEnemies )
	local hAbility = hCaster.abilities.hMouthBeam
	local hTarget = hEnemies[ RandomInt( 1, #hEnemies ) ]
	if hTarget == nil then
		return 1
	end
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 10.0
end

--------------------------------------------------------------------------------

function TeleportIsReady( hCaster )
	if ( GameRules:GetGameTime() > ( hCaster.fLastTeleportChain + hCaster.nTeleportChainCD ) ) then
		hCaster.nRecentTeleportsCast = 0
		hCaster.fLastTeleportChain = GameRules:GetGameTime()
	end

	local hAbility = hCaster.abilities.hTeleport
	if hAbility ~= nil and hAbility:IsFullyCastable() and ( hCaster.nRecentTeleportsCast < hCaster.nTeleportsToChain ) then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastTeleport( hCaster, hEnemies )
	local hAbility = hCaster.abilities.hTeleport

	local hFilteredEnemies = {}
	for _, hEnemy in pairs( hEnemies ) do
		local fDist = ( hEnemy:GetOrigin() - hCaster:GetOrigin() ):Length2D()
		if fDist > 500 then
			table.insert( hFilteredEnemies, hEnemy )
		end
	end

	local hTarget = nil
	if #hFilteredEnemies > 0 then
		hTarget = hFilteredEnemies[ RandomInt( 1, #hFilteredEnemies ) ]
	else
		hTarget = hEnemies[ RandomInt( 1, #hEnemies ) ]
	end

	local vTargetPos = hTarget:GetOrigin()

	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	hCaster.nRecentTeleportsCast = hCaster.nRecentTeleportsCast + 1

	if ( hCaster.nRecentTeleportsCast >= hCaster.nTeleportsToChain ) then
		return 4.0
	end

	return 1.8
end

--------------------------------------------------------------------------------

