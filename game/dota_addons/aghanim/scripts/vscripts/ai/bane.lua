--[[ Bane AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hBrainSapAbility = thisEntity:FindAbilityByName( "bane_brain_sap" )
	thisEntity.hFiendsGripAbility = thisEntity:FindAbilityByName( "bane_fiends_grip" )
	if thisEntity.hFiendsGripAbility == nil then
		print( 'MISSING bane_fiends_grip on Bane AI' )
	end

	thisEntity.flRetreatRange = 500
	thisEntity.flAttackRange = 400
	thisEntity.flFiendsGripDelayTime = GameRules:GetGameTime() + RandomFloat( 2, 4 )	-- need to live for this long before we can think about casting Fiends Grip
	thisEntity.PreviousOrder = "no_order"

	thisEntity:SetContextThink( "BaneThink", BaneThink, 0.5 )
end

--------------------------------------------------------------------------------

function BaneThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if thisEntity:IsChanneling() then
		return 1
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return HoldPosition()
	end

	local bFiendsGripReady = false
	if GameRules:GetGameTime() > thisEntity.flFiendsGripDelayTime and thisEntity.hFiendsGripAbility ~= nil and thisEntity.hFiendsGripAbility:IsFullyCastable() then
		--print( 'Fiends Grip ready' )
		bFiendsGripReady = true
	end	

	local hBestEnemy = nil
	local hGrippedEnemy = nil

	-- Try to Brain Sap
	if thisEntity.hBrainSapAbility  and thisEntity.hBrainSapAbility:IsFullyCastable() then
		local hTarget = hEnemies[#hEnemies]
		return CastBrainSap( hTarget )
	end

	-- grab the closest enemy from our list, but if our fiends grip is ready make sure we skip over the target if it is stunned
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then

			if bFiendsGripReady == true then
				local hStunModifier = hEnemy:FindModifierByName( "modifier_bane_fiends_grip" )
				if hStunModifier then
					--print( 'skipping over the gripped enemy as our potential target' )
					hGrippedEnemy = hEnemy
					goto continue
				else
					return CastFiendsGrip( hEnemy )
				end
			end

			-- ATTACK/APPROACH target
			return TargetEnemy( hEnemy )
		end

		::continue::
	end

	-- if we're still here then the stunned enemy is the only one that could be a target
	if hGrippedEnemy ~= nil then
		-- ATTACK/APPROACH stunned enemy
		return TargetEnemy( hGrippedEnemy )
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

function CastBrainSap( hEnemy )
	--print( "Bane - CastBrainSap" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.hBrainSapAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "brain_sap"

	return 1
end

--------------------------------------------------------------------------------

function CastFiendsGrip( hEnemy )
	--print( "Bane - CastFiendsGrip" )

	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin() + RandomVector( 100 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.hFiendsGripAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "fiends_grip"

	return 1
end

--------------------------------------------------------------------------------

function Approach(unit)
	--print( "Bane - Approach" )

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
	--print( "Bane - Retreat" )

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
	--print( "Bane - Hold Position" )
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