
--[[ units/ai/ai_bear_large.lua ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hRoar = thisEntity:FindAbilityByName( "bear_roar" )
	thisEntity.hBattleCry = thisEntity:FindAbilityByName( "big_bear_battle_cry" )

	thisEntity:SetContextThink( "BearLargeThink", BearLargeThink, 0.5 )

end

--------------------------------------------------------------------------------

function BearLargeThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.5
	end

	if thisEntity:GetAggroTarget() == nil then
		return 0.5
	end

	if thisEntity.hBattleCry ~= nil and thisEntity.hBattleCry:IsFullyCastable() then
		return CastBattleCry()
	end

	if thisEntity.hRoar ~= nil and thisEntity.hRoar:IsFullyCastable() then
		return CastRoar()
	end

	return 1.0
end

--------------------------------------------------------------------------------

function CastRoar()
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hRoar:entindex(),
		Queue = false,
	})

	return 2.0
end

function CastBattleCry()
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hBattleCry:entindex(),
		Queue = false,
	})
	return 2.0
end


