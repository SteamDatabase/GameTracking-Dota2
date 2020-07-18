require( "utility_functions" )

function GrantItemDropToHero( hPlayerHero, szItemName )

	local hItem = hPlayerHero:AddItemByName( szItemName )

	if hItem == nil then
		local newItem = CreateItem( szItemName, hPlayerHero, hPlayerHero )
		newItem:SetPurchaseTime( 0 )
		local drop = CreateItemOnPositionSync( hPlayerHero:GetAbsOrigin(), newItem )
		local dropTarget = hPlayerHero:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
		newItem:LaunchLoot( false, 150, 0.75, dropTarget )

		printf("launching loot for %s", hPlayerHero)
		return newItem
	end
	return hItem
end

function GetPlayerAbilitiesAndItems( nPlayerID )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )

	local vecAbilityNames = {}

	if hPlayerHero == nil then
		--printf("GetPlayerAbilitiesAndItems: no entity for Player ID %d, returning empty list.", nPlayerID)
		return vecAbilityNames
	end

	for ii=0,15 do
		local hItem = hPlayerHero:GetItemInSlot(ii)
		if hItem and hItem:GetAbilityName() then
			table.insert( vecAbilityNames, hItem:GetAbilityName() )
		end
	end

	for ii=0,(hPlayerHero:GetAbilityCount()-1) do
		local hAbility = hPlayerHero:GetAbilityByIndex(ii)
		if hAbility and hAbility:GetAbilityName() then
			table.insert( vecAbilityNames, hAbility:GetAbilityName() )
		end
	end

	return vecAbilityNames;

end
