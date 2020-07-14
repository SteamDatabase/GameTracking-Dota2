
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hEchoStompAbility = thisEntity:FindAbilityByName( "creature_elder_titan_echo_stomp" )
	thisEntity.hEarthSplitterAbility = thisEntity:FindAbilityByName( "creature_elder_titan_earth_splitter" )

	thisEntity:SetContextThink( "ElderTitanThink", ElderTitanThink, 0.5 )
end

--------------------------------------------------------------------------------

function ElderTitanThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity.hEchoStompAbility and thisEntity.hEchoStompAbility:IsFullyCastable() then
		local fEchoSearchRadius = 400
		local hEnemiesToEcho = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, fEchoSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		if #hEnemiesToEcho > 0 then
			return CastEchoStomp()
		end
	end

	if thisEntity.hEarthSplitterAbility and thisEntity.hEarthSplitterAbility:IsFullyCastable() then
		local fSplitterSearchRadius = thisEntity.hEarthSplitterAbility:GetCastRange() -- note: this range is more or less global
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, fSplitterSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false )
		if #hEnemies > 0 then
			local hFarthestEnemy = hEnemies[ 1 ]

			return CastEarthSplitter( hFarthestEnemy )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastEchoStomp()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hEchoStompAbility:entindex(),
		Queue = false,
	})

	return 3
end

--------------------------------------------------------------------------------

function CastEarthSplitter( hTarget )
	if hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false then
		return 0.5
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hEarthSplitterAbility:entindex(),
		Queue = false,
	})

	return 2
end

--------------------------------------------------------------------------------
