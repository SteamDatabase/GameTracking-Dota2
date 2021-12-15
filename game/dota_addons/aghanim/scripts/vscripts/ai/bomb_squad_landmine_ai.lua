
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	DetonateAblity = thisEntity:FindAbilityByName( "bomb_squad_landmine_detonate" )
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

	if DetonateAblity and DetonateAblity:IsFullyCastable() then
		local fDetonateRadius = DetonateAblity:GetSpecialValueFor( "detonate_radius" )
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fDetonateRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies == 0 then
			return 0.5
		end

		if thisEntity:FindModifierByName("modifier_bomb_squad_landmine_detonate") then
			--we're already exploding
			return -1
		end

		return Detonate()
	end
	return 1
end


--------------------------------------------------------------------------------

function Detonate()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = DetonateAblity:entindex(),
		Queue = false,
	})
	return -1
end


--------------------------------------------------------------------------------

