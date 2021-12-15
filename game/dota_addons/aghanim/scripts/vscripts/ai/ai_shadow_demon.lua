
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	--thisEntity.hShadowPoisonAbility = thisEntity:FindAbilityByName( "aghsfort_shadow_demon_shadow_poison" )
	thisEntity.hDisruptionAbility = thisEntity:FindAbilityByName( "aghsfort_shadow_demon_disruption" )
	if thisEntity.hDisruptionAbility == nil then
		print( 'MISSING aghsfort_shadow_demon_disruption on shadow demon ai' )
	end

	thisEntity.flRetreatRange = 500
	thisEntity.flAttackRange = 850
	thisEntity.flDisruptionDelayTime = GameRules:GetGameTime() + RandomFloat( 7, 12 )	-- need to live for this long before we can think about casting disruption
	thisEntity.PreviousOrder = "no_order"

	thisEntity:SetContextThink( "ShadowDemonThink", ShadowDemonThink, 0.5 )
end

--------------------------------------------------------------------------------

function ShadowDemonThink()
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

	local bDisruptionReady = false
	if GameRules:GetGameTime() > thisEntity.flDisruptionDelayTime and thisEntity.hDisruptionAbility ~= nil and thisEntity.hDisruptionAbility:IsFullyCastable() then
		--print( 'Disruption ready' )
		bDisruptionReady = true
	end	

	local hBestEnemy = nil
	local hDoomedEnemy = nil

	-- grab the closest enemy from our list, but if our disruption is ready make sure we skip over the target if it is DOOMED
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then

			if bDisruptionReady == true then
				local hDoomBuff = hEnemy:FindModifierByName( "modifier_doom_bringer_doom" )
				if hDoomBuff then
					print( 'skipping over the DOOMED enemy as our potential target' )
					hDoomedEnemy = hEnemy
					goto continue
				else
					return CastDisruption( hEnemy )
				end
			end

			-- ATTACK/APPROACH target
			return TargetEnemy( hEnemy )
		end

		::continue::
	end

	-- if we're still here then the doomed enemy is the only one that could be a target
	if hDoomedEnemy ~= nil then
		-- ATTACK/APPROACH doomed enemy
		return TargetEnemy( hDoomedEnemy )
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

function CastPoison( hEnemy )
	--print( "ai_shadow_demon - CastPoison" )

	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin()
--[[
	if ( fDist > 400 ) and hEnemy and hEnemy:IsMoving() then
		local vLeadingOffset = hEnemy:GetForwardVector() * RandomInt( 200, 400 )
		vTargetPos = hEnemy:GetOrigin() + vLeadingOffset
	end
--]]
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hShadowPoisonAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "poison"

	return 1
end

--------------------------------------------------------------------------------

function CastDisruption( hEnemy )
	--print( "ai_shadow_demon - CastDisruption" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.hDisruptionAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "disruption"

	return 1
end

--------------------------------------------------------------------------------

function Approach(unit)
	--print( "ai_shadow_demon - Approach" )

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
	--print( "ai_shadow_demon - Retreat" )

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
	--print( "ai_shadow_demon - Hold Position" )
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