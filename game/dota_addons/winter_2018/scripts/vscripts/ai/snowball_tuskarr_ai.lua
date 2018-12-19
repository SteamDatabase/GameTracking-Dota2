
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hKickAbility = thisEntity:FindAbilityByName( "frostivus2018_tusk_walrus_kick" )
	thisEntity.hSnowballAbility = thisEntity:FindAbilityByName( "tusk_snowball_meteor" )

	thisEntity:SetContextThink( "TuskarrThink", TuskarrThink, 0.5 )
end

--------------------------------------------------------------------------------

function TuskarrThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity:IsChanneling() then
		return 0.1
	end

	if thisEntity.hSnowballAbility and thisEntity.hSnowballAbility:IsFullyCastable() then

		local nSearchRange = thisEntity.hSnowballAbility:GetCastRange() - 250
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies > 0 then
			local hRandomEnemyPlayer = hEnemies[ RandomInt( 1, #hEnemies ) ]
			return CastSnowball( hRandomEnemyPlayer )
		end
	end

	if thisEntity.hKickAbility and thisEntity.hKickAbility:IsFullyCastable() then

		local nSearchRange = thisEntity.hKickAbility:GetCastRange()
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies > 0 then
			local hRandomEnemyPlayer = hEnemies[ RandomInt( 1, #hEnemies ) ]
			CastTargetedAbility( thisEntity, hRandomEnemyPlayer, thisEntity.hKickAbility )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastSnowball( hTarget )
	if hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false then
		return 0.1
	end
	local vToTarget = thisEntity:GetOrigin() - hTarget:GetOrigin()
	local distance = vToTarget : Length2D()
	local hitPosition = hTarget:GetOrigin()
	if distance >= 400 then
		vToTarget = hTarget:GetForwardVector() 
		vToTarget = vToTarget:Normalized()
		hitPosition = hTarget:GetOrigin() + vToTarget * 250
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hitPosition,
		AbilityIndex = thisEntity.hSnowballAbility:entindex(),
		Queue = false,
	})

	return 2.0
end
