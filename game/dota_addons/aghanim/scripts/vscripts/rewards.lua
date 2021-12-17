require( "constants" )
require( "gameplay_shared" )
require( "map_room" )
if GetMapName() == "main" then 
	require( "reward_tables" )
else
	require( "reward_tables_2021" )
end
require( "utility_functions" )
require( "ai/shared" )
require( "aghanim_ability_upgrade_interface" )


function GetMinMaxGoldChoiceReward( nRoomDepth, bElite )
	local nFixedGoldAwardOfDepth = ENCOUNTER_DEPTH_GOLD_REWARD[ nRoomDepth ]
	local nAdjustedFixedAmountOfDepth = math.ceil( nFixedGoldAwardOfDepth * GameRules.Aghanim:GetGoldModifier() / 100 )
	if bElite then
		--print( "Elite Room, increasing expected value of item reward " .. nFixedGoldAwardOfDepth .. " to " .. nFixedGoldAwardOfDepth * ELITE_VALUE_MODIFIER )
		nAdjustedFixedAmountOfDepth = nAdjustedFixedAmountOfDepth * ELITE_VALUE_MODIFIER
	end
	local nMaxValue = math.ceil( nAdjustedFixedAmountOfDepth * GOLD_REWARD_CHOICE_MAX_PCT )
	local nMinValue = math.floor( nAdjustedFixedAmountOfDepth * GOLD_REWARD_CHOICE_MIN_PCT ) 
	return nMinValue, nMaxValue
end

function GetPricedNeutralItems( nRoomDepth, bElite )
	local vecItemRewards = PRICED_ITEM_REWARD_LIST
	local nFixedGoldAwardOfDepth = ENCOUNTER_DEPTH_GOLD_REWARD[ nRoomDepth ]
	if bElite then
		--print( "Elite Room, increasing expected value of item reward " .. nFixedGoldAwardOfDepth .. " to " .. nFixedGoldAwardOfDepth * ELITE_NEUTRAL_ITEM_VALUE_MODIFIER )
		nFixedGoldAwardOfDepth = nFixedGoldAwardOfDepth * ELITE_NEUTRAL_ITEM_VALUE_MODIFIER
	end
	local flBonusPct = PRICED_ITEM_BONUS_DEPTH_PCT * nRoomDepth
	local nMaxValue = math.ceil( nFixedGoldAwardOfDepth * ( PRICED_ITEM_GOLD_MAX_PCT + flBonusPct ) )
	local nMinValue = math.floor( nFixedGoldAwardOfDepth * ( PRICED_ITEM_GOLD_MIN_PCT + flBonusPct ) ) 
	local vecPossibleItems = {}

	for szItemName, nValue in pairs( vecItemRewards ) do
		if nValue >= nMinValue and nValue <= nMaxValue then
			table.insert( vecPossibleItems, szItemName )
		end
	end

	if #vecPossibleItems == 0 then 
		print( "WARNING: Depth " .. tostring( nRoomDepth ) .. " found no valid priced neutral items between " .. tostring( nMinValue ) .. " and " .. tostring( nMaxValue ) )
	else
		print( "Depth " .. tostring( nRoomDepth ) .. " has " .. #vecPossibleItems .. " items between " .. tostring( nMinValue ) .. " and " .. tostring( nMaxValue ) )
	end

	return vecPossibleItems
end


function GetRandomUnique( hRandomStream, Array, BlacklistValues )
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
	nIndex = hRandomStream:RandomInt(1,#Whitelist)
	Candidate = Whitelist[ nIndex ]

	if bIgnoreBlacklist then
		--printf("WARNING: GetRandomUnique returning array[%d] = %s, ignoring blacklist.", nIndex, Candidate)
	end
	
	return Candidate
end

function GetRoomRewards( nRoomDepth, bElite, nPlayerID, vecExternalExcludeList )

	local vecRewardStruct = nil	

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )

	if hPlayerHero == nil then
		--printf("GetRoomRewards; Aborting, no hero entity for Player %d", nPlayerID )
		return nil
	end

	local hBlessingEliteUpgrade = hPlayerHero:FindModifierByName( "modifier_blessing_elite_shard_upgrade" )

	if( vecExternalExcludeList == nil ) then
		vecExternalExcludeList = {}
	end

	local bLimitUltimateUpgrades = tonumber(nRoomDepth) == 1

	local szHeroName = hPlayerHero:GetName()

	vecRewardStruct = ROOM_REWARDS[ "depth_" .. nRoomDepth].normal

	local hHeroRandomStream = GameRules.Aghanim:GetHeroRandomStream( nPlayerID )

	-- first, choose the appropriate reward tier for each option
	local vecGeneratedRewardTiers = {}

	for _,aRewardDef in pairs( vecRewardStruct ) do

		local flRoll = hHeroRandomStream:RandomFloat(0, 100.0)
		local flThreshold = 0.0

		for eRewardTier,flPct in pairs( aRewardDef ) do
			flThreshold = flThreshold + flPct
			if flRoll <= flThreshold then
				table.insert( vecGeneratedRewardTiers, eRewardTier )
				break
			end
		end
	end

	if TableLength(vecGeneratedRewardTiers) < 1 then
		return nil
	end

	-- shuffle the chosen reward tiers so that progressive probabilities are randomized
	ShuffleListInPlace( vecGeneratedRewardTiers, hHeroRandomStream )

	-- exclude any item or ability they've learned, chosen, have in inventory or are externally marked for exclusion
	local vecAbilitiesToExclude = GetPlayerAbilityAndItemNames( nPlayerID )
	for ii=1,nRoomDepth-1 do
		local RewardChoices = CustomNetTables:GetTableValue( "reward_choices", tostring(ii) )
		local RewardChoice = RewardChoices and RewardChoices[ tostring(nPlayerID) ] or nil
		if RewardChoice and RewardChoice["ability_name"] and RewardChoice["reward_type"] ~= "REWARD_TYPE_MINOR_ABILITY_UPGRADE" and RewardChoice["reward_type"] ~= "REWARD_TYPE_MINOR_STATS_UPGRADE" then
			table.insert( vecAbilitiesToExclude, RewardChoice["ability_name"] )
		end
	end

	for _,ExcludeAbility in pairs(vecExternalExcludeList) do
		table.insert( vecAbilitiesToExclude, ExcludeAbility )
	end

	local MinorUpgrades = deepcopy( MINOR_ABILITY_UPGRADES[ szHeroName ] )
	-- DISABLING this check. Causes a bug in trap rooms where the hero doesn't have their abilities. This was needed for minor upgrades of legendary shards, but we aren't using that.
	-- for nMinorUpgrade=#MinorUpgrades,1,-1 do 
	-- 	local Upgrade = MinorUpgrades[ nMinorUpgrade ]
	-- 	local szUpgradeAbilityName = Upgrade[ "ability_name" ]
	-- 	local hAbilityUpgrade = hPlayerHero:FindAbilityByName( szUpgradeAbilityName )
	-- 	if ( hAbilityUpgrade == nil or ( hAbilityUpgrade:IsHidden() and not hAbilityUpgrade:IsAttributeBonus() ) ) then
	-- 		-- print( "Removing upgrade " .. szUpgradeAbilityName .. " for hero " .. szHeroName )
	-- 		table.remove( MinorUpgrades, nMinorUpgrade )
	-- 	end
	-- end

	local MinorStatsUpgrades = deepcopy( MINOR_ABILITY_UPGRADES[ "base_stats_upgrades" ] )
	for nStatUpgrade=#MinorStatsUpgrades,1,-1 do
		local Upgrade = MinorStatsUpgrades[ nStatUpgrade ]
		for k,v in pairs ( STAT_UPGRADE_EXCLUDES[ szHeroName ] ) do
			if Upgrade[ "description" ] == v then
				--print( "blacklisting stat upgrade " .. v .. " for hero " .. szHeroName )
				table.remove( MinorStatsUpgrades, nStatUpgrade )
				break
			end
		end
	end

	-- then for each option, roll a reward type, and don't repeat types
	local vecGeneratedRewards = {}
	local vecMinorAbilityIDsToExclude = {}
	for _,eRewardTier in pairs(vecGeneratedRewardTiers) do

		local eGeneratedRewardType = nil 
	
		local aRewardTierDef = RebalanceRewards( REWARD_TIER_TABLE[eRewardTier], vecGeneratedRewards )

		local flRoll = hHeroRandomStream:RandomFloat(0, 100.0)
		local flThreshold = 0.0
		local MinorAbilityUpgrade = nil
		local MinorStatsUpgrade = nil

		for eRewardType,flPct in pairs( aRewardTierDef ) do

			flThreshold = flThreshold + flPct
			if flRoll <= flThreshold then

				local szAbilityName = nil
				local nQuantity = nil
				
				local nRarity = AGHANIM_REWARD_RARITY_COMMON
				if bElite then
					nRarity = AGHANIM_REWARD_RARITY_ELITE
				end
				if hBlessingEliteUpgrade ~= nil and bElite == false and eRewardType ~= "REWARD_TYPE_ABILITY_UPGRADE" and #vecGeneratedRewards == 0 then
					if hBlessingEliteUpgrade:IsAppliedToDepth( nRoomDepth ) then
						nRarity = AGHANIM_REWARD_RARITY_ELITE
					elseif hBlessingEliteUpgrade:CanApplyToDepth( nRoomDepth ) then
						hBlessingEliteUpgrade:ApplyToDepth( nRoomDepth )
						nRarity = AGHANIM_REWARD_RARITY_ELITE
					end
				end

				if eRewardType == "REWARD_TYPE_ABILITY_UPGRADE" then
					szAbilityName = GetRandomUnique( hHeroRandomStream, SPECIAL_ABILITY_UPGRADES[szHeroName], vecAbilitiesToExclude )
					nRarity = AGHANIM_REWARD_RARITY_LEGENDARY
				elseif eRewardType == "REWARD_TYPE_MINOR_ABILITY_UPGRADE" then
					local k = hHeroRandomStream:RandomInt( 1, #MinorUpgrades )
					local Upgrade = MinorUpgrades[ k ]
					table.remove( MinorUpgrades, k )
					MinorAbilityUpgrade = deepcopy( Upgrade )
					if nRarity == AGHANIM_REWARD_RARITY_ELITE then
						--print( "Elite Room, increasing expected value of ability upgrade from " .. MinorAbilityUpgrade[ "value" ] .. " to " .. MinorAbilityUpgrade[ "value" ] * ELITE_VALUE_MODIFIER )
						if MinorAbilityUpgrade[ "special_values" ] == nil then 
							MinorAbilityUpgrade[ "value" ] = MinorAbilityUpgrade[ "value" ] * ELITE_VALUE_MODIFIER
						else
							for _,SpecialValue in pairs ( MinorAbilityUpgrade[ "special_values" ] ) do
								SpecialValue[ "value" ] = SpecialValue[ "value" ] * ELITE_VALUE_MODIFIER
							end
						end
					end
					--table.insert( vecMinorAbilityIDsToExclude, MinorAbilityUpgrade[ "id" ] ) 
				elseif eRewardType == "REWARD_TYPE_MINOR_STATS_UPGRADE" then
					local k = hHeroRandomStream:RandomInt( 1, #MinorStatsUpgrades )
					local StatsUpgrade = MinorStatsUpgrades[ k ]
					table.remove( MinorStatsUpgrades, k )
					MinorStatsUpgrade = deepcopy( StatsUpgrade )
					if nRarity == AGHANIM_REWARD_RARITY_ELITE then
						--print( "Elite Room, increasing expected value of stats upgrade from " .. MinorStatsUpgrade[ "value" ] .. " to " .. MinorStatsUpgrade[ "value" ] * ELITE_VALUE_MODIFIER )
						MinorStatsUpgrade[ "value" ] = MinorStatsUpgrade[ "value" ] * ELITE_VALUE_MODIFIER
					end
				end

				if szAbilityName ~= nil then

					if bLimitUltimateUpgrades and szAbilityName and string.match(szAbilityName, ULTIMATE_ABILITY_NAMES[szHeroName] ) then
						for _key,szAbilityUpgrade in pairs(SPECIAL_ABILITY_UPGRADES[szHeroName]) do
							if string.match(szAbilityUpgrade, ULTIMATE_ABILITY_NAMES[szHeroName] ) then
								table.insert( vecAbilitiesToExclude, szAbilityUpgrade )
							end
						end
					end

					table.insert( vecAbilitiesToExclude, szAbilityName )
				end

				local GeneratedReward = 
				{
					reward_type  = eRewardType,
					reward_tier  = eRewardTier,
					ability_name = szAbilityName,
					quantity = nQuantity,
					rarity = nRarity,
				}

				if nRarity == AGHANIM_REWARD_RARITY_ELITE then
					GeneratedReward[ "elite" ] = 1
				else
					GeneratedReward[ "elite" ] = 0
				end

				if MinorAbilityUpgrade ~= nil then
					GeneratedReward[ "ability_name" ] = MinorAbilityUpgrade[ "ability_name" ]
					GeneratedReward[ "description" ] = MinorAbilityUpgrade[ "description" ]
					GeneratedReward[ "value" ] = MinorAbilityUpgrade[ "value" ]
					GeneratedReward[ "special_values" ] = MinorAbilityUpgrade [ "special_values" ]
					if GeneratedReward[ "special_values" ] then 
						local nValue = 1
						for _,SpecialValue in pairs ( GeneratedReward[ "special_values" ] ) do
							GeneratedReward[ "value" .. tostring( nValue ) ] = tonumber( SpecialValue[ "value" ] )
							nValue = nValue + 1
						end
					end
					
					GeneratedReward[ "id" ] = MinorAbilityUpgrade[ "id" ]
				end

				if MinorStatsUpgrade ~= nil then
					GeneratedReward[ "ability_name" ] = MinorStatsUpgrade[ "ability_name" ]
					GeneratedReward[ "description" ] = MinorStatsUpgrade[ "description" ]
					GeneratedReward[ "value" ] = MinorStatsUpgrade[ "value" ]
					GeneratedReward[ "id" ] = MinorStatsUpgrade[ "id" ]
				end

				table.insert( vecGeneratedRewards, GeneratedReward )
				break
			end
		end
		
		table.insert( vecGeneratedRewards, GeneratedReward )
	end
	--DeepPrintTable( vecGeneratedRewards )
	return vecGeneratedRewards

end

function TestRoomRewardConsoleCommand( cmdName, szRoomDepth, szIsElite )

	--CustomNetTables:SetTableValue( "reward_options", "current_depth", { szRoomDepth } );

	local bIsElite = (szIsElite == "true")
	local szRoomDepth = tostring( tonumber( szRoomDepth ) )
	local nPlayerID = Entities:GetLocalPlayer():GetPlayerID()

	--printf( "Running %s %d %s %s...", cmdName, nPlayerID, szRoomDepth, szIsElite )

	CustomNetTables:SetTableValue( "reward_options", "current_depth", { szRoomDepth } )

	CustomNetTables:SetTableValue( "reward_choices", szRoomDepth, {} )

	local RewardOptions = {}
	local vecPlayerRewards = GetRoomRewards( tonumber(szRoomDepth), bIsElite, nPlayerID ) 
	RewardOptions[ tostring(nPlayerID) ] = vecPlayerRewards;

	--DeepPrintTable( vecPlayerRewards )

	CustomNetTables:SetTableValue( "reward_options", szRoomDepth, RewardOptions )

end

function RebalanceRewards( aRewardDef, vecPreviouslyGeneratedRewards )

	local aRebalancedRewardDef = deepcopy( aRewardDef )
	NormalizeFloatArrayInPlace( aRebalancedRewardDef, 100.0 )
	return aRebalancedRewardDef

end

function NormalizeFloatArrayInPlace( aFloatValues, flDesiredSum )

	if flDesiredSum == nil then
		flDesiredSum = 1.0
	end

	local flSum = 0
	for _,flFloatValue in pairs( aFloatValues ) do
		flSum = flSum + flFloatValue
	end

	for key,flFloatValue in pairs( aFloatValues ) do
		aFloatValues[key] = ( aFloatValues[key] / flSum ) * flDesiredSum
	end

end

function GrantRewards( nPlayerID, szRoomDepth, aReward )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hPlayerHero == nil then
		--printf("Aborting grant reward, no hero entity for Player %d", nPlayerID )
		return
	end

	local RewardChoices = CustomNetTables:GetTableValue( "reward_choices", szRoomDepth )
	if RewardChoices == nil then
		RewardChoices = {}
	end

	local aExistingReward = RewardChoices[ tostring(nPlayerID) ]
	if aExistingReward ~= nil then
		--printf("GrantRewards: Player %d, Depth %s, aborting granting Reward %s to to existing Reward: %s", nPlayerID, szRoomDepth, DeepToString(aReward), DeepToString(aExistingReward) )
		return
	end

	--printf("granting reward to %s: %s", hPlayerHero:GetName(), DeepToString(aReward) )

	local eRewardType = aReward["reward_type"]
	local nQuantity = aReward["quantity"]
	local szAbilityName = aReward["ability_name"]
	local bEliteReward = aReward["elite"] == 1


	--local eRewardTier = aReward["reward_tier"
	if eRewardType == "REWARD_TYPE_ABILITY_UPGRADE" then
		local data = {}
		data["PlayerID"] = nPlayerID
        data["AbilityName"] = szAbilityName
        data["LevelReward"] = true
		CAghanim:OnAbilityUpgradeButtonClicked(1, data)
		GameRules.Aghanim:GetAnnouncer():OnRewardSelected( hPlayerHero, tonumber( szRoomDepth ), eRewardType, szAbilityName )
	elseif eRewardType == "REWARD_TYPE_MINOR_ABILITY_UPGRADE" then
		local Upgrade = deepcopy( MINOR_ABILITY_UPGRADES[ hPlayerHero:GetUnitName() ][ aReward[ "id" ] ] )
		if bEliteReward then
			if Upgrade[ "special_values" ] == nil then 
				Upgrade[ "value" ] = Upgrade[ "value" ] * ELITE_VALUE_MODIFIER
			else
				for _,SpecialValue in pairs ( Upgrade[ "special_values" ] ) do
					SpecialValue[ "value" ] = SpecialValue[ "value" ] * ELITE_VALUE_MODIFIER
				end
			end
		end

		if Upgrade == nil then 
			if aReward == nil then
				print( "ERROR!  Upgrade table is nil - failed to even find aReward!")
			else
				print( "ERROR!  Upgrade table is nil for " .. aReward[ "id" ] )
			end
			return
		end 

		Upgrade[ "elite" ] = bEliteReward
		CAghanim:AddMinorAbilityUpgrade( hPlayerHero, Upgrade )
		GameRules.Aghanim:GetAnnouncer():OnRewardSelected( hPlayerHero, tonumber( szRoomDepth ), eRewardType, Upgrade.description )
	elseif eRewardType == "REWARD_TYPE_MINOR_STATS_UPGRADE" then
		--Hook up via the same path as the minor ability upgrades
		local StatsUpgrade = deepcopy( MINOR_ABILITY_UPGRADES[ "base_stats_upgrades" ][aReward[ "id" ] ] )
		if bEliteReward then
			StatsUpgrade[ "value" ] = StatsUpgrade[ "value" ] * ELITE_VALUE_MODIFIER
		end
		--Make sure to grant and level up the stats ability if we haven't taken this reward yet
		CAghanim:AddMinorAbilityUpgrade( hPlayerHero, StatsUpgrade )
		CAghanim:VerifyStatsAbility(hPlayerHero, StatsUpgrade[ "ability_name" ])
		GameRules.Aghanim:GetAnnouncer():OnRewardSelected( hPlayerHero, tonumber( szRoomDepth ), eRewardType, StatsUpgrade.description )
	end

	RewardChoices[ tostring(nPlayerID) ] = aReward
	CustomNetTables:SetTableValue( "reward_choices", szRoomDepth, RewardChoices )
	CustomNetTables:SetTableValue( "reward_choices", "current_depth", { szRoomDepth } )


	local gameEvent = {}
	if aReward["quantity"] then
		gameEvent["int_value"] = tonumber(aReward["quantity"])
	end
	if aReward["ability_name"] then
		if eRewardType == "REWARD_TYPE_MINOR_ABILITY_UPGRADE" or eRewardType == "REWARD_TYPE_MINOR_STATS_UPGRADE" then
			--PrintTable( aReward, " reward choice: " )
			gameEvent["string_replace_token"] = aReward [ "description" ]
			gameEvent["ability_name"] = aReward[ "ability_name" ]
			if aReward[ "value" ] then 
				gameEvent["value"] = tonumber(aReward[ "value" ])
			else	
				if aReward[ "special_values" ] then 
					local nValue = 1
					for _,SpecialValue in pairs ( aReward[ "special_values" ] ) do
						local szValueName = "value" .. tostring( nValue )
						gameEvent[ szValueName ] = tonumber( SpecialValue[ "value" ] )
						nValue = nValue + 1
					end
				end
			end
		else
			gameEvent["locstring_value"] ="#DOTA_Tooltip_Ability_" .. aReward["ability_name" ]	
		end
	end
	gameEvent["player_id"] = nPlayerID
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#DOTA_HUD_" .. aReward["reward_type"] .. "_Toast"

	--DeepPrintTable( RewardChoices )
	FireGameEvent( "dota_combat_event_message", gameEvent )
end

--------------------------------------------------------------------------------

function GenerateRewardStatsForPlayer( hPlayerHero, reward )

	local szAbilityName = nil
	local szAbilityTexture = nil

	if reward.reward_type == "REWARD_TYPE_ABILITY_UPGRADE" then
		szAbilityName = reward.ability_name
		szAbilityTexture = GetAbilityTextureNameForAbility( szAbilityName ) 
	elseif reward.reward_type == "REWARD_TYPE_MINOR_ABILITY_UPGRADE" then
		szAbilityName = MINOR_ABILITY_UPGRADES[ hPlayerHero:GetUnitName() ][ reward.id ].description
		szAbilityTexture = GetAbilityTextureNameForAbility( reward.ability_name ) 
	elseif reward.reward_type == "REWARD_TYPE_MINOR_STATS_UPGRADE" then
		szAbilityName = MINOR_ABILITY_UPGRADES[ "base_stats_upgrades" ][ reward.id ].description
		szAbilityTexture = "attribute_bonus"
	end

	if szAbilityName == nil then
		return nil
	end

	local rewardStats =
	{
		ability_name = szAbilityName,
		rarity = reward.rarity,	-- 0 - normal, 1 - elite, 2 - boss
	}

	if reward.value ~= nil then
		rewardStats.value = reward.value
	end
	if reward.reward_type == "REWARD_TYPE_MINOR_ABILITY_UPGRADE" and MINOR_ABILITY_UPGRADES[ hPlayerHero:GetUnitName() ][ reward.id ].special_values ~= nil then
		local nIndex = 1
		for k,v in pairs( MINOR_ABILITY_UPGRADES[ hPlayerHero:GetUnitName() ][ reward.id ].special_values ) do
			rewardStats[ "value" .. nIndex ] = v.value
			nIndex = nIndex + 1
		end
	end

	if szAbilityTexture ~= nil then
		rewardStats.ability_texture = szAbilityTexture
	end

	return rewardStats
	
end

--------------------------------------------------------------------------------

function GenerateRewardStats( nPlayerID, szRoomDepth, roomOptions, szRewardIndex )
	
	local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	local rewardStats =
	{
		selected_reward = GenerateRewardStatsForPlayer( hHero, roomOptions[ szRewardIndex ] ),
		unselected_rewards = {}
	}

	for key,reward in pairs ( roomOptions ) do
		if key ~= szRewardIndex then
			table.insert( rewardStats.unselected_rewards, GenerateRewardStatsForPlayer( hHero, reward ) )
		end
	end

	GameRules.Aghanim:RegisterRewardStats( nPlayerID, szRoomDepth, rewardStats )

end

--------------------------------------------------------------------------------

function OnRewardChoice( eventSourceIndex, data )

	local nPlayerID = data["PlayerID"]
	local szRoomDepth = tostring(data["room_depth"])
	local szRewardIndex = tostring(data["reward_index"])

	--printf("Processing reward choice for Player %d, %s", nPlayerID, DeepToString(data))

	local rewardOptions = CustomNetTables:GetTableValue( "reward_options", szRoomDepth )
	if rewardOptions == nil then
		return
	end

	local roomOptions = rewardOptions[ tostring( nPlayerID ) ]

	--printf("reward options data %d %s %s %s", nPlayerID, szRewardIndex, DeepToString(roomOptions.keys), DeepToString(roomOptions));

	local aReward = roomOptions[szRewardIndex]

	GrantRewards( nPlayerID, szRoomDepth, aReward )

	GenerateRewardStats( nPlayerID, szRoomDepth, roomOptions, szRewardIndex )
end

--------------------------------------------------------------------------------

function OnRewardReroll( eventSourceIndex, data )
	local nPlayerID = data["player_id"]
	local nRoomDepth = data["room_depth"]

	local tRewardOptions = CustomNetTables:GetTableValue( "reward_options", tostring( nRoomDepth ) )
	if tRewardOptions == nil or tRewardOptions["rarity"] == "epic" then
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hPlayerHero then
		local hBuff = hPlayerHero:FindModifierByName( "modifier_blessing_upgrade_reroll" )
		if ( hBuff and hBuff:GetStackCount() > 0 ) then
			hBuff:SetStackCount( hBuff:GetStackCount() - 1 )
			
			local vecPlayerRewards = GetRoomRewards( nRoomDepth, tRewardOptions["elite"] == 1, nPlayerID, nil )
			tRewardOptions[ tostring( nPlayerID ) ] = vecPlayerRewards

			local gameEvent = {}
			gameEvent["player_id"] = nPlayerID
			gameEvent["teamnumber"] = -1
			gameEvent["message"] = "#DOTA_AghsLab_UpgradeReroll_Toast"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end

	-- This is potentially no change if there are no rerolls available
	CustomNetTables:SetTableValue( "reward_options", tostring( nRoomDepth ), tRewardOptions )
end
