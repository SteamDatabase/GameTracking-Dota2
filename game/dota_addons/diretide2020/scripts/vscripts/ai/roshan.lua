

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bActive = true
	thisEntity.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
	thisEntity.vHomePos = nil
	thisEntity.nCandyAttackTeam = nil
	thisEntity.vRadiantBucketPos = GameRules.Diretide.vRadiantHomeBucketLocs[1]
	thisEntity.vDireBucketPos = GameRules.Diretide.vDireHomeBucketLocs[1]
	thisEntity:SetContextThink( "RoshanThink", RoshanThink, 0.25 )
end

function RoshanThink()
	if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false or thisEntity.bActive == false then
		return -1
	end
	if thisEntity.vHomePos == nil then
		thisEntity.vHomePos = thisEntity:GetAbsOrigin()
	end
	
	if thisEntity.nCandyAttackTeam ~= nil then
		return CandyAttack( thisEntity.nCandyAttackTeam )
	end

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_NONE then
		return 0.25
	end

	if thisEntity.hTrickOrTreatTarget == nil then
		return ReturnHome()
	end

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_REQUEST then
		return RequestTreat( thisEntity.hTrickOrTreatTarget )
	end

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_ATTACK then
		return TakeTreatByForce( thisEntity.hTrickOrTreatTarget )
	end

	if thisEntity.nTreatMode == ROSHAN_TRICK_OR_TREAT_MODE_RETURN then
		return ReturnHome()
	end

	return ReturnHome()
end

function CandyAttack( nTeamToAttack )
	local vAttackPos = nil
	if nTeamToAttack == DOTA_TEAM_GOODGUYS then
		vAttackPos = thisEntity.vRadiantBucketPos
	else
		vAttackPos = thisEntity.vDireBucketPos
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = vAttackPos,
		Queue = false,
	})
	return 5.0
end

function RequestTreat( hTarget )
	local flDist = ( hTarget:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()
	if flDist > DIRETIDE_ROSHAN_REQUEST_PROXIMITY_DISTANCE - 50 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			TargetIndex = hTarget:entindex(),
			Queue = false,
		})
	end

	return 0.25
end

function TakeTreatByForce( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hTarget:entindex(),
		Queue = false,
	})

	return 0.25
end

function ReturnHome()
	local flDistToHome = ( thisEntity.vHomePos - thisEntity:GetAbsOrigin() ):Length2D() 
	if flDistToHome < 50.0 then
		thisEntity.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
		return 0.25
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vHomePos,
		Queue = false,
	})

	return 0.25
end
