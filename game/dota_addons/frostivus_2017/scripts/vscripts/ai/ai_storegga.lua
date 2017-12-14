function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	AvalancheAbility = thisEntity:FindAbilityByName( "storegga_avalanche" )

	thisEntity:SetContextThink( "StoreggaThink", StoreggaThink, 5 )
end

function StoreggaThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.bStarted == false then
		return 0.1
	elseif ( not thisEntity.bInitialInvulnRemoved ) then
		thisEntity:RemoveModifierByName( "modifier_invulnerable" )
		--print( "removed invuln modifier from Storegga boss" )
		thisEntity.bInitialInvulnRemoved = true
	end

	if thisEntity:IsChanneling() then
		return 1
	end

	if AvalancheAbility ~= nil and AvalancheAbility:IsFullyCastable() then
		return CastAvalanche()
	end
	
	return 0.5
end

function CastAvalanche()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = AvalancheAbility:entindex(),
		Queue = false,
	})
	return 11
end