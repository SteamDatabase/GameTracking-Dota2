function GetAliveHeroesInRoom( )

	local heroes = {}
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero and hPlayerHero:IsAlive() and GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( hPlayerHero:GetAbsOrigin() ) then
				table.insert( heroes, hPlayerHero )
			end
		end
	end

	return heroes

end

function GetAliveHeroes( )

	local heroes = {}
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero and hPlayerHero:IsAlive() then
				table.insert( heroes, hPlayerHero )
			end
		end
	end

	return heroes

end

function FindRandomPointInRoom( vSourcePos, nMinDistance, nMaxDistance )

	local nAttempts = 0
	local nMaxAttempts = 16

	while nAttempts < nMaxAttempts do
		local vPos = vSourcePos + RandomVector( RandomFloat( nMinDistance, nMaxDistance ) )
		if GameRules.Aghanim:GetCurrentRoom():IsValidSpawnPoint( vPos ) then
			return vPos
		end
		nAttempts = nAttempts + 1
	end

	-- Failed, just return the center of the room, + randomness
	return GameRules.Aghanim:GetCurrentRoom():GetOrigin() + RandomVector( RandomFloat( 0, 500 ) )

end

function FindPathablePositionNearby( vSourcePos, nMinDistance, nMaxDistance )
	local vPos = FindRandomPointInRoom( vSourcePos, nMinDistance, nMaxDistance )

	local nAttempts = 0
	local nMaxAttempts = 7

	while ( ( not GridNav:CanFindPath( vSourcePos, vPos ) ) and ( nAttempts < nMaxAttempts ) ) do
		vPos = FindRandomPointInRoom( vSourcePos, nMinDistance, nMaxDistance )
		nAttempts = nAttempts + 1
	end

	return vPos
end

---------------------------------------------------------------------------

function LaunchGoldBag( nGoldAmount, vDropPos, vDropTarget )

	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem.nGoldAmount = nGoldAmount

	-- curve fitting black magic
	local flGoldBagScale = 40.63019 + (-0.4869773 - 40.63019)/(1 + math.pow(nGoldAmount/7576116000, 0.1814258))
	
	flGoldBagScale = math.min( flGoldBagScale, 3)
	flGoldBagScale = math.max( flGoldBagScale, 0.7)

	local newItemPhysical = CreateItemOnPositionSync( vDropPos, newItem )
	newItemPhysical:SetModelScale( flGoldBagScale )

	if vDropTarget == nil then
		vDropTarget = FindRandomPointInRoom( vDropPos, 100, 150 )
	end

	newItem:LaunchLoot( true, 75, 0.75, vDropTarget )

	return newItem
end

--------------------------------------------------------------------------------

function FindRealLivingEnemyHeroesInRadius( nFriendlyTeamNumber, vPosition, flRange )

	local hRealHeroes = {}

	local hEnemies = FindUnitsInRadius( nFriendlyTeamNumber, vPosition, nil, flRange, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )

	for _,hHero in pairs(hEnemies) do
		if hHero:IsAlive() and hHero:IsRealHero() and not hHero:IsTempestDouble() and not hHero:IsClone() then
			table.insert( hRealHeroes, hHero )
		end
	end

	return hRealHeroes

end

--------------------------------------------------------------------------------


function UnitRescueThinker( thisEntity )
	if ( not thisEntity:IsAlive() or thisEntity.bRescued ) then
		return -1
	end

	if GameRules:IsGamePaused() == true or thisEntity.bStartRescue ~= true then
		return 0.1
	end

	if thisEntity.vPortalPos == nil then
		local hSpawner = Entities:FindByName( nil, thisEntity.szGoalEntity )
		if hSpawner then
			thisEntity.vPortalPos = FindPathablePositionNearby( hSpawner:GetAbsOrigin(), 50, 350 )
		end
	end

	if thisEntity.bReachedGoal ~= true then
		thisEntity.nHoldTime = 0
		local bReached = false
		if thisEntity.vPortalPos ~= nil then
			thisEntity:MoveToPosition( thisEntity.vPortalPos )
			local vPos = thisEntity:GetOrigin()
			local difference = vPos - thisEntity.vPortalPos
			local distance = difference:Length()
			if distance < 100 then
				thisEntity.bReachedGoal = true
			end
		else
			thisEntity.bReachedGoal = true
		end
		if thisEntity.bReachedGoal == true then
			thisEntity:Hold()
			local szPortalFX = "particles/econ/events/league_teleport_2014/teleport_start_league.vpcf"
			thisEntity.nPortalFX = ParticleManager:CreateParticle( szPortalFX, PATTACH_ABSORIGIN_FOLLOW, thisEntity )
			ParticleManager:SetParticleControlEnt( thisEntity.nPortalFX, 0, thisEntity, PATTACH_ABSORIGIN_FOLLOW, nil, thisEntity:GetAbsOrigin(), true )
			thisEntity:Attribute_SetIntValue( "effectsID", thisEntity.nPortalFX )
			EmitSoundOn("Creature.Sheep.Portal_Start", thisEntity)
		end
	else
		if thisEntity.nHoldTime < 3 then
			thisEntity.nHoldTime = thisEntity.nHoldTime + 1
		elseif thisEntity.szGoldFountainAbility ~= nil and thisEntity.bUsedGoldFountainAbility ~= true then
			local hGoldAbility = thisEntity:FindAbilityByName( thisEntity.szGoldFountainAbility )
			if hGoldAbility == nil then
				thisEntity.szGoldFountainAbility = nil
				return 0.1
			end

			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hGoldAbility:entindex(),
				Queue = false,
			})
			thisEntity.bUsedGoldFountainAbility = true
			if thisEntity.tGoldFountainGameEvent ~= nil then
				FireGameEvent( "dota_combat_event_message", thisEntity.tGoldFountainGameEvent )
			end
			thisEntity.bSoundStopped = true
			StopSoundOn("Creature.Sheep.Portal_Start", thisEntity)
			EmitSoundOn("Creature.Sheep.Portal_End", thisEntity)
		else
			if thisEntity.bSoundStopped ~= true then
				StopSoundOn("Creature.Sheep.Portal_Start", thisEntity)
				EmitSoundOn("Creature.Sheep.Portal_End", thisEntity)
			end

			if thisEntity.bUsedGoldFountainAbility == nil and thisEntity.nRescueGoldAmount > 0 then
				local nAdjustedAmount = math.ceil( thisEntity.nRescueGoldAmount * GameRules.Aghanim:GetGoldModifier() / 100 )
				local newItem = CreateItem( "item_bag_of_gold", nil, nil )
				newItem:SetPurchaseTime( 0 )
				newItem:SetCurrentCharges( nAdjustedAmount )
				CreateItemOnPositionSync( thisEntity:GetAbsOrigin(), newItem )
				local dropTarget = FindPathablePositionNearby( thisEntity:GetAbsOrigin(), 50, 250 )
				newItem:LaunchLoot( true, 300, 0.75, dropTarget )
			end

			thisEntity.bRescued = true

			local hBase = Entities:FindByName( nil, "rescued_units_locator" )
			local vTargetPoint = hBase:GetOrigin()
			thisEntity:SetAbsOrigin( vTargetPoint )
			local hRoomHub = GameRules.Aghanim.rooms[ "hub" ]
			local bKill = true
			if hRoomHub ~= nil then
				if hRoomHub.vecRescuedUnits == nil then
					hRoomHub.vecRescuedUnits = {}
				end
				local nRescuedCount = hRoomHub.vecRescuedUnits[ thisEntity:GetUnitName() ]
				if nRescuedCount == nil then
					nRescuedCount = 0
				end
				if nRescuedCount == 0 or thisEntity.bRescueOnlyOne ~= true then
					bKill = false
					hRoomHub.vecRescuedUnits[ thisEntity:GetUnitName() ] = nRescuedCount + 1
				end
			end
			if bKill then
				thisEntity:ForceKill(false)
			else
				FindClearSpaceForUnit( thisEntity, vTargetPoint, true )
				thisEntity:AddNewModifier( thisEntity, nil, "modifier_rescued_unit", {} )
			end
			ParticleManager:DestroyParticle( thisEntity.nPortalFX, false )
			thisEntity.nPortalFX = nil
		end
	end
	
	return 1
end