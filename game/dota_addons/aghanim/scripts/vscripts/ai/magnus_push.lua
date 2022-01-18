--[[ Magnus Push AI ]]

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.flRetreatRange = 300
	thisEntity.flAttackRange = 500
	thisEntity.PreviousOrder = "no_order"

	thisEntity.hSkewerAbility = thisEntity:FindAbilityByName( "creature_magnus_push_skewer" )
	thisEntity.hHornTossAbility = thisEntity:FindAbilityByName( "magnus_push_horn_toss" )
	thisEntity.bPatrolled = false
	thisEntity.flHornTossDelayTime = GameRules:GetGameTime() + RandomFloat( 1, 3 )	-- need to live for this long before we can think about casting impale
	
	thisEntity:SetInitialGoalEntity( nil )
	thisEntity.nAbilityListener1 = ListenToGameEvent( "dota_player_begin_cast", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnNonPlayerBeginCastAbility' ), nil )
	thisEntity.nAbilityListener2 = ListenToGameEvent( "dota_non_player_begin_cast", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnNonPlayerBeginCastAbility' ), nil )
	thisEntity:SetContextThink( "MagnusThink", MagnusThink, 2.0 )
end

--------------------------------------------------------------------------------------------------------

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.nAbilityListener1 )
	StopListeningToGameEvent( thisEntity.nAbilityListener2 )
end

--------------------------------------------------------------------------------------------------------

function MagnusThink()
	--print( "Magnus Thinking" )
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
	
	if hEnemy ~= nil and hEnemy:IsAlive() then
		local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()

		local bHornTossReady = false
		if GameRules:GetGameTime() > thisEntity.flHornTossDelayTime and thisEntity.hHornTossAbility ~= nil and thisEntity.hHornTossAbility:IsFullyCastable() then
			bHornTossReady = true
		end	

		if bHornTossReady == true then
			return CastHornToss( hEnemy )
		else
			return TargetEnemy( hEnemy )
		end
	end
	return 0.5
end


--------------------------------------------------------------------------------------------------------

function OnNonPlayerBeginCastAbility( event )
	local hCaster = nil
	if event.caster_entindex ~= nil and event.abilityname ~= nil then
		hCaster = EntIndexToHScript( event.caster_entindex )
		--If some other magnus within 400 range is using horn toss, wait a little bit before using it ourselves
		if event.abilityname == "magnus_push_horn_toss" then
			if hCaster ~= thisEntity and (hCaster:GetOrigin() - thisEntity:GetOrigin() ):Length2D() < 400 then 
				thisEntity.flHornTossDelayTime = GameRules:GetGameTime() + RandomFloat(2,4)
				--print('Delay horn toss')
			end
		end
	end
end


--------------------------------------------------------------------------------

function CastHornToss( hEnemy )
	--print( "Casting Horn Toss" )

	local vTargetPos = hEnemy:GetOrigin()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hHornTossAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "horntoss"

	return 4
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
	-- Do not retreat if we're above 50% HP
	local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	if flDist < thisEntity.flRetreatRange and thisEntity:GetHealthPercent() < 50 then
		if ( thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() < thisEntity.fTimeOfLastRetreat + 6 ) ) or ( thisEntity.PreviousOrder == "retreat" ) then
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
	--print( "Magnus - Approach" )

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
	--print( "Magnus - Retreat" )

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
	--print( "Magnus - Hold Position" )
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
