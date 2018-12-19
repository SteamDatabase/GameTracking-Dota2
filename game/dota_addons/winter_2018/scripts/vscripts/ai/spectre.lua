
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	--thisEntity.hDaggerAbility = thisEntity:FindAbilityByName( "spectre_dagger" )
	thisEntity.hDispersionAbility = thisEntity:FindAbilityByName( "frostivus2018_spectre_active_dispersion" )

	thisEntity:SetContextThink( "SpectreThink", SpectreThink, 0.5 )
end

--------------------------------------------------------------------------------

function SpectreThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	--[[
	if thisEntity.hDaggerAbility and thisEntity.hDaggerAbility:IsFullyCastable() then
		local hRandomEnemy = hEnemies[ RandomInt( 1, #hEnemies ) ] 
		return CastDagger( hRandomEnemy )
	end
	]]

	if thisEntity.hDispersionAbility and thisEntity.hDispersionAbility:IsFullyCastable() then
		return CastDispersion()
	end

	return 0.5
end

--------------------------------------------------------------------------------

--[[
function CastDagger( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.hDaggerAbility:entindex(),
		Queue = false,
	})

	return 0.5
end
]]

--------------------------------------------------------------------------------

function CastDispersion()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hDispersionAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------
