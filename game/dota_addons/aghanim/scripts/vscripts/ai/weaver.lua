--[[ Weaver AI ]]

require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hShukuchiAbility = thisEntity:FindAbilityByName( "weaver_shukuchi" )
	if thisEntity.hShukuchiAbility == nil then
		print( 'MISSING weaver_shukuchi on Weaver AI' )
	end

	thisEntity.hBugBombAbility = thisEntity:FindAbilityByName( "weaver_bug_bomb" )
	if thisEntity.hBugBombAbility == nil then
		print( 'MISSING weaver_bug_bomb on Weaver AI' )
	end

	thisEntity.flRetreatRange = 500
	thisEntity.flAttackRange = 800
	thisEntity.vSpawnPos = thisEntity:GetAbsOrigin()
	thisEntity.PreviousOrder = "no_order"

	thisEntity:SetContextThink( "WeaverThink", WeaverThink, 0.5 )
end

--------------------------------------------------------------------------------

function WeaverThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		local hEnemyUnits = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 4000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #hEnemyUnits > 0 then
			local hEnemyUnit = hEnemyUnits[1]
			return TargetEnemy( hEnemyUnit )
		end
		return HoldPosition()
	end

	if thisEntity.hShukuchiAbility ~= nil and thisEntity.hShukuchiAbility:IsFullyCastable() then
		--print( 'Shukuchi ready' )
		if thisEntity.PreviousOrder ~= nil and thisEntity.PreviousOrder ~= "shukuchi" then
			if ( thisEntity:GetHealthPercent() < 50 ) then
				return CastShukuchi()
			end
		end
	end	

	if thisEntity.hBugBombAbility ~= nil and thisEntity.hBugBombAbility:IsFullyCastable() then
		--print( 'Bug Bomb ready' )
		for _, hEnemy in pairs( hEnemies ) do
			if hEnemy ~= nil and hEnemy:IsAlive() then
				local vEnemyPos = hEnemy:GetOrigin()
				local flDist = ( vEnemyPos - thisEntity:GetOrigin() ):Length2D()
				if flDist > 500 then
					return CastBugBomb( vEnemyPos )
				else
					return Retreat( hEnemy )
				end
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
		--[[else
			return Retreat( hEnemy )]]
		end
	end

	if flDist <= thisEntity.flAttackRange then
		hAttackTarget = hEnemy
	end
	if flDist > thisEntity.flAttackRange then
		hApproachTarget = hEnemy
	end

	if hAttackTarget == nil and hApproachTarget ~= nil and thisEntity.PreviousOrder ~= "approach" then
		return Approach( hApproachTarget )
	end

	if hAttackTarget then
		thisEntity:FaceTowards( hAttackTarget:GetOrigin() )
		return HoldPosition()
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastShukuchi()
	--print( "Weaver - CastShukuchi" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hShukuchiAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "shukuchi"

	return 1
end

--------------------------------------------------------------------------------

function CastBugBomb( vPos )
	--print( "Weaver - CastBugBomb" )

	local vTargetPos = vPos + RandomVector( 100 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hBugBombAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "bug_bomb"

	return 1
end

--------------------------------------------------------------------------------

function Approach( unit )
	--print( "Weaver - Approach" )
	--[[
	local vToEnemy = ( unit:GetOrigin() - thisEntity:GetOrigin() ) - 500
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	]]
	thisEntity:MoveToPositionAggressive( unit:GetAbsOrigin() )

	thisEntity.PreviousOrder = "approach"

	return 1
end

--------------------------------------------------------------------------------

function Retreat( unit )
	--print( "Weaver - Retreat" )
	local objectives = Entities:FindAllByName( "objective" )
	local vObjective = nil
	if #objectives > 0 then
		local hObjective = objectives[1]
		vObjective = hObjective:GetAbsOrigin() + RandomVector( RandomFloat( 0, 500 ) )
	else
		local nRandomPos = RandomInt(1,2)
		if nRandomPos == 1 then
			vObjective = unit:GetAbsOrigin() + RandomVector( RandomFloat( 0, 500 ) )
		else
			vObjective = thisEntity.vSpawnPos
		end
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vObjective
	})

	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	thisEntity.PreviousOrder = "retreat"

	return 1.25
end

--------------------------------------------------------------------------------

function HoldPosition()
	--print( "Weaver - Hold Position" )
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