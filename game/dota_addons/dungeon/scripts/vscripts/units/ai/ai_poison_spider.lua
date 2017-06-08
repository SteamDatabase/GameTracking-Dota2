function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	hPoisonSpit = thisEntity:FindAbilityByName( "spider_poison_spit" )
	thisEntity:SetContextThink( "PoisonSpiderThink", PoisonSpiderThink, 1 )
end

function PoisonSpiderThink()
	if ( not thisEntity:IsAlive() ) or thisEntity:IsNull() then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	local hPoisonSpitTarget = nil
	local hApproachTarget = nil
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist > 0 and flDist <= 600 then
				hPoisonSpitTarget = enemy
			end
			if flDist > 600 then
				hApproachTarget = enemy
			end
		end
	end

	if hPoisonSpitTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	if hPoisonSpitTarget then
		if hPoisonSpit:IsFullyCastable() then
			return CastPoisonSpit( hPoisonSpitTarget )
		end

		thisEntity:FaceTowards( hPoisonSpitTarget:GetOrigin() )
	end

	return 0.5
end

function CastPoisonSpit( unit )
	thisEntity.bMoving = false

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hPoisonSpit:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})
	return 1
end


function Approach( unit )
	thisEntity.bMoving = true

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
end


