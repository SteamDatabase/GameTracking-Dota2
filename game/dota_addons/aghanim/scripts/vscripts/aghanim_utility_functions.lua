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
