

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	hIcicleAbility = thisEntity:FindAbilityByName( "large_frostbitten_icicle" )

	thisEntity:SetContextThink( "FrostbittenThink", FrostbittenThink, 1 )
end


function FrostbittenThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	if hIcicleAbility ~= nil and hIcicleAbility:IsFullyCastable() then
		return CastIcicle( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end
	return 1
end


function CastIcicle( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hIcicleAbility:entindex(),
		Position = enemy:GetOrigin(),
	})

	return 1.5
end
