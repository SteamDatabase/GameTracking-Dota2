--[[ Phantom Lancer AI ]]

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.nMaxSpiritLance = 8
	thisEntity.nSpiritLance = 0
	thisEntity.nMaxDoppelganger = 4
	thisEntity.nDoppelganger = 0
	thisEntity.flRetreatRange = 300
	thisEntity.flAttackRange = 500
	thisEntity.PreviousOrder = "no_order"
	thisEntity.bPatrolled = false

	thisEntity.hSpiritLanceAbility = thisEntity:FindAbilityByName( "aghslab_phantom_lancer_spirit_lance" )
	thisEntity.hDoppelgangerAbility = thisEntity:FindAbilityByName( "aghslab_phantom_lancer_doppelganger" )
	thisEntity:SetInitialGoalEntity( nil )
	thisEntity:SetContextThink( "PhantomLancerThink", PhantomLancerThink, 0.5 )
end

--------------------------------------------------------------------------------------------------------

function PhantomLancerThink()
	--print( "Phantom Lancer Thinking" )
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local nEnemiesRemoved = 0
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		if thisEntity.bPatrolled == false then
			thisEntity.bPatrolled = true
			return Patrol()
		end
		return 0.5
	end


	local hEnemy = enemies[#enemies]
	thisEntity:SetInitialGoalEntity( nil )

	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()

	if thisEntity.nSpiritLance <= thisEntity.nMaxSpiritLance then
		if fDist < 800 then
			if thisEntity.hSpiritLanceAbility ~= nil and thisEntity.hSpiritLanceAbility:IsFullyCastable() then
				return CastSpiritLance( hEnemy )
			end
		end
	end

	if thisEntity.nDoppelganger <= thisEntity.nMaxDoppelganger then
		if fDist < 600 then
			if thisEntity.hDoppelgangerAbility ~= nil and thisEntity.hDoppelgangerAbility:IsFullyCastable() then
				return CastDoppelganger()
			end
		end
	end

	if hEnemy ~= nil and hEnemy:IsAlive() then
		return TargetEnemy( hEnemy )
	end
	
	return 0.5
end

--------------------------------------------------------------------------------------------------------

function CastDoppelganger()
	--print( "Casting Doppelganger" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hDoppelgangerAbility:entindex(),
		Queue = false,
	})
	
	thisEntity.nDoppelganger = thisEntity.nDoppelganger + 1

	thisEntity.PreviousOrder = "doppelganger"

	return 1.0
end

--------------------------------------------------------------------------------

function CastSpiritLance( hEnemy )
	--print( "Casting Spirit Lance" )

	local vTargetPos = hEnemy:GetOrigin()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hSpiritLanceAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "spirit_lance"

	return 1
end

--------------------------------------------------------------------------------------------------------

function Patrol()
	if thisEntity:GetInitialGoalEntity() == nil then
		local hWaypoint = Entities:FindByClassnameNearest( "path_track", thisEntity:GetOrigin(), 2000.0 )
		if hWaypoint ~= nil then
			--print( "Patrolling to " .. hWaypoint:GetName() )
			thisEntity:SetInitialGoalEntity( hWaypoint )
		end
	end

	return 1.0
end

--------------------------------------------------------------------------------

function TargetEnemy( hEnemy )
	local hAttackTarget = nil
	local hApproachTarget = nil

	-- Retreat if close to enemy and did not just retreat
	local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	if flDist < thisEntity.flRetreatRange then
		if ( thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() < thisEntity.fTimeOfLastRetreat + 3 ) ) or ( thisEntity.PreviousOrder == "retreat" ) then
			-- We already retreated recently, so just attack
			return Approach( hEnemy )
		else
			return Retreat( hEnemy )
		end
	end

	-- Attack if within attack range
	if flDist <= thisEntity.flAttackRange then
		return Approach( hEnemy )
	end

	-- Approach if outside of attack range
	if flDist > thisEntity.flAttackRange then
		return Approach( hEnemy )
	end
	
	-- Hold if out of range and has just retreated
	if thisEntity.PreviousOrder ~= "hold_position" then
		thisEntity:FaceTowards( hEnemy:GetOrigin() )
		return HoldPosition()
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Approach( unit )
	--print( "Phantom Lancer - Approach" )

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

function Retreat( unit )
	--print( "Phantom Lancer - Retreat" )

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

	return 1
end

--------------------------------------------------------------------------------

function HoldPosition()
	--print( "Phantom Lancer - Hold Position" )
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

--------------------------------------------------------------------------------------------------------
