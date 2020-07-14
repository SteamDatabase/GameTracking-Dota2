
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	DetonateAblity = thisEntity:FindAbilityByName( "creature_landmine_detonate" )
	thisEntity:SetContextThink( "LandmineThink", LandmineThink, 1 )
end

--------------------------------------------------------------------------------

function LandmineThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	local fDetonateRadius = thisEntity.DetonateAblity:GetSpecialValueFor( "detonate_radius" )

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fDetonateRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.5
	end

	return Detonate()
end


--------------------------------------------------------------------------------

function Detonate()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.DetonateAblity:entindex(),
		Queue = false,
	})

	return 3
end


--------------------------------------------------------------------------------

