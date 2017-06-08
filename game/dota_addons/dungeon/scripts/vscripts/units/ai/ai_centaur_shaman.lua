
--[[ units/ai/ai_centaur_shaman.lua ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hSpawnedUnits = { }
	thisEntity.nMaxSpawns = 12

	thisEntity.hRangedAttackAbility = thisEntity:FindAbilityByName( "centaur_shaman_ranged_attack" )
	thisEntity.hShadowWordAbility = thisEntity:FindAbilityByName( "centaur_shaman_shadow_word" )

	thisEntity:SetContextThink( "CentaurShamanThink", CentaurShamanThink, 0.5 )
end

--------------------------------------------------------------------------------

function CentaurShamanThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	-- Clean up our spawned units list if necessary
	for i, hSpawnedUnit in ipairs( thisEntity.hSpawnedUnits ) do
		if hSpawnedUnit:IsNull() or ( not hSpawnedUnit:IsAlive() ) then
			table.remove( thisEntity.hSpawnedUnits, i )
		end
	end

	-- Find our Warlord master
	if ( not thisEntity.hMaster ) or thisEntity.hMaster:IsNull() then
		local hCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 1000 )
		local hWarlords = {}
		for _, hCreature in pairs( hCreatures ) do
			if ( hCreature:GetUnitName() == "npc_dota_creature_centaur_warlord" ) and hCreature:IsNull() == false and hCreature:IsAlive() then
				table.insert( hWarlords, hCreature )
			end
		end
		thisEntity.hMaster = hWarlords[ 1 ]
	end

	if thisEntity.hMaster and thisEntity.hMaster:IsAlive() and thisEntity.hMaster:IsNull() == false then
		-- Are we too far from master?
		local fDist = ( thisEntity.hMaster:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
		if fDist > 700 then
			return RunToMaster()
		end

		if thisEntity.hShadowWordAbility ~= nil and thisEntity.hShadowWordAbility:IsFullyCastable() then
			local nHealthDelta = thisEntity.hMaster:GetHealthPercent() - thisEntity:GetHealthPercent()
			-- Heal ourselves if we need it more than master
			if nHealthDelta > 20 then
				return CastShadowWord( thisEntity )
			end

			if ( thisEntity.hMaster:GetHealthPercent() < 100 ) then
				return CastShadowWord( thisEntity.hMaster )
			end
		end
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	-- Evaluate what we should do based on distance to enemy
	local hRangedAttackTarget = nil
	local hApproachTarget = nil
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if fDist < 300 then
				return Retreat( hEnemy )
			end
			if fDist <= 750 then
				hRangedAttackTarget = hEnemy
			end
			if fDist > 750 then
				hApproachTarget = hEnemy
			end
		end
	end

	if hRangedAttackTarget and hRangedAttackTarget:IsAlive() then
		if thisEntity.hRangedAttackAbility ~= nil and thisEntity.hRangedAttackAbility:IsFullyCastable() then
			return CastRangedAttack( hRangedAttackTarget )
		else
			-- We're not ready to cast ranged attack, so instead of idling let's just run around a bit
			return RunAround( hRangedAttackTarget )
		end
	end

	if hRangedAttackTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	thisEntity:FaceTowards( hAttackTarget:GetOrigin() )

	return 0.5
end

--------------------------------------------------------------------------------

function RunToMaster()
	--print( "Centaur Shaman - RunToMaster()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.hMaster:GetOrigin(),
		Queue = false,
	})
	return 1
end

--------------------------------------------------------------------------------

function Retreat( hEnemy )
	--print( "Centaur Shaman - Retreat()" )
	local vAwayFromEnemy = thisEntity:GetOrigin() - hEnemy:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()
	})
	return 1.25
end

--------------------------------------------------------------------------------

function Approach( hUnit )
	--print( "Centaur Shaman - Approach()" )
	local vToEnemy = hUnit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
end

--------------------------------------------------------------------------------

function RunAround( hEnemy )
	--print( "Centaur Shaman - RunAround()" )
	local vRunDestination = hEnemy:GetOrigin() + RandomVector( RandomFloat( 300, 450 ) )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vRunDestination
	})
	return 1
end

--------------------------------------------------------------------------------

function CastRangedAttack( hEnemy )
	--print( "Centaur Shaman - CastRangedAttack()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hRangedAttackAbility:entindex(),
		Position = hEnemy:GetOrigin(),
		Queue = false,
	})
	return 1
end

--------------------------------------------------------------------------------

function CastShadowWord( hUnit )
	--print( "Centaur Shaman - CastShadowWord()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hUnit:entindex(),
		AbilityIndex = thisEntity.hShadowWordAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

--[[
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
]]

--------------------------------------------------------------------------------

