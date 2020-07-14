
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hDispersionAbility = thisEntity:FindAbilityByName( "aghsfort_spectre_active_dispersion" )

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

	if thisEntity.hDispersionAbility and thisEntity.hDispersionAbility:IsFullyCastable() then
		return CastDispersion()
	end

	return 0.5
end

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
