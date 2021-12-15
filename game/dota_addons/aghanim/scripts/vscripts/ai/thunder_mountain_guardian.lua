
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end


	HammerSmashAbility = thisEntity:FindAbilityByName( "thunder_mountain_guardian_hammer_smash" )
	if thisEntity:GetUnitName() == "npc_dota_creature_large_thunder_mountain_guardian" then 
		HammerSmashAbility = thisEntity:FindAbilityByName( "large_thunder_mountain_guardian_hammer_smash" ) 
		PurificationAbility = thisEntity:FindAbilityByName( "large_thunder_mountain_guardian_purification" )
	end

	thisEntity.Zeus = nil

	thisEntity:SetContextThink( "TempleGuardianThink", TempleGuardianThink, 0.25 )
end

--------------------------------------------------------------------------------

function TempleGuardianThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity:IsChanneling() == true then

		return 0.1
	end

	local hWintersCurseBuff = thisEntity:FindModifierByName( "modifier_aghsfort_winter_wyvern_winters_curse" )
	if hWintersCurseBuff and hWintersCurseBuff:GetAuraOwner() ~= nil then
	
		if HammerSmashAbility ~= nil and HammerSmashAbility:IsCooldownReady() then
			return Smash( hWintersCurseBuff:GetAuraOwner() )
		end
		
		return 0.1
	end


	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.1
	end

	if thisEntity.PurificationAbility ~= nil and PurificationAbility:IsFullyCastable() and #hEnemies > 1 then 
		if thisEntity.Zeus == nil then 
			local hCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 2000 )
			for _, hCreature in pairs( hCreatures ) do
				if ( hCreature:GetUnitName() == "npc_dota_creature_thundergod_zeus" ) and hCreature:IsAlive() then
					thisEntity.Zeus = hCreature
					break
				end
			end
		else
			if thisEntity.Zeus:IsNull() == false and thisEntity.Zeus:IsAlive() then 
				return Purification( thisEntity.Zeus )
			end
		end
	end

	
	if HammerSmashAbility ~= nil and HammerSmashAbility:IsCooldownReady() then
		local hNearestEnemy = hEnemies[ 1 ]
		return Smash( hNearestEnemy )
	end

	return 0.1
end

--------------------------------------------------------------------------------

function Purification( friendly )
	--print( "temple_guardian - Purification" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = PurificationAbility:entindex(),
		TargetIndex = friendly:entindex(),
		Queue = false,
	})

	local fReturnTime = PurificationAbility:GetCastPoint() + 0.4
	--printf( "Purification - return in %.2f", fReturnTime )
	return fReturnTime

	--return 1.3
end

--------------------------------------------------------------------------------

function Smash( enemy )
	--printf( "temple_guardian - Smash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = HammerSmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	local fReturnTime = HammerSmashAbility:GetCastPoint() + 0.4
	--printf( "Smash - return in %.2f", fReturnTime )
	return fReturnTime

	--return 1.4
end

--------------------------------------------------------------------------------
