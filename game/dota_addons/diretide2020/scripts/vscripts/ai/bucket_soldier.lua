function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "OnBucketSoldierThink", OnBucketSoldierThink, 1 )
end

-----------------------------------------------------------------------------------------

function OnBucketSoldierThink()
	if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false then
		return -1
	end

	if thisEntity.hBucket == nil or thisEntity.hBucket:IsNull() then
		return 1
	end

	local flDist = ( thisEntity.hBucket:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()
	if flDist > DIRETIDE_BUCKET_SOLDIER_LEASH_RANGE then
		return ReturnToBucket()
	end

	-- Prioritize hero enemies
	if thisEntity:GetAggroTarget() == nil or ( thisEntity:GetAggroTarget() ~= nil and thisEntity:GetAggroTarget():IsHero() == false ) then
		local fSearchRadius = thisEntity:GetAcquisitionRange()
		local hEnemyHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		for _, hEnemy in pairs( hEnemyHeroes ) do
			if hEnemy ~= nil and hEnemy:IsNull() == false and ( not hEnemy:IsInvulnerable() ) then
				thisEntity:SetAggroTarget( hEnemy )

				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					TargetIndex = hEnemy:entindex(),
					Queue = false,
				})

				--print( "bucket_soldier - SetAggroTarget on " .. hEnemy:GetUnitName() )
				return 0.5
			end
		end
	end

	if thisEntity:GetAggroTarget() == nil then
		return PatrolBucket()
	end

	return 0.5
end

-----------------------------------------------------------------------------------------

function ReturnToBucket()
	local vTargetPos = thisEntity.hBucket:GetAbsOrigin() + RandomVector( RandomInt( 50, DIRETIDE_BUCKET_SOLDIER_MAINTAIN_RANGE ) )
	local flDist = ( vTargetPos - thisEntity:GetAbsOrigin() ):Length2D()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vTargetPos,
		Queue = false,
	})

	return flDist / thisEntity:GetIdealSpeed()
end

-----------------------------------------------------------------------------------------

function PatrolBucket()
	local vTargetPos = thisEntity.hBucket:GetAbsOrigin() + RandomVector( RandomInt( 50, DIRETIDE_BUCKET_SOLDIER_MAINTAIN_RANGE ) )
	local flDist = ( vTargetPos - thisEntity:GetAbsOrigin() ):Length2D()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = vTargetPos,
		Queue = false,
	})

	return ( flDist / thisEntity:GetIdealSpeed() ) + RandomInt( 3.0, 10.0 )
end

-----------------------------------------------------------------------------------------