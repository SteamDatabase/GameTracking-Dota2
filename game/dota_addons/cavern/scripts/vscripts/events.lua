---------------------------------------------------------
-- game_rules_state_change
---------------------------------------------------------

function CCavern:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if self.bUseTeamSelect == false then
			self:AssignTeams()
		end
		self:SetupEncounters()
		self:SetupRooms()
	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:ForceAssignHeroes()
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:OnGameBegin()
	end
end

---------------------------------------------------------

function CCavern:OnGameBegin()
	for _,Room in pairs( self.Rooms ) do
		if Room:GetTeamSpawnInRoom() ~= nil then
			Room:OpenAntechamber()
		end
	end
end

---------------------------------------------------------

function CCavern:OnGameFinished()
	self:AddResultToSignOut()
	print( "Metadata Table:" )
	PrintTable( self.EventMetaData, " " )
	print( "Signout Table:" )
	PrintTable( self.SignOutTable, " " )
	GameRules:SetEventMetadataCustomTable( self.EventMetaData )
	GameRules:SetEventSignoutCustomTable( self.SignOutTable )
end

---------------------------------------------------------

function CCavern:AddResultToSignOut()
	self.SignOutTable["game_time"] = GameRules:GetGameTime()

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local PlayerStats = {}
			PlayerStats["player_id"] = nPlayerID
			PlayerStats["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			PlayerStats["kills"] = self.EventMetaData[nPlayerID]["kills"]
			PlayerStats["revives"] = self.EventMetaData[nPlayerID]["revives"]
			PlayerStats["eliminations"] = self.EventMetaData[nPlayerID]["eliminations"]
			PlayerStats["team_position"] = self.EventMetaData[nPlayerID]["team_position"]
			PlayerStats["team_id"] = self.EventMetaData[nPlayerID]["team_id"]
			PlayerStats["level"] = 1
			PlayerStats["net_worth"] = 0

			local Hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if Hero ~= nil then
				if Hero.bEliminated == false then
					PlayerStats["level"] = PlayerResource:GetLevel( nPlayerID )
					PlayerStats["net_worth"] = PlayerResource:GetNetWorth( nPlayerID )
				else
					PlayerStats["level"] = self.EventMetaData[nPlayerID]["level"]
					PlayerStats["net_worth"] = self.EventMetaData[nPlayerID]["net_worth"]
				end
			end
			
			table.insert( self.SignOutTable["stats"], PlayerStats )
		end
	end
end

---------------------------------------------------------
-- dota_player_reconnected
-- * player_id
---------------------------------------------------------

function CCavern:OnPlayerReconnected( event )
	local hPlayer = PlayerResource:GetPlayer( event.player_id )
	if hPlayer ~= nil then
	end
end

---------------------------------------------------------
-- npc_spawned
-- * entindex
---------------------------------------------------------

function CCavern:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit ~= nil then
		if spawnedUnit:IsRealHero() then
			self:OnNPCSpawned_PlayerHero( event )
			return
		end
		if spawnedUnit:IsCreature() and spawnedUnit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
			self:OnNPCSpawned_EnemyCreature( event )
			return
		end
	end
end

---------------------------------------------------------

function CCavern:OnNPCSpawned_PlayerHero( event )
	local hPlayerHero = EntIndexToHScript( event.entindex )

	if hPlayerHero ~= nil then
		--if hPlayerHero:FindModifierByName("modifier_death_penalty") == nil then
		--	hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_death_penalty", {})
		--end
		if hPlayerHero.bFirstSpawnComplete == true and hPlayerHero:IsRealHero() and hPlayerHero:IsTempestDouble() == false then
			FindClearSpaceForUnit( hPlayerHero, hPlayerHero.vDeathPos, true )
		end
	end
end

---------------------------------------------------------

function CCavern:OnNPCSpawned_EnemyCreature( event )
	local hEnemyCreature = EntIndexToHScript( event.entindex )
	if hEnemyCreature ~= nil then
	end
end

---------------------------------------------------------
-- dota_on_hero_finish_spawn
-- * heroindex
-- * hero  		(string)
---------------------------------------------------------

function CCavern:OnHeroFinishSpawn( event )
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero ~= nil and hPlayerHero:IsRealHero() then
		if hPlayerHero.bFirstSpawnComplete == nil then
			hPlayerHero.bEliminated = false
			hPlayerHero.bFirstSpawnComplete = true
			for _,Room in pairs( self.Rooms ) do
				if Room:GetTeamSpawnInRoom() == hPlayerHero:GetTeamNumber() then
					--print( "Moving hero to Room " .. Room:GetRoomID() )
					FindClearSpaceForUnit( hPlayerHero, Room:GetAntechamberCenter() + RandomVector( 150 ), true )
					hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_antechamber_start", {} )
					local hTP = hPlayerHero:FindItemInInventory( "item_tpscroll" )
					if hTP ~= nil then
						UTIL_Remove( hTP )
					end
				end
			end

			-- for testing battlepoint gain
			--local hCheeseItem = CreateItem( "item_big_cheese_cavern", nil, nil )
			--local hCheeseItemPhysical = CreateItemOnPositionSync( hPlayerHero:GetAbsOrigin(), hCheeseItem )

			local nPlayerID = hPlayerHero:GetPlayerOwnerID()
			local PlayerBattlePointsData = {}
			PlayerBattlePointsData["player_id"] = nPlayerID
			PlayerBattlePointsData["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			PlayerBattlePointsData["points_earned"] = 0
			self.PlayerPointsData[nPlayerID] = PlayerBattlePointsData

			self.EventMetaData[nPlayerID] = {}
			self.EventMetaData[nPlayerID]["kills"] = 0
			self.EventMetaData[nPlayerID]["revives"] = 0
			self.EventMetaData[nPlayerID]["eliminations"] = 0
			self.EventMetaData[nPlayerID]["battle_points"] = 0
			self.EventMetaData[nPlayerID]["team_position"] = CAVERN_TEAMS_PER_GAME
			self.EventMetaData[nPlayerID]["team_id"] = hPlayerHero:GetTeamNumber()
			self.EventMetaData[nPlayerID]["level"] = 1
			self.EventMetaData[nPlayerID]["net_worth"] = 0

			table.insert( self.HeroesByTeam[hPlayerHero:GetTeamNumber()], hPlayerHero )

			local netTable = {}
			netTable["earned_points"] = PlayerBattlePointsData["points_earned"]
			CustomNetTables:SetTableValue( "bp_tracker", string.format( "%d", nPlayerID ), netTable )

			if hPlayerHero:HasModifier( "modifier_player_light" ) == false then
			--	printf( "Adding player light to player hero \"%s\"", hPlayerHero:GetUnitName() )
				hPlayerHero:AddNewModifier( nil, nil, "modifier_player_light", { duration = -1 } )
			end

			hPlayerHero:AddItemByName( "item_potion_of_cowardice" )
			hPlayerHero:SwapItems( 0, 5 ) -- put potion in last slot

			hPlayerHero:AddItemByName( "item_flask" )
			hPlayerHero:AddItemByName( "item_flask" )
			hPlayerHero:SwapItems( 0, 4 )

			hPlayerHero:AddItemByName( "item_enchanted_mango" )
			hPlayerHero:SwapItems( 0, 3 )

		end
	end
end

---------------------------------------------------------
-- entity_killed
-- * entindex_killed
-- * entindex_attacker
-- * entindex_inflictor
-- * damagebits
---------------------------------------------------------

function CCavern:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit ~= nil then
		if killedUnit:IsRealHero() and killedUnit:IsTempestDouble() == false then
			self:OnEntityKilled_PlayerHero( event )
			return
		end

		if killedUnit:IsCreature() then
			self:OnEntityKilled_EnemyCreature( event )
			return
		end
	end
end

---------------------------------------------------------

function CCavern:OnEntityKilled_PlayerHero( event )
	local killedHero = EntIndexToHScript( event.entindex_killed )
	local killerUnit = EntIndexToHScript( event.entindex_attacker )
	if killedHero ~= nil then
		
		if killerUnit then
			if killerUnit:IsCreature() then
				local gameEvent = {}
				gameEvent["player_id"] = killedHero:GetPlayerID()
				gameEvent["locstring_value"] = killerUnit:GetUnitName()
				gameEvent["teamnumber"] = -1
				gameEvent["message"] = "#Cavern_KilledByCreature"
				FireGameEvent( "dota_combat_event_message", gameEvent )

				self:FireDeathTaunt( killerUnit )
			end
			if killerUnit:IsHero() or killerUnit:IsOwnedByAnyPlayer() then
				local gameEvent = {}
				gameEvent["player_id"] = killedHero:GetPlayerOwnerID()
				gameEvent["player_id2"] = killerUnit:GetPlayerOwnerID()
				gameEvent["teamnumber"] = -1
				gameEvent["message"] = "#Cavern_KilledByPlayer"
				FireGameEvent( "dota_combat_event_message", gameEvent )
				self.EventMetaData[killerUnit:GetPlayerOwnerID()]["kills"] = self.EventMetaData[killerUnit:GetPlayerOwnerID()]["kills"] + 1
				killedHero.KillerNPC = killerUnit
			end
		end


		local newItem = CreateItem( "item_tombstone", killedHero , killedHero )
		newItem:SetPurchaseTime( 0 )
		newItem:SetPurchaser( killedHero )
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killedHero:GetAbsOrigin(), true )
		killedHero.Tombstone = tombstone
		killedHero.vDeathPos = killedHero:GetAbsOrigin()
		
		killedHero:AddNewModifier( killedHero, nil, "modifier_hide_on_minimap", { EnemiesOnly=true } )

		self:RemoveTombstoneVisionDummy( killedHero )

		local hTombstoneVisionDummy = CreateUnitByName( "npc_dota_tombstone_vision_dummy", killedHero:GetAbsOrigin(), false, killedHero, killedHero, killedHero:GetTeamNumber() )
		if hTombstoneVisionDummy == nil then
			print( "ERROR: OnEntityKilled_PlayerHero -- hTombstoneVisionDummy is nil (failed to create unit)" )
			return
		else
			killedHero.hTombstoneVisionDummy = hTombstoneVisionDummy
		end

		if killedHero:IsRealHero() and killedHero:HasModifier( "modifier_player_light" ) then
			--printf( "Removing player light from player hero \"%s\"", killedHero:GetUnitName() )
			killedHero:RemoveModifierByName( "modifier_player_light" )
		end

		if killedHero.nDeaths == nil then
			killedHero.nDeaths = 0
		end

		killedHero.nDeaths = killedHero.nDeaths + 1	
		
	end
end

---------------------------------------------------------

function CCavern:OnHeroDefeated( Hero )
	if Hero.bEliminated == true then
		return
	end


	Hero.bEliminated = true

	local netTable = {}
	netTable["eliminationTime"] = GameRules:GetGameTime()
	CustomNetTables:SetTableValue( "eliminated_players", string.format( "%d", Hero:GetPlayerOwnerID()), netTable )
	printf("Player %d has been eliminated.", Hero:GetPlayerOwnerID() )

	local CreditNPC = Hero.KillerNPC
	if CreditNPC ~= nil and CreditNPC:IsNull() == false and CreditNPC ~= Hero then
		local nCreditTeamID = CreditNPC:GetTeamNumber()
		local nCreditPlayerID = CreditNPC:GetPlayerOwnerID()
		self.EventMetaData[nCreditPlayerID]["eliminations"] = self.EventMetaData[nCreditPlayerID]["eliminations"] + 1
		self:OnBattlePointsEarned( nCreditTeamID, CAVERN_BP_REWARD_ELIMINATION, "points_elimination" )
		local gameEvent = {}
		gameEvent["player_id"] = Hero:GetPlayerID()
		gameEvent["player_id2"] = nCreditPlayerID
		gameEvent["teamnumber"] = -1
		gameEvent["int_value"] = CAVERN_BP_REWARD_ELIMINATION
		gameEvent["message"] = "#Cavern_PlayerEliminated"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	else
		local gameEvent = {}
		gameEvent["player_id"] = Hero:GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#Cavern_PlayerEliminatedUnderhollow"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	local bDefeatTeam = true
	for _,HeroInTable in pairs ( self.HeroesByTeam[Hero:GetTeamNumber()] ) do
		if HeroInTable and HeroInTable.bEliminated == false then
			bDefeatTeam = false
		end
	end
	if bDefeatTeam then
		self:OnTeamDefeated( Hero:GetTeamNumber() )
	end

	local nGoldCarried = PlayerResource:GetGold( Hero:GetPlayerID() )
	if nGoldCarried > 0 then
		--print( killedHero:GetUnitName() .. " just dropped " .. nGoldCarried .. " gold!" )
		LaunchGoldBag( nGoldCarried/2, Hero:GetAbsOrigin() )

		PlayerResource:SetGold( Hero:GetPlayerID(), 0, true )
		PlayerResource:SetGold( Hero:GetPlayerID(), 0, false )
	end

	for slot=0,DOTA_ITEM_SLOT_9 do
		local item = Hero:GetItemInSlot( slot )
		if item ~= nil then
			Hero:DropItemAtPositionImmediate( item, Hero:GetAbsOrigin() )
			item:LaunchLoot( false, 125, 0.75, Hero:GetAbsOrigin() + RandomVector( RandomFloat( 150, 300 ) ) )
		end
	end
end

---------------------------------------------------------

function CCavern:OnTeamDefeated( nTeam )
	--print( "OnTeamDefeated" )
	local nBattlePoints = 0
	local data = {}
	for _,Hero in pairs ( self.HeroesByTeam[nTeam] ) do
		self.EventMetaData[Hero:GetPlayerOwnerID()]["team_position"] = self.nNextTeamFinishPosition
		self.EventMetaData[Hero:GetPlayerOwnerID()]["team_id"] = nTeam
		self.EventMetaData[Hero:GetPlayerOwnerID()]["level"] = PlayerResource:GetLevel( Hero:GetPlayerOwnerID() )
		self.EventMetaData[Hero:GetPlayerOwnerID()]["net_worth"] = PlayerResource:GetNetWorth( Hero:GetPlayerOwnerID() )
		data["big_cheese"] = self.EventMetaData[Hero:GetPlayerOwnerID()]["points_big_cheese"] or 0
		data["small_cheese"] = self.EventMetaData[Hero:GetPlayerOwnerID()]["points_small_cheese"] or 0
		data["eliminations"] = self.EventMetaData[Hero:GetPlayerOwnerID()]["points_elimination"] or 0
	--	print( "Player " .. Hero:GetPlayerOwnerID() .. " Networth: " .. PlayerResource:GetNetWorth( Hero:GetPlayerOwnerID() ) )
	--	PlayerResource:SetCustomTeamAssignment( Hero:GetPlayerOwnerID(), 1 ) --Spectator
	end
	print( "Team " .. nTeam .. " has finished in position " .. self.nNextTeamFinishPosition .. " and earned " .. nBattlePoints )
	
	
	data["finish_position"] = self.nNextTeamFinishPosition
	CustomGameEventManager:Send_ServerToTeam( nTeam, "on_team_defeated", data ) 
	self.nNextTeamFinishPosition = self.nNextTeamFinishPosition - 1
end

---------------------------------------------------------

function CCavern:OnEntityKilled_EnemyCreature( event )
	local hDeadCreature = EntIndexToHScript( event.entindex_killed )
	local hKillerUnit = EntIndexToHScript( event.entindex_attacker )
	
	if hDeadCreature ~= nil and hKillerUnit ~= nil then
		if hDeadCreature:FindModifierByName( "modifier_breakable_container" ) then
			return
		end

		EmitSoundOnClient( "Dungeon.LastHit", hKillerUnit:GetPlayerOwner() )
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/darkmoon_last_hit_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hDeadCreature, hKillerUnit:GetPlayerOwner() ) )
	
		if hDeadCreature.nDeathXP == nil then
			print( "CCavern:OnEntityKilled_EnemyCreature - ERROR: Death XP not set for " .. hDeadCreature:GetUnitName() )
			return
		end

		local HeroesToReward = {}
		local nRewardTeam = hKillerUnit:GetTeamNumber()
		for _,Hero in pairs( HeroList:GetAllHeroes() ) do
			if (Hero ~= nil) and Hero:IsRealHero() and (not Hero:IsTempestDouble()) and (Hero:GetTeamNumber() == nRewardTeam) then
				--printf("adding reward hero %s %s", Hero, Hero:GetName())
				table.insert( HeroesToReward, Hero )
			end
		end

		if #HeroesToReward < 1 then
			return
		end

		local nXPPerHero = math.ceil( hDeadCreature.nDeathXP / #HeroesToReward )

		for _,RewardHero in pairs( HeroesToReward ) do
			RewardHero:AddExperience( nXPPerHero, DOTA_ModifyXP_CreepKill, false, true )
		end

		local nRandomBounty = RandomInt( hDeadCreature.nMinGoldBounty, hDeadCreature.nMaxGoldBounty )

		local nGoldPerHero = math.ceil( nRandomBounty / #HeroesToReward )

		if nRandomBounty > 0 then
			LaunchGoldBag( nRandomBounty, hDeadCreature:GetAbsOrigin() )
		end

		--printf("rewarded %d gold and %d xp to %d heros for creep death", nGoldPerHero, nXPPerHero, #HeroesToReward)

	end
end

---------------------------------------------------------
-- dota_holdout_revive_complete
-- * caster (reviver hero entity index)
-- * target (revivee hero entity index)
---------------------------------------------------------

function CCavern:OnPlayerRevived( event )
	local hRevivedHero = EntIndexToHScript( event.target )
	local hReviverHero = EntIndexToHScript( event.caster )
	if hRevivedHero ~= nil and hRevivedHero:IsRealHero() then
		hRevivedHero:SetHealth( hRevivedHero:GetMaxHealth() * 0.4 )
		hRevivedHero:SetMana( hRevivedHero:GetMaxMana() * 0.4 )
		EmitSoundOn( "Dungeon.HeroRevived", hRevivedHero )

		if hReviverHero ~= nil and hReviverHero:IsRealHero() then
			self.EventMetaData[hReviverHero:GetPlayerOwnerID()]["revives"] = self.EventMetaData[hReviverHero:GetPlayerOwnerID()]["revives"] + 1
		end

		self:RemoveTombstoneVisionDummy( hRevivedHero )

		local fInvulnDuration = 3
		hRevivedHero:AddNewModifier( hRevivedHero, nil, "modifier_invulnerable", { duration = fInvulnDuration } )
		hRevivedHero:AddNewModifier( hRevivedHero, nil, "modifier_omninight_guardian_angel", { duration = fInvulnDuration } )

		hRevivedHero:RemoveModifierByName( "modifier_hide_on_minimap" )

		if hRevivedHero:HasModifier( "modifier_player_light" ) == false then
		--	printf( "Adding player light to player hero \"%s\"", hRevivedHero:GetUnitName() )
			hRevivedHero:AddNewModifier( nil, nil, "modifier_player_light", { duration = -1 } )
		end
	end
end

---------------------------------------------------------
-- dota_holdout_revive_eliminated
-- * caster (reviver hero entity index)
-- * target (revivee hero entity index)
---------------------------------------------------------

function CCavern:OnPlayerReviveEliminated( event )
	local hEliminatedHero = EntIndexToHScript( event.target )
	local hEliminatorHero = EntIndexToHScript( event.caster )
	if hEliminatedHero ~= nil and hEliminatedHero:IsRealHero() and hEliminatorHero ~= nil and hEliminatorHero:IsRealHero() and hEliminatedHero.bEliminated ~= true then
		hEliminatedHero:RemoveModifierByName( "modifier_hide_on_minimap" )
		hEliminatedHero:AddNewModifier( hEliminatedHero, nil, "modifier_hide_on_minimap" , {})

		hEliminatedHero.KillerNPC = hEliminatorHero

		self:OnHeroDefeated( hEliminatedHero )
		self:RemoveTombstoneVisionDummy( hEliminatedHero )
	end
end

---------------------------------------------------------
-- dota_buyback
-- * entindex
-- * player_id
---------------------------------------------------------

function CCavern:OnPlayerBuyback( event )
	local hPlayer = PlayerResource:GetPlayer( event.player_id )
end

---------------------------------------------------------
-- dota_player_gained_level
-- * player (player entity index)
-- * level (new level)
---------------------------------------------------------

function CCavern:OnPlayerGainedLevel( event )
end

---------------------------------------------------------
-- dota_item-spawned
-- * player_id
-- * item_ent_index
---------------------------------------------------------

function CCavern:OnItemSpawned( event )
	local item = EntIndexToHScript( event.item_ent_index )
end

---------------------------------------------------------
-- dota_item_picked_up
-- * PlayerID
-- * HeroEntityIndex
-- * UnitEntityIndex (only if parent is not a hero)
-- * itemname
-- * ItemEntityIndex
---------------------------------------------------------

function CCavern:OnItemPickedUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )

	local hero = nil
	if event.HeroEntityIndex then
		hero = EntIndexToHScript( event.HeroEntityIndex )
	end

	if item and hero and item:GetAbilityName() ~= "item_tombstone" then
		item:SetPurchaser( hero )
	end

	if item and item:GetAbilityName() == "item_big_cheese_cavern" then
		local gameEvent = {}
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#Cavern_SomeoneTookTheCheese"
		FireGameEvent( "dota_combat_event_message", gameEvent )

		for nTeam=DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_1+CAVERN_TEAMS_PER_GAME-1 do
			MinimapEvent( nTeam, hero, hero:GetOrigin().x, hero:GetOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
		end
		
		EmitGlobalSound( "BigCheese.Pickup" )
	end
end

---------------------------------------------------------

function CCavern:OnNPCEnteredRoom( Room, NPC )
	if Room == nil or NPC == nil then
		return
	end

	if Room:IsDestroyedByRoshan() then
		NPC:AddNewModifier( NPC, nil, "modifier_room_destruction", {} )
	else
		NPC:RemoveModifierByName( "modifier_room_destruction" )
	end

	if NPC:IsOwnedByAnyPlayer() then
		self:OnPlayerOwnedNPCEnteredRoom( Room, NPC )
	end
end

---------------------------------------------------------

function CCavern:OnPlayerOwnedNPCEnteredRoom( Room, NPC )
	if not Room:IsEncounterCleared() and not Room:IsDestroyedByRoshan() then
		self:OnTeamDiscoverRoom( NPC:GetTeamNumber(), Room )
	end

	local OldRoom = NPC.hRoom
	if OldRoom ~= nil then
		for i = 1, #OldRoom.PlayerHeroesPresent do
			local HeroInOldRoom = OldRoom.PlayerHeroesPresent[i]
			if HeroInOldRoom == NPC then
				table.remove( OldRoom.PlayerHeroesPresent, i )
			--	print( "old room heroes: " .. #OldRoom.PlayerHeroesPresent )
			end
		end
	end

	NPC.hRoom = Room
	table.insert( Room.PlayerHeroesPresent, NPC )
	--print( "new room heroes: " .. #Room.PlayerHeroesPresent)
	
	for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		local Neighbor = Room:GetNeighboringRoom( nDir )
		if Neighbor and Neighbor ~= Room then
			Neighbor:GenerateDoodads()
		end
	end

	if Room:HasEncounterStarted() == false then
		Room:GenerateDoodads()
		Room:StartEncounter()
	end

	if CAVERN_ENCOUNTER_SPAWN_MODE == CAVERN_ENCOUNTER_SPAWN_ADJACENT or CAVERN_ENCOUNTER_SPAWN_MODE == CAVERN_ENCOUNTER_SPAWN_PATHABILITY then
	--	print( "StartEncountersInNeighboringRooms" )
		Room:StartEncountersInNeighboringRooms()
	end
end

---------------------------------------------------------

function CCavern:OnNPCLeftRoom( Room, NPC )
	if Room == nil or NPC == nil or NPC:IsOwnedByAnyPlayer() == false then
		return
	end
end


---------------------------------------------------------------------------

function CCavern:OnTeamDiscoverRoom( nTeam, DiscoverRoom )
	if GameRules:State_Get() <= DOTA_GAMERULES_STATE_PRE_GAME then
		return
	end 

	if DiscoverRoom == nil then
		return
	end

	if self.RoomsDiscoveredByTeam[nTeam] == nil then
		return
	end

	for _,Room in pairs ( self.RoomsDiscoveredByTeam[nTeam] ) do
		if Room ~= nil and DiscoverRoom == Room then
			return
		end
	end

	table.insert( self.RoomsDiscoveredByTeam[nTeam], DiscoverRoom )

	local data = {}
	data["encounter_name"] 		= DiscoverRoom:GetSelectedEncounterName()
	data["encounter_difficulty"] = DiscoverRoom:GetRoomLevel()
	data["encounter_type"] = DiscoverRoom:GetRoomType()
	CustomGameEventManager:Send_ServerToTeam( nTeam, "on_new_room_discovered", data ) 
end

---------------------------------------------------------


function CCavern:OnTriggerStartTouch( triggerName, activator_entindex, caller_entindex  )
	local NPC = EntIndexToHScript( activator_entindex )
	local TriggerEntity = EntIndexToHScript( caller_entindex )
	if NPC ~= nil then
		local i, j = string.find( triggerName, "room_" )
		local szRoomNumber = string.sub( triggerName, j+1, string.len( triggerName ) )
		local Room = self.Rooms[tonumber(szRoomNumber)]
		if Room ~= nil and Room:GetRoomVolume() == TriggerEntity then
			self:OnNPCEnteredRoom( Room, NPC )
			return	
		end

		local k,l = string.find( triggerName, "_ante" )
		local szRoomString = string.sub( triggerName, 1, k-1 )
		local m, n = string.find( szRoomString, "room_" )
		local szAntechamberRoomNumber = string.sub( szRoomString, n+1, string.len( szRoomString ) ) 
		local Room = self.Rooms[tonumber(szAntechamberRoomNumber)]
		if Room ~= nil and Room:GetAntechamberVolume() == TriggerEntity then
		--	print( "Entered antechamber")
			self:OnNPCEnteredRoom( Room, NPC )	
			return
		end
	end
end

---------------------------------------------------------

function CCavern:OnTriggerEndTouch( triggerName, activator_entindex, caller_entindex )
	local NPC = EntIndexToHScript( activator_entindex )
	local TriggerEntity = EntIndexToHScript( caller_entindex )
	if NPC ~= nil then
		local i, j = string.find( triggerName, "room_" )
		local szRoomNumber = string.sub( triggerName, j+1, string.len( triggerName ) )
		local Room = self.Rooms[tonumber(szRoomNumber)]
		if Room ~= nil and Room:GetRoomVolume() == TriggerEntity then
			--print( playerHero:GetUnitName() .. " just left room " .. Room:GetRoomID() )
			self:OnNPCLeftRoom( Room, NPC )
		end
	end
end


---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------

function CCavern:OnNonPlayerUsedAbility( event )
	local szAbilityName = event.abilityname
	local hCaster = EntIndexToHScript( event.caster_entindex )
end

---------------------------------------------------------

function CCavern:OnBattlePointsEarned( nTeamNumber, nBattlePoints, szReason )
	for _,Hero in pairs( HeroList:GetAllHeroes() ) do
		if Hero:GetTeamNumber() == nTeamNumber and Hero:IsRealHero() and Hero:IsTempestDouble() == false and Hero:IsClone() == false then
			local nPlayerID = Hero:GetPlayerOwnerID()
			
			local nDigits = string.len( tostring( nBattlePoints ) )

			local nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/msg_fx/msg_bp.vpcf", PATTACH_CUSTOMORIGIN, nil, Hero:GetPlayerOwner() )
			ParticleManager:SetParticleControl( nFXIndex, 0, Hero:GetOrigin() + Vector( 0, 64, 96 ) )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, nBattlePoints, -1 ) )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, nDigits + 1, 0 ) )
			ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 0, 255, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nFXIndex2 = ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/battle_point_splash.vpcf", PATTACH_WORLDORIGIN, nil, Hero:GetPlayerOwner() )
			ParticleManager:SetParticleControl( nFXIndex2, 1, Hero:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex2 )

			EmitSoundOnClient( "Plus.shards_tick", Hero:GetPlayerOwner() )

			self.PlayerPointsData[nPlayerID]["points_earned"] = self.PlayerPointsData[nPlayerID]["points_earned"] + nBattlePoints
			self.EventMetaData[nPlayerID]["battle_points"] = self.PlayerPointsData[nPlayerID]["points_earned"]
			if self.EventMetaData[nPlayerID][szReason] == nil then
				self.EventMetaData[nPlayerID][szReason] = 0
			end
			self.EventMetaData[nPlayerID][szReason] = self.EventMetaData[nPlayerID][szReason] + 1

			local netTable = {}
			netTable["earned_points"] = self.PlayerPointsData[nPlayerID]["points_earned"]
			CustomNetTables:SetTableValue( "bp_tracker", string.format( "%d", nPlayerID ), netTable )
			if szReason ~= nil then
				print( "Player " .. nPlayerID .. " just earned " .. nBattlePoints .. " battle points for " .. szReason )
			end
		end
	end
	
	self.SignOutTable["points"] = self.PlayerPointsData
end

--------------------------------------------------------------

function CCavern:OnEncounterCleared( nTeamNumber )
	for _,Hero in pairs( HeroList:GetAllHeroes() ) do
		if Hero:GetTeamNumber() == nTeamNumber and Hero:IsRealHero() and Hero:IsTempestDouble() == false and Hero:IsClone() == false then
			local nPlayerID = Hero:GetPlayerOwnerID()
			local EncounterCleared = {}
			EncounterCleared["player_id"] = nPlayerID
			EncounterCleared["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			table.insert( self.SignOutTable["encounters_cleared"], EncounterCleared )
			print( "PlayerID " .. nPlayerID .. " just got credit for clearing an encounter" )
		end
	end
end

--------------------------------------------------------------

function CCavern:OnChickenTreasureDiscovered( nTeamNumber )
	for _,Hero in pairs( HeroList:GetAllHeroes() ) do
		if Hero:GetTeamNumber() == nTeamNumber and Hero:IsRealHero() and Hero:IsTempestDouble() == false and Hero:IsClone() == false then
			local nPlayerID = Hero:GetPlayerOwnerID()
			local ChickenDiscovered = {}
			ChickenDiscovered["player_id"] = nPlayerID
			ChickenDiscovered["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			table.insert( self.SignOutTable["chickens_found"], ChickenDiscovered )
			print( "PlayerID " .. nPlayerID .. " just got credit for discovering chickens." )
		end
	end
end

--------------------------------------------------------------

function CCavern:OnBigCheeseTaken( nTeamNumber )
	for _,Hero in pairs( HeroList:GetAllHeroes() ) do
		if Hero:GetTeamNumber() == nTeamNumber and Hero:IsRealHero() and Hero:IsTempestDouble() == false and Hero:IsClone() == false then
			local nPlayerID = Hero:GetPlayerOwnerID()
			local BigCheeseTaken = {}
			BigCheeseTaken["player_id"] = nPlayerID
			BigCheeseTaken["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			table.insert( self.SignOutTable["big_cheese"], BigCheeseTaken )
			print( "PlayerID " .. nPlayerID .. " just got credit for taking the big cheese." )
		end
	end
end