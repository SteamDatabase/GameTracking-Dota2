require( "ai/ai_shared" )
require( "event_queue" )

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	thisEntity.EventQueue = CEventQueue()

	thisEntity.hBallLightning = thisEntity:FindAbilityByName( "creature_large_storm_spirit_ball_lightning" )
	thisEntity.hElectricVortex = thisEntity:FindAbilityByName( "creature_large_storm_spirit_electric_vortex" )	
	
	local flNow = GameRules:GetGameTime()
	thisEntity.flSpawnTime = flNow

	thisEntity.flLastPlayerInvadeTime = flNow - 10
	thisEntity.flLastRetreatTime = flNow

	thisEntity.hBallQueue = {}
	thisEntity.hBallCastQueue = {}
	thisEntity.vSafeSpace = Vector(2290.375, 1452.0, 384.0)
	--thisEntity.vThronePosition = Vector(3914.250000, -2507.468750, 517.000000)
	thisEntity.flLastItemUsed = flNow

	local fInitialDelay = RandomFloat( 0, 8 ) -- separating out the timing of all the ranged creeps' thinks
	thisEntity:SetContextThink( "StormSpiritThink", StormSpiritThink, fInitialDelay )
end

function StormSpiritThink()
	if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false then
		return -1
	end

	local flNow = GameRules:GetGameTime()

	local hEnemies = GetVisibleEnemyHeroesInRange( thisEntity, 10000 )
	local hTarget = GetRandomUnique( hEnemies )

	local bZipping = thisEntity:FindModifierByName("modifier_storm_spirit_ball_lightning") ~= nil

	if thisEntity.bInvading == nil and not bZipping then

		if hTarget and (flNow-thisEntity.flLastPlayerInvadeTime) > 2.5 then
			printf("invading player %s", hTarget:GetName())
			local vInvadePosition = hTarget:GetOrigin() + ( hTarget:GetOrigin()-thisEntity:GetOrigin() ):Normalized()*300
			table.insert( thisEntity.hBallQueue, { pos = vInvadePosition, delay=0, invade=true } )	
			thisEntity.hHateTarget = hTarget
		end

		if (thisEntity:GetHealth() < thisEntity:GetMaxHealth()/4) and (flNow-thisEntity.flLastRetreatTime) > 8 then
			local vRetreatPosition = thisEntity.vSafeSpace + RandomVector(500)	
			printf("retreating to %s", vRetreatPosition )
			table.insert( thisEntity.hBallQueue, { pos = vRetreatPosition, delay=0, invade=false } )	
		end

		if thisEntity.hHateTarget and (flNow-thisEntity.flLastItemUsed) > RandomFloat(1,2.5) then
			local nRandom = RandomInt(0,5)
			if nRandom == 0 then
				if( CastPositionalItem( thisEntity, thisEntity.hHateTarget, "item_viel_of_discord" ) ) then
					thisEntity.flLastItemUsed = flNow
				end
			elseif nRandom == 1 then
				if( CastTargetedItem( thisEntity, thisEntity.hHateTarget, "item_dagon_5" ) ) then
					thisEntity.flLastItemUsed = flNow
				end
			elseif nRandom == 2 then
				if( CastUntargetedItem( thisEntity, "item_shivas_guard" ) ) then
					thisEntity.flLastItemUsed = flNow
				end
			elseif nRandom == 3 then
				if( CastTargetedItem( thisEntity, thisEntity.hHateTarget, "item_sheepstick" ) ) then
					thisEntity.flLastItemUsed = flNow
				end
			elseif nRandom == 4 then
				if( CastTargetedItem( thisEntity, thisEntity.hHateTarget, "item_bloodthorn" ) ) then
					thisEntity.flLastItemUsed = flNow
				end
			end
		end

	end

	if not bZipping then
		return ProcessBallQueue(thisEntity)
	end

	return 0.5
end

function ProcessBallQueue(hCaster)
	
	local flNow = GameRules:GetGameTime()

	if thisEntity.bInvading == true then
		thisEntity.flLastPlayerInvadeTime = flNow
		thisEntity.bInvading = nil
		printf("starting invade at %s", flNow)
	elseif thisEntity.bInvading == false then
		thisEntity.flLastRetreatTime = flNow
		thisEntity.flLastPlayerInvadeTime = flNow + 1
		thisEntity.bInvading = nil
		printf("starting retreat at %s", flNow)
	end

	if thisEntity.hBallLightning:IsFullyCastable() then
		local hTop = table.remove(thisEntity.hBallQueue,1)
		if hTop ~= nil then
			table.insert(thisEntity.hBallCastQueue, hTop)
			thisEntity.EventQueue:AddEvent( hTop.delay,
			function(thisEntity,hTop)
				table.remove(thisEntity.hBallCastQueue)
				CastBallLightning( thisEntity, hTop.pos )	
				if hTop.invade == true then
					thisEntity.bInvading = true
				elseif hTop.invade == false then
					thisEntity.bInvading = false
				end
			end, thisEntity, hTop )
		end
		return 1.0
	end

	return 0.5
end

function CastBallLightning( hCaster, vPosition )
	if hCaster == nil or hCaster:IsNull() then
		return -1
	end

	local flNow = GameRules:GetGameTime()

	--printf("casting ball lightning on %s to %s at %s", hCaster, vPosition, flNow)

	local hAbility = hCaster.hBallLightning
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPosition,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 0.5
end
