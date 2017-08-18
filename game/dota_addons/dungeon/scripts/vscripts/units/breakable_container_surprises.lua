
---------------------------------------------------------------------------

function CDungeon:ChooseBreakableSurprise( hAttacker, hBreakableEnt )
	hBreakableEnt.nRewardSpawnDist = 32

	-- Note: hAttacker can be nil

	--[[
	if hAttacker then
		print( string.format( "CDungeon:ChooseBreakableSurprise() - hAttacker: %s", hAttacker:GetUnitName() ) )
	end
	]]

	if hBreakableEnt.zone == nil then
		print( "CDungeon:ChooseBreakableSurprise() -- WARNING: No zone found for this breakable. Defaulting to \"forest\"" )
		hBreakableEnt.zone = self:GetZoneByName( "forest" )
	end

	if hBreakableEnt.CommonItems == nil then
		print( "CDungeon:ChooseBreakableSurprise() -- WARNING: No CommonItems table found for this breakable. Defaulting to branches." )
		hBreakableEnt.CommonItems =
		{
			"item_branches",
		}
	end

	if hBreakableEnt.RareItems == nil then
		print( "CDungeon:ChooseBreakableSurprise() -- WARNING: No RareItems table found for this breakable. Defaulting to clarity." )
		hBreakableEnt.RareItems =
		{
			"item_clarity",
		}
	end

	if hBreakableEnt.nMinGold == nil then
		hBreakableEnt.nMinGold = 100
		print( string.format( "CDungeon:ChooseBreakableSurprise() -- WARNING: Missing nMinGold value for this breakable. Setting it to: %.2f", hBreakableEnt.nMinGold ) )
	end

	if hBreakableEnt.nMaxGold == nil then
		hBreakableEnt.nMaxGold = 200
		print( string.format( "CDungeon:ChooseBreakableSurprise() -- WARNING: Missing nMaxGold value for this breakable. Setting it to: %.2f", hBreakableEnt.nMaxGold ) )
	end

	if hBreakableEnt.fCommonItemChance == nil then
		hBreakableEnt.fCommonItemChance = 0.1
		print( string.format( "CDungeon:ChooseBreakableSurprise() -- WARNING: No fCommonItemChance specified for this breakable. Setting it to %.2f", hBreakableEnt.fCommonItemChance ) )
	end

	if hBreakableEnt.fRareItemChance == nil then
		hBreakableEnt.fRareItemChance = 0.02
		print( string.format( "CDungeon:ChooseBreakableSurprise() -- WARNING: No fRareItemChance specified for this breakable. Setting it to %.2f", hBreakableEnt.fRareItemChance ) )
	end

	if hBreakableEnt.fGoldChance == nil then
		hBreakableEnt.fGoldChance = 0.15
		print( string.format( "CDungeon:ChooseBreakableSurprise() -- WARNING: No fGoldChance specified for this breakable. Setting it to %.2f", hBreakableEnt.fGoldChance ) )
	end

	local fCommonItemThreshold = 1 - hBreakableEnt.fCommonItemChance
	local fRareItemThreshold = fCommonItemThreshold - hBreakableEnt.fRareItemChance
	local fGoldThreshold = fRareItemThreshold - hBreakableEnt.fGoldChance

	local fRandRoll = RandomFloat( 0, 1 )

	--[[
	print( "----------------------------------------" )
	print( string.format( "fRandRoll: %.2f", fRandRoll ) )
	print( string.format( "fCommonItemThreshold: %.2f", fCommonItemThreshold ) )
	print( string.format( "fRareItemThreshold: %.2f", fRareItemThreshold ) )
	print( string.format( "fGoldThreshold: %.2f", fGoldThreshold ) )
	]]

	if fRandRoll >= fCommonItemThreshold then
		self:CreateBreakableContainerCommonItemDrop( hAttacker, hBreakableEnt )
		--print( string.format( "fRandRoll (%.2f) >= fCommonItemThreshold (%.2f)", fRandRoll, fCommonItemThreshold ) )
		return
	elseif fRandRoll >= fRareItemThreshold then
		self:CreateBreakableContainerRareItemDrop( hAttacker, hBreakableEnt )
		--print( string.format( "fRandRoll (%.2f) >= fRareItemThreshold (%.2f)", fRandRoll, fRareItemThreshold ) )
		return
	elseif fRandRoll >= fGoldThreshold then
		--print( string.format( "fRandRoll (%.2f) >= fGoldThreshold (%.2f)", fRandRoll, fGoldThreshold ) )
		self:CreateBreakableContainerGoldDrop( hAttacker, hBreakableEnt )
		return
	else
		-- Drop nothing
		--print( string.format( "else drop nothing, fRandRoll was %.2f", fRandRoll ) )
	end
end

---------------------------------------------------------------------------

function CDungeon:CreateBreakableContainerCommonItemDrop( hAttacker, hBreakableEnt )
	if hBreakableEnt ~= nil and hBreakableEnt.CommonItems ~= nil then
		local nRandomIndex = RandomInt( 1, #hBreakableEnt.CommonItems )
		local newItem = CreateItem( hBreakableEnt.CommonItems[ nRandomIndex ], nil, nil )
		local drop = CreateItemOnPositionForLaunch( hBreakableEnt:GetAbsOrigin(), newItem )

		local vPos = self:GetBreakableRewardSpawnPos( hBreakableEnt )

		if newItem:GetAbilityName() == "item_health_potion" or newItem:GetAbilityName() == "item_mana_potion" then
			newItem:LaunchLootInitialHeight( true, 0, 100, 0.5, vPos )
		else
			newItem:LaunchLootInitialHeight( false, 0, 100, 0.5, vPos )
		end

		EmitSoundOn( "Dungeon.TreasureItemDrop", hBreakableEnt )
	end
end

---------------------------------------------------------------------------

function CDungeon:CreateBreakableContainerRareItemDrop( hAttacker, hBreakableEnt )
	if hBreakableEnt ~= nil and hBreakableEnt.RareItems ~= nil then
		local nRandomIndex = RandomInt( 1, #hBreakableEnt.RareItems )
		local newItem = CreateItem( hBreakableEnt.RareItems[ nRandomIndex ], nil, nil )
		local drop = CreateItemOnPositionForLaunch( hBreakableEnt:GetAbsOrigin(), newItem )

		local vPos = self:GetBreakableRewardSpawnPos( hBreakableEnt )

		newItem:LaunchLootInitialHeight( false, 0, 100, 0.5, vPos )

		EmitSoundOn( "Dungeon.TreasureItemDrop", hBreakableEnt )
	end
end

---------------------------------------------------------------------------

function CDungeon:CreateBreakableContainerGoldDrop( hAttacker, hBreakableEnt )
	local Zone = hBreakableEnt.zone

	local nGoldToDrop = RandomInt( hBreakableEnt.nMinGold, hBreakableEnt.nMaxGold )

	--print( "Zone.nGoldRemaining == " .. Zone.nGoldRemaining )
	if ( Zone.nGoldRemaining <= 0 ) then
		nGoldToDrop = 0
	elseif ( Zone.nGoldRemaining - nGoldToDrop ) <= 0 then
		nGoldToDrop = nGoldToDrop * 0.5
	end
	--print( "Breakable nGoldToDrop == " .. nGoldToDrop )

	--print( "Before breakable drop, Zone.nGoldRemaining == " .. Zone.nGoldRemaining )
	--print( "CDungeon:CreateBreakableContainerGoldDrop() - Drop a bag with " .. nGoldToDrop .. " gold.")
	if nGoldToDrop > 0 then
		local newItem = CreateItem( "item_bag_of_gold", nil, nil )
		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( nGoldToDrop )
		local drop = CreateItemOnPositionSync( hBreakableEnt:GetAbsOrigin(), newItem )

		local vPos = self:GetBreakableRewardSpawnPos( hBreakableEnt )

		newItem:LaunchLoot( true, 100, 0.5, vPos )
		Zone.nGoldRemaining = Zone.nGoldRemaining - nGoldToDrop
		EmitSoundOn( "Dungeon.TreasureItemDrop", hBreakableEnt )
		--print( "After breakable drop, Zone.nGoldRemaining == " .. Zone.nGoldRemaining )
	end
end

---------------------------------------------------------------------------

function CDungeon:GetBreakableRewardSpawnPos( hBreakableEnt )
	local vPos = hBreakableEnt:GetAbsOrigin() + RandomVector( hBreakableEnt.nRewardSpawnDist )

	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( hBreakableEnt:GetOrigin(), vPos ) ) and ( nAttempts < 5 ) ) do
		vPos = hBreakableEnt:GetOrigin() + RandomVector( hBreakableEnt.nRewardSpawnDist )
		nAttempts = nAttempts + 1

		if nAttempts >= 5 then
			vPos = hBreakableEnt:GetOrigin()
		end
	end

	return vPos
end

---------------------------------------------------------------------------

