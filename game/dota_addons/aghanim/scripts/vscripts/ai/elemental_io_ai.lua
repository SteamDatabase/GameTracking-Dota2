function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity.TetherAbility = thisEntity:FindAbilityByName( "aghsfort_wisp_tether" )

	thisEntity:SetContextThink( "ElementalIoThink", ElementalIoThink, 0.5 )
end

function ElementalIoThink()
	if ( not thisEntity:IsAlive() ) then
		
		return -1
	end
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:GetOwner() == nil or thisEntity:GetOwner():IsAlive() ~= true then
	-- We lost our owner Tiny. Let's find a new one. 
		local entities = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,  DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		local hPossibleOwner = nil
		for _, hAlly in pairs( entities ) do
			
			if hAlly ~= nil and not hAlly:IsNull() and hAlly:IsAlive() == true and hAlly:GetUnitName() == "npc_dota_creature_elemental_tiny" then
				printf("Found a valid tiny")
				hPossibleOwner = hAlly
				break
			end
		end

		if hPossibleOwner ~= nil then
			thisEntity:SetOwner( hPossibleOwner )
		else
			--No new owners found. Not even worth thinking anymore

			return -1
		end
	end

	if thisEntity.TetherAbility ~= nil and thisEntity.TetherAbility:IsFullyCastable() then
		 if (thisEntity:GetAbsOrigin() - thisEntity:GetOwner():GetAbsOrigin() ):Length2D() > 350  then
			return CastTether(thisEntity:GetOwner())
		 end
	end

	return 0.5
end

function CastTether( hTarget )
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.TetherAbility:entindex(),
		TargetIndex = hTarget:entindex(),
		Queue = false,
	})
	
	return 0.5
end
