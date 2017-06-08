--[[ units/ai/ai_lycan_boss.lua ]]

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	thisEntity.LYCAN_BOSS_SUMMONED_UNITS = { }
	thisEntity.LYCAN_BOSS_MAX_SUMMONS = 50
	thisEntity.nCAST_SUMMON_WOLVES_COUNT = 0

	hSummonWolvesAbility = thisEntity:FindAbilityByName( "lycan_boss_summon_wolves" )
	hShapeshiftAbility = thisEntity:FindAbilityByName( "lycan_boss_shapeshift" )
	hClawLungeAbility = thisEntity:FindAbilityByName( "lycan_boss_claw_lunge" )
	hClawAttackAbility = thisEntity:FindAbilityByName( "lycan_boss_claw_attack" )
	hRuptureBallAbility = thisEntity:FindAbilityByName( "lycan_boss_rupture_ball" )

	hSpawner = Entities:FindByName( nil, "forest_holdout_spawner_chief_vip" )

	thisEntity:SetContextThink( "LycanBossThink", LycanBossThink, 1 )
	--thisEntity:SetContextThink( "LycanBoss_AttackMove", LycanBoss_AttackMove, 0.5 )
end


function LycanBossThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return MoveToTarget()
	end

	thisEntity.bShapeshift = thisEntity:FindModifierByName( "modifier_lycan_boss_shapeshift" ) ~= nil
	if thisEntity.bShapeshift then
		if hClawLungeAbility ~= nil and hClawLungeAbility:IsFullyCastable() then
			return CastClawLunge( hEnemies[ RandomInt( 1, #hEnemies ) ] )
		end
	else
		if thisEntity:GetHealthPercent() < 50 then
			if hShapeshiftAbility:IsFullyCastable() then
				return CastShapeshift()
			end
		end
	end

	-- Check that the children we have in our list are still valid
	for i, hSummonedUnit in ipairs( thisEntity.LYCAN_BOSS_SUMMONED_UNITS ) do
		if hSummonedUnit == nil or hSummonedUnit:IsNull() or hSummonedUnit:IsAlive() == false then
			table.remove( thisEntity.LYCAN_BOSS_SUMMONED_UNITS, i )
		end
	end

	-- Have we hit our minion limit?
	if #thisEntity.LYCAN_BOSS_SUMMONED_UNITS < thisEntity.LYCAN_BOSS_MAX_SUMMONS then
		if hSummonWolvesAbility ~= nil and hSummonWolvesAbility:IsFullyCastable() then
			return CastSummonWolves()
		end
	end

	local hRuptureTargets = { }
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsRealHero() and ( hEnemy:GetUnitName() ~= "npc_dota_forest_camp_chief" ) then
			local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist > 500 then
				table.insert( hRuptureTargets, hEnemy )
			end
		end
	end

	-- Cast Rupture Ball on someone far away
	if hRuptureBallAbility ~= nil and hRuptureBallAbility:IsFullyCastable() then
		if #hRuptureTargets > 0 then
			return CastRuptureBall( hRuptureTargets[ RandomInt( 1, #hRuptureTargets ) ] )
		end
	end

	if hClawAttackAbility ~= nil and hClawAttackAbility:IsFullyCastable() then
		if #hEnemies > 1 and hEnemies[1]:GetUnitName() == "npc_dota_forest_camp_chief" then
			return CastClawAttack( hEnemies[ 2 ] )
		end
		return CastClawAttack( hEnemies[ 1 ] ) 
	end

	return 0.5
end


function MoveToTarget()
	if hSpawner == nil then
		print ( "Lycan doesn't know where target is" )
		return
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hSpawner:GetOrigin()
	})
	return 1
end


function CastClawAttack( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = hClawAttackAbility:entindex(),
	})

	return 1.00
end

function CastClawLunge( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hClawLungeAbility:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 0.5
end

function CastSummonWolves()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hSummonWolvesAbility:entindex(),
	})

	return 0.6
end


function CastShapeshift()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hShapeshiftAbility:entindex(),
	})

	return 1
end

function CastRuptureBall( unit )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hRuptureBallAbility:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})

	return 1
end
