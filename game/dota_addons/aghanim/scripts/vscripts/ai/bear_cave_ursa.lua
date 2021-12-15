function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	EarthshockAbility = thisEntity:FindAbilityByName( "bear_cave_ursa_earthshock" )
	OverpowerAbility = thisEntity:FindAbilityByName( "bear_cave_ursa_overpower" )

	thisEntity:SetContextThink( "BearCaveUrsaThink", BearCaveUrsaThink, 0.25 )
end

--------------------------------------------

function BearCaveUrsaThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 425, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then 
		return 0.1 
	end

	if OverpowerAbility ~= nil and OverpowerAbility:IsCooldownReady() then 
		return CastOverpower()
	end

	if EarthshockAbility ~= nil and EarthshockAbility:IsCooldownReady() then 
		return CastEarthshock()
	end
	
	return 0.1
end

--------------------------------------------

function CastEarthshock()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = EarthshockAbility:entindex(),
		Queue = false,
	})

	return 0.1
end

--------------------------------------------

function CastOverpower()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = OverpowerAbility:entindex(),
		Queue = false,
	})

	return 0.4
end