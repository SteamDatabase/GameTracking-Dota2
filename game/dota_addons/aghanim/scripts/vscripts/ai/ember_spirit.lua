
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hFireballAbility = thisEntity:FindAbilityByName( "ember_spirit_fireball" )

	thisEntity:SetContextThink( "EmberSpiritThink", EmberSpiritThink, 0.1 )
end

--------------------------------------------------------------------------------

function EmberSpiritThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	local fSearchRange = thisEntity:GetAcquisitionRange()
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.1
	end

	local fHealthPctFireball = 50
	if thisEntity:GetHealthPercent() <= fHealthPctFireball then
		if thisEntity.hFireballAbility and thisEntity.hFireballAbility:IsFullyCastable() then
			local hRandomTarget = hEnemies[ RandomInt( 1, #hEnemies ) ]
			return CastFireball( hRandomTarget:GetAbsOrigin() )
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------

function CastFireball( vTargetPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hFireballAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})

	return thisEntity.hFireballAbility:GetCastPoint() + 0.1
end

--------------------------------------------------------------------------------
