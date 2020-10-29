
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hPool = thisEntity:FindAbilityByName( "ghost_pool" )
	thisEntity.flSearchRadius = thisEntity.hPool:GetCastRange( thisEntity:GetOrigin(), nil )

	thisEntity:SetContextThink( "GhostThink", GhostThink, 0.5 )
end

--------------------------------------------------------------------------------

function GhostThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.flSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	if thisEntity.hPool ~= nil and thisEntity.hPool:IsFullyCastable() then
		return CastPool( hEnemies[ #hEnemies ] )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastPool( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hPool:entindex(),
		Position = enemy:GetAbsOrigin(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------
