require("units/ai/ai_cavern_shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	BlinkAbility = thisEntity:FindAbilityByName( "minimage_blink" )
	VoidAbility = thisEntity:FindAbilityByName( "minimage_mana_void" )
	thisEntity:SetContextThink( "MiniMageThink", MiniMageThink, 1 )
	thisEntity.DroppedPotion = false

end

--------------------------------------------------------------------------------

function MiniMageThink()
	-- have to do this early because InitaiRoomMobLogic returns early if thisEntity is dead
	if ( not thisEntity:IsAlive() ) then
		if not thisEntity.DroppedPotion then
			local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )
			thisEntity.DroppedPotion = true
			DropPotion( hClosestPlayer )
		end
		return -1
	end

	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )

	if not hClosestPlayer then
		return 1
	else
		
		if GameRules:IsGamePaused() == true then
			return 1
		end

		enemyDist = (thisEntity:GetAbsOrigin() - hClosestPlayer:GetAbsOrigin()):Length2D()

		if enemyDist > thisEntity:GetAttackRange() then
			if BlinkAbility ~= nil and BlinkAbility:IsFullyCastable() and enemyDist > 200 then
				return BlinkTo( hClosestPlayer )
			else
				MoveOrder( thisEntity, hClosestPlayer:GetAbsOrigin() )
			end
		else
			if VoidAbility ~= nil and VoidAbility:IsFullyCastable() and hClosestPlayer:GetMana() < 5 then
				return Void( hClosestPlayer )
			else
				AttackTargetOrder(thisEntity, hClosestPlayer)
			end
		end
	end
	
	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation
	
	return 0.5 + fFuzz

end

--------------------------------------------------------------------------------

function DropPotion(hEnemy)
	local newItem = CreateItem( "item_mana_potion", nil, nil )
	local drop = CreateItemOnPositionSync( thisEntity:GetAbsOrigin(), newItem )
	local dropTarget = thisEntity:GetAbsOrigin()
	if hEnemy then
		dropTarget = thisEntity:GetAbsOrigin() + (thisEntity:GetAbsOrigin() - hEnemy:GetAbsOrigin() ):Normalized()*RandomFloat(125,200) 
	end
	newItem:LaunchLoot( true, 75, 0.75, dropTarget )
end


function Stop()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP,
	})
end

function Void( hEnemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = VoidAbility:entindex(),
		TargetIndex = hEnemy:entindex(),
		Queue = false,
	})

	return 0.5
end

function BlinkTo( hEnemy )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = BlinkAbility:entindex(),
		Position = hEnemy:GetAbsOrigin() + (hEnemy:GetAbsOrigin() - hEnemy:GetAbsOrigin())*200,
		Queue = false,
	})

	return 0.55
end
