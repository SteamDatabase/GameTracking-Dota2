
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	BoneBallAbility = thisEntity:FindAbilityByName( "undead_tusk_bone_ball" )

	thisEntity:SetContextThink( "UndeadSpectralTuskThink", UndeadSpectralTuskThink, 0.5 )
end

--------------------------------------------------------------------------------

function UndeadSpectralTuskThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if ( not thisEntity:GetAggroTarget() ) then
		return 1.0
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	if BoneBallAbility ~= nil and BoneBallAbility:IsFullyCastable() and RollPercentage( ( 100 - thisEntity:GetHealthPercent() ) / 2 ) then
		return CastBoneBall( enemies[#enemies] )
	end

	return 0.5
end


function CastBoneBall( hTarget )
	-- print("medium bear - cleaving")

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:GetAggroTarget():entindex(),
		AbilityIndex = BoneBallAbility:entindex(),
		Queue = false,
	})

	return 1.0
end
