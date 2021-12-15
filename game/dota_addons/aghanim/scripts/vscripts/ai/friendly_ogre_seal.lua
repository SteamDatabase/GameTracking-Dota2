
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hFlop = thisEntity:FindAbilityByName( "friendly_ogreseal_flop" )
	thisEntity.flSearchRadius = 700

	thisEntity:SetContextThink( "FriendlyOgreSealThink", FriendlyOgreSealThink, 0.5 )
end

--------------------------------------------------------------------------------

function FriendlyOgreSealThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.flSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	for i = #hEnemies, 1, -1 do
		local hEnemy = hEnemies[ i ]
		if hEnemy ~= nil then
			if hEnemy:GetUnitName() == "npc_dota_explosive_barrel" or hEnemy:GetUnitName() == "npc_dota_crate" then
				table.remove( hEnemies, i )
			end
		end
	end

	if #hEnemies == 0 then
		return 0.25
	end

	--printf( "hEnemies > 0" )

	if thisEntity.hFlop ~= nil and thisEntity.hFlop:IsFullyCastable() then
		return CastBellyFlop( hEnemies[ #hEnemies ] )
	end

	return 0.25
end

--------------------------------------------------------------------------------

function CastBellyFlop( enemy )
	printf( "CastBellyFlop" )
	local vToTarget = enemy:GetOrigin() - thisEntity:GetOrigin()
	vToTarget = vToTarget:Normalized()
	local vTargetPos = thisEntity:GetOrigin() + vToTarget * 50

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hFlop:entindex(),
		Position = vTargetPos,
		Queue = false,
	})

	return 4
end

--------------------------------------------------------------------------------
