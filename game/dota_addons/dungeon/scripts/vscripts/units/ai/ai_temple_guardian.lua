function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bIsEnraged = false

	HammerSmashAbility = thisEntity:FindAbilityByName( "temple_guardian_hammer_smash" )
	HammerThrowAbility = thisEntity:FindAbilityByName( "temple_guardian_hammer_throw" )
	PurificationAbility = thisEntity:FindAbilityByName( "temple_guardian_purification" )
	WrathAbility = thisEntity:FindAbilityByName( "temple_guardian_wrath" )

	RageHammerSmashAbility = thisEntity:FindAbilityByName( "temple_guardian_rage_hammer_smash" )
	RageHammerSmashAbility:SetHidden( false )

	thisEntity:SetContextThink( "TempleGuardianThink", TempleGuardianThink, 1 )
end

function TempleGuardianThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:IsChanneling() == true then
		return 0.1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	local hCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 2000 )
	local hGuardians = {}
	for _, hCreature in pairs( hCreatures ) do
		if ( hCreature:GetUnitName() == "npc_dota_creature_temple_guardian" ) and hCreature:IsAlive() then
			table.insert( hGuardians, hCreature )
		end
	end

	if #hGuardians == 1 and ( not thisEntity.bIsEnraged ) then
		-- Our brother died, swap for enraged version of hammer smash
		thisEntity:SwapAbilities( "temple_guardian_hammer_smash", "temple_guardian_rage_hammer_smash", false, true )
		thisEntity.bIsEnraged = true
		thisEntity.fTimeEnrageStarted = GameRules:GetGameTime()
	end

	if WrathAbility ~= nil and WrathAbility:IsCooldownReady() and #hGuardians == 1 and thisEntity:GetHealthPercent() < 90 then
		if thisEntity.fTimeEnrageStarted and ( GameRules:GetGameTime() > ( thisEntity.fTimeEnrageStarted + 5 ) ) then
			return Wrath()
		end
	end

	if HammerThrowAbility ~= nil and HammerThrowAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 90 then
		local hLastEnemy = hEnemies[ #hEnemies ]
		if hLastEnemy ~= nil then
			local flDist = (hLastEnemy:GetOrigin() - thisEntity:GetOrigin()):Length2D()
			if flDist > 600 then
				return Throw( hLastEnemy )
			end
		end
	end

	for _, hGuardian in pairs( hGuardians ) do
		if hGuardian ~= nil and hGuardian:IsAlive() and ( hGuardian ~= thisEntity or #hGuardians == 1 ) and ( hGuardian:GetHealthPercent() < 80 ) and PurificationAbility ~= nil and PurificationAbility:IsFullyCastable() then
			return Purification( hGuardian )
		end
	end

	if not thisEntity.bIsEnraged then
		if HammerSmashAbility ~= nil and HammerSmashAbility:IsCooldownReady() then
			return Smash( hEnemies[ 1 ] )
		end
	else
		if RageHammerSmashAbility ~= nil and RageHammerSmashAbility:IsFullyCastable() then
			return RageSmash( hEnemies[ 1 ] )
		end
	end

	return 0.5
end

function Wrath()
	--print( "ai_temple_guardian - Wrath" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = WrathAbility:entindex(),
		Queue = false,
	})
	return 8
end

function Throw( enemy )
	--print( "ai_temple_guardian - Throw" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = HammerThrowAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 3
end

function Purification( friendly )
	--print( "ai_temple_guardian - Purification" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = PurificationAbility:entindex(),
		TargetIndex = friendly:entindex(),
		Queue = false,
	})
	return 1.3
end

function Smash( enemy )
	--print( "ai_temple_guardian - Smash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = HammerSmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 1.4
end

function RageSmash( enemy )
	--print( "ai_temple_guardian - RageSmash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = RageHammerSmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 1.1
end


