print( "Holdout addon is booting up..." )

--------------------------------------------------------------------------------

if CHoldout == nil then
	CHoldout = class({})
	_G.CHoldout = CHoldout
end

--------------------------------------------------------------------------------

require( "constants" ) -- require this first
require( "events" )
require( "filters" )
require( "precache" )
require( "utility_functions" )

require( "holdout_game_round" )
require( "holdout_game_spawner" )
require( "holdout_game_logging" )
require( "holdout_game_ui" )
require( "holdout_game_awards" )

--------------------------------------------------------------------------------

-- Precache resources, this hook happens before most things
function Precache( context )
	InitialPrecache( context )
end

--------------------------------------------------------------------------------

-- Actually make the game mode when we activate
function Activate()
	GameRules.holdOut = CHoldout()
	GameRules.holdOut:InitGameMode()
	LinkModifiers()
end

--------------------------------------------------------------------------------

function LinkModifiers()
	LinkLuaModifier( "modifier_wind", "modifiers/modifier_wind", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_wind_thinker", "modifiers/modifier_wind_thinker", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_provides_fow_position", "modifiers/modifier_provides_fow_position", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_penguin_herder_movement", "modifiers/modifier_penguin_herder_movement", LUA_MODIFIER_MOTION_HORIZONTAL )
end

--------------------------------------------------------------------------------

function CHoldout:InitGameMode()
	self._nRoundNumber = 1
	self._currentRound = nil
	self._flLastThinkGameTime = nil
	self._votes = {}
	self._flEndTime = nil
	self._nGameEndState = NOT_ENDED
	self._nRestartVoteYes = 0
	self._nRestartVoteNo = 0
	self._flGameOverAnimationTimer = 0
	self._bQuit = false
	self._bDisplayingGameEnd = false
	self._flVoteDuration = 1.0 -- we don't use voting right now
	self._bBossHasSpawned = false
	self._bBossHasDied = false
	self._hRubick = nil
	self._szDevHero = nil

	if self._nAccumulatedPoints == nil then
		self._nAccumulatedPoints = 0
	end

	self._hAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	if not self._hAncient then
		print( "Ancient entity not found!" )
	else
		self._hAncient:AddAbility( "ability_ancient_buddha" ) -- the ancient nevar dies!
		local buddhaAbility = self._hAncient:FindAbilityByName( "ability_ancient_buddha" )
		if buddhaAbility then
			buddhaAbility:SetLevel( 1 )
		end
	end

	self._vKillsWithoutDying = {}
	self._wonAwards = {}
	self._lastStreak = {}
	self._killsInWindow = {}
	self._killWindowExpireTime = {}
	self._lastMultiKill = {}

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		PlayerResource:SetCustomTeamAssignment( nPlayerID, DOTA_TEAM_GOODGUYS )
		self._vKillsWithoutDying[ nPlayerID ] = 0
		self._wonAwards[ nPlayerID ] = {}
		self._lastStreak[ nPlayerID ] = 0
		self._killsInWindow[ nPlayerID ] = 0
		self._killWindowExpireTime[ nPlayerID ] = 0
		self._lastMultiKill[ nPlayerID ] = 0 
	end

	GameRules:SetCustomGameSetupTimeout( 0 ) 
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
		
	GameRules:SetHeroRespawnEnabled( false )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroSelectionTime( 30.0 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetPostGameTime( 45.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetHeroMinimapIconScale( 0.7 )
	GameRules:SetCreepMinimapIconScale( 0.7 )
	GameRules:SetRuneMinimapIconScale( 0.7 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
 	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
 	GameRules:SetFirstBloodActive( false )

	-- keep these in sync with frostivus_2018.eventdef
	self._periodic_points_scale_normal_event_points = 8
	self._periodic_points_bonus_normal_event_points = 1000

	-- parse dev mode starting flags
	self._bDevMode = (GameRules:GetGameSessionConfigValue("DevMode", "false") == "true")
	self._bDevNoRounds = (GameRules:GetGameSessionConfigValue("DevNoRounds", "false") == "true")
	self._nDevRoundNumber = tonumber(GameRules:GetGameSessionConfigValue("DevRoundNumber", nil))
	--local nDevRoundNumber = GameRules:GetGameSessionConfigValue("DevRoundNumber", "nil")
	--if nDevRoundNumber ~= "nil" then
	--	self._nDevRoundNumber = tonumber(nDevRoundNumber)
	--end
	self._nDevRoundDelay = tonumber(GameRules:GetGameSessionConfigValue("DevRoundDelay", "5"))
	self._szDevHero = GameRules:GetGameSessionConfigValue("DevHero", nil)
	
	if self._bDevMode then
		GameRules:SetPreGameTime( 5.0 )
	end

	self:_ReadGameConfiguration()

	self._hEventGameDetails = GetLobbyEventGameDetails()

	if self._hEventGameDetails then
		printf("EventGameDetails table")
	    DeepPrintTable(self._hEventGameDetails)
	end

	-- Custom console commands
	Convars:RegisterCommand( "holdout_test_round", function(...) return self:_TestRoundConsoleCommand( ... ) end, "Test a round of holdout.", FCVAR_CHEAT )
	Convars:RegisterCommand( "holdout_spawn_gold", function(...) return self._GoldDropConsoleCommand( ... ) end, "Spawn a gold bag.", FCVAR_CHEAT )
	Convars:RegisterCommand( "holdout_status_report", function(...) return self:_StatusReportConsoleCommand( ... ) end, "Report the status of the current holdout game.", FCVAR_CHEAT )
	Convars:RegisterCommand( "holdout_kill_all_enemies", function(...) return self:_KillAllEnemiesConsoleCommand( ... ) end, "Kill all currently spawned enemies on the map.", FCVAR_CHEAT )
	
	CustomGameEventManager:RegisterListener( "cheat_to_round", function(...) return self:_ProcessCheatToRound( ... ) end )

	for _, tower in pairs( Entities:FindAllByName( "npc_dota_holdout_tower_spawn_protection" ) ) do
		tower:AddNewModifier( tower, nil, "modifier_invulnerable", {} )
	end

	for _, shrine in pairs( Entities:FindAllByClassname( "npc_dota_healer" ) ) do
		--print( "Setting respawn flag on shrine" )
		shrine:SetUnitCanRespawn( true )
		shrine:RemoveModifierByName( "modifier_invulnerable" )
	end

	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CHoldout, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CHoldout, "OnEntityKilled" ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CHoldout, "OnGameRulesStateChange" ), self )
	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( CHoldout, "OnNonPlayerUsedAbility" ), self )
	ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( CHoldout, "OnPlayerUsedAbility" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CHoldout, "OnItemPickedUp" ), self )
	GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap( CHoldout, "ModifierGainedFilter" ), self )
	--ListenToGameEvent( "player_reconnected", Dynamic_Wrap( CHoldout, "OnPlayerReconnected" ), self )

	CustomGameEventManager:RegisterListener( "vote_button_clicked", function(...) return self:_ProcessVoteButtonClick( ... ) end )

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 ) 
end

--------------------------------------------------------------------------------

-- Read and assign configurable keyvalues if applicable
function CHoldout:_ReadGameConfiguration()
	local kv = LoadKeyValues( "scripts/maps/" .. GetMapName() .. ".txt" )
	kv = kv or {} -- Handle the case where there is not keyvalues file

	self._bRestoreHPAfterRound = kv.RestoreHPAfterRound or false
	self._bRestoreMPAfterRound = kv.RestoreMPAfterRound or false
	self._bRewardForTowersStanding = kv.RewardForTowersStanding or false

	self._nTowerRewardAmount = tonumber( kv.TowerRewardAmount or 0 )
	self._nTowerScalingRewardPerRound = tonumber( kv.TowerScalingRewardPerRound or 0 )

	self._flPrepTimeBetweenRounds = tonumber( kv.PrepTimeBetweenRounds or 0 )
	self._flItemExpireTime = tonumber( kv.ItemExpireTime or 10.0 )

	if self._bDevMode then
		self._flPrepTimeBetweenRounds = self._nDevRoundDelay
	end

	self:_ReadRandomSpawnsConfiguration( kv["RandomSpawns"] )
	self:_ReadRandomSneakySpawnsConfiguration( kv["RandomSneakySpawns"] )
	self:_ReadLootItemDropsConfiguration( kv["ItemDrops"] )
	self:_ReadGiftItemDropsConfiguration( kv["GiftItemDrops"] )
	self:_ReadRoundConfigurations( kv )
end

--------------------------------------------------------------------------------

-- Verify spawners if random is set
function CHoldout:ChooseRandomSpawnInfo()
	if #self._vRandomSpawnsList == 0 then
		error( "Attempt to choose a random spawn, but no random spawns are specified in the data." )
		return nil
	end

	return self._vRandomSpawnsList[ RandomInt( 1, #self._vRandomSpawnsList ) ]
end

--------------------------------------------------------------------------------

function CHoldout:ChooseRandomSneakySpawnInfo()
	if #self._vRandomSneakySpawnsList == 0 then
		error( "Attempt to choose a random sneaky spawn, but no random sneaky spawns are specified in the data." )
		return nil
	end

	return self._vRandomSneakySpawnsList[ RandomInt( 1, #self._vRandomSneakySpawnsList ) ]
end

--------------------------------------------------------------------------------

-- Verify valid spawns are defined and build a table with them from the keyvalues file
function CHoldout:_ReadRandomSpawnsConfiguration( kvSpawns )
	self._vRandomSpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end

	for _, sp in pairs( kvSpawns ) do
		table.insert( self._vRandomSpawnsList, {
			szSpawnerName = sp.SpawnerName or "",
			szFirstWaypoint = sp.Waypoint or ""
		} )
	end
end

--------------------------------------------------------------------------------

function CHoldout:_ReadRandomSneakySpawnsConfiguration( kvSpawns )
	self._vRandomSneakySpawnsList = {}
	if type( kvSpawns ) ~= "table" then
		return
	end

	for _, sp in pairs( kvSpawns ) do
		table.insert( self._vRandomSneakySpawnsList, {
			szSpawnerName = sp.SpawnerName or "",
			szFirstWaypoint = sp.Waypoint or ""
		} )
	end
end

--------------------------------------------------------------------------------

-- If random drops are defined read in that data
function CHoldout:_ReadLootItemDropsConfiguration( kvLootDrops )
	self._vLootItemDropsList = {}
	if type( kvLootDrops ) ~= "table" then
		return
	end

	for _,lootItem in pairs( kvLootDrops ) do
		table.insert( self._vLootItemDropsList, {
			szItemName = lootItem.Item or "",
			nChance = tonumber( lootItem.Chance or 0 )
		})
	end
end

--------------------------------------------------------------------------------

function CHoldout:_ReadGiftItemDropsConfiguration( kvGiftDrops )
	self._vGiftItemDropsList = {}
	if type( kvGiftDrops ) ~= "table" then
		return
	end

	for _, giftItem in pairs( kvGiftDrops ) do
		table.insert( self._vGiftItemDropsList, {
			szItemName = giftItem.Item or "",
			nChance = tonumber( giftItem.Chance or 0 )
		})
	end
end

--------------------------------------------------------------------------------

-- Set number of rounds without requiring index in text file
function CHoldout:_ReadRoundConfigurations( kv )
	self._vRounds = {}
	while true do
		local szRoundName = string.format("Round%d", #self._vRounds + 1 )
		local kvRoundData = kv[ szRoundName ]
		if kvRoundData == nil then
			return
		end
		local roundObj = CHoldoutGameRound()
		roundObj:ReadConfiguration( kvRoundData, self, #self._vRounds + 1 )
		table.insert( self._vRounds, roundObj )
	end
end

--------------------------------------------------------------------------------------------------------

function CHoldout:ForceAssignHeroes()
	print( "ForceAssignHeroes()" )
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				if self._bDevMode and self._szDevHero ~= nil then
					printf("Setting selected hero to %s", self._szDevHero)
					hPlayer:SetSelectedHero( self._szDevHero )
				else
					print( "  Hero selection time is over: forcing nPlayerID " .. nPlayerID .. " to random a hero." )
					hPlayer:MakeRandomHeroSelection()
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------

-- Evaluate the state of the game
function CHoldout:OnThink()
	self:_SendRoundDataToClient()

	if GameRules:IsDaytime() == false then
		-- do this here because it doesn't work in Init
		GameRules:SetTimeOfDay( 0.251 )
	end

	if not self.bFortCached then
		for _, hFort in pairs( Entities:FindAllByClassname( "npc_dota_fort" ) ) do
			if hFort then
				self.hFort = hFort
				self.bFortCached = true
				break
			end
		end
	end

	if not self.bTowerFortificationAdded then
		local buildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
		for _, building in ipairs( buildings ) do
			if building:IsTower() then
				if not building:HasAbility( "tower_fortification" ) then building:AddAbility( "tower_fortification" ) end
				local fortificationAbility = building:FindAbilityByName( "tower_fortification" )
				if fortificationAbility then
					fortificationAbility:SetLevel( self._nRoundNumber / 2 )
				end
			end
		end

		self.bTowerFortificationAdded = true
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:_CheckForDefeat()
		self:_ThinkLootExpiry()

		if self._bDevMode and self._bDevNoRounds then
			return 1
		end

		if self._flPrepTimeEnd ~= nil then
			self:_ThinkPrepTime()
		elseif self._currentRound ~= nil then
			self._currentRound:Think()
			if self._currentRound:IsFinished() then
				self:_RoundFinished()
			end
			self:_ProcessThinkers()
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end

	return 1
end

--------------------------------------------------------------------------------
function CHoldout:_ProcessThinkers()

	if self._nRoundNumber == 13 and self.hWindThinker == nil then
		-- disabling the wind effect for now
   		--self.hWindThinker = CreateModifierThinker( nil, nil, "modifier_wind_thinker", {}, Vector(0,0,0), DOTA_TEAM_GOODGUYS, false )
		--printf( "Creating Wind_Thinker %s", self.hWindThinker )
	elseif self._nRoundNumber ~= 13 and self.hWindThinker then
		print( "Removing Wind_Thinker" )
		UTIL_Remove( self.hWindThinker )
		self.hWindThinker = nil
		GameRules:SetWeatherWindDirection( Vector(0,0,0) )
	end
end

--------------------------------------------------------------------------------

function CHoldout:_RoundFinished()
	self:_AwardPoints()
	self._currentRound:End( true )

	self._currentRound = nil

	-- Heal all players
	self:_RefreshPlayers()

	-- Heal ancient
	self._hAncient:SetHealth( self._hAncient:GetMaxHealth() )
	--self._hAncient:SetInvulnCount( self.nAncientInvulnerabilityCount )

	-- Respawn all buildings
	self:_RespawnBuildings()


	self._nRoundNumber = self._nRoundNumber + 1
	if self._nRoundNumber > #self._vRounds or self:HasBossDied() then
		if self._nGameEndState == NOT_ENDED then
			self:_Victory()
		end
	else
		self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
	end
end

--------------------------------------------------------------------------------

function CHoldout:_RefreshPlayers()
	for nPlayerID = 0, 5 -1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if not hero:IsAlive() then
					local vLocation = hero:GetOrigin()
					hero:RespawnHero( false, false )
					FindClearSpaceForUnit( hero, vLocation, true )
				end
				hero:SetHealth( hero:GetMaxHealth() )
				hero:SetMana( hero:GetMaxMana() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:_RespawnBuildings()
	-- Respawn all the towers.
	self:_PhaseAllUnits( true )
	local buildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false )
	for _,building in ipairs( buildings ) do
		if building:IsTower() then
			local sModelName = "models/props_structures/tower_good.vmdl"
			building:SetOriginalModel( sModelName )
			building:SetModel( sModelName )
			local vOrigin = building:GetOrigin()
			if building:IsAlive() then
				building:Heal( building:GetMaxHealth(), building )
			else
				building:RespawnUnit()
				building:SetPhysicalArmorBaseValue( TOWER_ARMOR ) -- using this hack because RespawnUnit wipes our armor and I don't want to fix RespawnUnit right now
			end
			building:SetOrigin( vOrigin )

			if not building:HasAbility( "tower_fortification" ) then building:AddAbility( "tower_fortification" ) end
			local fortificationAbility = building:FindAbilityByName( "tower_fortification" )
			if fortificationAbility then
				fortificationAbility:SetLevel( self._nRoundNumber / 2 )
			end

			building:RemoveModifierByName( "modifier_invulnerable" )
		end

		if building:IsShrine() then
			local sModelName = "models/props_structures/radiant_statue001.vmdl"
			building:SetOriginalModel( sModelName )
			building:SetModel( sModelName )

			local hHealAbility = building:FindAbilityByName( "filler_ability" )
		
			local vOrigin = building:GetOrigin()
			if building:IsAlive() then
				building:Heal( building:GetMaxHealth(), building )
			else
				building:RespawnUnit()
				building:SetPhysicalArmorBaseValue( SHRINE_ARMOR ) -- using this hack because RespawnUnit wipes our armor and I don't want to fix RespawnUnit right now
				if hHealAbility ~= nil then
					hHealAbility:StartCooldown( hHealAbility:GetCooldown( hHealAbility:GetLevel() ) )
				end
			end
			building:SetOrigin( vOrigin )

			building:RemoveModifierByName( "modifier_invulnerable" )
		end
	end
	self:_PhaseAllUnits( false )
end

--------------------------------------------------------------------------------

function CHoldout:_PhaseAllUnits( bPhase )
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, 0, FIND_ANY_ORDER, false )
	for _,unit in ipairs(units) do
		if bPhase then
			unit:AddNewModifier( units[i], nil, "modifier_phased", {} )
		else
			unit:RemoveModifierByName( "modifier_phased" )
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:_CheckForDefeat()
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return
	end

	local bAllPlayersDead = true
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if not PlayerResource:HasSelectedHero( nPlayerID ) then
				bAllPlayersDead = false
			else
				local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hero and hero:IsAlive() then
					bAllPlayersDead = false
				end
			end
		end
	end

	if bAllPlayersDead or not self._hAncient or self._hAncient:GetHealth() <= 1 then
		if self._nGameEndState == NOT_ENDED then
			if self._hAncient then
				self._hAncient:ForceKill( false )
			end
			self:_Defeated()
		end
		return
	end
end

--------------------------------------------------------------------------------

function CHoldout:_ThinkPrepTime()
	if GameRules:GetGameTime() >= self._flPrepTimeEnd then
		self._flPrepTimeEnd = nil

		if self._nRoundNumber > #self._vRounds then
			GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
			return false
		end

		self._currentRound = self._vRounds[ self._nRoundNumber ]
		self._currentRound:Begin()
		self:_NotifyClientOfRoundStart()
		return
	end

	self._vRounds[ self._nRoundNumber ]:Precache()
end

--------------------------------------------------------------------------------

function CHoldout:_ThinkLootExpiry()
	if self._flItemExpireTime <= 0.0 then
		return
	end

	local flCutoffTime = GameRules:GetGameTime() - self._flItemExpireTime
	local bExpire = ( self._nRoundNumber ~= 5 )

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if ( containedItem ~= nil and containedItem:IsNull() == false and ( containedItem:GetAbilityName() == "item_bag_of_gold" or item.Holdout_IsLootDrop ) ) and bExpire then
			self:_ProcessItemForLootExpiry( item, flCutoffTime )
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:_ProcessItemForLootExpiry( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	if item:GetCreationTime() >= flCutoffTime then
		return true
	end

	local containedItem = item:GetContainedItem()
	if containedItem and containedItem:GetAbilityName() == "item_bag_of_gold" then
		if self._currentRound and self._currentRound.OnGoldBagExpired then
			self._currentRound:OnGoldBagExpired()
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local inventoryItem = item:GetContainedItem()
	if inventoryItem then
		UTIL_RemoveImmediate( inventoryItem )
	end
	UTIL_RemoveImmediate( item )
	return false
end

--------------------------------------------------------------------------------

function CHoldout:GetDifficultyString()
	local nDifficulty = GameRules:GetCustomGameDifficulty()
	if nDifficulty > 4 then
		return string.format( "(+%d)", nDifficulty )
	elseif nDifficulty > 0 then
		return string.rep( "+", nDifficulty )
	else
		return ""
	end
end

--------------------------------------------------------------------------------

function CHoldout:CheckForLootItemDrop( killedUnit )
	for _,itemDropInfo in pairs( self._vLootItemDropsList ) do
		if RollPercentage( itemDropInfo.nChance ) then
			local newItem = CreateItem( itemDropInfo.szItemName, nil, nil )
			newItem:SetPurchaseTime( 0 )
			if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
				item:SetStacksWithOtherOwners( true )
			end
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
			drop.Holdout_IsLootDrop = true
			if itemDropInfo.szItemName ~= "item_tpscroll" then
				local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
				newItem:LaunchLoot( true, 300, 0.75, dropTarget )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:ComputeTowerBonusGold( nTowersTotal, nTowersStanding )
	local nRewardPerTower = self._nTowerRewardAmount + self._nTowerScalingRewardPerRound * ( self._nRoundNumber - 1 )
	return nRewardPerTower * nTowersStanding
end

--------------------------------------------------------------------------------

-- Custom game specific console command "holdout_test_round"
function CHoldout:_TestRoundConsoleCommand( cmdName, roundNumber, delay )
	local nRoundToTest = tonumber( roundNumber )
	if nRoundToTest == nil then
		print( "_TestRoundConsoleCommand - No valid round number provided!" )
		return
	end

	print( string.format( "Testing round %d", nRoundToTest ) )
	if nRoundToTest <= 0 or nRoundToTest > #self._vRounds then
		Msg( string.format( "Cannot test invalid round %d", nRoundToTest ) )
		return
	end

	
	if self._currentRound ~= nil then
		self:_RoundFinished()
		--self._currentRound:End()
		self._currentRound = nil
	end

	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			local nGold = self:GetTestRoundGoldToAward( nPlayerID, nRoundToTest )
			local nXP = self:GetTestRoundXPToAward( nPlayerID, nRoundToTest )
			local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			PlayerResource:ReplaceHeroWith( nPlayerID, PlayerResource:GetSelectedHeroName( nPlayerID ), nGold, nXP )
			if Hero ~= nil and Hero:IsNull() == false then
				UTIL_Remove( Hero )
			end
			PlayerResource:SetBuybackCooldownTime( nPlayerID, 0 )
			PlayerResource:SetBuybackGoldLimitTime( nPlayerID, 0 )
			PlayerResource:ResetBuybackCostTime( nPlayerID )
			self:SetCorrectAbilityPointsCount( nPlayerID )
		end
	end

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if containedItem then
			UTIL_RemoveImmediate( containedItem )
		end
		UTIL_RemoveImmediate( item )
	end

	self._flPrepTimeEnd = GameRules:GetGameTime() + self._flPrepTimeBetweenRounds
	self._nRoundNumber = nRoundToTest
	if delay ~= nil then
		delay = min(1, tonumber(delay) )
		self._flPrepTimeEnd = GameRules:GetGameTime() + delay
	end
end

function CHoldout:_ProcessCheatToRound( eventSourceIndex, args )
	if not SteamInfo:IsPublicUniverse() then
		local nRoundNumber = args[ "round_number" ]
		self:_TestRoundConsoleCommand( nil, nRoundNumber, nil )
	end
end


-- Custom game specific console command "holdout_kill_all_enemies"
function CHoldout:_KillAllEnemiesConsoleCommand( cmdName )
	if IsServer() then
		for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )) do
			if not unit:IsTower() then
				--UTIL_RemoveImmediate( unit )
				unit:Kill(nil,nil)
				--unit:Destroy()
			end
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:GetTestRoundGoldToAward( nPlayerID, nRoundToTest )
	if IsServer() then
		local nExpectedGold = ROUND_EXPECTED_VALUES_TABLE[ math.min(nRoundToTest,#ROUND_EXPECTED_VALUES_TABLE) ].gold or STARTING_GOLD
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		local nGold = nExpectedGold - self:GetHeroNetWorth( hHero )

		--print( string.format( "  nExpectedGold == %d", nExpectedGold ) )
		--print( string.format( "  player's hero's net worth: %d", self:GetHeroNetWorth( hHero ) ) )
		--print( string.format( "  nGold == %d", nGold ) )

		if nGold < 0 then
			nGold = 0
		end

		--print( string.format( "Awarding %d gold to player id %d", nGold, nPlayerID ) )

		return nGold
	end
end

--------------------------------------------------------------------------------

function CHoldout:GetHeroNetWorth( hHero )
	if IsServer() then
		if hHero == nil or hHero:IsNull() then
			print( "WARNING - GetHeroNetWorth: hHero doesn't exist" )
			return 0
		end

		local nNetWorthTotal = 0

		for slot = 0, DOTA_ITEM_SLOT_9 do
			local hItem = hHero:GetItemInSlot( slot )
			if hItem ~= nil and hItem:GetAbilityName() ~= "item_tpscroll" then
				nNetWorthTotal = nNetWorthTotal + hItem:GetCost()
			end
		end

		return nNetWorthTotal
	end
end

--------------------------------------------------------------------------------

function CHoldout:GetTestRoundXPToAward( nPlayerID, nRoundToTest )
	if IsServer() then
		local nExpectedXP = ROUND_EXPECTED_VALUES_TABLE[ math.min(nRoundToTest,#ROUND_EXPECTED_VALUES_TABLE) ].xp or 0
		local nXP = nExpectedXP

		--print( string.format( "  nExpectedXP == %d", nExpectedXP ) )
		--print( string.format( "  nXP == %d", nXP ) )

		if nXP < 0 then
			nXP = 0
		end

		--print( string.format( "Awarding %d xp to player id %d", nXP, nPlayerID ) )

		return nXP
	end
end

--------------------------------------------------------------------------------

function CHoldout:SetCorrectAbilityPointsCount( nPlayerID )
	if IsServer() then
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero == nil or hPlayerHero:IsNull() then
			print( "WARNING - GetHeroNetWorth: hPlayerHero doesn't exist" )
			return
		end

		if hPlayerHero:IsRealHero() == false then
			print( string.format( "WARNING - GetHeroNetWorth: hPlayerHero (\"%s\") is not a real hero", hPlayerHero:GetUnitName() ) )
			return
		end

		local nSpentPoints = 0

		for i = 0, DOTA_MAX_ABILITIES - 1 do
			local hAbility = hPlayerHero:GetAbilityByIndex( i )
			if hAbility and not hAbility:IsHidden() and hAbility:CanAbilityBeUpgraded() ~= ABILITY_NOT_LEARNABLE and self:IsValidAbility( hAbility ) then
				--print( string.format( "%s - increasing nSpentPoints by %d points", hAbility:GetAbilityName(), hAbility:GetLevel() ) )
				nSpentPoints = nSpentPoints + hAbility:GetLevel()
			end
		end

		local nPointsDelta = hPlayerHero:GetLevel() - nSpentPoints 
		if nPointsDelta == 0 then
			--print( "  already have correct points" )
			hPlayerHero:SetAbilityPoints( 0 )
			return
		elseif nPointsDelta < 0 then
			--print( "  we have too many points, reset all abilities to level 0 and re-award points" )
			for i = 0, DOTA_MAX_ABILITIES - 1 do
				local hAbility = hPlayerHero:GetAbilityByIndex( i )
				if hAbility and hAbility:CanAbilityBeUpgraded() ~= ABILITY_NOT_LEARNABLE and self:IsValidAbility( hAbility ) then
					hAbility:SetLevel( 0 )
				end
			end
			--print( "    set ability points to: " .. hPlayerHero:GetLevel() )
			hPlayerHero:SetAbilityPoints( hPlayerHero:GetLevel() )
		elseif nPointsDelta > 0 then
			--print( "  we are missing points, award nPointsDelta" )
			hPlayerHero:SetAbilityPoints( nPointsDelta )
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:IsValidAbility( hAbility )
	if IsServer() then
		local szName = hAbility:GetAbilityName()
		if szName then
			if szName == "throw_snowball" or szName == "throw_coal" or szName == "shoot_firework" or szName == "healing_campfire" or szName == "invoker_invoke" then
				return false
			end
		end

		return true
	end
end

--------------------------------------------------------------------------------

--[[
function CHoldout:IsConsumableAbility( hAbility )
	if hAbility:GetBehavior() == DOTA_ABILITY_BEHAVIOR_ITEM then
		return true
	end

	return false
end
]]

--------------------------------------------------------------------------------

function CHoldout:_GoldDropConsoleCommand( cmdName, goldToDrop )
	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	if goldToDrop == nil then goldToDrop = 100 end
	newItem:SetCurrentCharges( goldToDrop )
	local spawnPoint = Vector( 0, 0, 0 )
	local heroEnt = PlayerResource:GetSelectedHeroEntity( 0 )
	if heroEnt ~= nil then
		spawnPoint = heroEnt:GetAbsOrigin()
	end
	local drop = CreateItemOnPositionSync( spawnPoint, newItem )
	newItem:LaunchLoot( true, 300, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 350 ) ) )
end

--------------------------------------------------------------------------------

function CHoldout:_StatusReportConsoleCommand( cmdName )
	print( "*** Holdout Status Report ***" )
	print( string.format( "Current Round: %d", self._nRoundNumber ) )
	if self._currentRound then
		self._currentRound:StatusReport()
	end
	print( "*** Holdout Status Report End *** ")
end

--------------------------------------------------------------------------------

function CHoldout:_RestartGame()
	-- Clean up the last round
	self._currentRound:End( false )
	self:_RespawnBuildings()
	GameRules:ResetDefeated()
	
	-- Clean up everything on the ground; gold, tombstones, items, everything.
	while GameRules:NumDroppedItems() > 0 do
		local item = GameRules:GetDroppedItem(0)
		UTIL_RemoveImmediate( item )
	end

	
	for playerID=0,4 do
		PlayerResource:SetGold( playerID, STARTING_GOLD, false )
		PlayerResource:SetGold( playerID, 0, true )
		PlayerResource:SetBuybackCooldownTime( playerID, 0 )
		PlayerResource:SetBuybackGoldLimitTime( playerID, 0 )
		PlayerResource:ResetBuybackCostTime( playerID )
	end

	-- Reset values
	self:InitGameMode()

	GameRules:ResetToHeroSelection()
	FireGameEvent( "dota_reset_suggested_items", {} )

	-- Reset voting
	self._votes = {}
	self._flEndTime = nil
end

--------------------------------------------------------------------------------

function CHoldout:_Defeated()
	GameRules:SetOverlayHealthBarUnit( nil, 0 )
	GameRules:Defeated()

	self._nGameEndState = DEFEATED
	self._flGameOverAnimationTimer = GameRules:GetGameTime() + 0.0
	self:_DisplayGameEnd() 
end

--------------------------------------------------------------------------------

function CHoldout:_Victory()
	GameRules:SetOverlayHealthBarUnit( nil, 0 )

	self._nGameEndState = VICTORIOUS
	self._flGameOverAnimationTimer = GameRules:GetGameTime() + 0.0
	self:_DisplayGameEnd()
end

--------------------------------------------------------------------------------

function CHoldout:GameOverThink()
	if self._flGameOverAnimationTimer > GameRules:GetGameTime() then
		return 0.25
	end

	self._flGameOverAnimationTimer = 0
	if self._bDisplayingGameEnd == false then
		
		
	end

	return self:_CheckRestartVotes()
end

--------------------------------------------------------------------------------

function CHoldout:HasBossSpawned()
	return self._bBossHasSpawned
end

--------------------------------------------------------------------------------

function CHoldout:HasBossDied()
	return self._bBossHasDied
end

--------------------------------------------------------------------------------

function CHoldout:SpawnBoss()
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
	self._hRubick = CreateUnitByName( "npc_dota_hero_rubick", Vector( 0, 0, 0 ), true, nil, nil, DOTA_TEAM_BADGUYS )
	if self._hRubick ~= nil then
		for i=0,DOTA_MAX_ABILITIES-1 do
			local hAbility = self._hRubick:GetAbilityByIndex( i )
			while hAbility and hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
				hAbility:UpgradeAbility( true )
			end
			if hAbility ~= nil and ( hAbility:GetAbilityName() == "invoker_wex" or hAbility:GetAbilityName() == "invoker_exort" ) then
				hAbility:SetHidden( true )
			end
		end
		
		self._hRubick:SetUnitCanRespawn( true )
		self._bBossHasSpawned = true
	end
end

--------------------------------------------------------------------------------

function CHoldout:GetPlayerKillsWithoutDying( nPlayerID )
	return self._vKillsWithoutDying[nPlayerID]
end

--------------------------------------------------------------------------------

function CHoldout:ResetKillsWithoutDying( nPlayerID )
	local event = 
	{
		gold = 0,
		killer_id = 0,
		killer_streak = 0,
		killer_multikill = 0,
		victim_id = nPlayerID,
		victim_streak = self._lastStreak[nPlayerID] 
	}
	FireGameEvent( "dota_chat_kill_streak", event )

	self._vKillsWithoutDying[nPlayerID] = 0
	self._lastStreak[nPlayerID] = 0	
end

--------------------------------------------------------------------------------

function CHoldout:KillsToStreakEnumMap( kills )
	local ret = 0
	if kills >= KILLING_SPREE_KILLS then
		ret = 3
	end
	if kills >= DOMINATING_KILLS then
		ret = 4
	end
	if kills >= MEGA_KILL_KILLS then
		ret = 5
	end
	if kills >= UNSTOPPABLE_KILLS then
		ret = 6
	end
	if kills >= WICKED_SICK_KILLS then
		ret = 7
	end
	if kills >= MONSTER_KILL_KILLS then
		ret = 8
	end
	if kills >= GODLIKE_KILLS then
		ret = 9
	end
	if kills >= BEYOND_GODLIKE_KILLS then
		ret = 10
	end
	return ret
end

--------------------------------------------------------------------------------
 
function CHoldout:IncrementKillsWithoutDying( nPlayerID )
	if self._vKillsWithoutDying[nPlayerID] == nil then
		self._vKillsWithoutDying[nPlayerID] = 0
	end
	self._vKillsWithoutDying[nPlayerID] = self._vKillsWithoutDying[nPlayerID] + 1

	local newStreak = self:KillsToStreakEnumMap( self._vKillsWithoutDying[nPlayerID] )
	if newStreak > self._lastStreak[nPlayerID] then
		local event = 
		{
			gold = 0,
			killer_id = nPlayerID,
			killer_streak = newStreak,
			killer_multikill = 0,
		}
		FireGameEvent( "dota_chat_kill_streak", event )

		if newStreak == 3 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_spree_01" )
		end
		if newStreak == 4 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_dominate_01" )
		end
		if newStreak == 5 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_mega_01" )
		end
		if newStreak == 6 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_unstop_01" )
		end
		if newStreak == 7 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_wicked_01" )
		end
		if newStreak == 8 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_monster_01" )
		end
		if newStreak == 9 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_godlike_01" )
		end
		if newStreak == 10 then
			EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_holy_01" )
		end

		self._lastStreak[nPlayerID] = newStreak
	end
end

--------------------------------------------------------------------------------

function CHoldout:AddWonAward( award )
	if award ~= nil then
		local nPlayerID = award["PlayerID"]
		if self._wonAwards[nPlayerID] == nil then
			self._wonAwards[nPlayerID] = {}
		end
		table.insert( self._wonAwards[nPlayerID], award )
	end
end

--------------------------------------------------------------------------------

function CHoldout:IncrementKillsInWindow( nPlayerID )
	if self._killsInWindow[nPlayerID] == nil then
		self._killsInWindow[nPlayerID] = 0
	end

	if GameRules:GetGameTime() > self._killWindowExpireTime[nPlayerID] then
		self._killsInWindow[nPlayerID] = 1
		self._killWindowExpireTime[nPlayerID] = GameRules:GetGameTime() + 1.0
		self._lastMultiKill[nPlayerID] = 0
	else
		self._killsInWindow[nPlayerID] = self._killsInWindow[nPlayerID] + 1
		self._killWindowExpireTime[nPlayerID] = GameRules:GetGameTime() + 0.2
	end

	if self._lastMultiKill[nPlayerID] == 0 and self._killsInWindow[nPlayerID] > ULTRA_KILL_KILLS then
		local event = 
		{
			gold = 0,
			killer_id = nPlayerID,
			killer_streak = 0,
			killer_multikill = 4,
		}
		FireGameEvent( "dota_chat_kill_streak", event )
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_ultra_01" )
		self._lastMultiKill[nPlayerID] = ULTRA_KILL_KILLS
	end

	if self._lastMultiKill[nPlayerID] == ULTRA_KILL_KILLS and self._killsInWindow[nPlayerID] > RAMPAGE_KILLS then
		local event = 
		{
			gold = 0,
			killer_id = nPlayerID,
			killer_streak = 0,
			killer_multikill = 5,
		}
		FireGameEvent( "dota_chat_kill_streak", event )
		EmitAnnouncerSound( "announcer_killing_spree_announcer_kill_rampage_01" )
		self._lastMultiKill[nPlayerID] = 0
		self._killWindowExpireTime[nPlayerID] = 0
		self._killsInWindow[nPlayerID] = 0
	end
end

--------------------------------------------------------------------------------

function CHoldout:GetKillsInWindow( nPlayerID )
	return self._killsInWindow[nPlayerID]
end

--------------------------------------------------------------------------------

function CHoldout:OnBossKilledPlayer()
	if self._hRubick ~= nil then
		if self._hRubick.flSpeechCooldown > GameRules:GetGameTime() then
			return
		end
		self._hRubick.flSpeechCooldown = GameRules:GetGameTime() + SPEECH_COOLDOWN
		local nTaunt = RandomInt( 0, 8 )
		if nTaunt == 0 then
			EmitGlobalSound( "rubick_rub_arc_kill_05" )
		end
		if nTaunt == 1 then
			EmitGlobalSound( "rubick_rub_arc_kill_07" )
		end
		if nTaunt == 2 then
			EmitGlobalSound( "rubick_rub_arc_kill_08" )
		end
		if nTaunt == 3 then
			EmitGlobalSound( "rubick_rub_arc_kill_09" )
		end
		if nTaunt == 4 then
			EmitGlobalSound( "rubick_rub_arc_kill_11" )
		end
		if nTaunt == 5 then
			EmitGlobalSound( "rubick_rub_arc_kill_14" )
		end
		if nTaunt == 6 then
			EmitGlobalSound( "rubick_rub_arc_kill_15" )
		end
		if nTaunt == 7 then
			EmitGlobalSound( "rubick_rub_arc_kill_16" )
		end
		if nTaunt == 8 then
			EmitGlobalSound( "rubick_rub_arc_kill_17" )
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:RefreshShrines()
	for _, shrine in pairs( Entities:FindAllByClassname( "npc_dota_healer" ) ) do
		local hHealAbility = shrine:FindAbilityByName( "filler_ability" )
		if hHealAbility ~= nil then
			hHealAbility:EndCooldown()
		end
	end
end

--------------------------------------------------------------------------------

function CHoldout:FindAndGetFort()
	local bFoundFort = false
	for _, hFort in pairs( Entities:FindAllByClassname( "npc_dota_fort" ) ) do
		if hFort ~= nil and hFort:IsNull() == false then
			return hFort
		end
	end

	return nil
end

--------------------------------------------------------------------------------
