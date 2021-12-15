function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	BoneTossAbility = thisEntity:FindAbilityByName( "crypt_bone_giant_bone_toss" )

	thisEntity:SetContextThink( "BoneGiantThink", BoneGiantThink, 1 )
end

--------------------------------------------

function BoneGiantThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then 
		return 0.1 
	end

	if BoneTossAbility ~= nil and BoneTossAbility:IsFullyCastable() then
		return CastBoneToss( enemies[ RandomInt( 1, #enemies ) ] )
	end
	
	return 0.1
end

--------------------------------------------

function CastBoneToss( enemy )
	if BoneTossAbility == nil then
		return
	end

	if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.5 } )
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = BoneTossAbility:entindex(),
		Queue = false,
	})

	return 1.6
end
