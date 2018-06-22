
require("units/ai/ai_cavern_shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bShapeShifted = false
	thisEntity.hHateTarget = nil
	thisEntity.Wolves = {}

	hSummonWolvesAbility = thisEntity:FindAbilityByName( "creature_lycan_summon_wolves" )
	hShapeShiftAbility = thisEntity:FindAbilityByName( "creature_lycan_shapeshift" )

	thisEntity.EventQueue = CEventQueue()	

	thisEntity:SetContextThink( "LycanThink", LycanThink, 1 )
end

--------------------------------------------------------------------------------

function LycanThink()
	if thisEntity.hBKBAbility == nil then
		thisEntity.hBKBAbility = FindItemAbility(thisEntity, "item_black_king_bar")
	end

	if thisEntity.bShapeShifted == false then
		local flEarlyReturn = InitialRoomMobLogic( thisEntity )
		if flEarlyReturn == nil then
			return nil
		elseif flEarlyReturn > 0 then
			return flEarlyReturn
		end

		local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )
		if hClosestPlayer == nil then
			return 1
		end
	end
	
	local hEnemies = GetEnemyHeroesInRoom( thisEntity )

	RemoveDeadUnits( hEnemies )

	if #hEnemies < 1 then
		return 1
	end

	if thisEntity.bShapeShifted == true then
		if thisEntity.hHateTarget == nil or thisEntity.hHateTarget:IsAlive() == false or thisEntity.hHateTarget:IsAttackImmune() then
			thisEntity.hHateTarget = hEnemies[ #hEnemies ]
		end
	end

	local Friendlies = FindUnitsInRadius(
		DOTA_TEAM_BADGUYS, thisEntity:GetAbsOrigin(), nil, 800, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 
		DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false
	)

	for _, hFriendly in pairs( Friendlies ) do
		if hFriendly:GetUnitName() == "npc_dota_lycan_wolf"..tostring(i) then
			table.insert( thisEntity.Wolves, hFriendly )
		end
	end

	if thisEntity.bShapeShifted == false then
		if hShapeShiftAbility:IsFullyCastable() and hShapeShiftAbility:IsCooldownReady() then
			CastShapeshift()
		end
	end	

	if hSummonWolvesAbility:IsFullyCastable() and hSummonWolvesAbility:IsCooldownReady() then
		if #thisEntity.Wolves <= 16 and thisEntity.bShapeShifted == false then
			CastSummonWolves()	
		end
	end

	for _, hWolf in pairs( thisEntity.Wolves ) do
		hWolf:SetMaximumGoldBounty( 0 )
		hWolf:SetMinimumGoldBounty( 0 )
		hWolf:SetDeathXP( 0 )
		if hWolf.hTarget == nil or hWolf.hTarget:IsAlive() == false or hWolf.hTarget:IsAttackImmune() == true then
			hWolf.hTarget = GetRandomUnique( hEnemies, {hWolf.hTarget} )
			--printf( "hWolf wants to attack random target (%s)", hWolf.hTarget:GetUnitName() )
			AttackTargetOrder( hWolf, hWolf.hTarget )
		end
	end

	if thisEntity.hHateTarget then
		--printf( "Lycan wants to attack his hate target (%s)", thisEntity.hHateTarget:GetUnitName() )
		AttackTargetOrder( thisEntity, thisEntity.hHateTarget )
	elseif hClosestPlayer then
		--printf( "Lycan wants to attack closest player (%s)", hClosestPlayer:GetUnitName() )
		AttackTargetOrder( thisEntity, hClosestPlayer )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastSummonWolves()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hSummonWolvesAbility:entindex(),
		Queue = false,
	})	
end

--------------------------------------------------------------------------------

function CastShapeshift()
	local bIsLowHP = ( thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.5 ) )

	if bIsLowHP then
		thisEntity.bShapeShifted = true

		thisEntity:AddNewModifier(thisEntity, nil, "modifier_lycan_invuln", {duration=2} )

		StopOrder( thisEntity )

		if not thisEntity:IsNull() and thisEntity:IsAlive() then
			EmitSoundOn( "lycan_lycan_attack_05", thisEntity )
		end

		thisEntity.EventQueue:AddEvent( 1.5, function(thisEntity)	
			thisEntity:AddNewModifier(thisEntity, nil, "modifier_attack_speed_bonus", {attackSpeedBonus=50} )
			thisEntity:AddNewModifier(thisEntity, nil, "modifier_pangolier_heartpiercer_debuff", {duration=9000} )

			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hShapeShiftAbility:entindex()
			})

			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = thisEntity.hBKBAbility:entindex(),
			})
		end, thisEntity )
	end
end

--------------------------------------------------------------------------------
