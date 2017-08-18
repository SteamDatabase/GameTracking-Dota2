
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hChainFrost = thisEntity:FindAbilityByName( "lich_chain_frost" )
	thisEntity.hHex = thisEntity:FindAbilityByName( "ice_giant_hex" )

	thisEntity.fSearchRadius = thisEntity:GetAcquisitionRange()

	thisEntity:SetContextThink( "IceGiantThink", IceGiantThink, 1 )
end

--------------------------------------------------------------------------------

function IceGiantThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

	if #hEnemies == 0 then
		return 1
	end

	-- Increase acquisition range after the initial aggro
	if ( not thisEntity.bAcqRangeModified ) and #hEnemies > 0 then
		SetAggroRange( thisEntity, 850 )
		thisEntity.fInitialAggroTime = GameRules:GetGameTime()
	end

	if thisEntity.fInitialAggroTime and ( GameRules:GetGameTime() > thisEntity.fInitialAggroTime + RandomInt( 2, 6 ) ) then
		local hDesiredTarget = hEnemies[ RandomInt( 1, #hEnemies ) ]
		local hEnemiesNearTarget = FindUnitsInRadius( thisEntity:GetTeamNumber(), hDesiredTarget:GetOrigin(), nil, 425, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		if #hEnemiesNearTarget >= 2 then -- hDesiredTarget itself is found by FindUnitsInRadius
			if thisEntity.hChainFrost ~= nil and thisEntity.hChainFrost:IsFullyCastable() then
				return CastChainFrost( hDesiredTarget )
			end
		end
	end

	local hHexTargets = { }
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsRealHero() then
			local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if fDist > 500 then
				table.insert( hHexTargets, hEnemy )
			end
		end
	end

	-- Cast Hex on someone far away
	if thisEntity.hHex ~= nil and thisEntity.hHex:IsFullyCastable() then
		if #hHexTargets > 0 then
			return CastHex( hHexTargets[ RandomInt( 1, #hHexTargets ) ] )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastHex( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hHex:entindex(),
		Position = hEnemy:GetOrigin(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function CastChainFrost( hEnemy )
	if hEnemy == nil then
		return 1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.hChainFrost:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

