
require( "triggers/plateau" )

---------------------------------------------------------
-- game_rules_state_change
---------------------------------------------------------

function CDungeon:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		--print( "OnGameRulesStateChange: Strategy Time" )
		self:ForceAssignHeroes()

	elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--print( "OnGameRulesStateChange: Hero Selection" )

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		--print( "OnGameRulesStateChange: Pre Game" )

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
	end
end

---------------------------------------------------------
-- dota_player_reconnected
-- * player_id
---------------------------------------------------------

function CDungeon:OnPlayerReconnected( event )
	local hPlayer = PlayerResource:GetPlayer( event.player_id )
	if hPlayer ~= nil then
		local hPlayerHero = hPlayer:GetAssignedHero()
		if hPlayerHero ~= nil and hPlayerHero.bHasClickedScroll == true then
			self:OnScrollClicked( 0, { ent_index = hPlayerHero:entindex() })
			CustomGameEventManager:Send_ServerToPlayer( hPlayer, "hide_scroll", {} )
		end
	end
end

---------------------------------------------------------
-- npc_spawned
-- * entindex
---------------------------------------------------------

function CDungeon:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit ~= nil then
		if spawnedUnit:IsRealHero() and spawnedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self:OnNPCSpawned_PlayerHero( event )
			return
		end
		if spawnedUnit:IsCreature() and spawnedUnit:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS then
			self:OnNPCSpawned_EnemyCreature( event )
			return
		end

		-- Bit gross
		if spawnedUnit:GetUnitName() == "npc_dota_goodguys_healers" then
			spawnedUnit:AddNewModifier( spawnedUnit, nil, "modifier_filler_buff_icon", { duration = -1 } )
		end
	end
end

function CDungeon:OnNPCSpawned_PlayerHero( event )
	local hPlayerHero = EntIndexToHScript( event.entindex )
	if hPlayerHero ~= nil then
		hPlayerHero.CurrentZoneName = nil
		if hPlayerHero.bFirstSpawnComplete == nil then
			hPlayerHero:SetStashEnabled( false )
			local boots = CreateItem( "item_boots", hPlayerHero, hPlayerHero )
			boots:SetPurchaseTime( 0 )
			boots:SetPurchaser( hPlayerHero )
			hPlayerHero:AddItem( boots )

			if GetMapName() == "ep_1" and not PlayerResource:IsFakeClient( hPlayerHero:GetPlayerOwnerID() ) and IsDedicatedServer() and hPlayerHero.bHasClickedScroll ~= true then
				local scroll = CreateItem( "item_tpscroll", hPlayerHero, hPlayerHero )
				scroll:SetPurchaseTime( 0 )
				scroll:SetPurchaser( hPlayerHero )
				hPlayerHero:AddItem( scroll )
				hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_pre_teleport", {} )
			end

			if not IsDedicatedServer() and not PlayerResource:IsFakeClient( hPlayerHero:GetPlayerOwnerID() ) then
				if GetMapName() == "ep_1" then
					self:OnPlayerHeroEnteredZone( hPlayerHero, "start" )
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( hPlayerHero:GetPlayerOwnerID() ), "hide_scroll", {} )
				else
					self:OnPlayerHeroEnteredZone( hPlayerHero, "ep_2_start" )
				end
				
			end

			hPlayerHero.bFirstSpawnComplete = true
			if self.bExplorerMode == true then
				hPlayerHero.nRespawnsRemaining = EXPLORER_MODE_STARTING_LIVES
			else
				hPlayerHero.nRespawnsRemaining = nSTARTING_RESPAWNS
			end
			CustomNetTables:SetTableValue( "revive_state", string.format( "%d", hPlayerHero:entindex() ), { tombstone = false } )
			CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ), { respawns = hPlayerHero.nRespawnsRemaining } )
			local nPlayerID = hPlayerHero:GetPlayerOwnerID()
			if nPlayerID ~= -1 then
				PlayerResource:SetCustomBuybackCooldown( nPlayerID, 0 )
				PlayerResource:SetCustomBuybackCost( nPlayerID, 0 )
			end

			if self.bExplorerMode ~= true then
				local newArtifactCurrency = {}
				if self.bUseArtifactCurrency == true and nPlayerID ~= -1 then
					newArtifactCurrency["PlayerID"] = nPlayerID
					newArtifactCurrency["SteamID"] = PlayerResource:GetSteamID( nPlayerID )
					newArtifactCurrency["StartingBalance"] = PlayerResource:GetEventPremiumPoints( nPlayerID )
					newArtifactCurrency["Balance"] = PlayerResource:GetEventPremiumPoints( nPlayerID )
					newArtifactCurrency["Delta"] = 0
					table.insert( self.ArtifactCurrency, newArtifactCurrency )
					CustomNetTables:SetTableValue( "artifact_currency", string.format( "%d", nPlayerID ), newArtifactCurrency )
				end
				
				local relicTable = {}
				for _,Relic in pairs( self.RelicsDefinition ) do
					if Relic ~= nil and GetItemDefOwnedCount( nPlayerID, Relic["DungeonItemDef"] ) > 0 then
						table.insert( relicTable, Relic )	
					end
				end

				local PlayerArtifactsPurchased = {}
				PlayerArtifactsPurchased["PlayerID"] = nPlayerID
				PlayerArtifactsPurchased["SteamID"] = PlayerResource:GetSteamID( nPlayerID )
				PlayerArtifactsPurchased["PurchasedCount"] = 0
				table.insert( self.ArtifactsPurchased, PlayerArtifactsPurchased )

				CustomNetTables:SetTableValue( "relics", string.format( "%d", nPlayerID ), relicTable )
			end

			hPlayerHero:SetRevealRadius( 512 )
		end
		self.bPlayerHasSpawned = true
	end
end

---------------------------------------------------------

function CDungeon:OnNPCSpawned_EnemyCreature( event )
	local hEnemyCreature = EntIndexToHScript( event.entindex )
	if hEnemyCreature ~= nil and self.bExplorerMode == true then
		hEnemyCreature:AddNewModifier( hEnemyCreature, nil, "modifier_explorer_mode", {} )
	end
end

---------------------------------------------------------
-- entity_killed
-- * entindex_killed
-- * entindex_attacker
-- * entindex_inflictor
-- * damagebits
---------------------------------------------------------

function CDungeon:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit ~= nil then
		if killedUnit:IsRealHero() and ( killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS ) then
			self:OnEntityKilled_PlayerHero( event )
			return
		end

		if killedUnit:IsCreature() and ( killedUnit:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS ) then
			self:OnEntityKilled_EnemyCreature( event )
			return
		end
	end
end


function CDungeon:OnEntityKilled_PlayerHero( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killerUnit = EntIndexToHScript( event.entindex_attacker )
	if killedUnit and killedUnit:IsRealHero() then
		local gameEvent = {}
		gameEvent["player_id"] = killedUnit:GetPlayerID()
		gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
		gameEvent["locstring_value"] = killerUnit:GetUnitName()
		gameEvent["message"] = "#Dungeon_KilledByCreature"
		FireGameEvent( "dota_combat_event_message", gameEvent )
		
		self:FireDeathTaunt( killerUnit ) 

		for _,Zone in pairs( self.Zones ) do
			if Zone:ContainsUnit( killedUnit ) then
				Zone:AddStat( killedUnit:GetPlayerID(), ZONE_STAT_DEATHS, 1 )
				killedUnit.DeathZone = Zone
			end
		end

		local OrbOfPassage = killedUnit:FindItemInInventory( "item_orb_of_passage" )
		if OrbOfPassage ~= nil and killedUnit.nRespawnsRemaining == 0 then
			killedUnit:DropItemAtPositionImmediate( OrbOfPassage, killedUnit:GetAbsOrigin() )
		end

		local bDropTombstone = killedUnit.nRespawnsRemaining > 0
		if bDropTombstone then
			local newItem = CreateItem( "item_tombstone",killedUnit , killedUnit )
			newItem:SetPurchaseTime( 0 )
			newItem:SetPurchaser( killedUnit )
			local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
			tombstone:SetContainedItem( newItem )
			tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
			FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )
		end

		killedUnit.nRespawnsRemaining = math.max( 0, killedUnit.nRespawnsRemaining - nREVIVE_COST )
		CustomNetTables:SetTableValue( "revive_state", string.format( "%d", killedUnit:entindex() ), { tombstone = bDropTombstone } )
		CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", killedUnit:entindex() ),  { respawns = killedUnit.nRespawnsRemaining } )
		

		local netTable = {}
		CustomGameEventManager:Send_ServerToPlayer( killedUnit:GetPlayerOwner(), "life_lost", netTable ) 

		local hPlayer = killedUnit:GetPlayerOwner()
		if hPlayer ~= nil then
			if killedUnit.nRespawnsRemaining < nBUYBACK_COST then
				PlayerResource:SetCustomBuybackCooldown( hPlayer:GetPlayerID(), 0 )
				PlayerResource:SetCustomBuybackCost( hPlayer:GetPlayerID(), 999999 )
			else
				PlayerResource:SetCustomBuybackCooldown( hPlayer:GetPlayerID(), 0 )
				PlayerResource:SetCustomBuybackCost( hPlayer:GetPlayerID(), 0 )
			end
		end
	end
end


function CDungeon:OnEntityKilled_EnemyCreature( event )
	local hDeadCreature = EntIndexToHScript( event.entindex_killed )
	if hDeadCreature == nil then
		return
	end

	if hDeadCreature:FindModifierByName( "modifier_breakable_container" ) then
		return
	end

	local hAttackerUnit = EntIndexToHScript( event.entindex_attacker )
	if hAttackerUnit and hAttackerUnit:IsRealHero() then
		EmitSoundOnClient( "Dungeon.LastHit", hAttackerUnit:GetPlayerOwner() )
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/darkmoon_last_hit_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hDeadCreature, hAttackerUnit:GetPlayerOwner() ) )
	end

	local Zone = hDeadCreature.zone
	if Zone ~= nil then
		for _,zone in pairs( self.Zones ) do
			zone:OnEnemyKilled( hDeadCreature, Zone )
		end

		if hAttackerUnit and hAttackerUnit:IsRealHero() then
			Zone:AddStat( hAttackerUnit:GetPlayerID(), ZONE_STAT_KILLS, 1 )
		end

		local Heroes = HeroList:GetAllHeroes()
		if Zone.nXPRemaining > 0 then
			if hDeadCreature.nDeathXP == nil then
				print( "CDungeon:OnEntityKilled_EnemyCreature - ERROR: Death XP not set for " .. hDeadCreature:GetUnitName() )
				return
			end
			local nXPReward = math.min( hDeadCreature.nDeathXP, Zone.nXPRemaining )
			local nXPPerHero = math.ceil( nXPReward / 4 )
			for _,Hero in pairs ( Heroes ) do
				if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					Hero:AddExperience( nXPPerHero, DOTA_ModifyXP_CreepKill, false, true )
				end
			end

			Zone.nXPRemaining = Zone.nXPRemaining - nXPReward
		end

		if Zone.nGoldRemaining > 0 then
			local nEnemiesRemaining = Zone:GetNumberOfEnemies()
			if nEnemiesRemaining == 0 then
				print( "CDungeon:OnEntityKilled_EnemyCreature - ERROR: No enemies remaining in Zone.")
				return
			end
			if hDeadCreature.nMinGoldBounty == nil or hDeadCreature.nMaxGoldBounty == nil then
				print( "CDungeon:OnEntityKilled_EnemyCreature - ERROR: Bounties not set for " .. hDeadCreature:GetUnitName() )
				return
			end

			local nRandomBounty = RandomInt( hDeadCreature.nMinGoldBounty, hDeadCreature.nMaxGoldBounty )
			local nGoldToDrop = math.min( nRandomBounty, Zone.nGoldRemaining ) * 4
			local nPercentChance = math.max( nBASE_GOLD_BAG_DROP_RATE, 100 / nEnemiesRemaining )
			--print( "CDungeon:OnEntityKilled_EnemyCreature - Rolling " .. nPercentChance .. " to drop a bag with " .. nGoldToDrop .. " gold.")
			if RollPercentage( nPercentChance ) and nGoldToDrop > 0 then
				local newItem = CreateItem( "item_bag_of_gold", nil, nil )
				newItem:SetPurchaseTime( 0 )
				newItem:SetCurrentCharges( nGoldToDrop )
				local drop = CreateItemOnPositionSync( hDeadCreature:GetAbsOrigin(), newItem )
				local dropTarget = hDeadCreature:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
				newItem:LaunchLoot( true, 150, 0.75, dropTarget )
				Zone.nGoldRemaining = Zone.nGoldRemaining - nGoldToDrop
			end
		end

		if Zone.nGoldRemaining <= 0 and Zone.nXPRemaining <= 0 then
			Zone:RemoveItemDropsFromZoneEnemies()
		else
			if self.bUseArtifactCurrency == true and self.bExplorerMode == false and Zone:GetNumberOfBosses() == 0 then
				if RollPercentage( nBASE_ARTIFACT_BAG_DROP_RATE ) then
					local newItem = CreateItem( "item_bag_of_artifact_coins", nil, nil )
					newItem:SetPurchaseTime( 0 )
					newItem:SetCurrentCharges( nBASE_ARTIFACT_BAG_AMOUNT )
					local drop = CreateItemOnPositionSync( hDeadCreature:GetAbsOrigin(), newItem )
					local dropTarget = hDeadCreature:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
					newItem:LaunchLoot( false, 150, 0.75, dropTarget )
				end
			end
		end

		Zone:CleanupZoneEnemy( hDeadCreature )

		if hDeadCreature.bBoss == true and Zone:GetNumberOfBosses() == 0 then
			for _,Hero in pairs ( Heroes ) do
				if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					if Hero:IsAlive() == false then
						local vPos = hDeadCreature:GetOrigin() + RandomVector( 50.0 )
						Hero:RespawnHero( false, false, false )
						FindClearSpaceForUnit( Hero, vPos, true )
						Hero:AddNewModifier( Hero, nil, "modifier_invulnerable", { duration = 2.5 } )
						Hero:AddNewModifier( Hero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )
						EmitSoundOn( "Dungeon.HeroRevived", Hero )
					else
						EmitSoundOn( "Dungeon.StopBattleMusic", Hero )
					end
			
					local hPlayer = Hero:GetPlayerOwner()
					if hPlayer ~= nil then
						hPlayer:SetMusicStatus(0, 1.0) -- go back to laning music
					end

					Hero:ModifyHealth( Hero:GetMaxHealth(), nil, false, 0 )
					Hero:SetMana( Hero:GetMaxMana() )
				end
			end

			if hDeadCreature:GetUnitName() == "npc_dota_creature_temple_guardian" then
				local szRelayName = "ut_bossroom_bosses_died_trigger_relay"
				local hDeadBossesRelay = Entities:FindByName( nil, szRelayName )
				if hDeadBossesRelay then
					hDeadBossesRelay:Trigger()
				end
			end

			if hDeadCreature:GetUnitName() == "npc_dota_creature_ogre_tank_boss" then
				local szEntryRelayName = "df_rescue_captain_relay"
				local hEntryGateRelay = Entities:FindByName( nil, szEntryRelayName )
				if hEntryGateRelay then
					hEntryGateRelay:Trigger()
				end	
			end

			if hDeadCreature:GetUnitName() ~= "npc_dota_creature_spider_boss" then
				local enemies = FindUnitsInRadius( hDeadCreature:GetTeamNumber(), hDeadCreature:GetOrigin(), hDeadCreature, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
				for _,enemy in pairs ( enemies ) do
					if enemy ~= nil and enemy:IsAlive() then
						enemy:ForceKill( false )
					end
				end
			end

			if hDeadCreature:GetUnitName() == "npc_dota_creature_ice_boss" then
				local szRelayName = "aerie_exit_relay"
				local hAerieExitRelay = Entities:FindByName( nil, szRelayName )
				if hAerieExitRelay then
					hAerieExitRelay:Trigger()
				else
					print( string.format( "CDungeon:OnEntityKilled_EnemyCreature - ERROR: Relay %s not found", szRelayName ) )
				end
			end

			if hDeadCreature:GetUnitName() == "npc_dota_creature_elder_tiny" then
				local szRelayName = "crypt_entrance_relay"
				local hCryptEntryRelay = Entities:FindByName( nil, szRelayName )
				if hCryptEntryRelay then
					hCryptEntryRelay:Trigger()
				else
					print( string.format( "CDungeon:OnEntityKilled_EnemyCreature - ERROR: Relay %s not found", szRelayName ) )
				end
			end

			if hDeadCreature:GetUnitName() == "npc_dota_creature_amoeba_boss" then
				local szRelayName = "shoal_exit_relay"
				local hShoalExitRelay = Entities:FindByName( nil, szRelayName )
				if hShoalExitRelay then
					hShoalExitRelay:Trigger()
				else
					print( string.format( "CDungeon:OnEntityKilled_EnemyCreature - ERROR: Relay %s not found", szRelayName ) )
				end
			end

			local netTable = {}
			netTable["BossName"] = hDeadCreature:GetUnitName()
			CustomGameEventManager:Send_ServerToAllClients( "boss_fight_finished", netTable )
		end
	end
end

---------------------------------------------------------
-- dota_holdout_revive_complete
-- * caster (reviver hero entity index)
-- * target (revivee hero entity index)
---------------------------------------------------------

function CDungeon:OnPlayerRevived( event )
	local hRevivedHero = EntIndexToHScript( event.target )
	if hRevivedHero ~= nil and hRevivedHero:IsRealHero() then
		hRevivedHero:AddNewModifier( hRevivedHero, nil, "modifier_invulnerable", { duration = 2.5 } )
		hRevivedHero:AddNewModifier( hRevivedHero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )
		EmitSoundOn( "Dungeon.HeroRevived", hRevivedHero )

		CustomNetTables:SetTableValue( "revive_state", string.format( "%d", hRevivedHero:entindex() ), { tombstone = false } )
		CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hRevivedHero:entindex() ),  { respawns = hRevivedHero.nRespawnsRemaining })

		local hReviver = EntIndexToHScript( event.caster )
		local flChannelTime = event.channel_time
		if hReviver ~= nil and flChannelTime > 0.0 then
			for _,Zone in pairs( self.Zones ) do
				if Zone:ContainsUnit( hReviver ) then
					Zone:AddStat( hReviver:GetPlayerID(), ZONE_STAT_REVIVE_TIME, flChannelTime )
				end
			end
		end
	end
end

---------------------------------------------------------
-- dota_buyback
-- * entindex
-- * player_id
---------------------------------------------------------

function CDungeon:OnPlayerBuyback( event )
	local hPlayer = PlayerResource:GetPlayer( event.player_id )
	if hPlayer == nil then
		return
	end

	local hHero = hPlayer:GetAssignedHero()
	if hHero == nil then
		return
	end

	hHero.nRespawnsRemaining = math.max( hHero.nRespawnsRemaining - nBUYBACK_COST, 0 )
	CustomNetTables:SetTableValue( "revive_state", string.format( "%d", hHero:entindex() ), { tombstone = false } )
	CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hHero:entindex() ), { respawns = hHero.nRespawnsRemaining } )
	
	local netTable = {}
	CustomGameEventManager:Send_ServerToPlayer( hHero:GetPlayerOwner(), "life_lost", netTable ) 


	local vPos = hHero:GetOrigin()
	-- Below: Use your most recently touched checkpoint, ONLY if it's in your current zone. Otherwise use the zone's checkpoint.
	if hHero.DeathZone ~= nil then
		if hHero.DeathZone:IsCheckpointActivated() == true then
			vPos = hHero.DeathZone:GetCheckpoint():GetOrigin()
		else
			if hHero.hRespawnCheckpoint ~= nil then
				vPos = hHero.hRespawnCheckpoint:GetOrigin()
			end
		end

		-- fix me later
		if hHero.DeathZone.szName == "desert_start" then
			for _,VIP in pairs( hHero.DeathZone.VIPsAlive ) do
				if VIP ~= nil and VIP:GetUnitName() == "npc_dota_friendly_bristleback_son" then
					vPos = VIP:GetOrigin()
				end
			end
		end
	else
		if hHero.hRespawnCheckpoint ~= nil then
			vPos = hHero.hRespawnCheckpoint:GetOrigin()
		end
	end


	FindClearSpaceForUnit( hHero, vPos, true )
	hHero:AddNewModifier( hHero, nil, "modifier_invulnerable", { duration = 2.5 } )
	hHero:AddNewModifier( hHero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )
end

---------------------------------------------------------
-- dota_player_gained_level
-- * player (player entity index)
-- * level (new level)
---------------------------------------------------------

function CDungeon:OnPlayerGainedLevel( event )
end

---------------------------------------------------------
-- dota_item-spawned
-- * player_id
-- * item_ent_index
---------------------------------------------------------

function CDungeon:OnItemSpawned( event )
	local item = EntIndexToHScript( event.item_ent_index )
	if item ~= nil then
		local bIsRelic = false
		local itemKV = item:GetAbilityKeyValues()
		if itemKV and itemKV["DungeonItemDef"] ~= nil then
			item.bIsRelic = true
			if self.bExplorerMode == true then
				print( "CDungeon:OnItemSpawned - Artifact spawned in explorer mode, removing" )
				UTIL_Remove( item )
			end
		end

		if item.bIsRelic and item.nBoundPlayerID == nil and item:GetPurchaser() == nil and event.player_id == -1 then
			print( "CDungeon:OnItemSpawned - Relic Found" )
			self:OnRelicSpawned( item, itemKV )
		end
	end
end

---------------------------------------------------------
-- dota_item_picked_up
-- * PlayerID
-- * HeroEntityIndex
-- * UnitEntityIndex (only if parent is not a hero)
-- * itemname
-- * ItemEntityIndex
---------------------------------------------------------

function CDungeon:OnItemPickedUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local hero = EntIndexToHScript( event.HeroEntityIndex )
	if item ~= nil and hero ~= nil then
		if item.bIsRelic == true and item:GetPurchaser() ~= hero then
			hero:DropItemAtPositionImmediate( item, hero:GetOrigin() )
			return
		end

		if item.bHasBeenPickedUp == true then
			return
		end

		if item:GetAbilityName() ~= "item_tombstone" then
			item.bHasBeenPickedUp = true
			item:SetPurchaser( hero )

			local szEventZoneName = nil
			for _,Zone in pairs( self.Zones ) do
				if Zone:ContainsUnit( hero ) then
					szEventZoneName = Zone.szName
					if item:GetAbilityName() == "item_bag_of_gold" then
						Zone:AddStat( hero:GetPlayerID(), ZONE_STAT_GOLD_BAGS, 1 )
						return
					end
					if item:GetAbilityName() == "item_mana_potion" or item:GetAbilityName() == "item_health_potion" then
						Zone:AddStat( hero:GetPlayerID(), ZONE_STAT_POTIONS, 1 )
						return
					end
					Zone:AddStat( hero:GetPlayerID(), ZONE_STAT_ITEMS, 1 )
				end
			end
		end
	end
end

---------------------------------------------------------

function CDungeon:OnRelicSpawned( item, itemKV )
	local PlayerIDs = {}
	local nRelicItemDef = tonumber( itemKV["DungeonItemDef"] )
	print( "CDungeon:OnRelicSpawned - New Relic " .. item:GetAbilityName() .. " created of itemdef: " .. nRelicItemDef )
	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsRealHero() and Hero:HasOwnerAbandoned() == false then
			if GetItemDefOwnedCount( Hero:GetPlayerID(), nRelicItemDef ) == 0 then
				print( "CDungeon:OnRelicSpawned - PlayerID " .. Hero:GetPlayerID() .. " does not own item, adding to grant list." )
				table.insert( PlayerIDs, Hero:GetPlayerID() ) 
			end
		end
	end

	-- What do we do if it's empty?  Right now just give it to someone as a dupe?
	local bDupeForAllPlayers = #PlayerIDs == 0
	if bDupeForAllPlayers then
		print( "CDungeon:OnRelicSpawned - Item is dupe for all players, adding all players as valid." )
		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() then
				table.insert( PlayerIDs, Hero:GetPlayerID() ) 
			end
		end
	end

	local WinningPlayerID = -1
	if #PlayerIDs == 1 then
		WinningPlayerID = PlayerIDs[1]
	else
		for i=#PlayerIDs,1,-1 do
			for _,Relic in pairs( self.RelicsFound ) do
				if Relic ~= nil and Relic["PlayerID"] == PlayerIDs[i] then
					print( "CDungeon:OnRelicSpawned - PlayerID " .. PlayerIDs[i] .. " has already found an artifact this game, skipping." )
					table.remove( PlayerIDs, i )
				end
			end
		end
		if #PlayerIDs == 0 then
			WinningPlayerID = RandomInt( 0, 3 )
			print( "CDungeon:OnRelicSpawned - All players have found an artifact, randoming... winner is " .. WinningPlayerID )
		else
			WinningPlayerID = PlayerIDs[ RandomInt( 1, #PlayerIDs ) ]
			print( "CDungeon:OnRelicSpawned - " .. #PlayerIDs .. " players have not yet found an artifact, winner is player ID " .. WinningPlayerID )
		end
	end

	if WinningPlayerID == -1 or WinningPlayerID == nil then
		print( "CDungeon:OnRelicSpawned - ERROR - WinningPlayerID is invalid." )
		return
	end
	
	local WinningHero = PlayerResource:GetSelectedHeroEntity( WinningPlayerID )
	local WinningSteamID = PlayerResource:GetSteamID( WinningPlayerID )

	print( "CDungeon:OnRelicSpawned - Relic " .. item:GetAbilityName() .. " has been bound to " .. WinningPlayerID )
	item.nBoundPlayerID = WinningPlayerID
	item:SetPurchaser( WinningHero )

	EmitSoundOn( "Dungeon.Stinger06", WinningHero )
	local Relic = {}
	Relic["DungeonItemDef"] = itemKV["DungeonItemDef"]
	Relic["DungeonAction"] = itemKV["DungeonAction"]
	Relic["SteamID"] = WinningSteamID
	Relic["PlayerID"] = WinningPlayerID
	table.insert( self.RelicsFound, Relic )
	
	local gameEvent = {}
	gameEvent["player_id"] = WinningHero:GetPlayerID()
	gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
	gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. item:GetAbilityName()
	gameEvent["message"] = "#Dungeon_FoundNewRelic"
	FireGameEvent( "dota_combat_event_message", gameEvent )
end

---------------------------------------------------------


function CDungeon:OnTriggerStartTouch( triggerName, activator_entindex, caller_entindex  )
	--print( "CDungeon:OnTriggerStartTouch - " .. triggerName )
	local playerHero = EntIndexToHScript( activator_entindex )
	if playerHero ~= nil and playerHero:IsRealHero() and playerHero:GetPlayerOwnerID() ~= -1 then
		if triggerName == "crypt_holdout_zone_reefs_edge" then
			local CryptHoldoutZone = self:GetZoneByName( "crypt_holdout" )
			if CryptHoldoutZone ~= nil then
				CryptHoldoutZone:PerformZoneCleanup()
			end
		end
		local i, j = string.find( triggerName, "_zone_" )
		--This is a zone transition trigger
		if i ~= nil then
			local zone1Name = string.sub( triggerName, 1, i-1 )
			local zone2Name = string.sub( triggerName, j+1, string.len( triggerName ) )
		--	print( "Zone Transition: " .. zone1Name .. zone2Name )
			for _,zone in pairs( self.Zones ) do
				if zone ~= nil and ( zone.szName == zone1Name or zone.szName == zone2Name ) then
					zone:Precache()
				end
			end
		end

		local k, l = string.find( triggerName, "checkpoint" )
		if k ~= nil then
			self:OnCheckpointTouched( playerHero, triggerName )
			return
		end

		local m, o = string.find( triggerName, "reveal_radius" )
		if m ~= nil then
			--print( "triggerName == " .. triggerName )
			local TriggerEntity = EntIndexToHScript( caller_entindex )
			if TriggerEntity ~= nil then
				local nRevealRadius = TriggerEntity:Attribute_GetIntValue( "reveal_radius", 512 )
			--	print( "CDungeon - Setting FOW Reveal Radius to " .. nRevealRadius )
				playerHero:SetRevealRadius( nRevealRadius )
			end
		end

		if triggerName == "underground_temple_boss_spawn" then
			local Zone = self:GetZoneByName( "underground_temple" )
			if Zone ~= nil then
				local hSpawnerA = Entities:FindByName( nil, "underground_temple_boss_a" )
				local hSpawnerB = Entities:FindByName( nil, "underground_temple_boss_b" )
				if hSpawnerA and hSpawnerB then
					local hUnitA = CreateUnitByName( "npc_dota_creature_temple_guardian", hSpawnerA:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
					local hUnitB = CreateUnitByName( "npc_dota_creature_temple_guardian", hSpawnerB:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
					if hUnitA ~= nil and hUnitB ~= nil then
						hUnitA.bBoss = true
						hUnitB.bBoss = true
						hUnitA.bStarted = false
						hUnitB.bStarted = false
						hUnitA.bAwake = false
						hUnitB.bAwake = false
						hUnitA:AddNewModifier( hUnitA, nil, "modifier_temple_guardian_statue", {} )
						hUnitB:AddNewModifier( hUnitB, nil, "modifier_temple_guardian_statue", {} )
						Zone:AddEnemyToZone( hUnitA )
						Zone:AddEnemyToZone( hUnitB )
					end
				end
			end
		end

		if triggerName == "zonevolume_plateau" then
			CDungeon:OnPlayerEnterPlateau( playerHero )
		end
	end
end

---------------------------------------------------------

function CDungeon:OnTriggerEndTouch( triggerName, activator_entindex, caller_entindex )
	--print( "CDungeon:OnTriggerEndTouch - " .. triggerName )
	--This is a zone transition trigger
	local playerHero = EntIndexToHScript( activator_entindex )
	if playerHero ~= nil and playerHero:IsRealHero() and playerHero:GetPlayerOwnerID() ~= -1 then
		local i, j = string.find( triggerName, "_zone_" )
		if i ~= nil then
			local zone1Name = string.sub( triggerName, 1, i-1 )
			local zone2Name = string.sub( triggerName, j+1, string.len( triggerName ) )

			local zone1 = self:GetZoneByName( zone1Name )
			local zone2 = self:GetZoneByName( zone2Name )
			if zone1 ~= nil and zone1:ContainsUnit( playerHero ) then
				self:OnPlayerHeroEnteredZone( playerHero, zone1.szName )
				return
			end
			if zone2 ~= nil and zone2:ContainsUnit( playerHero ) then
				self:OnPlayerHeroEnteredZone( playerHero, zone2.szName )
				return
			end
		end

		if triggerName == "zonevolume_plateau" then
			CDungeon:OnPlayerExitPlateau( playerHero )
		end
	end
end

---------------------------------------------------------

function CDungeon:OnCheckpointTouched( playerHero, szNewCheckpointName  )
	local bAlreadyInList = false
	for _, szCheckpointName in pairs( self.CheckpointsActivated ) do
		if szCheckpointName == szNewCheckpointName then
			bAlreadyInList = true
		end
	end

	if bAlreadyInList == true then
		return
	end

	if playerHero ~= nil then
		local gameEvent = {}
		gameEvent["player_id"] = playerHero:GetPlayerID()
		gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
		gameEvent["message"] = "#Dungeon_ReachedCheckpoint"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	--print( "CDungeon - Checkpoint " .. szNewCheckpointName .. " activated." )
	table.insert( self.CheckpointsActivated, szNewCheckpointName )
	local szZoneName = nil
	local hBuilding = Entities:FindByName( nil, szNewCheckpointName .. "_building" )
	if hBuilding then
		hBuilding:SetTeam( DOTA_TEAM_GOODGUYS )
		hBuilding:AddNewModifier( hBuilding, nil, "modifier_provide_vision", {} )

		for _,zone in pairs( self.Zones ) do
			if zone ~= nil and zone:ContainsUnit( playerHero ) and zone:GetCheckpoint() ~= hBuilding then
				zone:SetCheckpoint( hBuilding )
				szZoneName = zone.szName
			end
		end
	else
		print( "CDungeon - failed to find checkpoint building named " .. szNewCheckpointName .. "_building" )
		return
	end

	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsRealHero() then
			--print( "CDungeon - Setting checkpoint for " .. Hero:GetUnitName() )
			Hero.hRespawnCheckpoint = hBuilding

			local nCurrentLives = Hero.nRespawnsRemaining
			if self.bExplorerMode == true then
				Hero.nRespawnsRemaining = math.min( Hero.nRespawnsRemaining + EXPLORER_MODE_LIVES_PER_CHECKPOINT, nMAX_RESPAWNS )
			else
				Hero.nRespawnsRemaining = math.min( Hero.nRespawnsRemaining + nCHECKPOINT_REVIVES, nMAX_RESPAWNS )
			end
			
			if nCurrentLives ~= Hero.nRespawnsRemaining then
				local netTable = {}
				CustomGameEventManager:Send_ServerToPlayer( Hero:GetPlayerOwner(), "gained_life", netTable )
			end

			local hPlayer = Hero:GetPlayerOwner()
			if hPlayer then
				PlayerResource:SetCustomBuybackCooldown( hPlayer:GetPlayerID(), 0 )
				PlayerResource:SetCustomBuybackCost( hPlayer:GetPlayerID(), 0 )
			end
		
			CustomNetTables:SetTableValue( "revive_state", string.format( "%d", Hero:entindex() ), { tombstone = false } )
			CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", Hero:entindex() ), { respawns = Hero.nRespawnsRemaining } )
			if not Hero:IsAlive() then
				--print( "CDungeon - Reviving Hero " .. Hero:GetUnitName() )
				Hero:RespawnHero( false, false, false )
				FindClearSpaceForUnit( Hero, Hero.hRespawnCheckpoint:GetOrigin(), true )
				Hero:AddNewModifier( Hero, nil, "modifier_invulnerable", { duration = 2.5 } )
				Hero:AddNewModifier( Hero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )
				EmitSoundOn( "Dungeon.HeroRevived", Hero )
			else
				Hero:AddNewModifier( Hero, nil, "modifier_aegis_regen", { duration = 5.0 } )
			end
		end
	end

	local netTable = {}
	netTable["CheckpointName"] = szZoneName
	CustomGameEventManager:Send_ServerToAllClients( "checkpoint_activated", netTable )
end

---------------------------------------------------------

function CDungeon:OnPlayerHeroEnteredZone( playerHero, zoneName )
	--print( "CDungeon:OnPlayerHeroEnteredZone - PlayerHero " .. playerHero:GetUnitName() .. " entered " .. zoneName )

	local netTable = {}
	netTable["ZoneName"] = zoneName
	CustomGameEventManager:Send_ServerToPlayer( playerHero:GetPlayerOwner(), "zone_enter", netTable )
end

---------------------------------------------------------

function CDungeon:OnZoneActivated( Zone )
	for _,zone in pairs( self.Zones ) do
		zone:OnZoneActivated( Zone )
	end

	if Zone.szName == "forest_holdout" then
		local hTowers = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,Tower in pairs( hTowers ) do
			if Tower ~= nil and Tower:GetUnitName() == "npc_dota_holdout_tower" then
				Tower:RemoveAbility( "building_no_vision" )
				Tower:RemoveModifierByName( "modifier_no_vision" )
			end
		end
	end

	if GetMapName() == "ep_2" and Zone.szName == "ice_lake" then
		local hTowers = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,Tower in pairs( hTowers ) do
			if Tower ~= nil and Tower:GetUnitName() == "npc_dota_holdout_tower_snow" then
				Tower:SetSkin( 2 )
			end
		end
	end
end

---------------------------------------------------------

function CDungeon:OnZoneEventComplete( Zone )
	for _,zone in pairs( self.Zones ) do
		zone:OnZoneEventComplete( Zone )
	end
end

---------------------------------------------------------

function CDungeon:OnQuestStarted( zone, quest )
	--print( "CDungeon:OnQuestStarted - Quest " .. quest.szQuestName .. " in Zone " .. zone.szName .. " started." )
	quest.bActivated = true

	for _,zone in pairs( self.Zones ) do
		zone:OnQuestStarted( quest )
	end

	if quest.Completion.Type == QUEST_EVENT_ON_DIALOG or quest.Completion.Type == QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED then
		local hDialogEntities = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,DialogEnt in pairs ( hDialogEntities ) do
			if DialogEnt ~= nil  and DialogEnt:GetUnitName() == quest.Completion.szNPCName and DialogEnt:FindModifierByName( "modifier_npc_dialog_notify" ) == nil then
				DialogEnt:AddNewModifier( DialogEnt, nil, "modifier_npc_dialog_notify", {} )
			end
		end
	end

	local netTable = {}
	netTable["ZoneName"] = zone.szName
	netTable["QuestName"] = quest.szQuestName
	netTable["QuestType"] = quest.szQuestType
	netTable["Completed"] = quest.nCompleted
	netTable["CompleteLimit"] = quest.nCompleteLimit
	netTable["Optional"] = quest.bOptional

	CustomGameEventManager:Send_ServerToAllClients( "quest_activated", netTable )
end

---------------------------------------------------------

function CDungeon:OnQuestCompleted( questZone, quest )
	--print( "CDungeon:OnQuestCompleted - Quest " .. quest.szQuestName .. " in Zone " .. questZone.szName .. " completed." )
	quest.nCompleted = quest.nCompleted + 1
	if quest.nCompleted >= quest.nCompleteLimit then
		quest.bCompleted = true
	end

	local bZonePreviouslyCompleted = questZone.bZoneCompleted

	if quest.bOptional ~= true then
		questZone:CheckForZoneComplete()
	end	

	if quest.bCompleted == true then
		for _,zone in pairs( self.Zones ) do
			zone:OnQuestCompleted( quest )
		end

		if quest.Completion.Type == QUEST_EVENT_ON_DIALOG or quest.Completion.Type == QUEST_EVENT_ON_DIALOG_ALL_CONFIRMED then
			local hDialogEntities = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,DialogEnt in pairs ( hDialogEntities ) do
				if DialogEnt ~= nil  and DialogEnt:GetUnitName() == quest.Completion.szNPCName and DialogEnt:FindModifierByName( "modifier_npc_dialog_notify" ) then
					--print("removing modifier from unit")
					DialogEnt:RemoveModifierByName( "modifier_npc_dialog_notify" )
				end
			end
		end

		local hLogicRelay = Entities:FindByName( nil, quest.szCompletionLogicRelay )
		if hLogicRelay then
			hLogicRelay:Trigger()
		end

		local Heroes = HeroList:GetAllHeroes()
		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				if quest.RewardXP ~= nil and quest.RewardXP > 0 then
					Hero:AddExperience( quest.RewardXP, DOTA_ModifyXP_Unspecified, false, true )
				end
				if quest.RewardGold ~= nil and quest.RewardGold > 0 then
					Hero:ModifyGold( quest.RewardGold, true, DOTA_ModifyGold_Unspecified )
				end
			end
		end
	end
	
	local netTable = {}
	netTable["ZoneName"] = questZone.szName
	netTable["QuestName"] = quest.szQuestName
	netTable["QuestType"] = quest.szQuestType
	netTable["Completed"] = quest.nCompleted
	netTable["CompleteLimit"] = quest.nCompleteLimit
	netTable["XPReward"] = quest.RewardXP or 0
	netTable["GoldReward"] = quest.RewardGold or 0
	netTable["ZoneCompleted"] = bZonePreviouslyCompleted == false and questZone.bZoneCompleted == true
	netTable["Optional"] = quest.bOptional
	netTable["ZoneStars"] = questZone.nStars

	CustomGameEventManager:Send_ServerToAllClients( "quest_completed", netTable )
end

---------------------------------------------------------

function CDungeon:OnDialogBegin( hPlayerHero, hDialogEnt )
	local Dialog = self:GetDialog( hDialogEnt )
	if Dialog == nil then
		print( "CDungeon:OnDialogBegin - ERROR: No Dialog found for " .. hDialogEnt:GetUnitName() )
		return
	end

	if self.bConfirmPending == true then
		print( "CDungeon:OnDialogBegin - Cannot dialog, a confirm dialog is pending." )
		return
	end

	if Dialog.szRequireQuestActive ~= nil then
		if self:IsQuestActive( Dialog.szRequireQuestActive ) == false then
			print( "CDungeon:OnDialogBegin - Required Active Quest for dialog line not active." )
			return
		end
	end

	local bShowAdvanceDialogButton = true
	local NextDialog = self:GetDialogLine( hDialogEnt, hDialogEnt.nCurrentLine + 1 ) 
	if Dialog.bPlayersConfirm == true or NextDialog == nil or NextDialog.bPlayersConfirm == true or Dialog.bForceBreak == true then
		bShowAdvanceDialogButton = false
	end

	local netTable = {}
	netTable["DialogEntIndex"] = hDialogEnt:entindex()
	netTable["PlayerHeroEntIndex"] = hPlayerHero:entindex()
	netTable["DialogText"] = Dialog.szText
	netTable["DialogAdvanceTime"] = Dialog.flAdvanceTime
	netTable["DialogLine"] = hDialogEnt.nCurrentLine
	netTable["ShowAdvanceButton"] = bShowAdvanceDialogButton
	netTable["SendToAll"] = Dialog.bSendToAll
	netTable["DialogPlayerConfirm"] = Dialog.bPlayersConfirm
	netTable["ConfirmToken"] = Dialog.szConfirmToken
	netTable["JournalEntry"] = hDialogEnt:FindAbilityByName( "ability_journal_note" ) ~= nil
	netTable["WardenNote"] = hDialogEnt:FindAbilityByName( "ability_warden_note" ) ~= nil

	--print("removing modifier from unit")
	hDialogEnt:RemoveModifierByName( "modifier_npc_dialog_notify" )

	for _,zone in pairs( self.Zones ) do
		zone:OnDialogBegin( hDialogEnt )
	end

	if Dialog.bPlayersConfirm == true then
		self.bConfirmPending = true
	end

	if Dialog.bSkipFacePlayer ~= true then 
		hDialogEnt.vOriginalFaceDir = hDialogEnt:GetOrigin() + hDialogEnt:GetForwardVector() * 50
		hDialogEnt:FaceTowards( hPlayerHero:GetOrigin() )
	end

	if Dialog.Gesture ~= nil then
		hDialogEnt:StartGesture( Dialog.Gesture )
	end

	if Dialog.Sound ~= nil then
		hDialogEnt:EmitSoundParams( Dialog.Sound, 0, VOICE_VOLUME, 0 )
	end

	if Dialog.bAdvance == true then
		hDialogEnt.nCurrentLine = hDialogEnt.nCurrentLine + 1
	end

	if Dialog.szGiveItemName ~= nil then
		local newItem = CreateItem( Dialog.szGiveItemName, nil, nil )
		if hPlayerHero:HasAnyAvailableInventorySpace() then
			hPlayerHero:AddItem( newItem )
		else
			if newItem ~= nil then
				local drop = CreateItemOnPositionSync( hPlayerHero:GetAbsOrigin(), newItem )
				local dropTarget = hPlayerHero:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
				newItem:LaunchLoot( false, 150, 0.75, dropTarget )
			end
		end
	end

	if Dialog.bDialogStopsMovement == true then
		hDialogEnt:SetMoveCapability( DOTA_UNIT_CAP_MOVE_NONE )
	end

	if hDialogEnt:FindAbilityByName( "ability_journal_note" ) ~= nil then
		local szJournalNumber = string.match( Dialog.szText, "chef_journal_(%d+)" )
		if szJournalNumber ~= nil then
			local nJournalNumber = tonumber( szJournalNumber );
			local nPlayerID = hPlayerHero:GetPlayerID()
			self:OnPlayerFoundChefNote( nPlayerID, nJournalNumber )
		end
	end

	if hDialogEnt:FindAbilityByName( "ability_warden_note" ) ~= nil then
		local szWardenNoteNumber = string.match( Dialog.szText, "warden_log_(%d+)" )
		if szWardenNoteNumber ~= nil then
			local nWardenNoteNumber = tonumber( szWardenNoteNumber );
			local nPlayerID = hPlayerHero:GetPlayerID()
			self:OnPlayerFoundWardenNote( nPlayerID, nWardenNoteNumber )
		end
	end

	if Dialog.bSendToAll == true then
		CustomGameEventManager:Send_ServerToAllClients( "dialog", netTable )
	else
		CustomGameEventManager:Send_ServerToPlayer( hPlayerHero:GetPlayerOwner(), "dialog", netTable )
	end
end

---------------------------------------------------------

function CDungeon:OnDialogEnded( eventSourceIndex, data )
	if data.DialogEntIndex == nil then
		return
	end
	local hDialogEnt = EntIndexToHScript( data.DialogEntIndex )
	local hPlayerHero = EntIndexToHScript( data.PlayerHeroEntIndex )
	local nDialogLine = data.DialogLine
	local bShowNextLine = data.ShowNextLine
	if hDialogEnt ~= nil and nDialogLine ~= nil then
		local Dialog = self:GetDialogLine( hDialogEnt, nDialogLine )
		if Dialog ~= nil then
			if Dialog.bSkipFacePlayer ~= true then
				hDialogEnt:StopFacing()
				hDialogEnt:FaceTowards( hDialogEnt.vOriginalFaceDir)
			end

			if Dialog.Gesture ~= nil then
				hDialogEnt:FadeGesture( Dialog.Gesture )
			end

			if Dialog.bDialogStopsMovement then
				hDialogEnt:SetMoveCapability( DOTA_UNIT_CAP_MOVE_GROUND )
			end

			if Dialog.OrderOnDialogEnd ~= nil then
				Dialog.OrderOnDialogEnd.UnitIndex = hDialogEnt:entindex()
				ExecuteOrderFromTable( Dialog.OrderOnDialogEnd )
			end
			if Dialog.InitialGoalEntity ~= nil then
				local hWaypoint = Entities:FindByName( nil, Dialog.InitialGoalEntity )
				if hWaypoint ~= nil then
					hDialogEnt:SetInitialGoalEntity( hWaypoint )
				end
			end
			if Dialog.szLogicRelay ~= nil then
				local hLogicRelay = Entities:FindByName( nil, Dialog.szLogicRelay )
				if hLogicRelay then
					hLogicRelay:Trigger()
				end
			end
			if Dialog.EntsToEnable ~= nil then
				for _, szEntName in pairs( Dialog.EntsToEnable ) do
					local hEnt = Entities:FindByName( nil, szEntName )
					if hEnt then
						hEnt:Enable()
					end
				end
			end
		end

		if bShowNextLine == 1 and hPlayerHero then
			self:OnDialogBegin( hPlayerHero, hDialogEnt )
		end
	end
end

---------------------------------------------------------

function CDungeon:OnBossFightIntro( hBoss )
	local Dialog = self:GetDialog( hBoss )
	if Dialog == nil then
		print( "CDungeon:OnBossFightIntro - ERROR: No Dialog found for boss " .. hBoss:GetUnitName() )
		return
	end

	if Dialog.bAdvance == true then
		hBoss.nCurrentLine = hBoss.nCurrentLine + 1
	end

	if Dialog.Gesture ~= nil then
		hBoss:StartGesture( Dialog.Gesture )
		hBoss.CurrentGesture = Dialog.Gesture
	end

	if Dialog.Sound ~= nil then
		EmitSoundOn( Dialog.Sound, hBoss )
	end

	if hBoss:FindModifierByName( "modifier_temple_guardian_statue" ) ~= nil then
		hBoss:AddNewModifier( hBoss, nil, "modifier_invulnerable", { duration = Dialog.flAdvanceTime } )
		hBoss:RemoveModifierByName( "modifier_temple_guardian_statue" )
	end


	local netTable = {}
	netTable["DialogText"] = Dialog.szText
	netTable["DialogEntIndex"] = hBoss:entindex()
	netTable["BossName"] = hBoss:GetUnitName()
	netTable["BossEntIndex"] = hBoss:entindex()
	netTable["BossIntroTime"] = Dialog.flAdvanceTime
	netTable["CameraPitch"] = Dialog.flCameraPitch
	netTable["CameraDistance"] = Dialog.flCameraDistance
	netTable["CameraLookAtHeight"] = Dialog.flCameraLookAtHeight
	netTable["SkipIntro"] = Dialog.bSkipBossIntro

	hBoss.bStarted = true
	hBoss.flIntroEndTime = GameRules:GetGameTime() + Dialog.flAdvanceTime
	hBoss.bIntroComplete = false

	local hFriendlyHero = nil
	if Dialog.bSkipBossIntro == false then
		local units = FindUnitsInRadius( hBoss:GetTeamNumber(), hBoss:GetOrigin(), hBoss, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
		for _,unit in pairs ( units ) do
			if unit ~= nil and unit ~= hBoss then
				unit:AddNewModifier( hBoss, nil, "modifier_boss_intro", { duration = netTable["BossIntroTime"] } )
				if unit:IsRealHero() and unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
					hFriendlyHero = unit
				end
			end
		end
	end

	CustomGameEventManager:Send_ServerToAllClients( "boss_intro_begin", netTable )

	hBoss:AddNewModifier( hFriendlyHero, nil, "modifier_provide_vision", {} )
	hBoss:AddNewModifier( hBoss, nil, "modifier_boss_intro", { duration = netTable["BossIntroTime"] } )
	hBoss:AddNewModifier( hBoss, nil, "modifier_followthrough", { duration = netTable["BossIntroTime"] + 1.0 } )
end

---------------------------------------------------------

function CDungeon:OnBossFightIntroEnd( hBoss )
	CustomGameEventManager:Send_ServerToAllClients( "boss_intro_end", netTable )

	if hBoss ~= nil then
		local units = FindUnitsInRadius( hBoss:GetTeamNumber(), hBoss:GetOrigin(), hBoss, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
		for _,unit in pairs ( units ) do
			if unit ~= nil and unit ~= hBoss then
				unit:RemoveModifierByName( "modifier_boss_intro" )
			end
		end

		--hBoss:RemoveModifierByName( "modifier_provide_vision" )
		hBoss:RemoveModifierByName( "modifier_boss_intro" )
		hBoss:RemoveGesture( hBoss.CurrentGesture )
		if hBoss:GetUnitName() == "npc_dota_creature_temple_guardian" then
			hBoss:RemoveGesture( ACT_DOTA_CAST_ABILITY_7 )
		end

		local Heroes = HeroList:GetAllHeroes()
		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				local hPlayer = Hero:GetPlayerOwner()
				if hPlayer ~= nil then
					hPlayer:SetMusicStatus(2, 1.0) -- turn on battle music
				end
			end
		end
	end
end

---------------------------------------------------------

function CDungeon:OnTreasureOpen( hPlayerHero, hTreasureEnt )
	--print( "OnTreasureOpen()" )

	self:ChooseTreasureSurprise( hPlayerHero, hTreasureEnt )


	--hTreasureEnt:Destroy()
end

---------------------------------------------------------

function CDungeon:UpdateGameEndTables()
	local metadataTable = {}
	metadataTable[ "event_name" ] = "siltbreaker"
	metadataTable[ "explorer_mode" ] = self.bExplorerMode

	local nTrophyID = 0
	local nTrophyZoneID = 0
	local nTrophyLevel = 0
	
	if GetMapName() == "ep_1" then
		metadataTable[ "map_name" ] = "ep_1"
		nTrophyID = 63
		nTrophyZoneID = 13
	elseif GetMapName() == "ep_2" then
		metadataTable[ "map_name" ] = "ep_2"
		nTrophyID = 64
		nTrophyZoneID = 15
	elseif GetMapName() == "ep_2_alt" then
		metadataTable[ "map_name" ] = "ep_2_alt"
	end

	metadataTable[ "zones" ] = {}

	local signoutTable = {}
	signoutTable["explorer_mode"] = self.bExplorerMode
	signoutTable["zone_data"] = {}
	signoutTable["chef_notes"] = self.ChefNotesFound
	signoutTable["warden_notes"] = self.WardenNotesFound
	signoutTable["invoker_found"] = self.InvokerFound
	signoutTable["penguin_ride"] = self.PenguinRideTimes
	signoutTable["artifacts_purchased"] = self.ArtifactsPurchased

	for _,zone in pairs( self.Zones ) do
		if not zone.bNoLeaderboard and zone.flCompletionTime > 0 then
			local zoneTable = {}

			zoneTable[ "zone_id" ] = zone.nZoneID
			zoneTable[ "completed" ] = zone.bZoneCompleted
			zoneTable[ "stars" ] = zone.nStars
			zoneTable[ "kills" ] = zone.nKills
			zoneTable[ "deaths" ] = zone.nDeaths
			zoneTable[ "items" ] = zone.nItems
			zoneTable[ "gold_bags" ] = zone.nGoldBags
			zoneTable[ "potions" ] = zone.nPotions
			zoneTable[ "revive_time" ] = zone.nReviveTime
			zoneTable[ "damage" ] = zone.nDamage
			zoneTable[ "healing" ] = zone.nHealing
			zoneTable[ "completion_time" ] = zone.flCompletionTime
			
			metadataTable[ "zones" ][ zone.szName ] = zoneTable

			-- Signout only gets a subset of the data to cut down on processing on the GC
			local signoutZoneTable = {}
			
			signoutZoneTable[ "stars" ] = zone.nStars
			signoutZoneTable[ "completed" ] = zone.bZoneCompleted
			signoutZoneTable[ "completion_time" ] = zone.flCompletionTime

			signoutTable["zone_data"][ zone.nZoneID ] = signoutZoneTable
			
			-- Grant a trophy if necessary
			if ( zone.nZoneID == nTrophyZoneID ) then
				nTrophyLevel = zone.nStars
				if ( nTrophyLevel == 0 ) then
					nTrophyLevel = 1
				end
			end
		end
	end
	
	if not self.bExplorerMode and nTrophyLevel > 0 then
		signoutTable[ "trophy_id" ] = nTrophyID
		signoutTable[ "trophy_level" ] = nTrophyLevel
	end

	if #self.RelicsFound > 0 then
		signoutTable[ "relics_found" ] = self.RelicsFound
	end

	if self.bUseArtifactCurrency == true then
		signoutTable["artifact_currency"] = self.ArtifactCurrency
		for _,Currency in pairs( self.ArtifactCurrency ) do
			print( "Currency PlayerID: " .. Currency["PlayerID"] )
			print( "Currency Starting Balance: " .. Currency["StartingBalance"] ) 
			print( "Currency Ending Balance: " .. Currency["Balance"] ) 
			print( "Currency Delta: " .. Currency["Delta"] ) 
		end
	end

	GameRules:SetEventMetadataCustomTable( metadataTable )
	GameRules:SetEventSignoutCustomTable( signoutTable )
end

---------------------------------------------------------

function CDungeon:OnZoneCompleted( zone )
	--print( "CDungeon:OnZoneCompleted - Zone " .. zone.szName .. " has been completed with " .. zone.nStars .. " stars " )
	
	self:UpdateGameEndTables();
end

---------------------------------------------------------

function CDungeon:OnGameFinished()
	print( "CDungeon:OnGameFinished" )

	self:UpdateGameEndTables()
end

---------------------------------------------------------

function CDungeon:OnScrollClicked( eventSourceIndex, data )
	local hPlayerHero = EntIndexToHScript( data.ent_index )
	if hPlayerHero ~= nil and hPlayerHero:FindModifierByName( "modifier_pre_teleport" ) ~= nil then
		for i = 0, DOTA_ITEM_MAX - 1 do
			local item = hPlayerHero:GetItemInSlot( i )
			if item and item:GetAbilityName() == "item_tpscroll" then
				ExecuteOrderFromTable({
					UnitIndex = hPlayerHero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					AbilityIndex = item:entindex(),
					Position = hPlayerHero:GetOrigin(),
				})
				hPlayerHero:AddNewModifier( hPlayerHero, item, "modifier_command_restricted", {} )
				hPlayerHero.bHasClickedScroll = true
			end
		end
	end
end

---------------------------------------------------------

local ConfirmCount = {}

function CDungeon:OnDialogConfirm( eventSourceIndex, data )
	if ConfirmCount[data.ConfirmToken] == nil then
		ConfirmCount[data.ConfirmToken] = 1
	else
		ConfirmCount[data.ConfirmToken] = ConfirmCount[data.ConfirmToken] + 1
	end

	local netTable = {}
	netTable["PlayerID"] = data.nPlayerID
	CustomGameEventManager:Send_ServerToAllClients( "dialog_player_confirm", netTable )

	local nValid = 0;
	for iPlayer = 0,4 do
		if PlayerResource:GetSteamAccountID( iPlayer ) ~= 0 then
			nValid = nValid + 1
		end
	end
		
	if ConfirmCount[data.ConfirmToken] == nValid then
		local netTable = {}
		for _,zone in pairs( self.Zones ) do
			zone:OnDialogAllConfirmed( EntIndexToHScript( data["DialogEntIndex"] ), data["DialogLine"] )
		end
		CustomGameEventManager:Send_ServerToAllClients( "dialog_player_all_confirmed", netTable )
		self.bConfirmPending = false
	end
end

---------------------------------------------------------

function CDungeon:OnDialogConfirmExpired( eventSourceIndex, data )
	ConfirmCount[data.ConfirmToken] = 4

	for _,zone in pairs( self.Zones ) do
		zone:OnDialogAllConfirmed( EntIndexToHScript( data["DialogEntIndex"] ), data["DialogLine"] )
	end
	CustomGameEventManager:Send_ServerToAllClients( "dialog_player_all_confirmed", netTable )
	self.bConfirmPending = false
end

---------------------------------------------------------

function CDungeon:OnRelicClaimed( eventSourceIndex, data )
	local nPlayerID = data["PlayerID"]
	local szClaimedRelicName = data["ClaimedRelicName"]
	if nPlayerID ~= nil and szClaimedRelicName ~= nil then
		print( "CDungeon:OnRelicClaimed - Player " .. nPlayerID .. " is trying to claim relic " .. szClaimedRelicName )
		local relicTable = CustomNetTables:GetTableValue( "relics", string.format( "%d", nPlayerID ) )
		if relicTable ~= nil then
			local relicIndex = 0
			for _,Relic in pairs( relicTable ) do
				relicIndex = relicIndex + 1
				if Relic ~= nil and Relic["RelicName"] == szClaimedRelicName then
					local Hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if Hero ~= nil then
						local nArtifactCurrencyCost = Relic["DungeonCurrencyCost"]
						local nBalance = 0
						for _,Currency in pairs ( self.ArtifactCurrency ) do
							if Currency ~= nil and Currency["PlayerID"] == nPlayerID then
								nBalance = Currency["Balance"]
							end
						end
						print( "CDungeon:OnRelicClaimed - Current Balance: " .. nBalance )
						print( "CDungeon:OnRelicClaimed - Artifact Cost: " .. nArtifactCurrencyCost ) 
						if nBalance < nArtifactCurrencyCost and self.bUseArtifactCurrency == true then
							--Throw error
							print( "CDungeon:OnRelicClaimed - ERROR: Not enough currency." )
						else
							if self.bUseArtifactCurrency == true then
								for _,Currency in pairs ( self.ArtifactCurrency ) do
									if Currency ~= nil and Currency["PlayerID"] == nPlayerID then
										Currency["Balance"] = nBalance - nArtifactCurrencyCost
										Currency["Delta"] = Currency["Delta"] - nArtifactCurrencyCost
										print( "CDungeon:OnRelicClaimed - Updated balance: " .. Currency["Balance"] )
										CustomNetTables:SetTableValue( "artifact_currency", string.format( "%d", nPlayerID ), Currency )
									end
								end
							end
							
							local newRelic = CreateItem( szClaimedRelicName, Hero, Hero )
							newRelic:SetPurchaseTime( GameRules:GetGameTime() )
							newRelic:SetPurchaser( Hero )
							newRelic.bIsRelic = true
							newRelic.nBoundPlayerID = nPlayerID
							if Hero:HasAnyAvailableInventorySpace() then
								Hero:AddItem( newRelic ) 
							else
								local drop = CreateItemOnPositionSync( Hero:GetAbsOrigin(), newRelic )
								local dropTarget = Hero:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
								newRelic:LaunchLoot( false, 150, 0.75, dropTarget )
							end
							
							Relic["Purchased"] = 1

							for _,PlayerArtifactsPurchased in pairs ( self.ArtifactsPurchased ) do
								if PlayerArtifactsPurchased ~= nil and PlayerArtifactsPurchased["PlayerID"] == nPlayerID then
									PlayerArtifactsPurchased["PurchasedCount"] = PlayerArtifactsPurchased["PurchasedCount"] + 1
								end
							end
							
							CustomNetTables:SetTableValue( "relics", string.format( "%d", nPlayerID ), relicTable )
						end	
					end
				end
			end
		end
	end
end

---------------------------------------------------------

function CDungeon:TrackPlayerAchievementEvent( trackingTable, nPlayerID, nIndex )
	local szAccountID = tostring( PlayerResource:GetSteamAccountID( nPlayerID ) )

	if trackingTable[ szAccountID ] == nil then
		trackingTable[ szAccountID ] = {}
	end

	trackingTable[ szAccountID ][ nIndex ] = true
end

---------------------------------------------------------

function CDungeon:OnPlayerFoundChefNote( nPlayerID, nChefNoteIndex )
	self:TrackPlayerAchievementEvent( self.ChefNotesFound, nPlayerID, nChefNoteIndex )
end

---------------------------------------------------------

function CDungeon:OnPlayerFoundWardenNote( nPlayerID, nWardenNoteIndex )
	self:TrackPlayerAchievementEvent( self.WardenNotesFound, nPlayerID, nWardenNoteIndex )
end

---------------------------------------------------------

function CDungeon:OnPlayerFoundInvoker( nPlayerID, nInvokerIndex )
	self:TrackPlayerAchievementEvent( self.InvokerFound, nPlayerID, nInvokerIndex )
end

---------------------------------------------------------

function CDungeon:OnCustomZoneEvent( szZoneName, szZoneEvent )
	for _,zone in pairs( self.Zones ) do
		zone:OnCustomZoneEvent( szZoneName, szZoneEvent )
	end
end

---------------------------------------------------------

function CDungeon:OnArtifactCoinsFound( nFindingPlayerID, nAmount )
	if nAmount == 0 or self.bExplorerMode == true then
		return
	end

	for _,Currency in pairs ( self.ArtifactCurrency ) do
		if Currency ~= nil then
			Currency["Balance"] = Currency["Balance"] + nAmount
			Currency["Delta"] = Currency["Delta"] + nAmount
			CustomNetTables:SetTableValue( "artifact_currency", string.format( "%d", Currency["PlayerID"] ), Currency )
		end
	end

	local gameEvent = {}
	if nFindingPlayerID ~= -1 then	
		gameEvent["player_id"] = nFindingPlayerID
		gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_bag_of_artifact_coins"
		gameEvent["int_value"] = nAmount
		gameEvent["message"] = "#Dungeon_FoundArtifactCoins"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	else
		gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_bag_of_artifact_coins"
		gameEvent["int_value"] = nAmount
		gameEvent["message"] = "#Dungeon_ZoneCompleteArtifactCoins"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end
end

---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------

function CDungeon:OnNonPlayerUsedAbility( event )
	local szAbilityName = event.abilityname
	if event.caster_entindex == nil then
		print( "ERROR: event.caster_entindex is nil.  (szAbilityName == " .. szAbilityName .. "\")" )
		return
	end
	local hCaster = EntIndexToHScript( event.caster_entindex )
	if szAbilityName ~= nil and hCaster ~= nil and hCaster.bBoss == true and GameRules:GetGameTime() > hCaster.flSpeechCooldown then
		self:FireAbilityLine( hCaster, szAbilityName )
	end
end

---------------------------------------------------------

function CDungeon:OnPenguinRideFinished( nPlayerID, flTime )
	print( "CDungeon:OnPenguinRideFinished - PlayerID " .. nPlayerID .. " achieved a time of " .. flTime )
	local PenguinRide = {}
	PenguinRide["PlayerID"] = nPlayerID
	PenguinRide["SteamID"] = PlayerResource:GetSteamID( nPlayerID )
	PenguinRide["Time"] = flTime
	table.insert( self.PenguinRideTimes, PenguinRide )
end