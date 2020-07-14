
function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	QuillAttack = thisEntity:FindAbilityByName( "ranged_quill_attack" )
	thisEntity:SetContextThink( "DireHoundBossThink", DireHoundBossThink, 1 )
end

function DireHoundBossThink()
	if GameRules:IsGamePaused() == true then
		return 1
	end
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	local hAttackTarget = nil
	local hApproachTarget = nil
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsAlive() then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then
				return Retreat( enemy )
			end
			if flDist <= 800 then
				hAttackTarget = enemy
			end
			if flDist > 800 then
				hApproachTarget = enemy
			end
		end
	end

	

	if hAttackTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	if QuillAttack:IsCooldownReady() then
		return Attack( hAttackTarget )
	end

	thisEntity:FaceTowards( hAttackTarget:GetOrigin() )
	return 0.5
end

function Attack(unit)
	thisEntity.bMoving = false

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.1 } )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = QuillAttack:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})
	return 1
end


function Approach(unit)
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



function Retreat(unit)
	thisEntity.bMoving = true

	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()
	})
	return 1.25
end

