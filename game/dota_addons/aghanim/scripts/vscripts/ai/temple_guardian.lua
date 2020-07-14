
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bIsEnraged = false
	thisEntity.nRageHealthPct = 15
	thisEntity.bBrotherDied = false

	thisEntity.Encounter = nil

	HammerSmashAbility = thisEntity:FindAbilityByName( "temple_guardian_hammer_smash" )
	HammerThrowAbility = thisEntity:FindAbilityByName( "temple_guardian_hammer_throw" )
	PurificationAbility = thisEntity:FindAbilityByName( "temple_guardian_purification" )
	WrathAbility = thisEntity:FindAbilityByName( "temple_guardian_wrath" )

	RageHammerSmashAbility = thisEntity:FindAbilityByName( "temple_guardian_rage_hammer_smash" )
	RageHammerSmashAbility:SetHidden( false )

	thisEntity:SetContextThink( "TempleGuardianThink", TempleGuardianThink, 1 )
end

--------------------------------------------------------------------------------

function TempleGuardianThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if thisEntity.Encounter == nil then
		return 1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity:IsChanneling() == true then
		return 0.1
	end

	local hWintersCurseBuff = thisEntity:FindModifierByName( "modifier_aghsfort_winter_wyvern_winters_curse" )
	if hWintersCurseBuff and hWintersCurseBuff:GetAuraOwner() ~= nil then
		if not thisEntity.bIsEnraged then
			if HammerSmashAbility ~= nil and HammerSmashAbility:IsCooldownReady() then
				return Smash( hWintersCurseBuff:GetAuraOwner() )
			end
		else
			if RageHammerSmashAbility ~= nil and RageHammerSmashAbility:IsFullyCastable() then
				return RageSmash( hWintersCurseBuff:GetAuraOwner() )
			end
		end

		return 0.1
	end

	if ( not thisEntity.bIsEnraged ) and ( thisEntity:GetHealthPercent() <= thisEntity.nRageHealthPct ) then
		thisEntity.bIsEnraged = true
		thisEntity:SwapAbilities( "temple_guardian_hammer_smash", "temple_guardian_rage_hammer_smash", false, true )
		--printf( "thisEntity.bIsEnraged: %s", tostring( thisEntity.bIsEnraged ) )
	end

	local hCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 2000 )
	local hGuardians = {}
	for _, hCreature in pairs( hCreatures ) do
		if ( hCreature:GetUnitName() == "npc_dota_creature_temple_guardian" ) and hCreature:IsAlive() then
			table.insert( hGuardians, hCreature )
		end
	end

	if #hGuardians == 1 and ( not thisEntity.bBrotherDied ) then
		thisEntity.bBrotherDied = true
		thisEntity.fTimeBrotherDied = GameRules:GetGameTime()
		thisEntity.bIsEnraged = true
	end

	if WrathAbility ~= nil and WrathAbility:IsCooldownReady() and #hGuardians == 1 and thisEntity:GetHealthPercent() <= 100 then
		local fTimeBeforeWrath = 3
		if thisEntity.fTimeBrotherDied and ( GameRules:GetGameTime() > ( thisEntity.fTimeBrotherDied + fTimeBeforeWrath ) ) then
			return Wrath()
		end
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.1
	end

	if HammerThrowAbility ~= nil and HammerThrowAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 90 then
		local hFarthestEnemy = hEnemies[ #hEnemies ]
		if hFarthestEnemy ~= nil then
			local flDist = (hFarthestEnemy:GetOrigin() - thisEntity:GetOrigin()):Length2D()
			if flDist > 600 then
				return Throw( hFarthestEnemy )
			end
		end
	end

	for _, hGuardian in pairs( hGuardians ) do
		if hGuardian ~= nil and hGuardian:IsAlive() and ( hGuardian ~= thisEntity or #hGuardians == 1 ) and ( hGuardian:GetHealthPercent() < 80 ) and PurificationAbility ~= nil and PurificationAbility:IsFullyCastable() and #hEnemies > 1 then
			return Purification( hGuardian )
		end
	end

	if not thisEntity.bIsEnraged then
		if HammerSmashAbility ~= nil and HammerSmashAbility:IsCooldownReady() then
			local hNearestEnemy = hEnemies[ 1 ]
			return Smash( hNearestEnemy )
		end
	else
		if RageHammerSmashAbility ~= nil and RageHammerSmashAbility:IsFullyCastable() then
			local hNearestEnemy = hEnemies[ 1 ]
			return RageSmash( hNearestEnemy )
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------

function Wrath()
	--print( "temple_guardian - Wrath" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = WrathAbility:entindex(),
		Queue = false,
	})

	local fReturnTime = WrathAbility:GetCastPoint() + WrathAbility:GetChannelTime() + 0.5
	--printf( "Wrath - return in %.2f", fReturnTime )
	return fReturnTime

	--return 8
end

--------------------------------------------------------------------------------

function Throw( enemy )
	--print( "temple_guardian - Throw" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = HammerThrowAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	local fReturnTime = HammerThrowAbility:GetCastPoint() + 1.8
	--printf( "Throw - return in %.2f", fReturnTime )
	return fReturnTime

	--return 3
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

function RageSmash( enemy )
	--printf( "temple_guardian - RageSmash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = RageHammerSmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	local fReturnTime = RageHammerSmashAbility:GetCastPoint() + 0.4
	--printf( "RageSmash - return in %.2f", fReturnTime )
	return fReturnTime

	--return 1.1
end

--------------------------------------------------------------------------------
