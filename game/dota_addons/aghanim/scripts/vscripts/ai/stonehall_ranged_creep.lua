function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	RangedAttack = thisEntity:FindAbilityByName( "stonehall_ranged_attack" )
	thisEntity:SetContextThink( "RangedCreepThink", RangedCreepThink, 0.2 )
end

function RangedCreepThink()
	if GameRules:IsGamePaused() == true then
		return 1
	end
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	if RangedAttack ~= nil and RangedAttack:IsCooldownReady() then
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
		AbilityIndex = RangedAttack:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})
	return 0.2
end
