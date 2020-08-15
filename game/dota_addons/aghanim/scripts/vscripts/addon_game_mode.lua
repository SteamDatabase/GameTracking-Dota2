
if CAghanim == nil then
	CAghanim = class({})
	_G.CAghanim = CAghanim
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Required .lua files, which help organize functions contained in our addon.
-- Make sure to call these beneath the mode's class creation.
------------------------------------------------------------------------------------------------------------------------------------------------------
require( "constants" ) -- require constants first
require( "aghanim_ability_upgrade_constants" ) -- lists of ability upgrades per hero
require( "aghanim_ability_upgrade_interface" ) -- upgrading abilities can go through the interface
require( "utility_functions" ) -- require utility_functions early (other required files may use its functions)
require( "aghanim_utility_functions" ) 
require( "precache" )
require( "blessings" )
require( "events" )
require( "filters" )
require( "room_tables" )
require( "ascension_levels" )
require( "triggers" )
require( "map_room" )
require( "rewards" )
require( "containers/breakable_containers_data" )
require( "containers/breakable_container_surprises" )
require( "containers/treasure_chest_data" )
require( "containers/treasure_chest_surprises" )
require( "containers/explosive_barrel_data" )
--require( "map_generation" )

--------------------------------------------------------------------------------

function Precache( context )
	print( "Precaching Aghanim assets..." )

	for _,Item in pairs( g_ItemPrecache ) do
		PrecacheItemByNameSync( Item, context )
	end

	for Item,Price in pairs( PRICED_ITEM_REWARD_LIST ) do
		PrecacheItemByNameSync( Item, context )
	end

	for i=1,#TREASURE_REWARDS do
		for j=1,#TREASURE_REWARDS[i] do
			PrecacheItemByNameSync( TREASURE_REWARDS[i][j], context )
		end
	end

	for _, breakableData in ipairs( BreakablesData ) do
		for i=1,#breakableData.CommonItems do
			PrecacheItemByNameSync( breakableData.CommonItems[i], context )
		end

		for i=1,#breakableData.MonsterUnits do
			PrecacheUnitByNameSync( breakableData.MonsterUnits[i], context, -1 )
		end		

		for i=1,#breakableData.RareItems do
			PrecacheItemByNameSync( breakableData.RareItems[i], context )
		end		
	end

	for _,Unit in pairs( g_UnitPrecache ) do
		PrecacheUnitByNameSync( Unit, context, -1 )
	end

	for AbilityName,Ability in pairs( ASCENSION_ABILITIES ) do
		-- Yes, it's not an item, but this works anyways since abilities are similar to items
		PrecacheItemByNameSync( AbilityName, context )
	end

	for _,Model in pairs( g_ModelPrecache ) do
		PrecacheResource( "model", Model, context )
	end

	for _,Particle in pairs( g_ParticlePrecache ) do
		PrecacheResource( "particle", Particle, context )
	end

	for _,Sound in pairs( g_SoundPrecache ) do
		PrecacheResource( "soundfile", Sound, context )
	end
end

--------------------------------------------------------------------------------

-- Create the game mode when we activate
function Activate()
	GameRules.Aghanim = CAghanim()
	GameRules.Aghanim:InitGameMode()
	LinkModifiers()
end

--------------------------------------------------------------------------------

function SpawnGroupPrecache( hSpawnGroup, context )

	local room = GameRules.Aghanim:FindRoomBySpawnGroupHandle( hSpawnGroup )
	if room ~= nil then
		--print( "Precaching room " .. room:GetName() .. "..." )
		room:GetEncounter():Precache( context )
	end

end

--------------------------------------------------------------------------------

function LinkModifiers()
	LinkLuaModifier( "modifier_bonus_room_start", "modifiers/modifier_bonus_room_start", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_morty_leash", "modifiers/modifier_morty_leash", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_provides_fow_position", "modifiers/modifier_provides_fow_position", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_sand_king_boss_caustic_finale", "modifiers/creatures/modifier_sand_king_boss_caustic_finale", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_breakable_container", "modifiers/modifier_breakable_container", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_boss_intro", "modifiers/modifier_boss_intro", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_attack_speed_unslowable", "modifiers/modifier_attack_speed_unslowable", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_move_speed_unslowable", "modifiers/modifier_move_speed_unslowable", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_sniper_big_game_hunter_limiter", "modifiers/modifier_sniper_big_game_hunter_limiter", LUA_MODIFIER_MOTION_NONE )
end


--------------------------------------------------------------------------------

function GetExitOptionData( nOptionNumber )
	return GameRules.Aghanim:GetExitOptionData( nOptionNumber )
end

--------------------------------------------------------------------------------

function CAghanim:InitGameMode()
	print( "Aghanim addon is loaded." )

	self.CurrentRoom = nil
	self.bStreamedStartingRoomExits = false
	self.bIsInTournamentMode = false
	self.nSeed = 0
	self.bFastTestEncounter = false
	self.flExpeditionStartTime = 0

	if GameRules:GetGameModeEntity():GetEventWindowStartTime() > 0 then
		self.nSeed = GameRules:GetGameModeEntity():GetEventGameSeed()
		if self.nSeed > 0 then
			self.bIsInTournamentMode = true
		end
	end

	if self.nSeed == 0 then
		self.nSeed = math.floor( GetSystemTimeMS() )
	else
		print( "Using fixed seed from the GC: " .. self.nSeed )
	end

	self.nAscensionLevel = 0
	self.bHasSetAscensionLevel = false
	self.bWonGame = false
	self.bHasAnyNewPlayers = false
	self.bHasSetNewPlayers = false
	self.bHasInitializedSpectatorCameras = false
	self.AghanimSummons = {}
	self.hMapRandomStream = CreateUniformRandomStream( self.nSeed )
	self.hPlayerRandomStreams = {}

	math.randomseed( self.nSeed )

	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:SetCustomGameSetupTimeout( 0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetTimeOfDay( 0.25 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetPostGameTime( 45.0 )
	GameRules:SetHeroSelectionTime( 90 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetStartingGold( AGHANIM_STARTING_GOLD )
	GameRules:SetGoldTickTime( 999999.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled( true )
 	GameRules:GetGameModeEntity():SetRandomHeroBonusItemGrantDisabled( true )
 	GameRules:GetGameModeEntity():SetDefaultStickyItem( "item_boots" )
 	GameRules:GetGameModeEntity():SetForceRightClickAttackDisabled( true )
 	GameRules:GetGameModeEntity():DisableClumpingBehaviorByDefault( true )
 	GameRules:GetGameModeEntity():SetMinimumAttackSpeed( 0.4 )
 	GameRules:GetGameModeEntity():SetNeutralStashTeamViewOnlyEnabled( true )
 	GameRules:GetGameModeEntity():SetNeutralItemHideUndiscoveredEnabled( true )

 	--Temp for tesitng new lives rules
 	if AGHANIM_TIMED_RESPAWN_MODE == true then
 		GameRules:GetGameModeEntity():SetBuybackEnabled( false )
 		GameRules:GetGameModeEntity():SetFixedRespawnTime( AGHANIM_TIMED_RESPAWN_TIME )
 	else
 		GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled( true )
		GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled( true )
		GameRules:SetHeroRespawnEnabled( false )
 	end

 	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
 	GameRules:GetGameModeEntity():SetFriendlyBuildingMoveToEnabled( true )
 	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:GetGameModeEntity():SetCameraSmoothCountOverride( 2 )
	GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled( false )
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride( "item_bottle" )
	
	GameRules:GetGameModeEntity():SetSendToStashEnabled( false )
	self.hFowBlockerRegion = GameRules:GetGameModeEntity():AllocateFowBlockerRegion( -16384, -16384, 16384, 16384, 128 )
	
 	GameRules:SetCustomGameAllowHeroPickMusic( false )
 	GameRules:SetCustomGameAllowBattleMusic( false )
	GameRules:SetCustomGameAllowMusicAtGameStart( true )

	-- Make the camera not z clip 
	GameRules:GetGameModeEntity():SetCameraZRange( 11, 3800 )

	-- Event Registration: Functions are found in dungeon_events.lua
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CAghanim, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( CAghanim, 'OnPlayerConnected' ), self )
	ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( CAghanim, 'OnPlayerReconnected' ), self )
	ListenToGameEvent( "hero_selected", Dynamic_Wrap( CAghanim, 'OnHeroSelected' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CAghanim, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CAghanim, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CAghanim, "OnPlayerGainedLevel" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CAghanim, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( CAghanim, "OnPlayerRevived" ), self )
	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( CAghanim, "OnPlayerBuyback" ), self )
	ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( CAghanim, "OnItemSpawned" ), self )
	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( CAghanim, "OnItemPurchased" ), self )
	--ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( CAghanim, "OnNonPlayerUsedAbility" ), self )
	ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CAghanim, "OnTriggerStartTouch" ), self )
	ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( CAghanim, "OnTriggerEndTouch" ), self )
	ListenToGameEvent( "aghsfort_path_selected", Dynamic_Wrap( CAghanim, "OnNextRoomSelected" ), self )
	ListenToGameEvent( "dota_hero_entered_shop", Dynamic_Wrap( CAghanim, "OnHeroEnteredShop" ), self )
	ListenToGameEvent( "dota_player_team_changed", Dynamic_Wrap( CAghanim, "OnPlayerTeamChanged" ), self )

	-- Filter Registration: Functions are found in filters.lua
	--GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( CAghanim, "HealingFilter" ), self )
	--GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CAghanim, "DamageFilter" ), self )
	--GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( CAghanim, "ItemAddedToInventoryFilter" ), self )
	GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap( CAghanim, "ModifierGainedFilter" ), self )

	self.nCrystalsLeft = 5
	self.PlayerCrystals = {}
	self.PlayerCurrentRooms = {}
	for nPlayerID = 0, AGHANIM_PLAYERS-1 do
		PlayerResource:SetCustomTeamAssignment( nPlayerID, DOTA_TEAM_GOODGUYS )
		table.insert( self.PlayerCurrentRooms, nPlayerID , {} )
		table.insert( self.PlayerCrystals, nPlayerID , {} )
	end

	for szHeroName,HeroUpgrades in pairs ( MINOR_ABILITY_UPGRADES ) do
		for k,v in pairs ( HeroUpgrades ) do
			v[ "id" ] = k
		end
		--PrintTable( HeroUpgrades, szHeroName .. ": " )
	end

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0.5 )

	-- Used to display the blessings
	CustomNetTables:SetTableValue( "game_global", "blessings", {} )

	local nTournamentSeed = 0
	if self.bIsInTournamentMode == true then
		nTournamentSeed = self.nSeed
	end
	CustomNetTables:SetTableValue( "game_global", "tournament_mode", { tostring( nTournamentSeed ) } )

	-- parse dev mode starting flags
	self._bDevMode = (GameRules:GetGameSessionConfigValue("DevMode", "false") == "true")
	self._szDevHero = GameRules:GetGameSessionConfigValue("DevHero", nil)
	self._szDevEncounter = GameRules:GetGameSessionConfigValue("DevEncounter", nil)

	if self._bDevMode then
		GameRules:SetHeroSelectionTime( 20.0 )
		GameRules:SetHeroSelectPenaltyTime( 0.0 )
		GameRules:SetPostGameTime( 10.0 )
	end

	self:RegisterConCommands()

	self.nNumViableRoomsForItems = NUM_VIABLE_ROOMS_FOR_DROPPED_ITEMS
	self.nNumNeutralItems = NUM_NEUTRAL_ITEMS_DROPPED
	self.DroppedNeutralItems = {}

	self:InitScoreboardInfo()
	self:InitPlayerInfo()
	self:AllocateRoomLayout()
	self:AssignEncountersToRooms()
	self:SetupSpawnLocations()

	-- Mark the first room as loaded, and start streaming the exit rooms immediately
	local room = self:GetStartingRoom()
	if room~= nil then
		room:OnSpawnRoomComplete( room:GetSpawnGroupHandle() )
	end

	-- Listener for the ability upgrade
	CustomGameEventManager:RegisterListener( "ability_upgrade_button_clicked", function(...) return self:OnAbilityUpgradeButtonClicked( ... ) end )
	self.bTestingAbilityUpgrades = false
	
	-- Listener for reward choice	
	CustomGameEventManager:RegisterListener( "reward_choice", function(...) return OnRewardChoice( ... ) end )

	if self.bIsInTournamentMode == true then
		self:SetAscensionLevel( 2 )
		print( "Tournament game difficulty is " .. self:GetAscensionLevel() )
	else		
		local nCustomGameDifficulty = GameRules:GetCustomGameDifficulty()
		if nCustomGameDifficulty > 0 then
			print( "Lobby game difficulty is " .. nCustomGameDifficulty )
			self:SetAscensionLevel( nCustomGameDifficulty - 1 )
		end
	end
		
	-- Create announcer Unit
	local dummyTable = 
	{ 	
		MapUnitName = "npc_dota_announcer_aghanim", 
		teamnumber = DOTA_TEAM_GOODGUYS,
	}
	CreateUnitFromTable( dummyTable, Vector( 0, 0, 0 ) )

	self:InitializeMetagame()
	self.BristlebackItems = {}
end

--------------------------------------------------------------------------------

function CAghanim:GetRandomSeed( )
	return self.nSeed
end

--------------------------------------------------------------------------------

function CAghanim:SetExpeditionStartTime( flStartTime )
	self.flExpeditionStartTime = flStartTime
	CustomNetTables:SetTableValue( "game_global", "expedition_start_time", { tostring( flStartTime ) } )
end

--------------------------------------------------------------------------------

function CAghanim:GetExpeditionStartTime( )
	return self.flExpeditionStartTime
end

--------------------------------------------------------------------------------

function CAghanim:GetHeroRandomStream( nPlayerID )

	local hStream = self.hPlayerRandomStreams[ tostring( nPlayerID ) ]
	if hStream ~= nil then
		return hStream
	end

	local nHeroID = PlayerResource:GetSelectedHeroID( nPlayerID )
	if nHeroID == 0 then
		print( "GetHeroRandomStream: Warning! Encountered hero id " .. nHeroID )
	end

	local hStream = CreateUniformRandomStream( self.nSeed + nHeroID )
	self.hPlayerRandomStreams[ tostring( nPlayerID ) ] = hStream
	return hStream

end

--------------------------------------------------------------------------------

function CAghanim:SetAnnouncer( hAnnouncer )
	self.hAnnouncer = hAnnouncer
end

--------------------------------------------------------------------------------

function CAghanim:GetAnnouncer( )
	return self.hAnnouncer
end

--------------------------------------------------------------------------------

function CAghanim:InitPlayerInfo()

	self.playerInfo = {}

	local hEventGameDetails = GetLobbyEventGameDetails()

	print("[Aghanim] EventGameDetails table:")
	if hEventGameDetails == nil then
		print("NOT FOUND!!")
		hEventGameDetails = {}
	end

	DeepPrintTable(hEventGameDetails)

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do

		local szAccountID = tostring( PlayerResource:GetSteamAccountID( nPlayerID ) )

		local hPlayerDetails = {}
		local szPlayerRecord = string.format( "Player%d", nPlayerID )
		if hEventGameDetails[szPlayerRecord] ~= nil then
			local szRecordAccountID = hEventGameDetails[szPlayerRecord]['account_id']
			if szRecordAccountID ~= nil and szRecordAccountID == szAccountID then
				hPlayerDetails = hEventGameDetails[szPlayerRecord]
			end
		end

		local info = 
		{
			nBPCapTotal = hPlayerDetails["pointcap_total"] or 0,
			nBPCapRemaining = hPlayerDetails["pointcap_remaining"] or 0,
			nArcaneFragmentCapTotal = hPlayerDetails["premium_pointcap_total"] or 0,
			nArcaneFragmentCapRemaining = hPlayerDetails["premium_pointcap_remaining"] or 0,
		}

		self.playerInfo[ tostring( nPlayerID ) ] = info
	end

end

--------------------------------------------------------------------------------

function CAghanim:CanPlayersAcceptCurrency( bBattlePoints )

	if bBattlePoints == false then
		return true
	end

	local connectedPlayers = self:GetConnectedPlayers()
	for i=1,#connectedPlayers do
		local nPlayerID = connectedPlayers[i]

		local player = self.playerInfo[ tostring( nPlayerID ) ] 
		if player ~= nil then
			if player.nBPCapRemaining > 0 then
				return true
			end
		end
	end
	return false

end

--------------------------------------------------------------------------------

function CAghanim:RegisterCurrencyGrant( nPlayerID, nPoints, bBattlePoints )

	local player = self.playerInfo[ tostring( nPlayerID ) ]
	if player == nil then
		return 0
	end

	if bBattlePoints == true then
		if nPoints > player.nBPCapRemaining then
			nPoints = player.nBPCapRemaining
		end
		player.nBPCapRemaining = player.nBPCapRemaining - nPoints
	else
		local nBonusPoints = nPoints * 2
		if nBonusPoints > player.nArcaneFragmentCapRemaining then
			nBonusPoints = player.nArcaneFragmentCapRemaining
		end
		player.nArcaneFragmentCapRemaining = player.nArcaneFragmentCapRemaining - nBonusPoints
		nPoints = nPoints + nBonusPoints
	end

	return nPoints
end

--------------------------------------------------------------------------------

function CAghanim:GetPointsCapRemaining( nPlayerID, bBattlePoints, bTotal )

	local player = self.playerInfo[ tostring( nPlayerID ) ]
	if player == nil then
		return 0
	end

	if bBattlePoints == true then
		if bTotal == false then
			return player.nBPCapRemaining
		else
			return player.nBPCapTotal
		end
	end
	
	if bTotal == false then
		return player.nArcaneFragmentCapRemaining
	else
		return player.nArcaneFragmentCapTotal
	end
end

--------------------------------------------------------------------------------

function CAghanim:InitScoreboardInfo()

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local kv = 
		{
			kills = 0,
			death_count = 0,
			gold_bags = 0
		}
		CustomNetTables:SetTableValue( "aghanim_scores", tostring( nPlayerID ), kv )
	end

end

--------------------------------------------------------------------------------

function CAghanim:RegisterPlayerKillStat( nPlayerID, nDepth )

	local scores = CustomNetTables:GetTableValue( "aghanim_scores", tostring(nPlayerID) )
	scores.kills = scores.kills + 1
	CustomNetTables:SetTableValue( "aghanim_scores", tostring(nPlayerID), scores )

	local szRoomDepth = tostring( nDepth )
	self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].kills = 
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].kills + 1

end

--------------------------------------------------------------------------------

function CAghanim:RegisterGoldBagCollectedStat( nPlayerID )

	local scores = CustomNetTables:GetTableValue( "aghanim_scores", tostring(nPlayerID) )
	scores.gold_bags = scores.gold_bags + 1
	CustomNetTables:SetTableValue( "aghanim_scores", tostring(nPlayerID), scores )

	if self:GetCurrentRoom() ~= nil then
		local szRoomDepth = tostring( self:GetCurrentRoom():GetDepth() )
		self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].gold_bags = 
			self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].gold_bags + 1
	end

end

--------------------------------------------------------------------------------

function CAghanim:GetNewPlayerList( )

	local vecPlayerIDs = {}
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) and PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local nGamePlayedCount = PlayerResource:GetEventGameCustomActionClaimCountByName( nPlayerID, "ti10_event_game_num_games_played" )
			if nGamePlayedCount < 3 then
				table.insert( vecPlayerIDs, nPlayerID )
			end
		end
	end
	return vecPlayerIDs

end

--------------------------------------------------------------------------------

function CAghanim:ReassignTrapRoomToNormalEncounter( nAct )

	local hRoom = nil
	for _,room in pairs(self.rooms) do
		if room:GetAct() == nAct and room:GetType() == ROOM_TYPE_TRAPS then
			hRoom = room
			break
		end
	end

	if hRoom == nil then
		return
	end

	-- Reassign this room back to a normal room
	hRoom.nRoomType = ROOM_TYPE_ENEMY

	-- Select a new encounter, and make sure no room has the same encounter on both exits
	local vecSiblingRoomNames = self:GetSiblingRoomNames( hRoom:GetName() )

	local vecEncounterOptions = {}
	for encounterName,encounterDef in pairs(ENCOUNTER_DEFINITIONS) do 

		if not self:IsEncounterDefAppropriateForRoom( encounterDef, hRoom ) then
			goto continue
		end

		for s=1,#vecSiblingRoomNames do
			local szOtherEncounterName = self.rooms[ vecSiblingRoomNames[s] ]:GetEncounterName()
			if szOtherEncounterName == encounterName then
				goto continue 	
			end
		end

		table.insert( vecEncounterOptions, encounterName )
		::continue::
	end
		
	if #vecEncounterOptions > 0 then
		local nPick = self.hMapRandomStream:RandomInt( 1, #vecEncounterOptions )
		--print( "Replacing trap encounter " .. hRoom:GetEncounterName() .. " with encounter " .. vecEncounterOptions[nPick] .. " in room " .. hRoom:GetName() )
		hRoom:AssignEncounter( vecEncounterOptions[nPick] )
		hRoom:GetEncounter():SelectAscensionAbilities()
	end

end

--------------------------------------------------------------------------------

function CAghanim:ComputeHasNewPlayers()

	if self.bHasSetNewPlayers == true then
		return
	end

	if PlayerResource:HasSetEventGameCustomActionClaimCount() == false then
		return
	end

	self.bHasSetNewPlayers = true

	-- Determine whether there are any new players
	local vecPlayerIDs = self:GetNewPlayerList( )
	self.bHasAnyNewPlayers = ( #vecPlayerIDs > 0 )

	-- Show new player popup for new players
	CustomNetTables:SetTableValue( "game_global", "new_players", vecPlayerIDs )

	if self.bHasAnyNewPlayers == true and self:GetAscensionLevel() == 0 then
		self:ReassignTrapRoomToNormalEncounter( 1 )
	end

	print( "New players " .. tostring( self.bHasAnyNewPlayers ) )

	-- Can't do this until we know whether we have new players
	self:GetAnnouncer():OnHeroSelectionStarted()
	
end

--------------------------------------------------------------------------------

function CAghanim:OnHeroSelectionStarted()

end

--------------------------------------------------------------------------------

function CAghanim:HasAnyNewPlayers()
	return self.bHasAnyNewPlayers
end

--------------------------------------------------------------------------------

function CAghanim:IsInTournamentMode()
	return self.bIsInTournamentMode
end

--------------------------------------------------------------------------------

function CAghanim:GetPlayerCurrentRoom( nPlayerID )
	return self.PlayerCurrentRooms[ nPlayerID ]
end

--------------------------------------------------------------------------------

function CAghanim:ClampMinimapToRoom( nPlayerID, hRoom )

	local flSize = hRoom:GetMaxs().x - hRoom:GetMins().x
	local flSizeY = hRoom:GetMaxs().y - hRoom:GetMins().y
	if flSizeY > flSize then
		flSize = flSizeY
	end

	local netTable = {}
	netTable[ "room_name" ] = hRoom:GetName()
	netTable[ "map_name" ] = hRoom:GetMapName()
	netTable[ "x" ] = hRoom:GetOrigin().x
	netTable[ "y" ] = hRoom:GetOrigin().y
	netTable[ "size" ] = flSize
	netTable[ "scale" ] = 8

	if hRoom:GetType() == ROOM_TYPE_BOSS then
		netTable[ "scale" ] = 4
	end
	
	if hRoom:GetName() == "a2_transition" then
		netTable[ "scale" ] = 2
	end

	if hRoom:GetType() == ROOM_TYPE_STARTING then
		netTable[ "map_name" ] = "main"
	end

	CustomNetTables:SetTableValue( "game_global", "minimap_info" .. nPlayerID, netTable )
end

--------------------------------------------------------------------------------

function CAghanim:SetPlayerCurrentRoom( nPlayerID, hRoom )
	self.PlayerCurrentRooms[ nPlayerID ] = hRoom
	self:ClampMinimapToRoom( nPlayerID, hRoom )
end

--------------------------------------------------------------------------------

function CAghanim:GetStartingRoom()
	for _,room in pairs(self.rooms) do
		if room:GetAct() == 1 and room:GetType() == ROOM_TYPE_STARTING then
			return room
		end
	end
	return nil
end

--------------------------------------------------------------------------------

function CAghanim:RegisterConCommands()
	print("Registering ConCommands...");
	local eCommandFlags = FCVAR_CHEAT
	Convars:RegisterCommand( "test_room_reward", function( ... ) return TestRoomRewardConsoleCommand(...) end, "Usage: test_room_reward <nRoomDepth> <bIsElite>", eCommandFlags );
	-- use aghanim_ability_upgrades to open the ability upgrade dev interface
	Convars:RegisterCommand( "aghanim_ability_upgrades", function(...) return self:TestAbilityUpgradesUICC( ... ) end, "", eCommandFlags )
	Convars:RegisterCommand( "win_encounter", function(...) return self:Dev_WinEncounter( ... ) end, "Completes the current encounter.", eCommandFlags )
	Convars:RegisterCommand( "win_game", function(...) return self:Dev_WinGame( ... ) end, "Completes the current game.", eCommandFlags )
	Convars:RegisterCommand( "set_ascension_level", function(...) return self:Dev_SetAscensionLevel( ... ) end, "Sets the current ascension level", eCommandFlags )
	Convars:RegisterCommand( "extra_lives", function(...) return self:Dev_ExtraLives( ... ) end, "Completes the current encounter.", eCommandFlags )
	Convars:RegisterCommand( "aghanim_test_encounter", function(...) return self:Dev_TestEncounter( ... ) end, "Tests a specific encounter at a specific level", eCommandFlags )
	Convars:RegisterCommand( "fast_test_encounter", function(...) self.bFastTestEncounter = true; return self:Dev_TestEncounter( ... ) end, "Tests a specific encounter at a specific level", eCommandFlags )
	Convars:RegisterCommand( "set_new_players", function(...) return self:Dev_SetNewPlayers( ... ) end, "Sets whether there are new players or not", eCommandFlags )
end

--------------------------------------------------------------------------------

function CAghanim:SetAscensionLevel( nLevel )

	if nLevel < 0 then
		nLevel = 0
	elseif nLevel > self:GetMaxAllowedAscensionLevel() then
		nLevel = self:GetMaxAllowedAscensionLevel()
	end
	
	print( 'Setting Ascension Level to ' .. nLevel )
	self.nAscensionLevel = nLevel
	self.bHasSetAscensionLevel = true
	CustomNetTables:SetTableValue( "game_global", "ascension_level", { nLevel } )

	-- Assign elite rooms, since the #s are dependent on the ascension level
	local vecEliteRooms = { {}, {}, {} }

	-- Which rooms can be elite?
	for k,roomDef in pairs(MAP_ATLAS) do
		-- Clear out any previous state
		local hRoom = self.rooms[ roomDef.name ]
		hRoom:SetEliteDepthBonus( 0 )

		-- No elites at depth 2 for ascension 0 or 1
		local bSuppress = ( nLevel <= 1 ) and ( roomDef.nDepth == 2 )
		if bSuppress == false and not roomDef.bCannotBeElite and hRoom:GetType() == ROOM_TYPE_ENEMY then
			table.insert( vecEliteRooms[ hRoom.nAct ], roomDef.name )
		end		
	end

	for nAct=1,3 do

		-- Assign elite rooms
		for nEliteRoom=1, MAP_ATLAS_ELITE_ROOMS_PER_ACT[nLevel+1][nAct] do
			if #vecEliteRooms[nAct] == 0 then
				break
			end
			local nPick = self.hMapRandomStream:RandomInt( 1, #vecEliteRooms[nAct] )

			local szEliteRoom = vecEliteRooms[nAct][nPick]
			--print( "Selecting elite room " ..  szEliteRoom )
			self.rooms[ szEliteRoom ]:SetEliteDepthBonus( 1 )
			self.rooms[ szEliteRoom ]:SendRoomToClient()
			table.remove( vecEliteRooms[nAct], nPick )

			-- Make sure no room has 2 elite exits at asc 0 and 1
			if nLevel <= 1 then
				local vecSiblingRoomNames = self:GetSiblingRoomNames( szEliteRoom )
				for s=1,#vecSiblingRoomNames do
					for h=1,#vecEliteRooms[nAct] do
						if vecEliteRooms[nAct][h] == vecSiblingRoomNames[s] then
							--print( "Removing elite room option " ..  vecEliteRooms[nAct][h] )
							table.remove( vecEliteRooms[nAct], h )
							break
						end
					end
				end
			end
		end

	end

	-- Now that we know our ascension level and eliteness, we can pick the abilities we want to use
	for k,room in pairs(self.rooms) do
		room:GetEncounter():SelectAscensionAbilities()
	end	

end 

--------------------------------------------------------------------------------

function CAghanim:GetMaxAllowedAscensionLevel( )
	return 3	
end 

--------------------------------------------------------------------------------

function CAghanim:GetAscensionLevel( )
	return self.nAscensionLevel
end 

--------------------------------------------------------------------------------

function CAghanim:HasSetAscensionLevel( )
	return self.bHasSetAscensionLevel
end 

--------------------------------------------------------------------------------

function CAghanim:DepthHasEliteEncounters( nDepth )

	local bSkippedOptions = false
	for encounterName,encounterDef in pairs(ENCOUNTER_DEFINITIONS) do 

		if ( nDepth >= encounterDef.nMinDepth and nDepth <= encounterDef.nMaxDepth ) then
--			if encounterDef.nMaxEliteRank ~= nil and encounterDef.nMaxEliteRank > 0 then
			if encounterDef.nEncounterType == ROOM_TYPE_ENEMY then
				return true
			end
		end
	end

	return false
end

--------------------------------------------------------------------------------

function CAghanim:GetSiblingRoomNames( szRoomName )
	-- Find the room(s) that can be entered from the same room as hRoom can be
	local hParentRooms = {}

	for _,otherRoom in pairs(self.rooms) do
		local vecExits = otherRoom:GetExits()
		for _,exit in pairs(vecExits) do
			if exit == szRoomName then
				table.insert( hParentRooms, otherRoom )
			end
		end
	end

	local szOtherExits = {}
	for i=1,#hParentRooms do
		local vecExits = hParentRooms[i]:GetExits()
		for _,szExit in pairs(vecExits) do
			if szExit ~= szRoomName then
				table.insert( szOtherExits, szExit )
			end
		end
	end
	
	return szOtherExits

end	

--------------------------------------------------------------------------------
-- Assign room reward
function CAghanim:AssignRoomReward( szRoomName, RewardPossibilites )

	local flRoll = self.hMapRandomStream:RandomFloat( 0, 100.0 )
	local flThreshold = 0.0

	for k,v in pairs( RewardPossibilites ) do
		flThreshold = flThreshold + v
		if flRoll <= flThreshold then
			szRewardResult = k
			break
		end
	end

	local nExitRoomType = MAP_ATLAS[ szRoomName ].nRoomType
	if nExitRoomType == ROOM_TYPE_BOSS then
		if szRoomName ~= "a3_boss" then 
			szRewardResult = "REWARD_TYPE_GOLD"
		else
			szRewardResult = "REWARD_TYPE_NONE"
		end
	elseif nExitRoomType == ROOM_TYPE_BONUS then
		szRewardResult = "REWARD_TYPE_GOLD"
	elseif nExitRoomType == ROOM_TYPE_TRANSITIONAL or nExitRoomType == ROOM_TYPE_STARTING then
		szRewardResult = "REWARD_TYPE_NONE"
	end
	
	--print( "Setting Room Reward for " .. szRoomName .. " to " .. szRewardResult )
	return szRewardResult

end


--------------------------------------------------------------------------------
-- Allocates the room layout
function CAghanim:AllocateRoomLayout()

	self.bMapFlipped = false --( self.hMapRandomStream:RandomInt( 0, 1 ) == 1 )

	local vecPotentialTrapRooms = { {}, {}, {} }
	local vecHiddenRooms = { {}, {}, {} } 
	self.nMaxDepth = 0

	-- Assign room positions + exits, given flip horizontal logic
	self.rooms = {}
	self.RoomRewards = {}

	-- We must sort the map alphabetically by room name, otherwise it is possible
	-- to get rooms with the same room reward at both exits, specifically which only happens
	-- at depth 4. It can happen if for example a3_3a's exits are assigned first, 
	-- then a3_3c's are assigned before a3_3b. The assignment at a3_3c doesn't know about
	-- the constraint place on a3_3b's exits by a3_3a. By doing it alphabetically, we avoid this problem case
	local sortedRoomDefs = {}
    for roomDef in pairs(MAP_ATLAS) do table.insert(sortedRoomDefs, roomDef) end
    table.sort(sortedRoomDefs)
    for _, n in ipairs(sortedRoomDefs) do
		local roomDef = MAP_ATLAS[n]

		local fHeightOffset = 512
		local vCenter = Vector( roomDef.vCenter.x, roomDef.vCenter.y, roomDef.vCenter.z + fHeightOffset )
		if self.bMapFlipped then
			vCenter.x = -vCenter.x
		end 

		if roomDef.nRoomType == ROOM_TYPE_ENEMY and roomDef.nDepth > self.nMaxDepth then
			self.nMaxDepth = roomDef.nDepth
		end

		local vMins = vCenter - roomDef.vSize / 2
		local vMaxs = vCenter + roomDef.vSize / 2
		self.rooms[ roomDef.name ] = CMapRoom( roomDef.name, roomDef.nRoomType, roomDef.nDepth, vMins, vMaxs, vCenter )

		local nGoldValue = ENCOUNTER_DEPTH_GOLD_REWARD[ roomDef.nDepth + 1 ]

		local RewardPossibilites = deepcopy( ROOM_CHOICE_REWARDS )
		ShuffleListInPlace( RewardPossibilites, self.hMapRandomStream )

		-- Have to normalize since the original set of rewards is *not* exactly normalized
		NormalizeFloatArrayInPlace( RewardPossibilites, 100.0 )

		-- If the side exit was previously assigned, remove it from the list of possible rewards
		if self.RoomRewards[ roomDef.exit_side ] ~= nil then
			RewardPossibilites[ self.RoomRewards[ roomDef.exit_side ] ] = nil
			NormalizeFloatArrayInPlace( RewardPossibilites, 100.0 )
		end

		if ( roomDef.exit_up ~= nil ) then
			self.rooms[ roomDef.name ]:AddExit( ROOM_EXIT_TOP, roomDef.exit_up )

			if self.RoomRewards[ roomDef.exit_up ] == nil then
				self.RoomRewards[ roomDef.exit_up ] = self:AssignRoomReward( roomDef.exit_up, RewardPossibilites )
			end
			
			-- Remove the reward assigned to exit_up as a possibility for exit_side
			if self.RoomRewards[ roomDef.exit_up ] ~= nil then
				RewardPossibilites[ self.RoomRewards[ roomDef.exit_up ] ] = nil
			end
			NormalizeFloatArrayInPlace( RewardPossibilites, 100.0 )
		end

		if ( roomDef.exit_side ~= nil ) then

			-- Deal with map flip
			local exitDirection = ROOM_EXIT_LEFT
			if MAP_ATLAS[ roomDef.exit_side ].vCenter.x < roomDef.vCenter.x then
				if self.bMapFlipped then
					exitDirection = ROOM_EXIT_RIGHT
				end
			else
				if not self.bMapFlipped then
					exitDirection = ROOM_EXIT_RIGHT
				end				
			end

			self.rooms[ roomDef.name ]:AddExit( exitDirection, roomDef.exit_side )

			if self.RoomRewards[ roomDef.exit_side ] == nil then
				self.RoomRewards[ roomDef.exit_side ] = self:AssignRoomReward( roomDef.exit_side, RewardPossibilites )
			end
		end

		if ( roomDef.nRoomType == ROOM_TYPE_ENEMY ) and ( roomDef.bCannotBeTrap == nil or roomDef.bCannotBeTrap == false ) then
			table.insert( vecPotentialTrapRooms[ self.rooms[ roomDef.name ].nAct ], roomDef.name )
		end

		local bSuppress = ( roomDef.nDepth == 2 )
		if ( not roomDef.bCannotBeElite ) and ( bSuppress == false ) then
			table.insert( vecHiddenRooms[ self.rooms[ roomDef.name ].nAct ], roomDef.name )
		end	
	end

	for nAct=1,3 do

		-- Assign trap rooms
		for nTrapRoom=1, MAP_TRAP_ROOMS_PER_ACT[nAct] do
			local nPick = self.hMapRandomStream:RandomInt( 1, #vecPotentialTrapRooms[nAct] )
			--print( "Selecting trap room option " ..  vecPotentialTrapRooms[nAct][nPick] )
			self.rooms[ vecPotentialTrapRooms[nAct][nPick] ].nRoomType = ROOM_TYPE_TRAPS
			table.remove( vecPotentialTrapRooms[nAct], nPick )		
		end

		-- Assign hidden rooms
		for nHiddenRoom=1, MAP_HIDDEN_ENCOUNTERS_PER_ACT[nAct] do
			local nPick = self.hMapRandomStream:RandomInt( 1, #vecHiddenRooms[nAct] )
			local szHiddenRoomName = vecHiddenRooms[nAct][nPick]
			--print( "Selecting hidden room option " ..  szHiddenRoomName )
			self.rooms[ szHiddenRoomName ]:SetHidden( )
			table.remove( vecHiddenRooms[nAct], nPick )

			-- Make sure no room has 2 hidden exits
			local vecSiblingRoomNames = self:GetSiblingRoomNames( szHiddenRoomName )
			for s=1,#vecSiblingRoomNames do
				for h=1,#vecHiddenRooms[nAct] do
					if vecHiddenRooms[nAct][h] == vecSiblingRoomNames[s] then
						--print( "Removing hidden room option " ..  vecHiddenRooms[nAct][h] )
						table.remove( vecHiddenRooms[nAct], h )
						break
					end
				end
			end
		end	

		local nNumCrystalsPerAct = 2
		if nAct == 3 then
			nNumCrystalsPerAct = 1
		end

		local crystalDepthsAssigned = {}
		for nCrystalRoom=1,nNumCrystalsPerAct do
			local bAssigned = false
			while bAssigned == false do
				local nPick = self.hMapRandomStream:RandomInt( 1, #vecPotentialTrapRooms[nAct] )
				local szCrystalRoom = vecPotentialTrapRooms[nAct][nPick] 
				local nDepth = self.rooms[ szCrystalRoom ]:GetDepth()
				if crystalDepthsAssigned[ tostring(nDepth) ] == nil then
					self.rooms[ szCrystalRoom ].bHasCrystal = true
					print( "assigning " .. szCrystalRoom .. " a crystal " ) 
					crystalDepthsAssigned[ tostring(nDepth) ] = true
					bAssigned = true
				end
				table.remove( vecPotentialTrapRooms[nAct], nPick )
			end
		end
	end

	for k,v in pairs ( self.rooms ) do
		v:SetRoomChoiceReward( self.RoomRewards[ v:GetName() ] )
		if self.RoomRewards[ v:GetName() ] ~= nil then
			print( "Room " .. v:GetName() .. " reward: " .. self.RoomRewards[ v:GetName() ]  )
		end
	end
end

--------------------------------------------------------------------------------
function CAghanim:IsEncounterDefAppropriateForRoom( encounterDef, room )

	if room:GetType() ~= encounterDef.nEncounterType then
		return false
	end

	local requiredDepth = room:GetDepth()
	if ( requiredDepth < encounterDef.nMinDepth ) or ( requiredDepth > encounterDef.nMaxDepth ) then
		return false
	end

	return true

end

--------------------------------------------------------------------------------

-- Allocates the room layout
function CAghanim:AssignEncountersToRooms()

	local vecAlreadySelectedEncounters = {}
	for k,room in pairs(self.rooms) do

		local vecEncounterOptions = {}

		while true do

			local bSkippedOptions = false
			for encounterName,encounterDef in pairs(ENCOUNTER_DEFINITIONS) do 

				if not self:IsEncounterDefAppropriateForRoom( encounterDef, room ) then
					goto continue
				end

				if vecAlreadySelectedEncounters[ encounterName ] == true then
					bSkippedOptions = true
					goto continue 
				end

				-- Make sure no room has the same encounter on both exits,
				-- possible because we're shipping with only 3 options in act 3
				local vecSiblingRoomNames = self:GetSiblingRoomNames( room:GetName() )
				for s=1,#vecSiblingRoomNames do
					local szOtherEncounterName = self.rooms[ vecSiblingRoomNames[s] ]:GetEncounterName()
					if szOtherEncounterName == encounterName then
						--print( "Suppressing duplicate encounter " .. szOtherEncounterName .. " in room " .. room:GetName() )
						goto continue 	
					end
				end

				table.insert( vecEncounterOptions, encounterName )
				::continue::
			end

			if #vecEncounterOptions > 0 then
				break
			end

			-- This logic causes us to re-use encounters if we've already used them all once
			if bSkippedOptions == false then
				vecEncounterOptions = { "encounter_test_immediate_victory" }
				break
			else	
				for encounterName,encounterDef in pairs(ENCOUNTER_DEFINITIONS) do 

					if self:IsEncounterDefAppropriateForRoom( encounterDef, room ) then
						vecAlreadySelectedEncounters[ encounterName ] = nil
					end
				end

			end
		end

		-- FOR DEBUGGING, USE A FIXED ENCOUNTER LAYOUT WITH SPECIFIC DUPES
		if USE_ENCOUNTER_FIXED_LAYOUT == true then
			vecEncounterOptions = { ENCOUNTER_FIXED_LAYOUT[room:GetName()] }
			room.nRoomType = ENCOUNTER_DEFINITIONS[ vecEncounterOptions[1] ].nEncounterType
		end

		if self._szDevEncounter and room:GetName() == "a1_2a" then
			vecEncounterOptions = { self._szDevEncounter }
			room.nRoomType = ENCOUNTER_DEFINITIONS[ vecEncounterOptions[1] ].nEncounterType
		end
		
		if #vecEncounterOptions > 0 then
			local nPick = self.hMapRandomStream:RandomInt( 1, #vecEncounterOptions )
			room:AssignEncounter( vecEncounterOptions[nPick] )
			vecAlreadySelectedEncounters[ vecEncounterOptions[nPick] ] = true
		else
			print( "Unable to find valid encounter for room " .. k  )
		end
	end
end

--------------------------------------------------------------------------------

-- Sets up the spawn locations for the players
function CAghanim:SetupSpawnLocations()

	if ( not self.bMapFlipped ) then
		return
	end

	local hLeftEnt = Entities:FindByName( nil, "a1_1a_teamspawn_left" )
	if hLeftEnt == nil then
		print( "Unable to find a1_1a_teamspawn_left" )
	end

	local hRightEnt = Entities:FindByName( nil, "a1_1a_teamspawn_right" )
	if hRightEnt == nil then
		print( "Unable to find a1_1a_teamspawn_right" )
	end

	local vOffset = hRightEnt:GetAbsOrigin() - hLeftEnt:GetAbsOrigin()

	local hPlayerStarts = Entities:FindAllByClassname( "info_player_start_goodguys" )
	if #hPlayerStarts == 0 then
		print( "Failed to find any info_player_start_goodguys entities" )
	end

	for i=1, #hPlayerStarts do
		local vNewPosition = hPlayerStarts[i]:GetAbsOrigin() + vOffset
		hPlayerStarts[i]:SetAbsOrigin( vNewPosition )
	end

	local entitiesToFlip = 
	{
		"encounter_end_locator",
		"encounter_boss_preview_locator",	
		"encounter_outpost_1_override",	
		"encounter_outpost_2_override",	
	}

	for i=1, #entitiesToFlip do

		local hLocator = Entities:FindByName( nil, entitiesToFlip[i] )
		if hLocator ~= nil then
			local vNewPosition = hLocator:GetAbsOrigin()
			vNewPosition.x = -vNewPosition.x
			hLocator:SetAbsOrigin( vNewPosition )
		end

	end
end

--------------------------------------------------------------------------------

function CAghanim:FindRoomBySpawnGroupHandle( hSpawnGroupHandle )

	for k,room in pairs(self.rooms) do
		if room:GetSpawnGroupHandle() == hSpawnGroupHandle then
			return room
		end
	end

	return nil
end

--------------------------------------------------------------------------------

function CAghanim:GetExitOptionData( nOptionNumber )

	if self:GetCurrentRoom() == nil then
		print( "GetExitOptionData has no room")
		return nil
	end

	local exits = {}
	local exitDirections = {}
	local exitLocations = {}

	for direction=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do

		local room = self:GetCurrentRoom():GetExit( direction )
		local vExitLocation = self:GetCurrentRoom():GetExitLocation( direction )
		if ( room ~= nil ) then
			table.insert( exits, self:GetRoom( room ) )
			table.insert( exitDirections, direction )
			table.insert( exitLocations, vExitLocation )
		end
	end

	-- No exits? we're done
	if #exits == 0 then
		return nil
	end

	-- Gotta do this before we tweak the option number for the rest of this algorithm
	local hOverrideLocators = self:GetCurrentRoom():FindAllEntitiesInRoomByName( "encounter_outpost_" .. nOptionNumber .. "_override" )

	if ( nOptionNumber > #exits ) then
		nOptionNumber = #exits
	end

	local hRequestedExit = exits[nOptionNumber]
	local strPreviewUnit = hRequestedExit:GetEncounter():GetPreviewUnit()
	local hAscensionAbilities = hRequestedExit:GetEncounter():GetAscensionAbilities()
	local szAscensionAbilities = ""
	for i = 1,#hAscensionAbilities do
		if i ~= 1 then
			szAscensionAbilities = szAscensionAbilities .. ";"
		end
		szAscensionAbilities = szAscensionAbilities .. hAscensionAbilities[i] 
	end

	local exitData =
	{
		nExitDirection = exitDirections[nOptionNumber],
		vExitLocation = exitLocations[nOptionNumber],
		szEncounterPreviewUnit = strPreviewUnit,
		flEncounterPreviewModelScale = ENCOUNTER_PREVIEW_SCALES[ strPreviewUnit ],
		nEncounterType = hRequestedExit:GetType(),
		bIsEliteEncounter = ( hRequestedExit:GetEliteRank() > 0 ),
		szNextRoomName = hRequestedExit:GetName(),
		szRewardType = hRequestedExit:GetRoomChoiceReward(),
		szEncounterName = hRequestedExit:GetEncounter():GetName(),
		szAscensionNames = szAscensionAbilities,
		nExitCount = #exits,
		nDepth = hRequestedExit:GetDepth(),
		flZOffset = 0,
	}

	--if self:GetCurrentRoom():GetExitReward( nOptionNumber ) then
--		print( "Exit option " .. nOptionNumber .. " for room " .. self:GetCurrentRoom().szRoomName  .. " has reward type " .. exits[nOptionNumber]:GetRoomChoiceReward() .. " in room " .. exits[nOptionNumber].szRoomName )
--	end

	if exitData.flEncounterPreviewModelScale == nil then
		exitData.flEncounterPreviewModelScale = 1.0
	end

	if #hOverrideLocators > 0 then
		exitData.vOverrideLocation = hOverrideLocators[1]:GetAbsOrigin()
	end

	if exits[nOptionNumber]:IsHidden() then
		exitData.szEncounterPreviewUnit = "models/ui/exclamation/questionmark.vmdl"
		exitData.flEncounterPreviewModelScale = 0.0015
		if exitData.nEncounterType == ROOM_TYPE_TRAPS then
			exitData.bIsEliteEncounter = hRequestedExit:ShouldDisplayHiddenAsElite()
		end
		exitData.nEncounterType = ROOM_TYPE_ENEMY
		exitData.flZOffset = 25
	end

	return exitData
end

--------------------------------------------------------------------------------

function CAghanim:OnNextRoomSelected( event )
	self:GetCurrentRoom():OnNextRoomSelected( event.selected_room )
end

--------------------------------------------------------------------------------

-- Evaluate the state of the game
function CAghanim:OnThink()

	local nGameState = GameRules:State_Get()
	if nGameState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:ComputeHasNewPlayers()
		if not self.bStreamedStartingRoomExits then
			-- Stream the starting room exits here so people don't have to wait for those
			-- First exits to appear, gives more time for the streamer to do its work too
			self.bStreamedStartingRoomExits = true
			local room = self:GetStartingRoom()
			if room ~= nil then
				self:SetCurrentRoom( room )
				room:LoadExitRooms()
			end
		end
	elseif nGameState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if self:GetCurrentRoom() and self:GetCurrentRoom():GetEncounter() and self:GetCurrentRoom():GetEncounter():HasStarted() and self:GetCurrentRoom():GetEncounter():NeedsToThink() then
			self:GetCurrentRoom():GetEncounter():OnThink()
			self:_CheckForDefeat()
		end
	elseif nGameState >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	--CustomNetTables:SetTableValue( "special_ability_upgrades", tostring( 0 ), SPECIAL_ABILITY_UPGRADES[szHeroName] )
	return 1
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CAghanim:ForceAssignHeroes()

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				hPlayer:MakeRandomHeroSelection()
			end
		end
	end

end

--------------------------------------------------------------------------------

function CAghanim:SetCurrentRoom( hRoom )
	if hRoom ~= self.CurrentRoom then
		self.CurrentRoom = hRoom
		self.flCurrentRoomChangeTime = GameRules:GetGameTime()

		for k,v in pairs ( self.rooms ) do
			v:SendRoomToClient()
		end

		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				self:RegisterEncounterStartStats( nPlayerID, hRoom:GetDepth() )
			end
		end

	end
end

--------------------------------------------------------------------------------

function CAghanim:GetCurrentRoom()
	return self.CurrentRoom
end

--------------------------------------------------------------------------------

function CAghanim:GetCurrentRoomChangeTime()
	return self.flCurrentRoomChangeTime
end

--------------------------------------------------------------------------------

function CAghanim:GetRoom( szRoomName )
	return self.rooms[ szRoomName ]
end

--------------------------------------------------------------------------------

function CAghanim:GetRoomList()
	return self.rooms
end
 
--------------------------------------------------------------------------------

function CAghanim:FindRoomForPoint( vPoint )
	for _,room in pairs(self.rooms) do
		if room:IsInRoomBounds( vPoint ) then
			return room
		end
	end
	return nil
end

--------------------------------------------------------------------------------

function CAghanim:GetMaxDepth()
	return self.nMaxDepth
end
 
--------------------------------------------------------------------------------

function CAghanim:IsMapFlipped()
	return self.bMapFlipped
end
 
 --------------------------------------------------------------------------------

function CAghanim:GetBossUnitForAct( nAct )
	for _,room in pairs(self.rooms) do
		if room:GetType() == ROOM_TYPE_BOSS then
			if room:GetAct() == nAct then
				return room:GetEncounter():GetPreviewUnit()
			end
		end
	end

	return nil
end
 
--------------------------------------------------------------------------------

function CAghanim:AddFowOutlineBlocker( vMins, vMaxs )
	self.hFowBlockerRegion:AddRectangularOutlineBlocker( vMins, vMaxs, false )
end
 
--------------------------------------------------------------------------------

function CAghanim:ClearFowBlockers( vMins, vMaxs )
	self.hFowBlockerRegion:AddRectangularBlocker( vMins, vMaxs, true )
end

--------------------------------------------------------------------------------

function CAghanim:AddMinorAbilityUpgrade( hHero, upgradeTable )
	print( "Adding minor ability upgrade for playerID " .. hHero:GetPlayerOwnerID() )
	--PrintTable( upgradeTable, "upgrade" )

	if hHero.MinorAbilityUpgrades == nil then
		hHero.MinorAbilityUpgrades = {}
	end

	local szAbilityName = upgradeTable[ "ability_name" ]
	if hHero.MinorAbilityUpgrades[ szAbilityName ] == nil then
		hHero.MinorAbilityUpgrades[ szAbilityName ] = {}
	end

	local szSpecialValueName = upgradeTable[ "special_value_name" ]
	if hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ] == nil then
		hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ] = {}
	end

	local newUpgradeTable = {}
	newUpgradeTable[ "operator" ] = upgradeTable[ "operator" ]
	newUpgradeTable[ "value" ] = upgradeTable[ "value" ]
	table.insert( hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ], newUpgradeTable )

	CustomNetTables:SetTableValue( "minor_ability_upgrades", tostring( hHero:GetPlayerOwnerID() ), hHero.MinorAbilityUpgrades )

	--PrintTable( hHero.MinorAbilityUpgrades, " -- " )

	local Buff = hHero:FindModifierByName( "modifier_minor_ability_upgrades" )
	if Buff == nil then
		print( "Error - No minor ability upgrade buff!" )
		return
	end
	Buff:ForceRefresh()

	local hAbility = hHero:FindAbilityByName( upgradeTable[ "ability_name"] )
	if hAbility ~= nil then
		if hAbility:GetIntrinsicModifierName() ~= nil then
			local hIntrinsicModifier = hHero:FindModifierByName( hAbility:GetIntrinsicModifierName() )
			if hIntrinsicModifier then
				print( "Force Refresh intrinsic modifier after minor upgrade" )
				hIntrinsicModifier:ForceRefresh()
			end
		end
	end
end
--------------------------------------------------------------------------------

function CAghanim:VerifyStatsAbility( hHero, szAbilityName )
	--print( "Verifying stats upgrade for playerID " .. hHero:GetPlayerOwnerID() )
	if hHero == nil or szAbilityName == nil then
		return
	end

	local hAbility = hHero:FindAbilityByName(szAbilityName)
	if hAbility == nil then
		hAbility = hHero:AddAbility(szAbilityName)
	 	hAbility:UpgradeAbility( true )
	 	--printf("Adding Stats Ability...", szAbilityName)
	 end

	-- Currently there's only one buff for all the stats, so just refresh it here.
	-- If we decide to spread them out, the buffs should be refreshed based on their ability.
	local StatsBuff = hHero:FindModifierByName( "modifier_aghsfort_minor_stats_upgrade" )
 	if StatsBuff == nil then
		print( "Error - No minor ability upgrade buff!" )
		return
	end
	StatsBuff:ForceRefresh()

	 return
   

end

--------------------------------------------------------------------------------

function CAghanim:GetFragmentDropEV()
	local fDropEV = 0
	for _, odds in pairs( ARCANE_FRAGMENT_RANDOM_DROP_CHANCES ) do
		fDropEV = fDropEV + ( ( odds.high_chance - odds.low_chance ) * odds.num_fragments )
	end
	fDropEV = fDropEV / 100

	print( 'CAghanim:GetFragmentDropEV() calculated an average number of drops: ' .. fDropEV )

	return fDropEV
end

--------------------------------------------------------------------------------

function CAghanim:RollRandomFragmentDrops()
	local fRoll = RandomFloat( 0, 100.0 )
	print( 'CAghanim:RollRandomFragmentDrops() rolled a ' .. fRoll )

	for _, odds in pairs( ARCANE_FRAGMENT_RANDOM_DROP_CHANCES ) do
		if fRoll >= odds.low_chance and fRoll <= odds.high_chance then
			print( 'CAghanim:RollRandomFragmentDrops() selecting ' .. odds.num_fragments .. ' fragment drops for this room' )
			return odds.num_fragments
		end
	end

	print( 'WARNING: CAghanim:RollRandomFragmentDrops() did not find a valid entry for this roll ' .. fRoll )
	return 0
end

--------------------------------------------------------------------------------

function CAghanim:RollRandomNeutralItemDrops( hEncounter )
	if self.nNumNeutralItems <= 0 then
		return 0
	end

	local nPctChance = ( 100 * self.nNumNeutralItems ) / self.nNumViableRoomsForItems
	local nItemsToDrop = 0
	while hEncounter:RoomRandomInt( 1, 100 ) < nPctChance do
		nItemsToDrop = nItemsToDrop + 1

		if nItemsToDrop == 2 then
			break
		end

		local nRemainingItems = self.nNumNeutralItems - nItemsToDrop
		if nRemainingItems < self.nNumViableRoomsForItems then
			nPctChance = PCT_BASE_TWO_ITEM_DROP
		else
			nPctChance = ( nRemainingItems / self.nNumViableRoomsForItems ) * 100
		end
	end

	nItemsToDrop = math.min( self.nNumNeutralItems, nItemsToDrop )
	self.nNumNeutralItems = self.nNumNeutralItems - nItemsToDrop
	self.nNumViableRoomsForItems = self.nNumViableRoomsForItems - 1 
	return nItemsToDrop
end


--------------------------------------------------------------------------------

function CAghanim:PrepareNeutralItemDrop( hRoom, bElite )

	local nDepth = hRoom:GetDepth()
	local vecPotentialItems = GetPricedNeutralItems( nDepth, bElite )
	local vecFilteredItems = GameRules.Aghanim:FilterPreviouslyDroppedItems( vecPotentialItems )

	local vecTable = vecFilteredItems
	if #vecTable == 0 then
		print( "WARNING! All potential items have been dropped, falling back to original depth list. ")
		vecTable = vecPotentialItems
		if #vecPotentialItems == 0 then
			print( "WARNING! trying to drop a neutral item in a place where there is no priced list, depth " .. nDepth )
			return nil
		end
	end

	local szItemDrop = vecFilteredItems[ hRoom:RoomRandomInt( 1, #vecFilteredItems ) ]
	if szItemDrop == nil then
		return nil
	end
	
	if self:GetTestEncounterDebugRoom() ~= nil then
		print( "adding neutral item to debug crate:" .. szItemDrop ) 
		table.insert( self.debugItemsToStuffInCrate.RoomReward, szItemDrop )
	end	

	self:MarkNeutralItemAsDropped( szItemDrop )
	return szItemDrop
end

--------------------------------------------------------------------------------

function CAghanim:MarkNeutralItemAsDropped( szItemName )
	table.insert( self.DroppedNeutralItems, szItemName )
end

--------------------------------------------------------------------------------

function CAghanim:FilterPreviouslyDroppedItems( vecPotentialItems )
	for i = #vecPotentialItems,1,-1 do
		local szItemName = vecPotentialItems[ i ] 
		for _,szDroppedItemName in pairs ( self.DroppedNeutralItems ) do
			if szItemName == szDroppedItemName then
				table.remove( vecPotentialItems, i )
			end
		end
	end

	return vecPotentialItems
end

--------------------------------------------------------------------------------

function CAghanim:RegisterSummonForAghanim( nDepth, szUnitName )
	local Summon = {}
	Summon[ "depth" ] = nDepth
	Summon[ "unit_name" ] = szUnitName
	table.insert( self.AghanimSummons, Summon )
end

--------------------------------------------------------------------------------

function CAghanim:GetSummonsForAghanim()
	return self.AghanimSummons
end

--------------------------------------------------------------------------------

function CAghanim:InitializeMetagame()
	self.SignOutTable = {}
	self.SignOutTable[ "event_name" ]  = "aghanim"
	self.SignOutTable[ "player_list" ] = {}
	self.SignOutTable[ "team_depth_list" ] = {}

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local SignOutPlayer = 
		{
			steam_id = 0,
			hero_id = 0,
			battle_points = 0,
			arcane_fragments = 0,
			bonus_arcane_fragments = 0,
			current_ascension_level = 0,
			blessings = {},
			depth_list = {},
		}
		table.insert( self.SignOutTable[ "player_list" ], nPlayerID, SignOutPlayer )

		local netTable = {}
		netTable[ "arcane_fragments" ] = 0
		netTable[ "battle_points" ] = 0
		CustomNetTables:SetTableValue( "currency_rewards", tostring( nPlayerID ), netTable )
	end
end

--------------------------------------------------------------------------------

function CAghanim:RegisterEncounterStats( stats )

	if stats.selectedRoom == nil and stats.unselectedRoom == nil then
		return
	end

	local depthInfo = {}

	if stats.selectedRoom ~= nil then
		depthInfo.selected_encounter = stats.selectedRoom.szEncounterName
		depthInfo.selected_elite = stats.selectedRoom.bIsElite
		depthInfo.selected_hidden = stats.selectedRoom.bIsHidden
		depthInfo.selected_reward = stats.selectedRoom.szReward
		depthInfo.selected_encounter_type = stats.selectedRoom.nRoomType

		if stats.selectedRoom.ascensionAbilities ~= nil and #stats.selectedRoom.ascensionAbilities > 0 then
			depthInfo.ascension_abilities = {}
			for i=1,#stats.selectedRoom.ascensionAbilities do
				local szAscensionAbility = stats.selectedRoom.ascensionAbilities[i]
				depthInfo.ascension_abilities[ szAscensionAbility ] = GetAbilityTextureNameForAbility( szAscensionAbility )
			end
		end

	end

	if stats.unselectedRoom ~= nil then
		depthInfo.unselected_encounter = stats.unselectedRoom.szEncounterName
		depthInfo.unselected_elite = stats.unselectedRoom.bIsElite
		depthInfo.unselected_hidden = stats.unselectedRoom.bIsHidden
		depthInfo.unselected_reward = stats.unselectedRoom.szReward
	end

	self.SignOutTable[ "team_depth_list" ][ stats.depth ] = depthInfo

end

--------------------------------------------------------------------------------

function CAghanim:RegisterBlessingStat( nPlayerID, szBlessingName, nLevel, szActionName, nOrder )	
	self.SignOutTable[ "player_list" ][ nPlayerID ].blessings[szBlessingName] = nLevel

	local blessings = CustomNetTables:GetTableValue( "game_global", "blessings" )
	if blessings[ tostring( nPlayerID) ] == nil then
		blessings[ tostring( nPlayerID ) ] = {}
	end	

	blessings[ tostring( nPlayerID ) ][ szActionName ] = nOrder
	CustomNetTables:SetTableValue( "game_global", "blessings", blessings )
end

--------------------------------------------------------------------------------

function CAghanim:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )

	if self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth] == nil then
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth] = {}
	end

end

--------------------------------------------------------------------------------

function CAghanim:RegisterRewardStats( nPlayerID, szRoomDepth, stats )
	
	self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
 
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].rarity = stats.selected_reward.rarity
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].selected_reward = stats.selected_reward.ability_name
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].selected_reward_value = stats.selected_reward.value
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].selected_reward_texture = stats.selected_reward.ability_texture

	for nIndex = 1,#stats.unselected_rewards do
		local keyName = "unselected_reward" .. nIndex
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth][ keyName ] = stats.unselected_rewards[ nIndex ].ability_name
	end

end

--------------------------------------------------------------------------------

function CAghanim:RegisterEncounterStartStats( nPlayerID, nDepth )
	
	local szRoomDepth = tostring( nDepth )
	self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
 
 	if self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].net_worth ~= nil then
 		return
 	end

	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].net_worth = PlayerResource:GetNetWorth( nPlayerID )
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].level = PlayerResource:GetLevel( nPlayerID )
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].death_count = 0
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].kills = 0
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].gold_bags = 0

	--PrintTable( self.SignOutTable[ "player_list" ][ nPlayerID ] )
end

--------------------------------------------------------------------------------

function CAghanim:RegisterPlayerDeathStat( nPlayerID, nDepth )
	
	local scores = CustomNetTables:GetTableValue( "aghanim_scores", tostring(nPlayerID) )
	scores.death_count = scores.death_count + 1
	CustomNetTables:SetTableValue( "aghanim_scores", tostring(nPlayerID), scores )

	local szRoomDepth = tostring( nDepth )
	self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
 
 	if self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].death_count == nil then
 		return
 	end

	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].death_count = 
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].death_count + 1

	--PrintTable( self.SignOutTable[ "player_list" ][ nPlayerID ] )
end

--------------------------------------------------------------------------------

function CAghanim:GetConnectedPlayers( )
	local connectedPlayers = {}
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			if PlayerResource:IsValidPlayerID( nPlayerID ) and PlayerResource:GetConnectionState( nPlayerID ) ~= DOTA_CONNECTION_STATE_ABANDONED then
				table.insert( connectedPlayers, nPlayerID )
			end
		end
	end
	return connectedPlayers
end

--------------------------------------------------------------------------------

function CAghanim:GrantAllPlayersPoints( nPoints, bBattlePoints, szReason )

	local vecPoints = {}

	local connectedPlayers = self:GetConnectedPlayers()
	for i=1,#connectedPlayers do
		local nPlayerID = connectedPlayers[i]
		vecPoints[ tostring(nPlayerID) ] = self:GrantPlayerPoints( nPlayerID, nPoints, bBattlePoints, szReason )
	end

	return vecPoints

end

--------------------------------------------------------------------------------

function CAghanim:GrantPlayerPoints( nPlayerID, nDesiredPoints, bBattlePoints, szReason )
	local Hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )

	-- Clamps the amount of points to the amount remaining
	-- QUESTION: Should this also multiply the fragments by the bonus? 
	-- If so, we need to fix the GC to not do the 2x bonus grant,
	-- or change the display to not match the underlying grant amount sent to the GC
	local nPoints = self:RegisterCurrencyGrant( nPlayerID, nDesiredPoints, bBattlePoints )			
	if nPoints == 0 then
		return 0
	end

	local nDigits = string.len( tostring( nPoints ) )
	if bBattlePoints then
		print ( "Awarding player " .. nPlayerID .. " " .. nPoints .. " battle points for " .. szReason )
		self.SignOutTable[ "player_list" ][ nPlayerID ][ "battle_points" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "battle_points" ] + nPoints
		if Hero then	
			local nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/msg_fx/msg_bp.vpcf", PATTACH_CUSTOMORIGIN, nil, Hero:GetPlayerOwner() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, Hero, PATTACH_OVERHEAD_FOLLOW, nil, Hero:GetOrigin() + Vector( 0, 64, 96 ), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, nPoints, -1 ) )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, nDigits + 1, 0 ) )
			ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 255, 255, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nFXIndex2 = ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/battle_point_splash.vpcf", PATTACH_WORLDORIGIN, nil, Hero:GetPlayerOwner() )
			ParticleManager:SetParticleControl( nFXIndex2, 1, Hero:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex2 )
		end
	else
		print ( "Awarding player " .. nPlayerID .. " " .. nPoints .. " arcane fragments for " .. szReason )
		self.SignOutTable[ "player_list" ][ nPlayerID ][ "arcane_fragments" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "arcane_fragments" ] + nDesiredPoints
		self.SignOutTable[ "player_list" ][ nPlayerID ][ "bonus_arcane_fragments" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "bonus_arcane_fragments" ] + ( nPoints - nDesiredPoints )
		if Hero then	
			local nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/msg_fx/msg_bp.vpcf", PATTACH_CUSTOMORIGIN, nil, Hero:GetPlayerOwner() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, Hero, PATTACH_OVERHEAD_FOLLOW, nil, Hero:GetOrigin() + Vector( 0, 64, 96 ), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, nPoints, -1 ) )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, nDigits + 1, 0 ) )
			ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 0, 255, 255 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local nFXIndex2 = ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/arcane_fragments_splash.vpcf", PATTACH_WORLDORIGIN, nil, Hero:GetPlayerOwner() )
			ParticleManager:SetParticleControl( nFXIndex2, 1, Hero:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex2 )
		end
	end

	local netTable = {}
	netTable[ "arcane_fragments" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "arcane_fragments" ] + self.SignOutTable[ "player_list" ][ nPlayerID ][ "bonus_arcane_fragments" ]
	netTable[ "battle_points" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "battle_points" ]
	CustomNetTables:SetTableValue( "currency_rewards", tostring( nPlayerID ), netTable )

	return nPoints

end
 
 --------------------------------------------------------------------------------

function CAghanim:MarkGameWon()
	self.bWonGame = true

	printf("======== ENDING GAME - VICTORY ==========\n");
	self:GetAnnouncer():OnGameWon()
	GameRules.Aghanim:OnGameFinished()
	GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
end

--------------------------------------------------------------------------------

function CAghanim:_CheckForDefeat()
	if self.bPlayerHasSpawned == false then
		return
	end

	local bAnyHeroesAlive = false
	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil then
			-- TODO: make sure that servers will die when everyone DCs, since we don't want AFK checks for this mode 
			if Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and 
				( Hero:IsAlive() or Hero:IsReincarnating() or ( Hero:GetRespawnsDisabled() == false ) ) then
				bAnyHeroesAlive = true
			end
		end
	end

	if bAnyHeroesAlive == false then
		printf("======== ENDING GAME ==========\n");
		self:GetAnnouncer():OnGameLost()
		GameRules.Aghanim:OnGameFinished()
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
	end
	
end

--------------------------------------------------------------------------------

function CAghanim:Dev_WinGame()
	self:MarkGameWon()
end

--------------------------------------------------------------------------------

function CAghanim:Dev_WinEncounter()
	if self:GetCurrentRoom() and self:GetCurrentRoom():IsActivated() and self:GetCurrentRoom():GetEncounter() then
		self:GetCurrentRoom():GetEncounter():Dev_ForceCompleteEncounter()
	else
		printf( "ERROR - win_encounter command failed" )
	end
end

--------------------------------------------------------------------------------

function CAghanim:Dev_SetAscensionLevel( cmdName, szLevel )
	local nLevel = tonumber( szLevel ) 
	self:SetAscensionLevel( nLevel )
end

--------------------------------------------------------------------------------

function CAghanim:Dev_SetNewPlayers( cmdName, szNewPlayers )
	self.bHasAnyNewPlayers = tonumber( szNewPlayers ) > 0
end

--------------------------------------------------------------------------------

function CAghanim:Dev_ExtraLives()

	local nPlayerID = Entities:GetLocalPlayer():GetPlayerID()

	--for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
	--	if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero ~= nil then
				printf("adding lives to %d", nPlayerID)
				hPlayerHero.nRespawnsRemaining = math.min( AGHANIM_MAX_LIVES, hPlayerHero.nRespawnsRemaining + 1 )
				CustomGameEventManager:Send_ServerToPlayer( hPlayerHero:GetPlayerOwner(), "gained_life", {} )
				CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ),  { respawns = hPlayerHero.nRespawnsRemaining } )
			end
			
		--end
	--end
end

--------------------------------------------------------------------------------

function CAghanim:Dev_TestEncounter( cmdName, szEncounterName, szIsElite )

	local nEliteDepthBonus = 0
	if szIsElite ~= nil then
		nEliteDepthBonus = tonumber( szIsElite )
		if nEliteDepthBonus > 0 then
			nEliteDepthBonus = 1
		end
	end

	local encounterDef = ENCOUNTER_DEFINITIONS[ szEncounterName ]
	if encounterDef == nil then
		printf( "%s: Invalid encounter %s", cmdName, szEncounterName )
		return
	end

	local nRoomDepth = encounterDef.nMinDepth

	local hFinalRoom = self:GetCurrentRoom()
	if hFinalRoom == nil then
		printf( "%s: Can't use since we're still loading", cmdName )
		return
	end

	local nCurrDepth = hFinalRoom:GetDepth()

	if nRoomDepth <= nCurrDepth then
		printf( "%s: You're already at the same or lower depth %d than you requested [%d]", cmdName, nCurrDepth, nRoomDepth )
		return
	end

	printf( "Running %s %s %d %d [%s %d]...", cmdName, szEncounterName, nRoomDepth, nEliteDepthBonus, hFinalRoom:GetName(), nCurrDepth )
 
	-- Find the room we will do the encounter in, as well as the previous room
	self.testEncounter = 
	{
		hPrevPrevRoom = nil,	
		hPrevRoom = nil,
		hFinalRoom = hFinalRoom,
		rewardClaimList = {},
	}

	self.debugItemsToStuffInCrate = 
	{
		RoomReward = {}
	}

	for i=nCurrDepth+1, nRoomDepth do 

		-- Find the first valid exit
		self.testEncounter.hPrevPrevRoom = self.testEncounter.hPrevRoom
		self.testEncounter.hPrevRoom = self.testEncounter.hFinalRoom
		for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
			local szExitRoomName = self.testEncounter.hPrevRoom:GetExit( nExitDirection )
			if szExitRoomName ~= nil then
				self.testEncounter.hFinalRoom = GameRules.Aghanim:GetRoom( szExitRoomName )
				if self.testEncounter.hFinalRoom:GetDepth() ~= i then
					print( "unexpected depth in room " .. self.testEncounter.hFinalRoom:GetName() )
				end
				table.insert( self.testEncounter.rewardClaimList, self.testEncounter.hFinalRoom )
				break
			end
		end

	end

	-- Don't claim the room we're going to, not should we claim the one right before the selected room; 
	-- we're going to Dev_WinEncounter that one after teleporting there

	-- This is the target room
	table.remove( self.testEncounter.rewardClaimList, #self.testEncounter.rewardClaimList )

	-- This is the room before the target room
	if #self.testEncounter.rewardClaimList > 0 then
		table.remove( self.testEncounter.rewardClaimList, #self.testEncounter.rewardClaimList )
	end

	-- Win the current room assuming we haven't already won
	if self:GetCurrentRoom():GetDepth() ~= 1 and self:GetCurrentRoom():GetEncounter():IsComplete() == false then
		self:Dev_WinEncounter()
		self:GetCurrentRoom():GetEncounter():TryCompletingMapEncounter()
		self:GetCurrentRoom():GetEncounter():GenerateRewards()
	end

	-- Change the encounter in the final room to the desired one
	self.testEncounter.hFinalRoom:SetEliteDepthBonus( nEliteDepthBonus )
	self.testEncounter.hFinalRoom:AssignEncounter( szEncounterName )
	self.testEncounter.hFinalRoom:GetEncounter():SelectAscensionAbilities()

	-- We're going to be teleporting into the previous room, so we need to stream that in
	if self.testEncounter.hPrevPrevRoom ~= nil then
		self.testEncounter.hPrevPrevRoom:LoadExitRooms()
	end

	-- Also start the previous room streaming in the final room. Note that this can
	-- be done simultaneously as the prev prev room, since once LoadExitRooms was called,
	-- the system knows the height of the maps to spawn to correct connect to prev prev
	-- NOTE that if hPrevRoom == the current room, this will be the second call to
	-- LoadExitRooms on the same room, but the code is tolerant of that
	self.testEncounter.hPrevRoom:LoadExitRooms()

	-- Next we must start a think function where we do two things
	-- 1) Wait for the exit rooms to be loaded
	-- 2) Make all players claim rewards for all intervening rooms
	GameRules:GetGameModeEntity():SetThink( "OnTestEncounterThink", self, "TestEncounterThink", 0.5 )

end

--------------------------------------------------------------------------------

function CAghanim:GrantEstimatedRoomRewards( hRoom )

	local nMinValue, nMaxValue = GetMinMaxGoldChoiceReward( hRoom:GetEncounter():GetDepth(), false )
	local nQuantity = math.random( nMinValue, nMaxValue ) / 3	-- *1/3 since it's 1/3 likely you'll pick it

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			PlayerResource:ModifyGold( nPlayerID, nQuantity, true, DOTA_ModifyGold_Unspecified )
		end
	end

end

--------------------------------------------------------------------------------

function CAghanim:DetermineRewardSelectionState()

	local CurrentRoom = CustomNetTables:GetTableValue( "reward_options", "current_depth" )
	if CurrentRoom == nil then
		return nil
	end

	local szRoomDepth = CurrentRoom["1"];
	local rewardOptions = CustomNetTables:GetTableValue( "reward_options", szRoomDepth )
	if rewardOptions == nil then
		return nil
	end

	local netTable = CustomNetTables:GetTableValue( "reward_choices", szRoomDepth )
	if netTable == nil then
		return nil
	end

	local vecPlayerIDs = self:GetConnectedPlayers( )
	if #vecPlayerIDs == 0 then
		return nil
	end

	local rewardState = {}
	for i=1,#vecPlayerIDs do
		local nPlayerID = vecPlayerIDs[i]
		local bHasChosen = ( netTable[ tostring(nPlayerID) ] ~= nil )
		rewardState[ tostring(nPlayerID) ] = bHasChosen
	end

	return rewardState
end

--------------------------------------------------------------------------------

function CAghanim:HaveAllRewardsBeenSelected()

	local CurrentRoom = CustomNetTables:GetTableValue( "reward_options", "current_depth" )
	if CurrentRoom == nil then
		return false
	end

	local szRoomDepth = CurrentRoom["1"];

	--print( "HaveAllRewardsBeenSelected depth " .. szRoomDepth )

	-- Some depths don't give rewards. If we hit this, then it's ok; exit out.
	local rewardOptions = CustomNetTables:GetTableValue( "reward_options", szRoomDepth )
	if rewardOptions == nil then
		return true
	end

	--print( "Waiting for choices " )

	-- Check to see if all players have made choices yet at the current depth
	local netTable = CustomNetTables:GetTableValue( "reward_choices", szRoomDepth )
	if netTable == nil then
		return false
	end

	local vecPlayerIDs = self:GetConnectedPlayers( )
	for i=1,#vecPlayerIDs do
		local nPlayerID = vecPlayerIDs[i]
		if netTable[ tostring(nPlayerID) ] == nil then
			--print( "Player not done choosing " .. nPlayerID )
			return false
		end
	end

	return true
end


--------------------------------------------------------------------------------

function CAghanim:OnTestEncounterThink()

	-- First handle all rewards being selected
	local CurrentRoom = CustomNetTables:GetTableValue( "reward_options", "current_depth" )
	if CurrentRoom == nil then
		return 1
	end

	local szRoomDepth = CurrentRoom["1"];

	--print( "OnTestEncounterThink depth " .. szRoomDepth )

	if self:HaveAllRewardsBeenSelected() == false then
		return 1
	end

	-- Once all players have made a choice, deal with claiming the next depth
	--print( "Claiming next depth " )
	if #self.testEncounter.rewardClaimList > 0 then
	 	--print( "Claiming rewards for room " .. self.testEncounter.rewardClaimList[1]:GetName() .. " depth " .. self.testEncounter.rewardClaimList[1]:GetDepth() ) 
	 	if ( tonumber( szRoomDepth ) + 1 ) ~= self.testEncounter.rewardClaimList[1]:GetDepth() then
	 		printf( "Warning!! Unexpected depth in claim list [was %d, expected %d]!!", self.testEncounter.rewardClaimList[1]:GetDepth(), tonumber( szRoomDepth ) + 1 )
	 	end

		local hRoom = self.testEncounter.rewardClaimList[1]
		hRoom:GetEncounter():RegisterSummonForAghanim()
		hRoom:GetEncounter():GenerateRewards()
		self:GrantEstimatedRoomRewards( hRoom )
		table.remove( self.testEncounter.rewardClaimList, 1 )

		if self.bFastTestEncounter == true then
			for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
				if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
					-- Select the first option for each player
					local hChoice =
					{
						PlayerID = nPlayerID,
						room_depth = hRoom:GetDepth(),
						reward_index = 1,
					}
					OnRewardChoice( nil, hChoice )
				end
			end
		end

		return 1
	end

	-- If we're here, then all players have selected all rewards
	-- Next handle streaming of the rooms
	if self.testEncounter.hPrevPrevRoom ~= nil then
		--print( "Testing for stream in" .. self.testEncounter.hPrevPrevRoom:GetName() )
		if not self.testEncounter.hPrevPrevRoom:AreAllExitRoomsReady() then
			return 1
		end

		--print( "Selected " .. self.testEncounter.hPrevPrevRoom:GetName() .. " -> " .. self.testEncounter.hPrevRoom:GetName() )
		self.testEncounter.hPrevPrevRoom:OnNextRoomSelected( self.testEncounter.hPrevRoom:GetName() )
		self.testEncounter.hPrevPrevRoom = nil

		-- Wait for a tick to make sure all the spawn group shenanigans are done so we can teleport in
		return 1
	end

	if self:GetCurrentRoom() ~= self.testEncounter.hPrevRoom then

		if self.testEncounter.bHasTeleported then
			return 1
		end

		--print( "Testing for stream in" .. self.testEncounter.hPrevRoom:GetName() )
		if not self.testEncounter.hPrevRoom:AreAllExitRoomsReady() then
			return 1
		end

		-- teleport all players into the prev room, we're ready to go
		local vTeleportTarget = self.testEncounter.hPrevRoom:GetOrigin()
		local hEndLocators = self.testEncounter.hPrevRoom:FindAllEntitiesInRoomByName( "encounter_end_locator", true )
		if #hEndLocators > 0 then
			vTeleportTarget = hEndLocators[1]:GetAbsOrigin()
		end

		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
     			if hPlayerHero ~= nil then
     				FindClearSpaceForUnit( hPlayerHero, vTeleportTarget, true )
     				CenterCameraOnUnit( nPlayerID, hPlayerHero )
				end
			end
		end

		self.testEncounter.bHasTeleported = true
		return 1
	end

	-- Ok, we've teleported. Now we can finish the prev room and get its rewards
	self:Dev_WinEncounter()
	self.testEncounter = nil

	-- Disable thinking
	return nil
end

function CAghanim:GetTestEncounterDebugRoom()
	if self.testEncounter == nil then
		return nil
	end
	return self.testEncounter.hPrevRoom
end
