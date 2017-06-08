function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	AssaultAttack = thisEntity:FindAbilityByName( "ranged_assault_attack" )
	thisEntity:SetContextThink( "RangedCreepThink", RangedCreepThink, 1 )
end

function RangedCreepThink()
	if GameRules:IsGamePaused() == true then
		return 1
	end
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	if AssaultAttack ~= nil and AssaultAttack:IsCooldownReady() then
		return Attack( enemies[1] )
	end

	thisEntity:FaceTowards( enemies[1]:GetOrigin() )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP,
	})
	return 0.5
end

function Attack(unit)
	thisEntity.bMoving = false

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = AssaultAttack:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})
	return 1
end
