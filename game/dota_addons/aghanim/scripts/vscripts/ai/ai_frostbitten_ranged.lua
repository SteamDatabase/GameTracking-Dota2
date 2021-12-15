
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hFreezingBlast = thisEntity:FindAbilityByName( "frostbitten_freezing_blast" )
	thisEntity.hFrostArmor = thisEntity:FindAbilityByName( "frostbitten_shaman_frost_armor" )

	thisEntity.fSearchRadius = thisEntity:GetAcquisitionRange()

	thisEntity:SetContextThink( "FrostbittenRangedThink", FrostbittenRangedThink, 0.5 )
end

--------------------------------------------------------------------------------

function FrostbittenRangedThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if ( not thisEntity.bInitialized ) and thisEntity.bIsRitualist then
		--print( "thisEntity:GetSequence() == " .. thisEntity:GetSequence() )
		SetAggroRange( thisEntity, 0 )
		thisEntity.bInitialized = true
		thisEntity:AddAbility( "frostbitten_shaman_ritualist_passive" )
	end

	-- Increase acquisition range after the initial aggro
	if thisEntity:GetAggroTarget() and ( not thisEntity.bAcqRangeIncreased ) then
		-- On aggro we're removing any ritual gestures.  They end abruptly right now, ideally would let current cycle play out.
		thisEntity:RemoveGesture( ACT_DO_NOT_DISTURB )
		thisEntity:RemoveGesture( ACT_DOTA_VICTORY )

		SetAggroRange( thisEntity, 1000 )
		thisEntity.bAcqRangeIncreased = true
	end

	-- Are we currently holding aggro?
    if ( not thisEntity.bHasAggro ) and thisEntity:GetAggroTarget() then
		thisEntity.timeOfLastAggro = GameRules:GetGameTime()
		thisEntity.bHasAggro = true
	elseif thisEntity.bHasAggro and ( not thisEntity:GetAggroTarget() ) then
		thisEntity.bHasAggro = false
	end

	if ( not thisEntity.bHasAggro ) then
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	-- If we've had aggro for a bit we're willing to cast
	local bWillingToCast = false
	local fDelayBeforeCast = RandomFloat( 0.0, 2.3 )
	if GameRules:GetGameTime() > ( thisEntity.timeOfLastAggro + fDelayBeforeCast ) then
		bWillingToCast = true
	end

	if bWillingToCast then
		if thisEntity.hFreezingBlast ~= nil and thisEntity.hFreezingBlast:IsFullyCastable() then
			return CastFreezingBlast( hEnemies[ #hEnemies ] )
		else
			local hAllies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			local hFrostArmorTargets = {}
			for _, hAlly in pairs( hAllies ) do
				if ( not hAlly:HasModifier( "modifier_breakable_container" ) ) then
					table.insert( hFrostArmorTargets, hAlly )
				end
			end
			if #hFrostArmorTargets > 0 and thisEntity.hFrostArmor ~= nil and thisEntity.hFrostArmor:IsFullyCastable() then
				return CastFrostArmor( hFrostArmorTargets[ RandomInt( 1, #hFrostArmorTargets ) ] )
			end
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastFreezingBlast( hTarget )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.1 } )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hFreezingBlast:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function CastFrostArmor( hAlly )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hAlly:entindex(),
		AbilityIndex = thisEntity.hFrostArmor:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------

