
require( "utility_functions" )

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------

function GetPlayerAbilitiesAndItems( nPlayerID )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )

	local vecAbilities = {}

	if hPlayerHero == nil then
		--printf("GetPlayerAbilitiesAndItems: no entity for Player ID %d, returning empty list.", nPlayerID)
		return vecAbilities
	end

	-- @todo: fix this not catching neutral item slot (maybe not bottle either)
	for i = 0, 15 do
		local hItem = hPlayerHero:GetItemInSlot( i )
		if hItem then
			table.insert( vecAbilities, hItem )
		end
	end

	for i = 0, ( hPlayerHero:GetAbilityCount() - 1 ) do
		local hAbility = hPlayerHero:GetAbilityByIndex( i )
		if hAbility then
			table.insert( vecAbilities, hAbility )
		end
	end

	return vecAbilities
end

--------------------------------------------------------------------------------

function GetPlayerAbilityAndItemNames( nPlayerID )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )

	local vecAbilityNames = {}

	if hPlayerHero == nil then
		--printf("GetPlayerAbilityAndItemNames: no entity for Player ID %d, returning empty list.", nPlayerID)
		return vecAbilityNames
	end

	-- @todo: fix this not catching neutral item slot (maybe not bottle either)
	for i = 0, 15 do
		local hItem = hPlayerHero:GetItemInSlot( i )
		if hItem and hItem:GetAbilityName() then
			table.insert( vecAbilityNames, hItem:GetAbilityName() )
		end
	end

	for i = 0, ( hPlayerHero:GetAbilityCount() - 1 ) do
		local hAbility = hPlayerHero:GetAbilityByIndex( i )
		if hAbility and hAbility:GetAbilityName() then
			table.insert( vecAbilityNames, hAbility:GetAbilityName() )
		end
	end

	return vecAbilityNames;
end

--------------------------------------------------------------------------------
