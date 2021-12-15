--[[ Centaur Warrunner AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hHoofStompAbility = thisEntity:FindAbilityByName( "aghslab_centaur_hoof_stomp" )
	thisEntity.hDoubleEdgeAbility = thisEntity:FindAbilityByName( "aghslab_centaur_double_edge" )
	if thisEntity.hDoubleEdgeAbility == nil then
		print( 'MISSING aghslab_centaur_double_edge on Centaur Warrunner AI' )
	end

	thisEntity.flRetreatRange = 500
	thisEntity.flAttackRange = 400
	thisEntity.flDoubleEdgeDelayTime = GameRules:GetGameTime() + RandomFloat( 6, 12 )	-- need to live for this long before we can think about casting impale
	thisEntity.PreviousOrder = "no_order"

	thisEntity:SetContextThink( "CentaurWarrunnerThink", CentaurWarrunnerThink, 0.5 )
end

--------------------------------------------------------------------------------

function CentaurWarrunnerThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if thisEntity.PreviousOrder == "double_edge" then
		return HoldPosition()
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return HoldPosition()
	end

	-- Try to Hoof Stomp
	if thisEntity.hHoofStompAbility  and thisEntity.hHoofStompAbility:IsFullyCastable() then
		local hEnemiesInRange = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemiesInRange > 0 then
			return CastHoofStomp()
		end
	end

	local bDoubleEdgeReady = false
	if GameRules:GetGameTime() > thisEntity.flDoubleEdgeDelayTime and thisEntity.hDoubleEdgeAbility ~= nil and thisEntity.hDoubleEdgeAbility:IsFullyCastable() then
		bDoubleEdgeReady = true
	end	

	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			if bDoubleEdgeReady == true then
				return CastDoubleEdge( hEnemy )
			else
				return TargetEnemy( hEnemy )
			end
		end
	end

	return 0.5
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

function CastHoofStomp()
	--print( "Centaur Warrunner - CastHoofStomp" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hHoofStompAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "hoof_stomp"

	return 1
end

--------------------------------------------------------------------------------

function CastDoubleEdge( hEnemy )
	--print( "Centaur Warrunner - CastDoubleEdge" )

	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin() + RandomVector( 100 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hDoubleEdgeAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "double_edge"

	return 1
end

--------------------------------------------------------------------------------

function Approach(unit)
	--print( "Centaur Warrunner - Approach" )

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
	--print( "Centaur Warrunner - Retreat" )

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
	--print( "Centaur Warrunner - Hold Position" )
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