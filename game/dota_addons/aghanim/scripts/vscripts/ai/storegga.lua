
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	SlamAbility = thisEntity:FindAbilityByName( "storegga_arm_slam" )
	GrabAbility = thisEntity:FindAbilityByName( "storegga_grab" )
	ThrowAbility = thisEntity:FindAbilityByName( "storegga_grab_throw" )
	GroundPoundAbility = thisEntity:FindAbilityByName( "storegga_ground_pound" )
	AvalancheAbility = thisEntity:FindAbilityByName( "storegga_avalanche" )

	thisEntity.flThrowTimer = 0.0 -- externally updated

	thisEntity.fLongWaitTime = 15

	thisEntity.fEnemySearchRange = 2500
	thisEntity.fRockSearchRange = 2500

	thisEntity:SetContextThink( "StoreggaThink", StoreggaThink, 1 )
end

--------------------------------------------------------------------------------

function StoreggaThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if ( not thisEntity.bInitialInvulnRemoved ) then
		thisEntity:RemoveModifierByName( "modifier_invulnerable" )
		thisEntity.bInitialInvulnRemoved = true
	end

	if thisEntity:IsChanneling() then
		return 0.1
	end

	if AvalancheAbility ~= nil and AvalancheAbility:IsFullyCastable() and thisEntity:GetHealthPercent() < 50 then
		return CastAvalanche()
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fEnemySearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
	local rocks = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fRockSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )

	local nEnemiesAliveInRange = 0
	for i = 1, #enemies do
		local enemy = enemies[ i ]
		if enemy ~= nil then
			if enemy:IsRealHero() and enemy:IsAlive() then
				nEnemiesAliveInRange = nEnemiesAliveInRange + 1
				if enemy:FindModifierByName( "modifier_storegga_grabbed_debuff" ) ~= nil then
					--printf( "removed %s from enemies table", enemy:GetUnitName() )
					table.remove( enemies, i )
				end
			end
		end
	end

	-- remove all non-rocks
	for i = #rocks, 1, -1 do
		local possibleRock = rocks[i]
		if possibleRock ~= nil then
			if string.find( possibleRock:GetUnitName(), "npc_dota_storegga_rock" ) == nil then
				--print( '^^^Removing non-rock from Storegga rock list named: ' .. possibleRock:GetUnitName() )
				table.remove( rocks, i )
			end
		end
	end

	local hNearestEnemy = enemies[ 1 ]
	local hFarthestEnemy = enemies[ #enemies ]

	local hGrabbedEnemyBuff = thisEntity:FindModifierByName( "modifier_storegga_grabbed_buff" )
	local hGrabbedTarget = nil
	if hGrabbedEnemyBuff == nil then
		if GrabAbility ~= nil and GrabAbility:IsFullyCastable() then
			if hNearestEnemy ~= nil and nEnemiesAliveInRange > 1 and RandomInt( 0, 1 ) == 0 then
				printf( "  Grab the nearest enemy (%s)", hNearestEnemy:GetUnitName() )
				return CastGrab( hNearestEnemy )
			elseif #rocks > 0 then
				local hRandomRock = rocks[ RandomInt( 1, #rocks ) ] 
				if hRandomRock ~= nil then
					printf( "  Grab a random rock" )
					return CastGrab( hRandomRock )
				end
			end
		end
	else
		-- Note: hThrowObject and flThrowTimer are both set by the modifier
		local hGrabbedTarget = hGrabbedEnemyBuff.hThrowObject
		if GameRules:GetGameTime() > thisEntity.flThrowTimer and hGrabbedTarget ~= nil then
			if ThrowAbility ~= nil and ThrowAbility:IsFullyCastable() then
				if hFarthestEnemy ~= nil then
					printf( "  Throw at the farthest enemy; pos: %s", hFarthestEnemy:GetOrigin() )
					return CastThrow( hFarthestEnemy:GetOrigin() )
				elseif #rocks > 0 then
					local hFarthestRock = rocks[ #rocks ]
					if hFarthestRock ~= nil then
						printf( "  Throw at the farthest.. rock?; pos: %s", hFarthestRock:GetOrigin() )
						return CastThrow( hFarthestRock:GetOrigin() )
					end
				elseif GameRules:GetGameTime() > ( thisEntity.flThrowTimer + thisEntity.fLongWaitTime ) then
					printf( "  a lot of time has passed and we're still holding onto an object, so just throw it somewhere pathable" )

					-- If I've been waiting too long, throw grabbed object at some random location
					local nMaxDistance = 1400
					local vRandomThrowPos = nil

					local nMaxAttempts = 7
					local nAttempts = 0

					repeat
						if nAttempts > nMaxAttempts then
							vRandomThrowPos = nil
							printf( "WARNING - storegga - failed to find valid position for throw target pos" )
							break
						end

						local vPos = thisEntity:GetAbsOrigin() + RandomVector( nMaxDistance )
						vRandomThrowPos = FindPathablePositionNearby( vPos, 0, 500 )
						nAttempts = nAttempts + 1
					until ( GridNav:CanFindPath( thisEntity:GetOrigin(), vRandomThrowPos ) )
					--until ( GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vRandomThrowPos ) )

					if vRandomThrowPos == nil then
						printf( "  never found a good random pos to throw to, so just use my own origin" )
						vRandomThrowPos = thisEntity:GetAbsOrigin()
					end

					return CastThrow( vRandomThrowPos )
				end
			end
		end
	end

	if GroundPoundAbility and GroundPoundAbility:IsFullyCastable() then
		local fGroundPoundSearchRadius = 300
		local hGroundPoundEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fGroundPoundSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
		if #hGroundPoundEnemies > 0 then
			return CastGroundPound()
		end
	end

	if SlamAbility ~= nil and SlamAbility:IsFullyCastable() then
		if RandomInt( 0, 1 ) == 1 then
			if hNearestEnemy ~= nil then
				--printf( "Slam the nearest enemy (%s)", hNearestEnemy:GetUnitName() )
				return CastSlam( hNearestEnemy )
			end
		else
			if hFarthestEnemy ~= nil then
				--printf( "Slam the farthest enemy (%s)", hFarthestEnemy:GetUnitName() )
				return CastSlam( hFarthestEnemy )
			end
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------

function CastSlam( enemy )
	if enemy == nil or enemy:IsAlive() == false then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = SlamAbility:entindex(),
	})

	local fInterval = SlamAbility:GetCastPoint() + 0.1

	-- Enemies may run away from us so we don't want to try to calculate exactly what our return interval should
	--	be (e.g. based on the distance and our movespeed), so for larger distances we're just adding a little extra time
	local fDistToEnemy = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local fNearDistance = 800
	local fMediumDistance = 1300
	if fDistToEnemy > fMediumDistance then
		printf( "  enemy is beyond medium distance" )
		fInterval = fInterval + 1.0
	elseif fDistToEnemy > fNearDistance then
		printf( "  enemy is beyond near distance" )
		fInterval = fInterval + 0.5
	end

	return fInterval
	--return 1.2
end

--------------------------------------------------------------------------------

function CastGrab( enemy )
	if enemy == nil or enemy:IsAlive() == false then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = GrabAbility:entindex(),
	})

	local fInterval = GrabAbility:GetCastPoint() + 0.1
	return fInterval
	--return 1.5
end

--------------------------------------------------------------------------------

function CastThrow( vPos )
	local vDir = vPos - thisEntity:GetOrigin()
	local flDist = vDir:Length2D()
	vDir.z = 0.0
	vDir = vDir:Normalized()

	local vFinalPos = vPos
	if flDist < 200 then
		-- The target's too close and we don't want to throw the unit into our feet, so throw it forward instead
		vFinalPos = thisEntity:GetOrigin() + vDir * flDist
	end

	printf( "Casting throw at %s", vPos )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vFinalPos,
		--Position = thisEntity:GetOrigin() + vDir * flDist,
		AbilityIndex = ThrowAbility:entindex(),
		Queue = false,
	})

	local fInterval = ThrowAbility:GetCastPoint() + 0.1
	return fInterval
	--return 1.5
end

--------------------------------------------------------------------------------

function CastAvalanche()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = AvalancheAbility:entindex(),
		Queue = false,
	})

	local fInterval = AvalancheAbility:GetCastPoint() + AvalancheAbility:GetChannelTime() + 0.1
	return fInterval
	--return 11
end

--------------------------------------------------------------------------------

function CastGroundPound()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = GroundPoundAbility:entindex(),
		Queue = false,
	})

	local fInterval = GroundPoundAbility:GetCastPoint() + GroundPoundAbility:GetChannelTime() + 0.1
	return fInterval
	--return 4.0
end
