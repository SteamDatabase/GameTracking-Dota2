--[[ Snapfire AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hScatterblast = thisEntity:FindAbilityByName( "snapfire_scatterblast" )
	thisEntity.hFiresnapCookie = thisEntity:FindAbilityByName( "snapfire_firesnap_cookie" )
	thisEntity.hMortimerKisses = thisEntity:FindAbilityByName( "snapfire_mortimer_kisses" )

	thisEntity.hBlackKingBarAbility = nil
	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_creature_black_king_bar" then
			--print( "BKB Found" )
			thisEntity.hBlackKingBarAbility = item
		end
	end

	thisEntity.fSearchRadius = thisEntity:GetAcquisitionRange()
	thisEntity.flMortimerKissesDelayTime = GameRules:GetGameTime() + RandomFloat( 10, 16 )	-- need to live for this long before we can think about casting mortimer kisses
	thisEntity.hKissesTarget = nil
	thisEntity.bReapplyNoCCAfterAbility = false

	thisEntity:SetContextThink( "SnapfireThink", SnapfireThink, 1 )
end

--------------------------------------------------------------------------------

function SnapfireThink()
	--print( "Thinking" )
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Reapply the no CC after abilities used
	if thisEntity.bReapplyNoCCAfterAbility == true then
		print( 'ADDING NO CC BACK IN!' )
		thisEntity.bReapplyNoCCAfterAbility = false
		thisEntity:AddNewModifier( thisEntity, nil, 'modifier_absolute_no_cc', { duration = -1 } )
	end

	if thisEntity.hMortimerKisses ~= nil and ( thisEntity.hMortimerKisses:IsChanneling() or thisEntity:HasModifier( "modifier_snapfire_mortimer_kisses" ) ) then
		if thisEntity.hKissesTarget ~= nil then
			--print( "Snapfire is channeling Kisses" )
			return AimMortimerKisses()
		end
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	local target = hEnemies[ RandomInt( 1, #hEnemies ) ]

	if thisEntity.hScatterblast ~= nil and thisEntity.hScatterblast:IsFullyCastable() then
		return CastScatterblast( target )
	end

	if thisEntity.hFiresnapCookie ~= nil and thisEntity.hFiresnapCookie:IsFullyCastable() then
		local vPos = thisEntity:GetAbsOrigin()
		local vForward = thisEntity:GetForwardVector()
		local vLeapPosition = vPos + vForward * 400
		local flDist = ( target:GetOrigin() - vLeapPosition ):Length2D()
		if flDist < 300 then
			return CastFiresnapCookie()
		end
	end

	if ( thisEntity:GetHealthPercent() < 50 ) then
		if thisEntity.hBlackKingBarAbility ~= nil and thisEntity.hBlackKingBarAbility:IsFullyCastable() then
			return CastBKB()
		end
	end

	if thisEntity.flMortimerKissesDelayTime < GameRules:GetGameTime() then
		if thisEntity.hMortimerKisses ~= nil and thisEntity.hMortimerKisses:IsFullyCastable() then
			return CastMortimerKisses( target )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastScatterblast( enemy )
	if enemy == nil then
		return
	end
	--print( "Casting Scatterblast" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hScatterblast:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function CastFiresnapCookie()
	--print( "Casting Firesnap Cookie" )

	thisEntity.bReapplyNoCCAfterAbility = true
	thisEntity:RemoveAbility( 'ability_absolute_no_cc' )
	thisEntity:RemoveModifierByName( 'modifier_absolute_no_cc' )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:entindex(),
		AbilityIndex = thisEntity.hFiresnapCookie:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function CastBKB()
	--print( "Casting BKB" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hBlackKingBarAbility:entindex(),
	})

	return 1
end

--------------------------------------------------------------------------------

function CastMortimerKisses( enemy )
	if enemy == nil then
		return
	end

	thisEntity.bReapplyNoCCAfterAbility = true
	thisEntity:RemoveAbility( 'ability_absolute_no_cc' )
	thisEntity:RemoveModifierByName( 'modifier_absolute_no_cc' )

	thisEntity.hKissesTarget = enemy
	local vTargetPos = enemy:GetOrigin() + RandomVector( 25 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hMortimerKisses:entindex(),
		Position = vTargetPos,
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function AimMortimerKisses()
	--print( "Correcting Aim" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
		TargetIndex = thisEntity.hKissesTarget:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------