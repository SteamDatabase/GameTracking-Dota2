
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hIcePathAbility = thisEntity:FindAbilityByName( "jakiro_ice_path" )
	thisEntity.hMacropyreAbility = thisEntity:FindAbilityByName( "jakiro_macropyre" )

	thisEntity:SetContextThink( "Jakiro_Think", Jakiro_Think, 1 )
end

--------------------------------------------------------------------------------

function Jakiro_Think()
	if not IsServer() then
		return
	end
	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity.hIcePathAbility and thisEntity.hIcePathAbility:IsFullyCastable() then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies > 0 then
			local hTarget = hEnemies[ RandomInt( 1, #hEnemies ) ] 
			return CastIcePath( hTarget )
		end
	end


	if thisEntity.hMacropyreAbility and thisEntity.hMacropyreAbility:IsFullyCastable() then

		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies > 1 then
			local hTarget = hEnemies[ RandomInt( 1, #hEnemies ) ] 
			return CastMacropyre( hTarget )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastIcePath(hTarget)
	if hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false or hTarget:IsStunned() then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hIcePathAbility:entindex(),
		Queue = false,					
	})

	return 1
end

--------------------------------------------------------------------------------


function CastMacropyre(hTarget)

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hMacropyreAbility:entindex(),
		Queue = false,					
	})

	return 1
end
