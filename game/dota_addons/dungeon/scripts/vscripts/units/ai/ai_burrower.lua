--[[ units/ai/ai_burrower.lua ]]

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		ImpaleAbility = thisEntity:FindAbilityByName( "nyx_assassin_impale" )	
		CarapaceAbility = thisEntity:FindAbilityByName( "nyx_assassin_spiked_carapace" )
		BurrowAbility = thisEntity:FindAbilityByName( "nyx_assassin_burrow" )
		UnburrowAbility = thisEntity:FindAbilityByName( "nyx_assassin_unburrow" )
		BurrowAbility:SetHidden( false )

		thisEntity:SetContextThink( "BurrowerThink", BurrowerThink, 1 )
	end
end


function BurrowerThink()
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	if ImpaleAbility ~= nil and ImpaleAbility:IsCooldownReady() then
		if thisEntity:FindModifierByName( "modifier_nyx_assassin_burrow" ) == nil then
			 if BurrowAbility ~= nil and BurrowAbility:IsCooldownReady() then
			 	return CastBurrow()
			 end
		else
			return CastImpale( enemies[ RandomInt( 1, #enemies ) ] )
		end	
	else
		if thisEntity:FindModifierByName( "modifier_nyx_assassin_burrow" ) == nil then
			local nResult = RandomInt( 0, 1 )
			if nResult == 0 then
				--Just fight
				return 2
			else
				return Retreat( enemies[1] )
			end
		else
			return CastUnburrow()
		end
	end

	return 0.5
end

function CastBurrow()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = BurrowAbility:entindex(),
	})
	return 2
end

function CastUnburrow()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = UnburrowAbility:entindex(),
	})
	return 1
end

function CastImpale(unit)
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = ImpaleAbility:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})
	return 3
end

function Retreat(unit)
	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = CarapaceAbility:entindex(),
	})
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()
	})
	return 1.0
end
