
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hSwapAbility = thisEntity:FindAbilityByName( "vengeful_spirit_nether_swap_projectile" )
	if thisEntity.hSwapAbility == nil then
		print( 'ERROR - MISSING vengeful_spirit_nether_swap_projectile on vengeful spirit ai' )
	end

	thisEntity.hMagicMissileAbility = thisEntity:FindAbilityByName( "vengeful_spirit_magic_missile_projectile" )
	if thisEntity.hMagicMissileAbility == nil then
		print( 'ERROR - MISSING vengeful_spirit_magic_missile_projectile on vengeful spirit ai' )
	end

	thisEntity.flRetreatRange = 500
	thisEntity.flAttackRange = 850

	--thisEntity.flRangedAttackDelayTime = GameRules:GetGameTime() + RandomFloat( 2, 5 )	-- need to live for this long before we can think about casting
	thisEntity.PreviousOrder = "no_order"

	thisEntity.hCrystalMaiden = nil
	thisEntity.bSwapMode = false
	thisEntity.vSwapDestination = nil

	thisEntity:SetContextThink( "VengefulSpiritThink", VengefulSpiritThink, 0.5 )
end

--------------------------------------------------------------------------------

function VengefulSpiritThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	VerifyCrystalMaiden()

	if thisEntity.hCrystalMaiden == nil then
		thisEntity.hCrystalMaiden =	FindCrystalMaiden()
	end

	thisEntity.bSwapMode = false
	if thisEntity.hCrystalMaiden ~= nil then
		if thisEntity.hCrystalMaiden:IsChanneling() then
			--print( 'CM IsChanneling! Swap Mode Activate!' )
			thisEntity.bSwapMode = true
			thisEntity:SetInitialGoalEntity( nil )	-- need to break this for the forced movements to work
		end
	end

	if thisEntity.bSwapMode == true then
		if thisEntity.vSwapDestination == nil then
			thisEntity.vSwapDestination = FindPathablePositionNearby( thisEntity.hCrystalMaiden:GetAbsOrigin(), 300, 600 )
		end

		if thisEntity.vSwapDestination ~= nil then
			-- if we're close to the swap destination, chill and wait for swap uptime, otherwise move closer to the swap destination
			local vCurrentPos = thisEntity:GetAbsOrigin()
			local vToSwapDestination = thisEntity.vSwapDestination - vCurrentPos
			local fDist = vToSwapDestination:Length2D()
			if fDist < 200 then
				--print( 'MADE IT TO SWAP DESTINATION!' )
				if thisEntity.hSwapAbility:IsFullyCastable() then
					local nSwapRange = thisEntity.hSwapAbility:GetCastRange( thisEntity:GetAbsOrigin(), nil )
					local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, nSwapRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false )
					local hSwapTarget = nil
					-- grab the *farthest* enemy from our list
					for i = 1, #hEnemies do
						local hEnemy = hEnemies[i]
						if hEnemy ~= nil and hEnemy:IsAlive() then
							return CastSwap( hEnemy )
						end
					end
					--print( 'NO ENEMY TO SWAP FOUND' )
				end

				return HoldPosition()
			else
				--print( 'MOVING TO SWAP DESTINATION!' )
				--DebugDrawSphere( thisEntity.vSwapDestination, Vector( 255, 255, 0 ), 1.0, 50, false, 1.25 )
				return MoveToSwapPosition()
			end
		end
	end

	-- CM ULT NOT HAPPENING IF WE'RE HERE

	local fAcquisitionRange = thisEntity:GetAcquisitionRange()
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fAcquisitionRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		--print( 'NO ENEMIES' )
		return HoldPosition()
	end

	local bMagicMissileReady = false
	--if GameRules:GetGameTime() > thisEntity.flRangedAttackDelayTime and thisEntity.hSwapAbility ~= nil and thisEntity.hSwapAbility:IsFullyCastable() then
	if thisEntity.hMagicMissileAbility ~= nil and thisEntity.hMagicMissileAbility:IsFullyCastable() then
		bMagicMissileReady = true
	end	

	-- grab the closest enemy from our list
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then

			if bMagicMissileReady == true then
				return CastMagicMissile( hEnemy )
			end

			-- ATTACK/APPROACH target
			return TargetEnemy( hEnemy )
		end
	end

	return HoldPosition()
end

--------------------------------------------------------------------------------

function FindCrystalMaiden()
	if thisEntity.hCrystalMaiden == nil then
		local hQueens = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #hQueens > 0 then
			for _,hQueen in pairs( hQueens ) do
				if hQueen ~= nil and hQueen:IsNull() == false and hQueen:IsAlive() == true and hQueen:GetUnitName() == "npc_dota_creature_crystal_maiden_miniboss" then
					return hQueen
				end
			end
		end
	end

	return nil
end

--------------------------------------------------------------------------------

function VerifyCrystalMaiden()
	if thisEntity.hCrystalMaiden ~= nil then
		if thisEntity.hCrystalMaiden:IsNull() == true or thisEntity.hCrystalMaiden:IsAlive() == false then
			thisEntity.hCrystalMaiden = nil
		end
	end
end

--------------------------------------------------------------------------------

function TargetEnemy( hEnemy )
	--print( 'TargetEnemy!' )
	local hAttackTarget = nil
	local hApproachTarget = nil

	local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	if flDist < thisEntity.flRetreatRange then
		if ( thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() < thisEntity.fTimeOfLastRetreat + 3 ) ) then
			-- We already retreated recently, so just attack
			hAttackTarget = hEnemy
		else
			return Retreat( hEnemy )
		end
	end

	if flDist <= thisEntity.flAttackRange then
		hAttackTarget = hEnemy
	end
	if flDist > thisEntity.flAttackRange then
		hApproachTarget = hEnemy
	end

	if hAttackTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	if hAttackTarget then
		thisEntity:FaceTowards( hAttackTarget:GetOrigin() )
		--return HoldPosition()
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastSwap( hEnemy )
	--print( "ai_vengeful_spirit_captain - CastDisruption" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hEnemy:GetOrigin(),
		AbilityIndex = thisEntity.hSwapAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "swap"

	return 1
end

--------------------------------------------------------------------------------

function CastMagicMissile( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hEnemy:GetOrigin(),
		AbilityIndex = thisEntity.hMagicMissileAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "magic_missile"

	return 1
end

--------------------------------------------------------------------------------

function Approach(unit)
	--print( "ai_vengeful_spirit_captain - Approach" )

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})

	thisEntity.PreviousOrder = "approach"

	return 1
end

--------------------------------------------------------------------------------

function Retreat(unit)
	--print( "ai_vengeful_spirit_captain - Retreat" )

	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()

	-- if away from enemy is an unpathable area, find a new direction to run to
	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 5 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( thisEntity:GetIdealSpeed() )
		nAttempts = nAttempts + 1
	end

	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos,
	})

	thisEntity.PreviousOrder = "retreat"

	return 1.25
end

--------------------------------------------------------------------------------

function HoldPosition()
	--print( "ai_vengeful_spirit_captain - Hold Position" )
	if thisEntity.PreviousOrder == "hold_position" then
		return 0.5
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_HOLD_POSITION,
		Position = thisEntity:GetOrigin()
	})

	thisEntity.PreviousOrder = "hold_position"

	return 0.5
end

--------------------------------------------------------------------------------

function MoveToSwapPosition()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vSwapDestination,
	})

	thisEntity.PreviousOrder = "move_to_swap"

	return 1.25
end
