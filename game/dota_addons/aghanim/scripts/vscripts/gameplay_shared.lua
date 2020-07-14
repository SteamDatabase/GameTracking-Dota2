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

function GetRandomUnique( Array, BlacklistValues, bRemoveFromTable )
	if Array == nil then
		return nil
	end

	--PrintTable( Array, "Array:" )
	--PrintTable( BlacklistValues, "BlacklistValues:" )

	local Whitelist = {}
	if BlacklistValues == nil then
		Whitelist = Array
	else
		for _,Value in pairs(Array) do
			if not TableContainsValue( BlacklistValues, Value ) then	
				table.insert(Whitelist, Value)
			end
		end
	end

	local bIgnoreBlacklist = false
	if #Whitelist < 1 then
		bIgnoreBlacklist = true
		Whitelist = Array
	end

	
	local Candidate = nil
	nIndex = RandomInt(1,#Whitelist)
	Candidate = Whitelist[ nIndex ]

	if bIgnoreBlacklist then
		printf("WARNING: GetRandomUnique returning array[%d] = %s, ignoring blacklist.", nIndex, Candidate)
	end

	if bRemoveFromTable == true then
		local vecRemoveKeys = {}
		for ii=1,#Array do
			table.insert(vecRemoveKeys,ii)
		end
		for _,nIndex in pairs(vecRemoveKeys) do
			table.remove( Array, nIndex )
		end
	end
	
	return Candidate
end
