LinkLuaModifier( "modifier_battle_royale", "modifiers/modifier_battle_royale", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_respawn_haste", "modifiers/modifier_respawn_haste", LUA_MODIFIER_MOTION_NONE )

require( "blessings")

---------------------------------------------------------
-- game_rules_state_change
---------------------------------------------------------

function CAghanim:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:OnHeroSelectionStarted()
	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:ForceAssignHeroes()
	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		-- empty
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:OnGameStarted()
	end
end

---------------------------------------------------------

function CAghanim:OnHeroSelected( event )
	self:GetAnnouncer():OnHeroSelected( event.hero_unit )
end

---------------------------------------------------------

function CAghanim:OnGameStarted()
	--SendToServerConsole( "say SEED: " .. self.nSeed .. " ASC LEVEL: " .. self:GetAscensionLevel() )
end

---------------------------------------------------------

function CAghanim:OnGameFinished()
	self:AddResultToSignOut()

	print( "[ Aghanim Signing Out ]:" )
	PrintTable( self.SignOutTable, " " )

	GameRules:SetEventSignoutCustomTable( self.SignOutTable )
	GameRules:SetEventMetadataCustomTable( self.SignOutTable ) -- Same data used for both
end
 
---------------------------------------------------------

function CAghanim:AddResultToSignOut()
	
	self.SignOutTable["depth"] = self:GetCurrentRoom():GetDepth()
	self.SignOutTable["ascension_level"] = self:GetAscensionLevel()
	self.SignOutTable["won_game"] = self.bWonGame
	self.SignOutTable["seed"] = self.nSeed
	self.SignOutTable["event_window_start_time"] = GameRules:GetGameModeEntity():GetEventWindowStartTime()
	self.SignOutTable["tournament_mode"] = ( self.SignOutTable["event_window_start_time"] > 0 ) and ( GameRules:GetGameModeEntity():GetEventGameSeed() > 0 )


	if self.SignOutTable["event_window_start_time"] > 0 then
		printf("EVENT WINDOW START TIME: %d", self.SignOutTable["event_window_start_time"] )
	end

	-- we may want to subtract hero pick time or do something more complicated here
	local flGameTime = GameRules:GetGameTime()
	self.SignOutTable["game_time"] = flGameTime
	printf("GAME TIME: %f", flGameTime )
	
	local unScore = self:GetLeaderboardScore( self.SignOutTable )
	self.SignOutTable["score"] = unScore
	printf("GAME SCORE (lower is better): %d", unScore )

	-- only add leaderboard score message to signout if we're in an event window and have a custom seed
	if self.SignOutTable["event_window_start_time"] > 0 and GameRules:GetGameModeEntity():GetEventGameSeed() > 0 then
		local nData1 = 0
		local nData2 = 0
		local nData3 = 0
		local nData4 = 0
		local nData5 = 0
		local pszLeaderboardName = tostring( self.SignOutTable["event_window_start_time"] )
		GameRules:AddEventMetadataLeaderboardEntryRawScore( pszLeaderboardName, flGameTime, unScore, nData1, nData2, nData3, nData4, nData5 )
	end

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "steam_id" ] = PlayerResource:GetSteamID( nPlayerID )
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "hero_id" ] = PlayerResource:GetSelectedHeroID( nPlayerID )
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "current_ascension_level" ] = PlayerResource:GetEventGameCustomActionClaimCountByName( nPlayerID, "ti10_event_game_current_ascension_level" )
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "bp_remaining" ] = self:GetPointsCapRemaining( nPlayerID, true, false )
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "bp_total_cap" ] = self:GetPointsCapRemaining( nPlayerID, true, true )
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "fragments_remaining" ] = self:GetPointsCapRemaining( nPlayerID, false, false )
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "fragments_total_cap" ] = self:GetPointsCapRemaining( nPlayerID, false, true )
		end
	end
end

function CAghanim:GetLeaderboardScore( SignOutTable )
	
	-- if you won, treat it as one extra depth
	local nEffectiveDepth = SignOutTable["depth"]
	if self.bWonGame then
		nEffectiveDepth = nEffectiveDepth + 1
	end

	-- set a theoretical max depth of 30, just so we have some wiggle room if we change things
	-- it just means that a perfect score is still above zero
	local nMaxScoreDepth = 30
	local nMaxScoreTime = 1000000

	local flCompletionTime = SignOutTable["game_time"] 

	-- lower scores are better
	local nScore = (nMaxScoreDepth - nEffectiveDepth) * nMaxScoreTime + math.min( nMaxScoreTime, math.ceil(flCompletionTime*100) )

	return nScore
end

---------------------------------------------------------
-- player_connect_full
-- * player_id
---------------------------------------------------------

function CAghanim:CenterSpectatorOnPlayers( nSpectatorPlayerID )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:IsValidPlayerID( nPlayerID ) then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero ~= nil then
					--print( "CenterCameraOnUnit " .. nSpectatorPlayerID, hHero:GetUnitName() )
					CenterCameraOnUnit( nSpectatorPlayerID, hHero )
					return
				end
			end
		end
	end

end

---------------------------------------------------------
-- player_connect_full
-- * player_id
---------------------------------------------------------

function CAghanim:OnPlayerConnected( event )
end

---------------------------------------------------------

function CAghanim:OnPlayerTeamChanged( event )

	-- If we're a spectator, center the camera on one of the heores
	--print( "OnPlayerTeamChanged " .. event.player_id .. " " .. PlayerResource:GetTeam( event.player_id ) .. " " .. PlayerResource:GetLiveSpectatorTeam( event.player_id ) )
	if PlayerResource:GetTeam( event.player_id ) == TEAM_SPECTATOR or PlayerResource:GetLiveSpectatorTeam( event.player_id ) == DOTA_TEAM_GOODGUYS then
		self:CenterSpectatorOnPlayers( event.player_id )
	end

end


---------------------------------------------------------
-- dota_player_reconnected
-- * player_id
---------------------------------------------------------

function CAghanim:OnPlayerReconnected( event )

	--print( "OnPlayerReconnected " .. event.player_id .. " " .. PlayerResource:GetTeam( event.player_id ) .. " " .. PlayerResource:GetLiveSpectatorTeam( event.player_id ) )
	if PlayerResource:GetTeam( event.player_id ) == TEAM_SPECTATOR or PlayerResource:GetLiveSpectatorTeam( event.player_id ) == DOTA_TEAM_GOODGUYS then
		self:CenterSpectatorOnPlayers( event.player_id )
		return
	end

	local hPlayer = PlayerResource:GetPlayer( event.player_id )
	if hPlayer == nil then
		return
	end

	--If the player's hero is not in the current room, then teleport them to it
	local hHero = PlayerResource:GetSelectedHeroEntity( event.player_id )
	if hHero == nil then
		return
	end

	CenterCameraOnUnit( event.player_id, hHero )

end

---------------------------------------------------------
-- npc_spawned
-- * entindex
---------------------------------------------------------

function CAghanim:OnNPCSpawned( event )

	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit == nil then
		return
	end

	if spawnedUnit:IsRealHero() then
		self:OnNPCSpawned_PlayerHero( event )
		return
	end

	--print( " CAghanim:OnNPCSpawned " .. spawnedUnit:entindex() .. " " .. tostring( spawnedUnit:IsCreature() ) )
	if spawnedUnit:IsCreature() and spawnedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		self:OnNPCSpawned_EnemyCreature( event )
		return
	end 

	if spawnedUnit:IsSummoned() and spawnedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		self:OnNPCSpawned_AlliedSummon( event )
		return
	end 
end

--------------------------------------------------------------------------------

-- Evaluate the state of the game
function CAghanim:InitBlessings( hHero )

	if hHero == nil then 
		return
	end

	print ( "Init Blessings -- " .. hHero:GetUnitName() )

	local nPlayerID = hHero:GetPlayerOwnerID()
	for blessing_name,blessing_keys in pairs(BLESSING_MODIFIERS) do

		local nClaimCount = 0
		local nBlessingType = nil
		local szActionName = nil

		if blessing_keys.action_names ~= nil then
			for i = #blessing_keys.action_names,1,-1 do
				if PlayerResource:GetEventGameCustomActionClaimCountByName( nPlayerID, blessing_keys.action_names[i] ) > 0 then
					szActionName = blessing_keys.action_names[i]
					nClaimCount = i
					break
				end
			end
		else
			szActionName = blessing_keys.action_name
			nClaimCount = PlayerResource:GetEventGameCustomActionClaimCountByName( nPlayerID, szActionName )
			nBlessingType = blessing_keys.blessing_type

			-- Used to test blessings, even if they haven't claimed it
			local nTestClaimCount = BLESSING_MODIFIERS_FORCE_LIST[blessing_name]
			if nTestClaimCount ~= nil then
				print( 'Forcing blessing ' .. blessing_name )
				nClaimCount = nTestClaimCount
			end
		end

		if nClaimCount > 0 then
			local kv = 
			{
				blessing_level = nClaimCount
			}

			print( 'Player ' .. nPlayerID .. ' adding blessing ' .. blessing_name )

			if nBlessingType == nil or nBlessingType == BLESSING_TYPE_MODIFIER then
				--print( "Modifier Blessing added - " .. hHero:GetUnitName() .. " - " .. blessing_name )
				local hModifier = hHero:AddNewModifier( hHero, nil, blessing_name, kv )
				if hModifier.IsBlessing == nil then
					print( "Blessing " .. blessing_name .. " doesn't inherit from modifier_blessing_base!!" )
				end

			elseif nBlessingType == BLESSING_TYPE_ITEM_GRANT then
				--print( "Item Grant Blessing added - " .. hHero:GetUnitName() .. " - " .. blessing_name )

				for k,v in pairs( blessing_keys.keys.items ) do
					--print( 'Item Grant blessing - ' .. k )
					GrantItemDropToHero( hHero, k )
				end

			elseif nBlessingType == BLESSING_TYPE_GOLD_GRANT then
				--print( "Gold Grant Blessing added - " .. hHero:GetUnitName() .. " - " .. blessing_name )
				--print( "Adding gold " .. blessing_keys.keys.gold_amount )

				local nPlayerID = hHero:GetPlayerID()
				PlayerResource:ModifyGold( nPlayerID, blessing_keys.keys.gold_amount, true, DOTA_ModifyGold_Unspecified )

			elseif nBlessingType == BLESSING_TYPE_LIFE_GRANT then
				--print( "Life Grant Blessing added - " .. hHero:GetUnitName() .. " - " .. blessing_name )
				--print( "Adding lives " .. blessing_keys.keys.lives )

				hHero.nRespawnsRemaining = hHero.nRespawnsRemaining + blessing_keys.keys.lives

			else
				print( "ERROR - bad BLESSING_TYPE detected for action " .. blessing_keys.action_name )
				return
			end

			self:RegisterBlessingStat( nPlayerID, blessing_name, nClaimCount, szActionName, blessing_keys.scoreboard_order )
		end
	end

end

---------------------------------------------------------

function CAghanim:CenterAllSpectatorsOnHero( hPlayerHero )

	print( "CenterAllSpectatorsOnHero" )
	-- Center spectator cameras on the starting room
	for nPlayerID = 0, DOTA_MAX_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) == true then
			if PlayerResource:GetTeam( nPlayerID ) == TEAM_SPECTATOR or PlayerResource:GetLiveSpectatorTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				--print( "CenterAllSpectatorsOnHero " .. nPlayerID .. " " .. hPlayerHero:GetUnitName() )
				CenterCameraOnUnit( nPlayerID, hPlayerHero )
			end
		end
	end

end

---------------------------------------------------------

function CAghanim:OnNPCSpawned_PlayerHero( event )
	
	local hPlayerHero = EntIndexToHScript( event.entindex )
	if hPlayerHero == nil or hPlayerHero:IsRealHero() == false then
		return
	end

	--[[
	if hPlayerHero.bFirstSpawnComplete and hPlayerHero:IsRealHero() and hPlayerHero:IsTempestDouble() == false then
		FindClearSpaceForUnit( hPlayerHero, hPlayerHero.vDeathPos, true )
	end
	]]

	if hPlayerHero.bFirstSpawnComplete == nil then

		if self.bHasInitializedSpectatorCameras == false then
			self:CenterAllSpectatorsOnHero( hPlayerHero )
			self.bHasInitializedSpectatorCameras = true
		end

		hPlayerHero:SetStashEnabled( false )
		hPlayerHero:SetAbilityPoints( 0 )
		hPlayerHero.nRespawnsRemaining = AGHANIM_STARTING_LIVES
		hPlayerHero:SetRespawnsDisabled( false )

		local nPlayerID = hPlayerHero:GetPlayerOwnerID()
		if nPlayerID ~= -1 then
			PlayerResource:SetCustomBuybackCooldown( nPlayerID, 0 )
			PlayerResource:SetCustomBuybackCost( nPlayerID, 0 )
		end

		local hTP = hPlayerHero:GetItemInSlot( DOTA_ITEM_TP_SCROLL )
		if hTP then
			UTIL_Remove( hTP )
		end

		-- Add blessing modifiers
		self:InitBlessings( hPlayerHero )

		if AGHANIM_ENABLE_BOTTLE == true then
			local hBottle = GrantItemDropToHero( hPlayerHero, "item_bottle" )
			if hBottle ~= nil then
				local nMaxCharges = hBottle:GetSpecialValueFor( "max_charges" )
				hBottle:SetCurrentCharges( nMaxCharges )
			end
		else
			local hFlask = GrantItemDropToHero( hPlayerHero, "item_flask" )
			if hFlask ~= nil then
				hFlask:SetCurrentCharges( AGHANIM_STARTING_SALVES )
			end
			local hMango = GrantItemDropToHero( hPlayerHero, "item_enchanted_mango" )
			if hMango ~= nil then
				hMango:SetCurrentCharges( AGHANIM_STARTING_MANGOES )
			end
		end	

		-- blessings may give additional lives so make sure these net tables get set afterwards
		--printf("setting remaining respawns on %d to %d", hPlayerHero:entindex(), hPlayerHero.nRespawnsRemaining )
		CustomNetTables:SetTableValue( "revive_state", string.format( "%d", hPlayerHero:entindex() ), { tombstone = false } )
		CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ), { respawns = hPlayerHero.nRespawnsRemaining } )

		-- Add the battle royale modifier to all heroes
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_battle_royale", { } )

		hPlayerHero.MinorAbilityUpgrades = {}
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_minor_ability_upgrades", {} )

		-- Add and level up the base stats upgrade ability
		local hAbility = hPlayerHero:FindAbilityByName( "aghsfort_minor_stats_upgrade" )
		if hAbility == nil then
			hAbility = hPlayerHero:AddAbility("aghsfort_minor_stats_upgrade")
		 	hAbility:UpgradeAbility( true )
		 end

	else
		local fInvulnDuration = 3.0

		local hBlessing = hPlayerHero:FindModifierByName( "modifier_blessing_respawn_invulnerability" )
		if hBlessing ~= nil then
			--print( 'Player revived w/ respawn invulnerability blessing - adding ' .. hBlessing.respawn_invulnerability_time_bonus .. ' seconds to invuln time' )
			fInvulnDuration = fInvulnDuration + hBlessing.respawn_invulnerability_time_bonus

			--print( 'OnNPCSpawned_PlayerHero - blessing values, min_move_speed = ' .. hBlessing.min_move_speed .. '. bonus_attack_speed = ' .. hBlessing.bonus_attack_speed )

			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_respawn_haste", { duration = fInvulnDuration, min_move_speed = hBlessing.min_move_speed, bonus_attack_speed = hBlessing.bonus_attack_speed } )
		end

		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_invulnerable", { duration = fInvulnDuration } )
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_omninight_guardian_angel", { duration = fInvulnDuration } )
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_phased", { duration = fInvulnDuration }  )
		hPlayerHero.Tombstone = nil
	end

	hPlayerHero.bFirstSpawnComplete = true

	if self.bDataSent == nil then
		-- Send the special ability data for each hero
		--print ("sending special ability upgrade data")
		CustomNetTables:SetTableValue( "special_ability_upgrades", tostring( 0 ), SPECIAL_ABILITY_UPGRADES )
		self.bDataSent = true
	end
	
	self.bPlayerHasSpawned = true

end

---------------------------------------------------------

function CAghanim:OnNPCSpawned_EnemyCreature( event )
	local hEnemyCreature = EntIndexToHScript( event.entindex )
	if hEnemyCreature == nil then
		return
	end

	if hEnemyCreature:FindModifierByName( "modifier_breakable_container" ) then
		return
	end

	-- inform the encounter
	if self:GetCurrentRoom() == nil then
		return
	end

	local hEncounter = self:GetCurrentRoom():GetEncounter()
	if not hEncounter:IsComplete() then
		hEncounter:OnEnemyCreatureSpawned( hEnemyCreature )
	end
end

---------------------------------------------------------

function CAghanim:OnNPCSpawned_AlliedSummon( event )
	local hSummonedUnit = EntIndexToHScript( event.entindex )
	if hSummonedUnit == nil then
		return
	end

	local nPlayerID = hSummonedUnit:GetPlayerOwnerID()
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hPlayerHero ~= nil then
		hSummonedUnit:AddNewModifier( hPlayerHero, nil, "modifier_battle_royale", { } )
	end
end

---------------------------------------------------------
-- dota_on_hero_finish_spawn
-- * heroindex
-- * hero  		(string)
---------------------------------------------------------

--[[
function CAghanim:OnHeroFinishSpawn( event )
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero ~= nil and hPlayerHero:IsRealHero() then
		if hPlayerHero.bFirstSpawnComplete == nil then
			hPlayerHero.bEliminated = false
			hPlayerHero.bFirstSpawnComplete = true

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
			self.EventMetaData[nPlayerID]["level"] = 1
			self.EventMetaData[nPlayerID]["net_worth"] = 0

			table.insert( self.HeroesByTeam[hPlayerHero:GetTeamNumber()], hPlayerHero )
		end
	end
end
]]

---------------------------------------------------------
-- entity_killed
-- * entindex_killed
-- * entindex_attacker
-- * entindex_inflictor
-- * damagebits
---------------------------------------------------------

function CAghanim:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit ~= nil then
		if killedUnit:IsRealHero() and killedUnit:IsTempestDouble() == false then
			self:OnEntityKilled_PlayerHero( event )
			return
		end

		if killedUnit:IsCreature() then
			--self:OnEntityKilled_EnemyCreature( event )
			return
		end
	end
end

---------------------------------------------------------

function CAghanim:OnEntityKilled_PlayerHero( event )
	local killedHero = EntIndexToHScript( event.entindex_killed )
	local killerUnit = EntIndexToHScript( event.entindex_attacker )
	if killedHero == nil or killedHero:IsRealHero() == false then
		return
	end
		
	local szKillerUnit = nil

	if killerUnit then
		if killerUnit:IsCreature() then
			szKillerUnit = killerUnit:GetUnitName()

			local gameEvent = {}
			gameEvent["player_id"] = killedHero:GetPlayerID()
			gameEvent["locstring_value"] = killerUnit:GetUnitName()
			gameEvent["teamnumber"] = -1
			gameEvent["message"] = "#Aghanim_KilledByCreature"
			FireGameEvent( "dota_combat_event_message", gameEvent )

			--self:FireDeathTaunt( killerUnit )
		end
	end

	self:GetAnnouncer():OnHeroKilled( killedHero:GetUnitName(), szKillerUnit, killedHero.nRespawnsRemaining )

	local bDropTombstone = false--killedHero.nRespawnsRemaining > 0

	if bDropTombstone then	
		local newItem = CreateItem( "item_tombstone", killedHero , killedHero )
		newItem:SetPurchaseTime( 0 )
		newItem:SetPurchaser( killedHero )
		local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
		tombstone:SetContainedItem( newItem )
		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
		FindClearSpaceForUnit( tombstone, killedHero:GetAbsOrigin(), true )
		killedHero.Tombstone = tombstone
		killedHero.vDeathPos = killedHero:GetAbsOrigin()
	end

	killedHero:SetRespawnsDisabled( killedHero.nRespawnsRemaining == 0 )
	killedHero:SetRespawnPosition( killedHero:GetAbsOrigin() )
	if killedHero:GetRespawnsDisabled() == false then
		killedHero.nRespawnFX = ParticleManager:CreateParticle( "particles/items_fx/aegis_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, killedHero )
		ParticleManager:SetParticleControl( killedHero.nRespawnFX, 1, Vector( AGHANIM_TIMED_RESPAWN_TIME, 0, 0 ) )

		AddFOWViewer( killedHero:GetTeamNumber(), killedHero:GetAbsOrigin(), 800.0, AGHANIM_TIMED_RESPAWN_TIME, false )
	end

	killedHero.nRespawnsRemaining = math.max( 0, killedHero.nRespawnsRemaining - LIFE_REVIVE_COST )

	CustomGameEventManager:Send_ServerToPlayer( killedHero:GetPlayerOwner(), "life_lost", {} )
	CustomNetTables:SetTableValue( "revive_state", string.format( "%d", killedHero:entindex() ), { tombstone = bDropTombstone } )
	CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", killedHero:entindex() ),  { respawns = killedHero.nRespawnsRemaining } )

	local hPlayer = killedHero:GetPlayerOwner()
	if hPlayer ~= nil then
		if killedHero.nRespawnsRemaining < LIFE_BUYBACK_COST then
			PlayerResource:SetCustomBuybackCooldown( hPlayer:GetPlayerID(), 0 )
			PlayerResource:SetCustomBuybackCost( hPlayer:GetPlayerID(), 999999 )
		else
			PlayerResource:SetCustomBuybackCooldown( hPlayer:GetPlayerID(), 0 )
			PlayerResource:SetCustomBuybackCost( hPlayer:GetPlayerID(), 0 )
		end

		self:RegisterPlayerDeathStat( hPlayer:GetPlayerID(), self:GetCurrentRoom():GetDepth() )
	end

end

---------------------------------------------------------

---------------------------------------------------------
-- dota_holdout_revive_complete
-- * caster (reviver hero entity index)
-- * target (revivee hero entity index)
---------------------------------------------------------

function CAghanim:OnPlayerRevived( event )

	local hRevivedHero = EntIndexToHScript( event.target )
	local hReviverHero = EntIndexToHScript( event.caster )
	if hRevivedHero ~= nil and hRevivedHero:IsRealHero() then
		hRevivedHero:SetHealth( hRevivedHero:GetMaxHealth() * 0.01 * REVIVE_HEALTH_PCT )
		hRevivedHero:SetMana( hRevivedHero:GetMaxMana() * 0.01 * REVIVE_MANA_PCT )
		EmitSoundOn( "Dungeon.HeroRevived", hRevivedHero )

		if hReviverHero ~= nil and hReviverHero:IsRealHero() then
			--self.EventMetaData[hReviverHero:GetPlayerOwnerID()]["revives"] = self.EventMetaData[hReviverHero:GetPlayerOwnerID()]["revives"] + 1
		end

		--self:RemoveTombstoneVisionDummy( hRevivedHero )

		hRevivedHero.Tombstone = nil
		local fInvulnDuration = 3

		local hBlessing = hRevivedHero:FindModifierByName( "modifier_blessing_respawn_invulnerability" )
		if hBlessing ~= nil then
			--print( 'Player revived w/ respawn invulnerability blessing - adding ' .. hBlessing.respawn_invulnerability_time_bonus .. ' seconds to invuln time' )
			fInvulnDuration = fInvulnDuration + hBlessing.respawn_invulnerability_time_bonus

			--print( 'OnPlayerRevived - blessing values, min_move_speed = ' .. hBlessing.min_move_speed .. '. bonus_attack_speed = ' .. hBlessing.bonus_attack_speed )

			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_respawn_haste", { duration = fInvulnDuration, min_move_speed = hBlessing.min_move_speed, bonus_attack_speed = hBlessing.bonus_attack_speed } )
		end

		hRevivedHero:AddNewModifier( hRevivedHero, nil, "modifier_invulnerable", { duration = fInvulnDuration } )
		hRevivedHero:AddNewModifier( hRevivedHero, nil, "modifier_omninight_guardian_angel", { duration = fInvulnDuration } )
		hRevivedHero:AddNewModifier( hRevivedHero, nil, "modifier_phased", { duration = fInvulnDuration }  )
		if hRevivedHero.nRespawnFX ~= nil then
			ParticleManager:DestroyParticle( hRevivedHero.nRespawnFX, false )
			hRevivedHero.nRespawnFX = nil
		end
		hRevivedHero:RemoveModifierByName( "modifier_hide_on_minimap" )
	end
end

---------------------------------------------------------
-- dota_buyback
-- * entindex
-- * player_id
---------------------------------------------------------

function CAghanim:OnPlayerBuyback( event )

	local hPlayer = PlayerResource:GetPlayer( event.player_id )
	if hPlayer == nil then
		return
	end

	local hHero = hPlayer:GetAssignedHero()
	if hHero == nil then
		return
	end

	hHero.nRespawnsRemaining = math.max( hHero.nRespawnsRemaining - LIFE_BUYBACK_COST, 0 )
	hHero:SetRespawnsDisabled( hHero.nRespawnsRemaining == 0 )
	CustomNetTables:SetTableValue( "revive_state", string.format( "%d", hHero:entindex() ), { tombstone = false } )
	CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hHero:entindex() ), { respawns = hHero.nRespawnsRemaining } )

	if hHero.vDeathPos ~= nil then	
		FindClearSpaceForUnit( hHero, hHero.vDeathPos, true )
	end

	hHero.Tombstone = nil
	hHero:AddNewModifier( hHero, nil, "modifier_invulnerable", { duration = 2.5 } )
	hHero:AddNewModifier( hHero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )

end

---------------------------------------------------------
-- dota_player_gained_level
-- * player (player entity index)
-- * level (new level)
---------------------------------------------------------

function CAghanim:OnPlayerGainedLevel( event )
	-- empty
end

---------------------------------------------------------
-- dota_item-spawned
-- * player_id
-- * item_ent_index
---------------------------------------------------------

function CAghanim:OnItemSpawned( event )
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

function CAghanim:OnItemPickedUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )

	local hero = nil
	if event.HeroEntityIndex then
		hero = EntIndexToHScript( event.HeroEntityIndex )
	end

	if item and hero and item:GetAbilityName() ~= "item_tombstone" then
		item:SetPurchaser( hero )
	end

	if event.PlayerID ~= nil and item ~= nil and item:GetAbilityName() == "item_bag_of_gold" then
		self:RegisterGoldBagCollectedStat( event.PlayerID )
	end
end

---------------------------------------------------------
-- dota_item_purchased
-- * PlayerID
-- * itemname
-- * itemcost
---------------------------------------------------------

function CAghanim:OnItemPurchased( event )
	local szHeroName = null
	if PlayerResource:IsValidPlayerID( event.PlayerID ) then
		local nHeroID = PlayerResource:GetSelectedHeroID( event.PlayerID )
		szHeroName = DOTAGameManager:GetHeroUnitNameByID( nHeroID )
	end

	self:GetAnnouncer():OnItemPurchased( szHeroName, event.itemname )
end

--------------------------------------------------------------------------------

function CAghanim:OnTreasureOpen( hPlayerHero, hTreasureEnt )
	--printf( "OnTreasureOpen()" )

	self:ChooseTreasureSurprise( hPlayerHero, hTreasureEnt )
end

--------------------------------------------------------------------------------
-- dota_hero_entered_shop
-- > shop_type - short
-- > shop_entindex - int
-- > hero_entindex- int

--------------------------------------------------------------------------------

function CAghanim:OnHeroEnteredShop( event )
	local hHero = EntIndexToHScript( event.hero_entindex )
	local hShop = EntIndexToHScript( event.shop_entindex )
	if hHero and hShop then
		local szLine = nil
		local MeepoLines =
		{
			"meepo_meepo_levelup_01",
			"meepo_meepo_move_19",
			"meepo_meepo_spawn_04",
			"meepo_meepo_begin_01",
			"meepo_meepo_divided_25",
			"meepo_meepo_respawn_05",
			"meepo_meepo_respawn_08",
			"meepo_meepo_rare_03",
			"meepo_meepo_rare_04",
			"meepo_meepo_win_04",
		}

		local BBLines =
		{
			"bristleback_bristle_cast_02",
			"bristleback_bristle_nasal_goo_02",
			"bristleback_bristle_kill_09",
			"bristleback_bristle_lasthit_02",
			"bristleback_bristle_lasthit_05",
			"bristleback_bristle_lasthit_13",
			"bristleback_bristle_levelup_01",
			"bristleback_bristle_purch_02",
			"bristleback_bristle_win_04",
			"bristleback_bristle_ally_08",
		}

		if hShop:GetShopType() ~= DOTA_SHOP_CUSTOM then		
			szLine = MeepoLines[ RandomInt( 1, #MeepoLines ) ]			
		else
			szLine = BBLines[ RandomInt( 1, #BBLines ) ]

			if hHero:GetUnitName() == "npc_dota_hero_tusk" and RandomInt( 0, 2 ) == 0 then
				szLine = "bristleback_bristle_ally_09"
			end
		end

		EmitSoundOnLocationForPlayer( szLine, hShop:GetAbsOrigin(), hHero:GetPlayerOwnerID() )
	end
end

--------------------------------------------------------------------------------
-- trigger_start_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short

--------------------------------------------------------------------------------

function CAghanim:OnTriggerStartTouch( event )

	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local hTriggerSpawnGroup = hTriggerEntity:GetSpawnGroupHandle()
	if hUnit ~= nil then
		local i, j = string.find( event.trigger_name, "room_activate" )
		if i ~= nil then
			-- Figure out if we've triggered a room trigger for the first time
			if hTriggerEntity.bHasBeenTriggered == nil then
				hTriggerEntity.bHasBeenTriggered = true
				local room = self:FindRoomBySpawnGroupHandle( hTriggerSpawnGroup )
				if room ~= nil then
					self:OnRoomTriggerInitialTouch( hUnit, hTriggerEntity, room:GetName() )
				else
					print( "Unable to find room associated with spawn group " .. hTriggerSpawnGroup )
				end
			end
		end
	end

end

--------------------------------------------------------------------------------
-- trigger_end_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short

--------------------------------------------------------------------------------

function CAghanim:OnTriggerEndTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	if hUnit ~= nil then
		-- empty
	end
end

--------------------------------------------------------------------------------

function CAghanim:OnRoomTriggerInitialTouch( hUnit, hTriggerEntity, szRoomName )
	--print( string.format( "OnRoomTriggerInitialTouch - szRoomName: %s", szRoomName ) )

	self:ActivateRoom( szRoomName )
end

--------------------------------------------------------------------------------

function CAghanim:ActivateRoom( szRoomName )
	local room = self:GetRoom( szRoomName )
	self:SetCurrentRoom( room )	
	room:Activate()
end

--------------------------------------------------------------------------------

---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------

--[[
function CAghanim:OnNonPlayerUsedAbility( event )
	local szAbilityName = event.abilityname
	local hCaster = EntIndexToHScript( event.caster_entindex )
end
]]

---------------------------------------------------------
