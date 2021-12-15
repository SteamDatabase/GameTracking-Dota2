function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SprintAbility = thisEntity:FindAbilityByName( "bashy_sprint" )
	CrushAbility = thisEntity:FindAbilityByName( "bashy_slithereen_crush" )
	thisEntity.hAmpedUnit = nil

	thisEntity:SetContextThink( "BashyThink", BashyThink, 1 )
end

--------------------------------------------

function BashyThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.hAmpedUnit == nil or 
		thisEntity.hAmpedUnit:IsNull() or 
		thisEntity.hAmpedUnit:IsAlive() == false or 
		thisEntity.hAmpedUnit:FindModifierByName( "modifier_slardar_amplify_damage" ) == nil then 
		
		thisEntity.hAmpedUnit = nil 
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies == 0 then 
			return 0.1 
		end

		for _,hEnemy in pairs ( enemies ) do 
			if hEnemy and hEnemy:FindModifierByName( "modifier_slardar_amplify_damage" ) then 
				thisEntity.hAmpedUnit = hEnemy
				break
			end
		end
	end

	if thisEntity.hAmpedUnit == nil then 
		return 0.1 
	end

	if SprintAbility and SprintAbility:IsFullyCastable() and thisEntity:FindModifierByName( "modifier_slardar_sprint" ) == nil then 
		return CastSprint()
	end

	local hBuff = thisEntity:FindModifierByName( "modifier_bashy_passive" )
	if hBuff and hBuff:GetStackCount() == 100 then 
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		if #enemies == 0 then 
			return 0.1 
		end

		if CrushAbility and CrushAbility:IsFullyCastable() then 
			return CastCrush() 
		end
	end


	return AttackAmpedTarget()
end

--------------------------------------------

function CastSprint()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SprintAbility:entindex(),
		Queue = false,
	})

	return 0.1
end

--------------------------------------------

function CastCrush()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = CrushAbility:entindex(),
		Queue = false,
	})

	return 0.1
end


--------------------------------------------

function AttackAmpedTarget()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = thisEntity.hAmpedUnit:entindex(),
		Queue = false,
	})

	return 0.1
end