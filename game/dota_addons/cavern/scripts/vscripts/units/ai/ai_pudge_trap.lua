
function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		hHookAbility = thisEntity:FindAbilityByName( "pudge_meat_hook_lua" )

		thisEntity:AddNewModifier( thisEntity, nil, "modifier_rooted", {} )
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_invulnerable", {} )

		thisEntity:SetContextThink( "PudgeThink", PudgeThink, 1 )
	end
end


function PudgeThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	if not thisEntity.bInitialized then
		local nLevel = thisEntity.hRoom:GetRoomLevel()
		hHookAbility:SetLevel( nLevel )
		thisEntity.bInitialized = true
	end

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_rooted", {} )

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	for i = #enemies,1,-1 do
		if enemies[i].Room ~= thisEntity.Room or enemies[i]:CanEntityBeSeenByMyTeam( thisEntity ) == false then
			table.remove( enemies, i )
		end
	end

	if #enemies == 0 then
		return RandomFloat( 0.5, 1.0 )
	end

	if RandomInt( 0, 1 ) == 1 then
		return Patrol()
	end

	local hTarget = thisEntity:GetAggroTarget()
	if hTarget then
		if ( thisEntity:GetAbsOrigin() - hTarget:GetAbsOrigin() ):Length2D() < 300 then
			return RandomFloat( 0.5, 1.0 )
		end
	end

	if ( thisEntity.timeOfLastHook == nil ) or ( GameRules:GetGameTime() > thisEntity.timeOfLastHook + 5 ) then
		return CastHook( enemies[ RandomInt( 1, #enemies ) ] )
	end

	return RandomFloat( 0.5, 1.0 )
end


function CastHook( enemy )
	local vEnemyPos = enemy:GetAbsOrigin()
	local vEnemyFacing = enemy:GetForwardVector()
	local vHookTargetPos = vEnemyPos

	if enemy:IsMoving() then
		local bGuessPlayerWillJuke = RandomFloat( 0, 1 ) > 0.7
		if bGuessPlayerWillJuke then
			vHookTargetPos = vEnemyPos
		else
			local nRandomDistance = RandomInt( 150, 350 )
			vHookTargetPos = vEnemyPos + ( vEnemyFacing * nRandomDistance )
		end
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hHookAbility:entindex(),
		Position = vHookTargetPos,
	})

	thisEntity.timeOfLastHook = GameRules:GetGameTime()
	return RandomFloat( 0.5, 1.0 )
end


function Patrol()
	thisEntity:RemoveModifierByName( "modifier_rooted" )
	local vPatrolPos = nil
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + RandomVector( 75 )
	})
	return RandomFloat( 0.5, 1.0 )
end