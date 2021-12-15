
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end


	CloudAbility = thisEntity:FindAbilityByName( "thunder_mountain_zeus_cloud" )
	if CloudAbility then 
		CloudAbility:StartCooldown( 15.0 )
	end

	thisEntity:SetContextThink( "ZeusThink", ZeusThink, 0.25 )
end

--------------------------------------------------------------------------------

function ZeusThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity:IsChanneling() == true then
		return 0.1
	end


	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.1
	end

	--print( "hello")
	
	if CloudAbility ~= nil and CloudAbility:IsCooldownReady() then
		return Cloud( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end

	return 0.1
end

--------------------------------------------------------------------------------

function Cloud( enemy )
	--printf( "temple_guardian - Smash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = CloudAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	local fReturnTime = CloudAbility:GetCastPoint() + 0.4
	--printf( "Smash - return in %.2f", fReturnTime )
	return fReturnTime

	--return 1.4
end

--------------------------------------------------------------------------------
