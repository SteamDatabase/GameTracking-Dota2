
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hTimeWalkAbility = thisEntity:FindAbilityByName( "creature_faceless_void_time_walk" )

	thisEntity:SetContextThink( "Faceless_Void_Jump_Think", Faceless_Void_Jump_Think, 0.5 )
end

--------------------------------------------------------------------------------

function Faceless_Void_Jump_Think()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity.hTimeWalkAbility and thisEntity.hTimeWalkAbility:IsFullyCastable() then
		if thisEntity:GetHealthPercent() >= 75 then
			return 0.5
		end

		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return 1
		end

		local hTarget = hEnemies[ RandomInt( 1, #hEnemies ) ] 

		return CastTimeWalk( hTarget )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastTimeWalk(hTarget)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hTimeWalkAbility:entindex(),
		Queue = false,					
	})

	return 1
end

--------------------------------------------------------------------------------
