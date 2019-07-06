
function CJungleSpirits:DropSpiritGems( hUnit, nAmount, hKiller )
	if IsServer() then
		local szItemName = "item_spirit_gem"
		local fModelScale = SMALL_GEM_MODELSCALE

		if nAmount >= 5 and nAmount < 20 then
			szItemName = "item_spirit_gem_medium"
			fModelScale = MEDIUM_GEM_MODELSCALE
		elseif nAmount >= 20 then
			szItemName = "item_spirit_gem_big"
			fModelScale = BIG_GEM_MODELSCALE
		end

		local vPos = hUnit:GetAbsOrigin()

		--printf( "DropSpiritGems - dropping \"%s\"", szItemName )

		local newItem = CreateItem( szItemName, nil, nil )

		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( nAmount )

		local hPhysicalItem = CreateItemOnPositionSync( vPos, newItem )
		hPhysicalItem:SetModelScale( fModelScale )

		local dropTarget = vPos + RandomVector( RandomFloat( 100, 200 ) )
		newItem:LaunchLoot( true, 200, 0.5, dropTarget )

		local hSpiritGemModifier = hUnit:FindModifierByName( "modifier_spirit_gem" )
		if hSpiritGemModifier ~= nil then
			local nNewStackAmount = hSpiritGemModifier:GetStackCount() - nAmount
			hSpiritGemModifier:SetStackCount( nNewStackAmount )
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:DropGemStackFromUnit( hUnit, nAmount, hKiller )
	local nGemsToDrop = nAmount

	-- For feel, guarantee we're always dropping a few single essence items,
	-- rather than merging everything aggressively into higher denominations
	if nGemsToDrop >= 5 then
		for i = 1, 5 do
			self:DropSpiritGems( hUnit, GEMS_PER_SMALL_ITEM, hKiller )
			nGemsToDrop = nGemsToDrop - GEMS_PER_SMALL_ITEM
		end
	end

	-- Drop large denominations next if we can
	local nBigGemsToDrop = math.floor( nGemsToDrop / GEMS_PER_BIG_ITEM )
	--printf( "dropping %d large cupcakes", nBigGemsToDrop )

	for i = 1, nBigGemsToDrop do
		self:DropSpiritGems( hUnit, GEMS_PER_BIG_ITEM, hKiller )
		nGemsToDrop = nGemsToDrop - GEMS_PER_BIG_ITEM
	end

	-- Drop medium denominations next if we can
	local nMediumGemsToDrop = math.floor( nGemsToDrop / GEMS_PER_MEDIUM_ITEM )
	--printf( "dropping %d medium cupcakes", nMediumGemsToDrop )

	for i = 1, nMediumGemsToDrop do
		self:DropSpiritGems( hUnit, GEMS_PER_MEDIUM_ITEM, hKiller )
		nGemsToDrop = nGemsToDrop - GEMS_PER_MEDIUM_ITEM
	end

	-- Drop any remaining ones as single items
	--printf( "dropping %d small cupcakes", nGemsToDrop )

	for i = 1, nGemsToDrop do
		self:DropSpiritGems( hUnit, GEMS_PER_SMALL_ITEM, hKiller )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetGemsTillNextTier( hSpirit, nBranch )
	if nBranch < SPIRIT_BRANCH_JUNGLE and nBranch > SPIRIT_BRANCH_VOLCANO then
		print( "Accessing invalid branch " .. nBranch )
		return -1
	end

	if hSpirit == nil then
		print ( "invalid spirit passed to get gems required for next tier" )
		return -1
	end

	local branchTable = hSpirit.BranchData[nBranch]
	if branchTable == nil then
		print( "branch not found" )
		return -1
	end

	local nNextLevel = branchTable.nCurrentTier + 1
	if nNextLevel > 13 then
		return -1
	end

	return CUPCAKES_REQUIRED_PER_BRANCH_LEVEL[ hSpirit:GetLevel() ] - branchTable.nCurrentXP
end

--------------------------------------------------------------------------------

function CJungleSpirits:CanSpendGems( nGems, hSpirit, nBranch, bUpgrade )
	if nBranch < SPIRIT_BRANCH_JUNGLE or nBranch > SPIRIT_BRANCH_VOLCANO then
		print( "Accessing invalid branch " .. nBranch )
		return false
	end

	if hSpirit == nil then
		print ( "invalid spirit passed to get gems required for next tier" )
		return false
	end

	local branchTable = hSpirit.BranchData[nBranch]
	if branchTable == nil then
		print( "branch not found" )
		return false
	end

	local nNextLevel = branchTable.nCurrentTier + 1
	if nNextLevel > 10 and bUpgrade then
		print( "Cannot upgrade max level branch" )
		return false
	end

	if nNextLevel == 1 and not bUpgrade then
		print( "Cannot use unlearned global ability" )
		return false
	end
	
	local nMorokaiLevel = hSpirit:GetLevel() - 1
	if nMorokaiLevel == 0 then
		nMorokaiLevel = 1
	end

	local nGemsRequirement = self:GetGemCost( nBranch, nMorokaiLevel , bUpgrade )
	--print( "Need " .. nGemsRequirement .. " to do this action" )
	return nGems >= nGemsRequirement
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetGemCost( nBranch, nTier, bUpgrade )
	if bUpgrade then
		if nTier == #CUPCAKES_REQUIRED_PER_BRANCH_LEVEL then
			return math.floor( CUPCAKES_REQUIRED_PER_BRANCH_LEVEL[ nTier ] * GEMS_REQUIRED_PCT )
		else
			return math.floor( CUPCAKES_REQUIRED_PER_BRANCH_LEVEL[ nTier + 1 ] * GEMS_REQUIRED_PCT )
		end
	else
		return CUPCAKES_COST_PER_TEAM_SHARED_ABILITY[ nTier ]  
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:AddGemsToUnit( hUnit, nGems )
	local hSpiritGemModifier = hUnit:FindModifierByName( "modifier_spirit_gem" )
	if hSpiritGemModifier then
		local nCreepGemStack = self:GetScaledAndRandomizedGemCount( nGems )
		hSpiritGemModifier:SetStackCount( nCreepGemStack )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetScaledAndRandomizedGemCount( nBaseGemCount )
	local nFinalGemCount = self:ScaleGemAmountWithGameTime( nBaseGemCount )
	nFinalGemCount = self:GetGemFuzzForValue( nFinalGemCount )

	return nFinalGemCount
end

--------------------------------------------------------------------------------

function CJungleSpirits:ScaleGemAmountWithGameTime( nBaseGemAmount )
	--self:TestGemScaleValues( nBaseGemAmount )

	local nMinutesElapsed = math.floor( GameRules:GetGameTime() / 60 )
	local fBonus = nMinutesElapsed * GEM_BONUS_GAIN_PER_MINUTE
	local nScaledGemAmount = math.floor( nBaseGemAmount + fBonus )

	--printf( "%d mins elapsed, resulting in a %.2f bonus, so increase base gem amt from %d to %d", nMinutesElapsed, fBonus, nBaseGemAmount, nScaledGemAmount )

	return nScaledGemAmount
end

--------------------------------------------------------------------------------

function CJungleSpirits:TestGemScaleValues( nBaseGemAmount )
	printf( "TestGemScaleValues" )

	for nMinutesElapsed = 1, 60 do
		local fBonus = nMinutesElapsed * GEM_BONUS_GAIN_PER_MINUTE
		local nScaledGemAmount = math.floor( nBaseGemAmount + fBonus )

		printf( "nScaledGemAmount: %.2f", nScaledGemAmount )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetGemFuzzForValue( nGemCount )
	local fMultiplier = 1.0 + RandomFloat( -GEM_AMOUNT_FUZZ_RANGE, GEM_AMOUNT_FUZZ_RANGE )
	local nFuzzyGemCount = math.floor( nGemCount * fMultiplier )

	--printf( "nGemCount == %d, fMultiplier == %.2f, nFuzzyGemCount == %d", nGemCount, fMultiplier, nFuzzyGemCount )

	return nFuzzyGemCount
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetMaxTier( hSpirit )
	local nMaxTier = hSpirit.BranchData[SPIRIT_BRANCH_JUNGLE].nCurrentTier
	for i = SPIRIT_BRANCH_JUNGLE,SPIRIT_BRANCH_VOLCANO do
		if hSpirit.BranchData[i].nCurrentTier > nMaxTier then
			nMaxTier = hSpirit.BranchData[i].nCurrentTier
		end
	end

	return nMaxTier
end

--------------------------------------------------------------------------------