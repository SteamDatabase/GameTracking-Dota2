
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hStiflingAbility = thisEntity:FindAbilityByName( "bandit_stifling_dagger" )
	thisEntity.hBlinkStrikeAbility = thisEntity:FindAbilityByName( "creature_blink_strike" )

	thisEntity.hStiflingAbility:SetLevel( 4 )
	thisEntity.hBlinkStrikeAbility:SetLevel( 4 )

	thisEntity:SetContextThink( "BanditCaptainThink", BanditCaptainThink, 0.5 )
end

--------------------------------------------------------------------------------

function BanditCaptainThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	-- Get last aggro timestamp
    if ( not thisEntity.bHasAggro ) and thisEntity:GetAggroTarget() then
		thisEntity.timeOfLastAggro = GameRules:GetGameTime()
		thisEntity.bHasAggro = true
	end

	if thisEntity.bHasAggro and ( not thisEntity:GetAggroTarget() ) then
		thisEntity.bHasAggro = false
	end

	if thisEntity.hStiflingAbility ~= nil and thisEntity.hStiflingAbility:IsChanneling() then
		return 0.5
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	-- Categorize our enemies based on distance
	local hMediumDistEnemies = { }

	local hFarthestEnemy = nil
	local fFarthestEnemyDist = 0

	for _, hEnemy in pairs( hEnemies ) do
		local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
		if fDist > fFarthestEnemyDist then
			fFarthestEnemyDist = fDist
			hFarthestEnemy = hEnemy
		end

		if fDist > 300 then
			table.insert( hMediumDistEnemies, hEnemy )
		end
	end

	-- If we've had aggro for a bit, we're willing to launch Stifling Dagger
	local fDelayBeforeStifling = RandomFloat( 2, 4 )
	if thisEntity.timeOfLastAggro and ( GameRules:GetGameTime() > ( thisEntity.timeOfLastAggro + fDelayBeforeStifling ) ) then
		if thisEntity.hStiflingAbility ~= nil and thisEntity.hStiflingAbility:IsFullyCastable() then
			if hFarthestEnemy ~= nil then
				return CastStiflingDagger( hFarthestEnemy )
			else
				return CastStiflingDagger( hEnemies[ RandomInt( 1, #hEnemies ) ] )
			end
		end
	end

	-- If we've had aggro for a bit, we're willing to launch Blink Strike
	local fDelayBeforeBlinkStrike = RandomFloat( 3, 5 )
	if thisEntity.timeOfLastAggro and ( GameRules:GetGameTime() > ( thisEntity.timeOfLastAggro + fDelayBeforeBlinkStrike ) ) then
		if thisEntity.hBlinkStrikeAbility ~= nil and thisEntity.hBlinkStrikeAbility:IsFullyCastable() then
			-- Prefer to blinkstrike onto a unit we're not right next to
			if #hMediumDistEnemies > 0 then
				return CastBlinkStrike( hMediumDistEnemies[ RandomInt( 1, #hMediumDistEnemies ) ] )
			else
				return CastBlinkStrike( hEnemies[ RandomInt( 1, #hEnemies ) ] )
			end
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastStiflingDagger( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hEnemy:GetOrigin(),
		AbilityIndex = thisEntity.hStiflingAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

function CastBlinkStrike( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.hBlinkStrikeAbility:entindex(),
		Queue = false,
	})
	return 5
end

--------------------------------------------------------------------------------

