
--[[ units/ai/ai_centaur_dunerunner.lua ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hDoubleEdgeAbility = thisEntity:FindAbilityByName( "centaur_dunerunner_double_edge" )
	thisEntity.hEarthbindAbility = thisEntity:FindAbilityByName( "dunerunner_earthbind" )

	thisEntity:SetContextThink( "CentaurDunerunnerThink", CentaurDunerunnerThink, 0.5 )
end

--------------------------------------------------------------------------------

function CentaurDunerunnerThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	-- @todo: Make Dunerunner either run away after netting or follow-up the net with some other move
	if thisEntity.hEarthbindAbility ~= nil and thisEntity.hEarthbindAbility:IsFullyCastable() then
		return CastEarthbind( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end

	--[[
	local hAggroTarget = thisEntity:GetAggroTarget()
	local fDistToAggroTarget = nil
	if hAggroTarget then
		fDistToAggroTarget = ( hAggroTarget:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	end

	if fDistToAggroTarget < 150 then
		if thisEntity.hDoubleEdgeAbility ~= nil and thisEntity.hDoubleEdgeAbility:IsFullyCastable() then
			return CastDoubleEdge( hAggroTarget )
		end
	end
	]]

	return 0.5
end

--------------------------------------------------------------------------------

function CastDoubleEdge( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hDoubleEdgeAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

function CastEarthbind( hEnemy )
	local vEnemySpeed = hEnemy:GetBaseMoveSpeed()
	local vEnemyForward = hEnemy:GetForwardVector()
	local vPos = nil
	if hEnemy:IsMoving() then
		vPos = hEnemy:GetOrigin() + ( vEnemyForward * vEnemySpeed )
	else
		vPos = hEnemy:GetOrigin()
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPos,
		AbilityIndex = thisEntity.hEarthbindAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

