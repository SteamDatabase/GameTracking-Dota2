
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hArrowAbility = thisEntity:FindAbilityByName( "bandit_archer_arrow" )

	thisEntity:SetContextThink( "BanditArcherThink", BanditArcherThink, 0.5 )
end

--------------------------------------------------------------------------------

function BanditArcherThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	local hAttackTarget = nil
	local hApproachTarget = nil
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then --and hEnemy:GetUnitName() ~= "npc_dota_friendly_bristleback_son" 
			local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then
				if ( thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() < thisEntity.fTimeOfLastRetreat + 3 ) ) then
					-- We already retreated recently, so just attack
					hAttackTarget = hEnemy
				else
					return Retreat( hEnemy )
				end
			end
			if flDist <= 1200 then
				hAttackTarget = hEnemy
			end
			if flDist > 1200 then
				hApproachTarget = hEnemy
			end
		end
	end

	if hAttackTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	if hAttackTarget and thisEntity.hArrowAbility ~= nil and thisEntity.hArrowAbility:IsFullyCastable() then
		return CastArrow( hAttackTarget )
	end

	if hAttackTarget then
		thisEntity:FaceTowards( hAttackTarget:GetOrigin() )
		return 1.0
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastArrow( hEnemy )
	--print( "ai_bandit_archer - CastArrow" )

	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin()

	if ( fDist > 400 ) and hEnemy and hEnemy:IsMoving() then
		local vLeadingOffset = hEnemy:GetForwardVector() * RandomInt( 200, 400 )
		vTargetPos = hEnemy:GetOrigin() + vLeadingOffset
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hArrowAbility:entindex(),
		Queue = false,
	})

	return 2
end

--------------------------------------------------------------------------------

function Approach(unit)
	--print( "ai_bandit_archer - Approach" )

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})

	return 1
end

--------------------------------------------------------------------------------

function Retreat(unit)
	--print( "ai_bandit_archer - Retreat" )

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

	return 1.25
end

--------------------------------------------------------------------------------

