if GetMapName() == "main" then 
	require( "reward_tables" )
else
	require( "reward_tables_2021" )
end
require( "map_encounter" )


function CAghanim:ChooseBreakableSurprise( hAttacker, hBreakableEnt )
	hBreakableEnt.nRewardSpawnDist = 32

	if hBreakableEnt.RoomReward ~= nil then
		self:SpawnRoomReward( hBreakableEnt, hAttacker )
		return
	end
	-- Note: hAttacker can be nil

	--[[
	if hAttacker then
		print( string.format( "CAghanim:ChooseBreakableSurprise() - hAttacker: %s", hAttacker:GetUnitName() ) )
	end
	]]

	--[[
	--These are initialized when the crate unit is spawned in map_encounter
	printf( "----------------------------------------" )
	printf( "  hBreakableEnt.fRareItemChance: %.2f", hBreakableEnt.fRareItemChance )
	printf( "  hBreakableEnt.fCommonItemChance: %.2f", hBreakableEnt.fCommonItemChance )
	printf( "  hBreakableEnt.fMonsterChance: %.2f", hBreakableEnt.fMonsterChance )
	printf( "  hBreakableEnt.fGoldChance: %.2f", hBreakableEnt.fGoldChance )
	]]

	local fRareItemThreshold = 1 - hBreakableEnt.fRareItemChance
	local fCommonItemThreshold = fRareItemThreshold - hBreakableEnt.fCommonItemChance
	local fMonsterThreshold = fCommonItemThreshold - hBreakableEnt.fMonsterChance
	local fGoldThreshold = fMonsterThreshold - hBreakableEnt.fGoldChance

	local fRandRoll = RandomFloat( 0, 1 )

	--[[
	printf( "----------------------------------------" )
	printf( "fRandRoll: %.2f", fRandRoll )
	printf( "fRareItemThreshold: %.2f", fRareItemThreshold )
	printf( "fCommonItemThreshold: %.2f", fCommonItemThreshold )
	printf( "fMonsterThreshold: %.2f", fMonsterThreshold )
	printf( "fGoldThreshold: %.2f", fGoldThreshold )
	]]

	if fRandRoll >= fRareItemThreshold then
		self:CreateBreakableContainerRareItemDrop( hAttacker, hBreakableEnt )
		--print( string.format( "fRandRoll (%.2f) >= fRareItemThreshold (%.2f)", fRandRoll, fRareItemThreshold ) )
		return
	elseif fRandRoll >= fCommonItemThreshold then
		self:CreateBreakableContainerCommonItemDrop( hAttacker, hBreakableEnt )
		--print( string.format( "fRandRoll (%.2f) >= fCommonItemThreshold (%.2f)", fRandRoll, fCommonItemThreshold ) )
		return
	elseif fRandRoll >= fMonsterThreshold then
		self:CreateBreakableContainerMonsterSpawn( hAttacker, hBreakableEnt )
		--print( string.format( "fRandRoll (%.2f) >= fMonsterThreshold (%.2f)", fRandRoll, fMonsterThreshold ) )
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

function CAghanim:CreateBreakableContainerRareItemDrop( hAttacker, hBreakableEnt )
	if hBreakableEnt ~= nil and hBreakableEnt.RareItems ~= nil then
		local nRandomIndex = RandomInt( 1, #hBreakableEnt.RareItems )
		local newItem = CreateItem( hBreakableEnt.RareItems[ nRandomIndex ], nil, nil )
		local drop = CreateItemOnPositionForLaunch( hBreakableEnt:GetAbsOrigin(), newItem )

		local vPos = self:GetBreakableRewardSpawnPos( hBreakableEnt )

		newItem:LaunchLootInitialHeight( false, 0, 100, 0.5, vPos )

		EmitSoundOn( "Dungeon.TreasureItemDrop", hBreakableEnt )
	end
end

--------------------------------------------------------------------------------

function CAghanim:CreateBreakableContainerCommonItemDrop( hAttacker, hBreakableEnt )
	if hBreakableEnt ~= nil and hBreakableEnt.CommonItems ~= nil then
		local nHealthPotChance = 55 -- hack for quick pseudo-randomness; we're not pulling in the items from the hBreakableEnt table
		--printf( "nHealthPotChance: %d", nHealthPotChance )
		local szItem = nil
		if RollPseudoRandomPercentage( nHealthPotChance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, hAttacker ) == true then
			szItem = "item_health_potion"
			--printf( "pseudo-random roll resulted in health pot" )
		else
			szItem = "item_mana_potion"
			--printf( "pseudo-random roll resulted in mana pot" )
		end

		local newItem = CreateItem( szItem, nil, nil )

		--[[
		local nRandomIndex = RandomInt( 1, #hBreakableEnt.CommonItems )
		local newItem = CreateItem( hBreakableEnt.CommonItems[ nRandomIndex ], nil, nil )
		]]

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

--------------------------------------------------------------------------------

function CAghanim:CreateBreakableContainerMonsterSpawn( hAttacker, hBreakableEnt )
	if hBreakableEnt == nil then
		return
	end

	local monsterUnits = hBreakableEnt.MonsterUnits
	if monsterUnits ~= nil and #monsterUnits > 0 then
		local nRandomIndex = RandomInt( 1, #monsterUnits )
		local szMonsterUnit = monsterUnits[ nRandomIndex ]

		local vPos = self:GetBreakableRewardSpawnPos( hBreakableEnt )

		-- Spawn the monster at vPos

		EmitSoundOn( "Dungeon.TreasureItemDrop", hBreakableEnt )
	end
end

---------------------------------------------------------------------------

function CAghanim:CreateBreakableContainerGoldDrop( hAttacker, hBreakableEnt )
	local nGoldToDrop = RandomInt( hBreakableEnt.nMinGold, hBreakableEnt.nMaxGold )

	--print( "Breakable nGoldToDrop == " .. nGoldToDrop )

	--print( "CAghanim:CreateBreakableContainerGoldDrop() - Drop a bag with " .. nGoldToDrop .. " gold.")
	if nGoldToDrop > 0 then
		local newItem = CreateItem( "item_bag_of_gold", nil, nil )
		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( nGoldToDrop )
		local drop = CreateItemOnPositionSync( hBreakableEnt:GetAbsOrigin(), newItem )

		local vPos = self:GetBreakableRewardSpawnPos( hBreakableEnt )

		newItem:LaunchLoot( true, 100, 0.5, vPos )
		EmitSoundOn( "Dungeon.TreasureItemDrop", hBreakableEnt )
	end
end

---------------------------------------------------------------------------

function CAghanim:GetBreakableRewardSpawnPos( hBreakableEnt )
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
