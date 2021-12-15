--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bRetreating = false
	thisEntity.nLeashRange = 1100
	thisEntity.nMaintainRange = 400

	thisEntity:SetContextThink( "OnBucketSoldierThink", OnBucketSoldierThink, 1 )
end

-----------------------------------------------------------------------------------------

function OnBucketSoldierThink()
	if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false then
		return -1
	end

	if thisEntity.bInitialized == nil then
		thisEntity.bInitialized = true

		--print( 'SEARCHING FOR CANDY WELL' )
		thisEntity.vBucketPos = thisEntity:GetAbsOrigin()
		local hAllies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_UNITS_EVERYWHERE, false )
		--print( 'FOUND ALLIES = ' .. #hAllies )
		if #hAllies > 0 then
			for _,ally in pairs( hAllies ) do
				if ally:GetUnitName() == "npc_dota_building_candy_well" then
					--print( "Candy Well Found" )
					thisEntity.vBucketPos = ally:GetAbsOrigin()
				end
			end
		end
	end

	local flDist = ( thisEntity.vBucketPos - thisEntity:GetAbsOrigin() ):Length2D()
	--print( 'DISTANCE FROM HOME = ' .. flDist )

	if thisEntity.bRetreating == true then
		if flDist > thisEntity.nMaintainRange then
			return ReturnToBucket()
		else
			thisEntity.bRetreating = false
		end
	end

	if flDist > thisEntity.nLeashRange then
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

				print( "bucket_soldier - SetAggroTarget on " .. hEnemy:GetUnitName() )
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
	--print( '^^^ Returning to Bucket!' )

	thisEntity.bRetreating = true

	thisEntity:SetInitialGoalEntity( nil )	-- need to break this for the forced movements to work

	--DebugDrawSphere( thisEntity.vBucketPos, Vector( 255, 255, 0 ), 1.0, 50, false, 1.25 )
	--local flDist = ( vTargetPos - thisEntity:GetAbsOrigin() ):Length2D()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vBucketPos,
		Queue = false,
	})

	return 1.0
end

-----------------------------------------------------------------------------------------

function PatrolBucket()
	local vTargetPos = thisEntity.vBucketPos + RandomVector( RandomInt( thisEntity.nMaintainRange / 2, thisEntity.nMaintainRange ) )
	--DebugDrawSphere( vTargetPos, Vector( 255, 255, 0 ), 1.0, 50, false, 1.25 )
	--local flDist = ( vTargetPos - thisEntity:GetAbsOrigin() ):Length2D()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = vTargetPos,
		Queue = false,
	})

	return 2.0
end

-----------------------------------------------------------------------------------------
