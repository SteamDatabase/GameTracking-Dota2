
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

function FilterEntitiesOutsideOfRange( vPosition, hEntitiesTable, flRange )
	if hEntitiesTable == nil or #hEntitiesTable == 0 then
		return {}
	end

	for n=#hEntitiesTable,1,-1 do
		local hEntity = hEntitiesTable[ n ]
		if hEntity ~= nil then
			local fDist = ( hEntity:GetOrigin() - vPosition ):Length2D()
			if fDist > flRange then
				table.remove( hEntitiesTable, n )
			end
		end 
	end

	return hEntitiesTable
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
	if (not hAttacker or not hEnemy or not hAttacker:HasAttackCapability() ) then
		return 0.25
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
	if ( not hAttacker or not hEnemy or not hAttacker:HasAttackCapability() ) then
		return 0.25
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

function CastTargetedItem( hUnit, hTarget, szItemName )
	local hItem = hUnit:FindItemInInventory( szItemName )
	return CastTargetedAbility( hUnit, hTarget, hItem )
end

--------------------------------------------------------------------------------

function CastUntargetedItem( hUnit, szItemName )
	local hItem = hUnit:FindItemInInventory( szItemName )
	return CastUntargetedAbility( hUnit, hItem )
end

--------------------------------------------------------------------------------

function CastPositionalItem( hUnit, vPosition, szItemName )
	local hItem = hUnit:FindItemInInventory( szItemName )
	return CastPositionalAbility( hUnit, vPosition, hItem )
end

--------------------------------------------------------------------------------

function CastTargetedAbility( hUnit, hTarget, hAbility )
	if type(hAbility) == "string" then 
		hAbility = hUnit:FindAbilityByName(hAbility)
		printf("result of string ability is %s", hAbility:GetName())
	end
	if hAbility and hAbility:IsFullyCastable() then
		--printf( "%s casting %s on %s", hUnit:GetName(), hAbility:GetName(), hTarget:GetName() )
		ExecuteOrderFromTable({
			UnitIndex = hUnit:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = hTarget:entindex(),
			AbilityIndex = hAbility:entindex()
		})
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function CastPositionalAbility( hUnit, vPosition, hAbility )
	if type(hAbility) == "string" then 
		hAbility = hUnit:FindAbilityByName(hAbility)
	end
	if hAbility and hAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = hUnit:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vPosition,
			AbilityIndex = hAbility:entindex()
		})
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function CastUntargetedAbility( hUnit, hAbility )
	if type(hAbility) == "string" then 
		hAbility = hUnit:FindAbilityByName(hAbility)
	end
	if hAbility and hAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = hUnit:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex()
		})
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function GetAlliesInRange( hCaster, flRange )
	return FindUnitsInRadius( hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, flRange, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, 
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
end

function LastAllyCastTime( hCaster, hAbility, flRange, hTarget )
	if flRange == nil then
		flRange = 1000
	end
	local flLastCastTime = -999999
	local hAllies = GetAlliesInRange( hCaster, flRange )
	for index,hAlly in pairs(hAllies) do
		local flAllyTime = hAlly["last_cast_time_"..hAbility:GetName()]
		local hAllyTarget = hAlly["last_cast_target_"..hAbility:GetName()]
		if flAllyTime ~= nil and (hTarget == nil or hTarget == hAllyTarget) then
			flLastCastTime = math.max(flAllyTime,flLastCastTime)
		end
	end
	return flLastCastTime
end

--------------------------------------------------------------------------------

function UpdateLastCastTime( hCaster, hAbility, hTarget )
	hCaster["last_cast_time_"..hAbility:GetName()] = GameRules:GetGameTime()
	hCaster["last_cast_target_"..hAbility:GetName()] = hTarget
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
