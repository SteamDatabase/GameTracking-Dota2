
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	--thisEntity.hRangedAttackAbility = thisEntity:FindAbilityByName( "polarity_ranged_attack_positive" )
	--if thisEntity.hRangedAttackAbility == nil then
	--	thisEntity.hRangedAttackAbility = thisEntity:FindAbilityByName( "polarity_ranged_attack_negative" )
	--end

	--if thisEntity.hRangedAttackAbility == nil then
	--	print( 'ERROR - MISSING polarity_ranged_attack_X on polarity ghost ai' )
	--end

	thisEntity.flRetreatRange = 200
	thisEntity.flAttackRange = 450
	thisEntity.flRangedAttackDelayTime = GameRules:GetGameTime() + RandomFloat( 2, 5 )	-- need to live for this long before we can think about casting
	thisEntity.PreviousOrder = "no_order"

	thisEntity:SetContextThink( "PolarityGhostThink", PolarityGhostThink, 0.5 )
end

--------------------------------------------------------------------------------

function PolarityGhostThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return HoldPosition()
	end

	--local bRangedAttackReady = false
	--if GameRules:GetGameTime() > thisEntity.flRangedAttackDelayTime and thisEntity.hRangedAttackAbility ~= nil and thisEntity.hRangedAttackAbility:IsFullyCastable() then
	--	bRangedAttackReady = true
	--end	

	-- grab the closest enemy from our list
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then

			--if bRangedAttackReady == true then
			--	return CastRangedAttack( hEnemy )
			--end

			-- ATTACK/APPROACH target
			return TargetEnemy( hEnemy )
		end
	end

	return HoldPosition()
end

--------------------------------------------------------------------------------

function TargetEnemy( hEnemy )
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

function CastRangedAttack( hEnemy )
	--print( "ai_polarity_ghost - CastDisruption" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hEnemy:GetOrigin(),
		AbilityIndex = thisEntity.hRangedAttackAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "ranged_attack"

	return 1
end

--------------------------------------------------------------------------------

function Approach(unit)
	--print( "ai_polarity_ghost - Approach" )

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})

	thisEntity.PreviousOrder = "approach"

	return 1
end

--------------------------------------------------------------------------------

function Retreat(unit)
	--print( "ai_polarity_ghost - Retreat" )

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
	--print( "ai_polarity_ghost - Hold Position" )
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