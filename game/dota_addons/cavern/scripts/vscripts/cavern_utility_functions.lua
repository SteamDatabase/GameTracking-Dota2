

function LaunchGoldBag( nGoldAmount, vDropPos, vDropTarget )

	local newItem = CreateItem( "item_cavern_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem.nGoldAmount = nGoldAmount

	-- curve fitting black magic
	local flGoldBagScale = 40.63019 + (-0.4869773 - 40.63019)/(1 + math.pow(nGoldAmount/7576116000, 0.1814258))
	
	flGoldBagScale = math.min( flGoldBagScale, 3)
	flGoldBagScale = math.max( flGoldBagScale, 0.7)

	local newItemPhysical = CreateItemOnPositionSync( vDropPos, newItem )
	newItemPhysical:SetModelScale( flGoldBagScale )

	if vDropTarget == nil then
		vDropTarget = vDropPos + RandomVector( RandomFloat( 100, 150 ) )
	end

	newItem:LaunchLoot( true, 75, 0.75, vDropTarget )

	return newItem

end

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
	