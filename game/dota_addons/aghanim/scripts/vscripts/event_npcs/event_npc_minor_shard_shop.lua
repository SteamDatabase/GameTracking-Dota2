require( "event_npc" )

EVENT_NPC_MINOR_SHARD_COST = 400
EVENT_NPC_ELITE_MINOR_SHARD_COST = 800

EVENT_NPC_SHARD_SHOP_DECLINE = 0
EVENT_NPC_SHARD_SHOP_MINOR_1 = 1
EVENT_NPC_SHARD_SHOP_MINOR_2 = 2
EVENT_NPC_SHARD_SHOP_ELITE   = 3


--------------------------------------------------------------------------------

if CEvent_NPC_MinorShardShop == nil then
	CEvent_NPC_MinorShardShop = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:constructor( vPos )
	self:SetupShopContents()

	CEvent_NPC.constructor( self, vPos )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:GetEventNPCName()
	return "npc_dota_creature_shard_shop_oracle"
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:ResetAllOptionStockCounts()
	self:SetupShopContents()
	CEvent_NPC.ResetAllOptionStockCounts( self )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:SetupShopContents()
	self.MinorUpgrades =  {}

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			self.MinorUpgrades[ nPlayerID ] = {}

			local PossibleUpgrades = deepcopy( MINOR_ABILITY_UPGRADES[ hPlayerHero:GetUnitName() ] )
			for nMinorUpgrade=#PossibleUpgrades,1,-1 do
				local PossibleUpgrade = PossibleUpgrades[ nMinorUpgrade ]
				local szUpgradeAbilityName = PossibleUpgrade[ "ability_name" ]
				local hAbilityUpgrade = hPlayerHero:FindAbilityByName( szUpgradeAbilityName )
				if ( hAbilityUpgrade == nil or hAbilityUpgrade:IsHidden() ) then
					-- print( "Removing upgrade " .. szUpgradeAbilityName .. " for hero " .. hPlayerHero:GetUnitName() )
					table.remove( PossibleUpgrades, nMinorUpgrade )
				end
			end

			for nOptionResponse = EVENT_NPC_SHARD_SHOP_MINOR_1, EVENT_NPC_SHARD_SHOP_ELITE do
				local nIndex = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 1, #PossibleUpgrades )
				local Upgrade = PossibleUpgrades[ nIndex ] 
				Upgrade[ "elite" ] = 0

				if nOptionResponse == EVENT_NPC_SHARD_SHOP_ELITE then 
					if Upgrade[ "special_values" ] == nil then 
						Upgrade[ "value" ] = Upgrade[ "value" ] * ELITE_VALUE_MODIFIER
					else
						for _,SpecialValue in pairs ( Upgrade[ "special_values" ] ) do
							SpecialValue[ "value" ] = SpecialValue[ "value" ] * ELITE_VALUE_MODIFIER
						end
					end

					Upgrade[ "elite" ] = 1
				end

				table.insert( self.MinorUpgrades[ nPlayerID ], nOptionResponse, Upgrade ) 
				table.remove( PossibleUpgrades, nIndex )
			end
		end
	end

	PrintTable( self.MinorUpgrades, "-->" )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_SHARD_SHOP_DECLINE,EVENT_NPC_SHARD_SHOP_ELITE  do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	if nOptionResponse == EVENT_NPC_SHARD_SHOP_DECLINE then 
		EventOption[ "dismiss" ] = 1 
		return EventOption
	end

	local Upgrade = self.MinorUpgrades[ hPlayerHero:GetPlayerID() ][ nOptionResponse ]
	if Upgrade == nil then 
		return nil 
	end

	EventOption[ "dialog_vars" ] = {}
	if Upgrade[ "special_values" ] == nil then 
		EventOption[ "dialog_vars" ][ "value" ] = FormatValue( Upgrade[ "value" ] )
	else
		local nValue = 1
		for _,SpecialValue in pairs ( Upgrade[ "special_values" ] ) do
			EventOption[ "dialog_vars" ][ "value" .. tostring( nValue ) ] = FormatValue( SpecialValue[ "value" ] )
			nValue = nValue + 1
		end
	end

	EventOption[ "elite" ] = Upgrade[ "elite" ]
	EventOption[ "ability_name" ] = Upgrade[ "ability_name" ]
	EventOption[ "dialog_vars" ][ "ability_name" ] = tostring( "#DOTA_Tooltip_Ability_" .. Upgrade[ "ability_name" ] )
	EventOption[ "description" ] = Upgrade[ "description" ]
	EventOption[ "minor_shard" ] = 1

	return EventOption 
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT 
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:GetOptionInitialStockCount( nPlayerID, nOptionResponse )
	if nOptionResponse == EVENT_NPC_SHARD_SHOP_DECLINE then 
		return -1 --inf
	end

	return 1
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:GetOptionGoldCost( nPlayerID, nOptionResponse )

	local flDiscount = 0
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hPlayerHero ~= nil then
		local hDiscountBuff = hPlayerHero:FindModifierByName("modifier_blessing_oracle_shop_discount")
		if hDiscountBuff ~= nil then
			flDiscount = hDiscountBuff:GetStackCount()
		end
	end


	if nOptionResponse == EVENT_NPC_SHARD_SHOP_ELITE then 
		return EVENT_NPC_ELITE_MINOR_SHARD_COST * ((100 - flDiscount) / 100 )
	end

	if nOptionResponse == EVENT_NPC_SHARD_SHOP_DECLINE then 
		return 0
	end

	return EVENT_NPC_MINOR_SHARD_COST * ((100 - flDiscount) / 100 )
end

--------------------------------------------------------------------------------

function CEvent_NPC_MinorShardShop:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_SHARD_SHOP_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end

	local Upgrade = self.MinorUpgrades[ hPlayerHero:GetPlayerID() ][ nOptionResponse ]
	if Upgrade == nil then 
		print( "error, upgrade was not found" )
		return EVENT_NPC_OPTION_INVALID
	end

	if Upgrade[ "elite" ] == 1 then 
		Upgrade[ "elite" ] = true 
	else
		Upgrade[ "elite" ] = false 
	end

	GameRules.Aghanim:AddMinorAbilityUpgrade( hPlayerHero, Upgrade )
	EmitSoundOnLocationForPlayer( "hud.equip.agh_shard", hPlayerHero:GetAbsOrigin(), hPlayerHero:GetPlayerID() )

	local gameEvent = {}
	
	
	gameEvent["string_replace_token"] = Upgrade[ "description" ]
	gameEvent["ability_name"] = Upgrade[ "ability_name" ]
	if Upgrade[ "value" ] then 
		gameEvent["value"] = tonumber( Upgrade[ "value" ])
	else	
		if Upgrade[ "special_values" ] then 
			local nValue = 1
			for _,SpecialValue in pairs ( Upgrade[ "special_values" ] ) do
				local szValueName = "value" .. tostring( nValue )
				gameEvent[ szValueName ] = tonumber( SpecialValue[ "value" ] )
				nValue = nValue + 1
			end
		end
	end
		
	
	gameEvent["player_id"] = hPlayerHero:GetPlayerID()
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#DOTA_HUD_ShardPurchase_Toast"

	--DeepPrintTable( RewardChoices )
	FireGameEvent( "dota_combat_event_message", gameEvent )

	return nOptionResponse
end

--------------------------------------------------------------------------------

return CEvent_NPC_MinorShardShop