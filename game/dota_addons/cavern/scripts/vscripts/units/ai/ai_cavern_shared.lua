
--------------------------------------------------------------------------------
-- Room Mob Specific Fucntions --
--------------------------------------------------------------------------------

function RemoveUnitsNotInRoom( hUnit, hTargets )
	for i = #hTargets, 1, -1 do
		if hUnit.hRoom == nil or hTargets[i].hRoom == nil 
			or hTargets[ i ].hRoom.nRoomID ~= hUnit.hRoom.nRoomID or hTargets[ i ]:CanEntityBeSeenByMyTeam( hUnit ) == false then
			table.remove( hTargets, i )
		end
	end
end

function RemoveDeadUnits( hTargets )
	for i = #hTargets, 1, -1 do
		if hTargets[i]:IsNull() or not hTargets[i]:IsAlive() then
			table.remove( hTargets, i )
		end
	end
end

--------------------------------------------------------------------------------

function ArePlayersInRoom( hRoom )
	return #hRoom.PlayerHeroesPresent > 0
end

--------------------------------------------------------------------------------

function GetEnemyHeroesInRange( hUnit , flRange )
	if flRange == nil then
		flRange = 1250
	end
	local enemies = FindUnitsInRadius( hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, flRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	return enemies
end

--------------------------------------------------------------------------------

function GetVisibleEnemyHeroesInRange( hUnit , flRange )
	if flRange == nil then
		flRange = 1250
	end
	local enemies = FindUnitsInRadius( hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, flRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	return enemies
end

--------------------------------------------------------------------------------

function GetEnemyHeroesInRoom( hUnit , flRange )
	local enemies = GetEnemyHeroesInRange( hUnit, flRange )
	RemoveUnitsNotInRoom( hUnit, enemies )
	return enemies
end

--------------------------------------------------------------------------------

function GetVisibleEnemyHeroesInRoom( hUnit , flRange )
	local enemies = GetVisibleEnemyHeroesInRange( hUnit, flRange )
	RemoveUnitsNotInRoom( hUnit, enemies )
	return enemies
end

--------------------------------------------------------------------------------

function GetNoteworthyVisibleEnemiesNearby( hUnit, flRange )
	if flRange == nil then
		flRange = 1250
	end

	local eTARGETED_UNITS = DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local enemies = FindUnitsInRadius( hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, flRange, DOTA_UNIT_TARGET_TEAM_ENEMY, eTARGETED_UNITS, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	for index, hEnemy in pairs( enemies ) do
		if hEnemy:IsRealHero() == false and hEnemy:IsConsideredHero() == false and hEnemy:IsIllusion() == false then
			-- Remove the most unimportant units
			table.remove( enemies, index )
		end
	end

	return enemies
end

--------------------------------------------------------------------------------

function GetClosestPlayerInRoomOrReturnToSpawn( hUnit, flRange, flLeashTimeMin, flLeashTimeMax)
	if flRange == nil then
		flRange = 1500
	end

	local hClosestHero = nil
	local flClosestDist = 1e10

	local VisibleEnemies = GetVisibleEnemyHeroesInRoom( hUnit, flRange )

	if VisibleEnemies ~= nil then
		hClosestHero = VisibleEnemies[1]
	end

	if hClosestHero == nil then
		hUnit.bReturningToSpawn = true
		ReturnToSpawnPos( hUnit , true)
		return nil
	end	

	--if hUnit.vSpawnPos == nil or (hUnit:GetAbsOrigin() - hUnit.vSpawnPos):Length2D() < 50 then
	--	hUnit.bReturningToSpawn = false
	--end

	--if hUnit.bReturningToSpawn == true then	
	--	ReturnToSpawnPos( hUnit , hClosestHero == nil)
	--	return nil
	--end
	
	return hClosestHero
end

--------------------------------------------------------------------------------

function GetClosestNoteworthyEnemyNearbyOrReturnToSpawn( hUnit, flRange )
	if flRange == nil then
		flRange = 1250
	end

	local hClosestEnemy = nil
	local flClosestDist = 1e10

	local VisibleEnemies = GetNoteworthyVisibleEnemiesNearby( hUnit, flRange )
	for _, hEnemy in pairs( VisibleEnemies ) do
		local flDist = (hUnit:GetAbsOrigin() - hEnemy:GetAbsOrigin()):Length2D()
		if flDist < flClosestDist and hEnemy:IsAlive() and not hEnemy:IsAttackImmune() then
			hClosestEnemy = hEnemy
			flClosestDist = flDist
		end	
	end

	if not hClosestEnemy then
		ReturnToSpawnPos( hUnit , true)
		return nil
	end	

	return hClosestEnemy
end

--------------------------------------------------------------------------------

function GetFarthestPlayerInRoomOrReturnToSpawn( hUnit, flRange )

	if flRange == nil then
		flRange = 1250
	end

	local hFarthestHero = nil
	local flFarthestDist = 1e10

	local VisibleEnemies = GetVisibleEnemyHeroesInRoom( hUnit, flRange )
	for _,Hero in pairs( VisibleEnemies ) do
		local flDist = (hUnit:GetAbsOrigin() - Hero:GetAbsOrigin()):Length2D()
		if flDist < flFarthestDist then
			hFarthestHero = Hero
			flFarthestDist = flDist
		end	
	end

	if not hFarthestHero then
		ReturnToSpawnPos( hUnit , true)
		return nil
	end	

	return hFarthestHero
end

--------------------------------------------------------------------------------

function InitialRoomMobLogic( hUnit , bDisableFuzz )

	if hUnit == nil or hUnit:IsNull() or ( not hUnit:IsAlive() ) then
		return nil
	end
		
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not hUnit.bInitialized then
		hUnit.vSpawnPos = hUnit:GetAbsOrigin()
		hUnit.bInitialized = true
		if not bDisableFuzz then
			return RandomFloat( 0, 0.5 ) -- Adds some timing separation
		end
	end

	return -1
end

--------------------------------------------------------------------------------

function ReturnToSpawnPos( hUnit , bRoomEmpty)

	local flDelay = 1

	if not hUnit.vSpawnPos then
		print( "ai_cavern_shared/ReturnToSpawnPos - No valid vSpawnPos, stopping instead" )
		StopOrder( hUnit )
		return flDelay
	end

	-- don't spam the move order if the room is empty and we're already there
	if bRoomEmpty and (hUnit:GetAbsOrigin() - hUnit.vSpawnPos):Length2D() <= 1 then
		return flDelay
	end	

	ExecuteOrderFromTable({
		UnitIndex = hUnit:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hUnit.vSpawnPos,
	})

	return flDelay

end


--------------------------------------------------------------------------------
-- General Utility Fucntions --
--------------------------------------------------------------------------------

function AdvancedRandomVector( MaxLength, MinLength, vAwayFromVec, vAwayFromDist )
	local vCandidate = nil
	repeat
		vCandidate = RandomVector(1):Normalized()*RandomFloat(MinLength,MaxLength)
	until (vAwayFromVec == nil or vAwayFromDist == nil) or ( (vAwayFromVec - vCandidate):Length2D() > vAwayFromDist )
	return vCandidate
end

function GetRandomUnique( Array, BlacklistValues, bRemoveFromTable )
	local Candidate = nil
	local nIndex = 1
	for i=1,#Array do
		nIndex = RandomInt(1,#Array)
		Candidate = Array[ nIndex ]
		if BlacklistValues == nil or not TableContainsValue( BlacklistValues, Candidate ) then	
			break
		end
	end

	if bRemoveFromTable == true then
		table.remove( Array, nIndex )
	end

	return Candidate
end

function MoveOrder( hUnit, vPos )
	ExecuteOrderFromTable({
		UnitIndex = hUnit:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
	})

	return 1.0
end

function StopOrder( hUnit )
	ExecuteOrderFromTable({
		UnitIndex = hUnit:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP,
	})
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

	--printf( "AttackTargetOrder -- attacker: %s, target: %s", hAttacker:GetUnitName(), hEnemy:GetUnitName() )

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

function FindItemAbility( hCaster, szItemName )
	for i = 0, 5 do
		local item = hCaster:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == szItemName then
				return item
			end
		end
	end
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
--------------------------------------------------------------------------------
