
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
if GetMapName() == "main" then
	require( "room_tables" )
else
	require( "room_tables_2021" )
end
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
	GameRules.Aghanim:GetAnnouncer():GetUnit():AddNewModifier( GameRules.Aghanim:GetAnnouncer():GetUnit(), nil, "modifier_announcer_ontakedamage", {} )
end

--------------------------------------------------------------------------------

function SpawnGroupPrecache( hSpawnGroup, context )
	--print( "SpawnGroupPrecache" )
	local room = GameRules.Aghanim:FindRoomBySpawnGroupHandle( hSpawnGroup )
	if room ~= nil then
		print( "Precaching room " .. room:GetName() .. "..." )
		if room:GetEncounter() then
			room:GetEncounter():Precache( context )
		end

		if GetMapName() == "hub" then 
			local ExitRoom = GameRules.Aghanim:GetRoom( room.szSingleExitRoomName )
			if ExitRoom then 
				if #ExitRoom.vecPotentialEncounters > 0 then
					for _,hEncounter in pairs ( ExitRoom.vecPotentialEncounters ) do
						if hEncounter and hEncounter.GetPreviewUnit ~= nil then
							--print( "precaching preview unit" )
							PrecacheUnitByNameSync( hEncounter:GetPreviewUnit(), context, -1 )
						end
					end
				end
			end
		end
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
	LinkLuaModifier( "modifier_npc_dialog", "modifiers/modifier_npc_dialog", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_npc_dialog_notify", "modifiers/modifier_npc_dialog_notify", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_trap_room_player", "modifiers/traps/heroes/modifier_trap_room_player", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_player_disabled", "modifiers/modifier_player_disabled", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_aghslab_monkey_king_boundless_strike_cast", "modifiers/creatures/modifier_aghslab_monkey_king_boundless_strike_cast", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_aghslab_monkey_king_primal_spring_cast", "modifiers/creatures/modifier_aghslab_monkey_king_primal_spring_cast", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_boss_tinker_laser_burn_thinker", "modifiers/creatures/modifier_boss_tinker_laser_burn_thinker", LUA_MODIFIER_MOTION_NONE ) -- Boss Tinker's Laser ability uses both C++ and Lua, might clean it up later
	LinkLuaModifier( "modifier_boss_tinker_laser_burn_debuff", "modifiers/creatures/modifier_boss_tinker_laser_burn_debuff", LUA_MODIFIER_MOTION_NONE ) -- Boss Tinker's Laser ability uses both C++ and Lua, might clean it up later
	LinkLuaModifier( "modifier_hero_ambient_effects", "modifiers/modifier_hero_ambient_effects", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_announcer_ontakedamage", "modifiers/modifier_announcer_ontakedamage", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_rescued_unit", "modifiers/modifier_rescued_unit", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_return_to_hub", "modifiers/modifier_return_to_hub", LUA_MODIFIER_MOTION_BOTH )
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
	self.bInVictorySequence = false
	self.nMaxDepth = 0
	self.rooms = {}
	self.RoomRewards = {}
	self.bMapFlipped = false

	self.nStartingLives = AGHANIM_STARTING_LIVES
	self.nMaxLives = AGHANIM_MAX_LIVES
	self.nCursedItemSlots = 0
	self.nGoldModifier = 100

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
	self:InitializeMetagame()
	self.hMapRandomStream = CreateUniformRandomStream( self.nSeed )
	self.hPlayerRandomStreams = {}

	math.randomseed( self.nSeed )

	--GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_CUSTOMUI_BEHIND_HUD_ELEMENTS, false );
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_DEFAULT_UI_AGHANIMS_STATUS, false );

	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )

	GameRules:SetEnableAlternateHeroGrids( false )
	GameRules:SetCustomGameSetupTimeout( 0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetTimeOfDay( 0.251 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetPreGameTime( 5.0 )
	GameRules:SetPostGameTime( 45.0 )
	GameRules:SetHeroSelectionTime( 90 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetStartingGold( AGHANIM_STARTING_GOLD )
	for nPlayerIDForGold = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerIDForGold ) then
			PlayerResource:SetGold( nPlayerIDForGold, AGHANIM_STARTING_GOLD, false )
		end
	end
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
	GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath( false )
	GameRules:SetAllowOutpostBonuses( false )
	GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered( true )
	GameRules:GetGameModeEntity():SetForcedHUDSkin( "aghanims_labyrinth_2021" )

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
	-- GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true ) -- This breaks the custom FoW shader
	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride( "item_bottle" )
	GameRules:GetGameModeEntity():SetInnateMeleeDamageBlockPerLevelAmount( MELEE_BLOCK_SCALING_VALUE )

	GameRules:GetGameModeEntity():SetSendToStashEnabled( false )
	self.hFowBlockerRegion = GameRules:GetGameModeEntity():AllocateFowBlockerRegion( -16384, -16384, 16384, 16384, 128 )
	
 	GameRules:SetCustomGameAllowHeroPickMusic( false )
 	GameRules:SetCustomGameAllowBattleMusic( false )
	GameRules:SetCustomGameAllowMusicAtGameStart( true )

	-- Make the camera not z clip 
	GameRules:GetGameModeEntity():SetCameraZRange( 11, 3800 )

	-- Set response rule flag for announcer to skip empty response groups
	Convars:SetBool( "rr_dacmode", true )

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
	ListenToGameEvent( "dota_watch_tower_captured", Dynamic_Wrap( CAghanim, "OnOutpostCaptured" ), self )
	ListenToGameEvent( "player_chat", Dynamic_Wrap( CAghanim, "OnPlayerChat" ), self )

	-- Filter Registration: Functions are found in filters.lua
	--GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( CAghanim, "HealingFilter" ), self )
	--GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CAghanim, "DamageFilter" ), self )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( CAghanim, "ItemAddedToInventoryFilter" ), self )
	GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap( CAghanim, "ModifierGainedFilter" ), self )
	GameRules:SetFilterMoreGold( true ) -- apply our gold filter to more than the usual set of stuff.
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( CAghanim, "FilterModifyGold" ), self )

	

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

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", AGHANIM_THINK_INTERVAL )

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

	
	if self.bIsInTournamentMode == true then
		self:SetAscensionLevel( AGHANIM_TRIAL_ASCENSION )
		print( "Tournament game difficulty is " .. self:GetAscensionLevel() )
	else		
		local nCustomGameDifficulty = GameRules:GetCustomGameDifficulty()
		if nCustomGameDifficulty > 0 then
			print( "Lobby game difficulty is " .. nCustomGameDifficulty )
			self:SetAscensionLevel( nCustomGameDifficulty - 1 )
		end
	end

	if self.bHasSetAscensionLevel == false then 
		self:SetAscensionLevel( AGHANIM_ASCENSION_APPRENTICE )
	end

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

	-- Listener for reward rerolls	
	CustomGameEventManager:RegisterListener( "reroll_rewards", function(...) return OnRewardReroll( ... ) end )

	
		
	-- Create announcer Unit
	local dummyTable = 
	{ 	
		MapUnitName = "npc_dota_announcer_aghanim", 
		teamnumber = DOTA_TEAM_GOODGUYS,
	}
	local hAnnouncer = CreateUnitFromTable( dummyTable, Vector( 0, 0, 0 ) )
	hAnnouncer:AddEffects( EF_NODRAW )
	if hAnnouncer then 
		print( "hAnnouncer spawned successfully!" )
	end

	self.BristlebackItems = {}
	self.hAutoChannelEventOutpostBuff = nil 
end

--------------------------------------------------------------------------------

function CAghanim:GetStartingLives()
	return self.nStartingLives
end

--------------------------------------------------------------------------------

function CAghanim:GetMaxLives()
	return self.nMaxLives
end

--------------------------------------------------------------------------------

function CAghanim:GetGoldModifier() 
	return self.nGoldModifier
end

--------------------------------------------------------------------------------

function CAghanim:GetStartingCursedItemSlots()
	return self.nCursedItemSlots
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

function CAghanim:SetHeroAvailability()
	local bAllHeroesAvailableInLocalGames = not Convars:GetBool("dota_aghslab_test_hero_unlocks_in_local_game")

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local unlocks = PlayerResource:GetLabyrinthEventGameHeroUnlocks( nPlayerID )
		if unlocks == nil or ( GetLobbyEventGameDetails() == nil and bAllHeroesAvailableInLocalGames ) then
			-- couldn't get the data from event.  Give all heroes to each player
			-- ult names is a proxy for all heroes
			for k,v in pairs( _G.ULTIMATE_ABILITY_NAMES ) do
				local nHeroID = DOTAGameManager:GetHeroIDByName( k )
				GameRules:AddHeroToPlayerAvailability( nPlayerID, nHeroID )
			end
		else
			-- unlock the heroes the user has
			for k,v in pairs( unlocks ) do
				GameRules:AddHeroToPlayerAvailability( nPlayerID, v )
			end
		end
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
		local nBonusPoints = nPoints * 3
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
	if scores ~= nil then
		scores.kills = scores.kills + 1
		CustomNetTables:SetTableValue( "aghanim_scores", tostring(nPlayerID), scores )
	end

	local szRoomDepth = tostring( nDepth )
	self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].kills = 
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].kills + 1

end

--------------------------------------------------------------------------------

function CAghanim:RegisterGoldBagCollectedStat( nPlayerID )

	local scores = CustomNetTables:GetTableValue( "aghanim_scores", tostring(nPlayerID) )
	-- scores was getting a nil value
	if scores ~= nil then
		scores.gold_bags = scores.gold_bags + 1
		CustomNetTables:SetTableValue( "aghanim_scores", tostring(nPlayerID), scores )

		if self:GetCurrentRoom() ~= nil then
			local szRoomDepth = tostring( self:GetCurrentRoom():GetDepth() )
			self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
			self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].gold_bags = 
				self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].gold_bags + 1
		end
	end

end

--------------------------------------------------------------------------------

function CAghanim:IncrementPlayerLivesPurchased( nPlayerID, nDepth )
	local szRoomDepth = tostring( nDepth )
	self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
	if self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].lives_purchased == nil then
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].lives_purchased = 0
	end
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].lives_purchased = 
		self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].lives_purchased + 1

	--printf( "$$ Player %d has bought %d lives at depth %d", nPlayerID, self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].lives_purchased, nDepth )
end

--------------------------------------------------------------------------------

function CAghanim:RegisterEventNPCInteractionStat( nPlayerID, nDepth, nEventOption )
	local szRoomDepth = tostring( nDepth )
	self:EnsurePlayerStatAtDepth( nPlayerID, szRoomDepth )
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].event_option = nEventOption
	--printf( "$$ Player %d event interaction at depth %d with response %d", nPlayerID, nDepth, nEventOption )
end

--------------------------------------------------------------------------------

function CAghanim:RegisterEventNPCAtDepthStat( nDepth, szEventNPCName )
	-- NOTE: Player depth stats, the depth is a string. But *Team* depth stats, the depth is an int.
	if self.SignOutTable[ "team_depth_list" ][ nDepth ] == nil then
		self.SignOutTable[ "team_depth_list" ][ nDepth ] = {}
	end
	self.SignOutTable[ "team_depth_list" ][ nDepth ].event_npc = szEventNPCName
	--printf( "$$ Event NPC %s is at depth %d", szEventNPCName, nDepth )
end

--------------------------------------------------------------------------------

function CAghanim:GetNewPlayerList( )

	self.bLostToPrimalBeast = true
	local vecPlayerIDs = {}
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) and PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local nGamePlayedCount = PlayerResource:GetEventGameCustomActionClaimCountByName( nPlayerID, "labyrinth_num_games_played" )
			if nGamePlayedCount < 2 then
				table.insert( vecPlayerIDs, nPlayerID )
			end
			if PlayerResource:GetEventGameCustomActionClaimCountByName( nPlayerID, "labyrinth_lost_to_beast" ) < 1 then
				self.bLostToPrimalBeast = false
			end
		end
	end
	return vecPlayerIDs

end

--------------------------------------------------------------------------------

function CAghanim:HaveAllPlayersLostToPrimalBeast( )
	return self.bLostToPrimalBeast or false
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

	-- Show new player popup for new players, but not in development
	local vecConnectedPlayers = self:GetConnectedPlayers()
	if #vecConnectedPlayers > 1 then 
		CustomNetTables:SetTableValue( "game_global", "new_players", vecPlayerIDs )
	end

	print( "New players " .. tostring( self.bHasAnyNewPlayers ) )

	-- Can't do this until we know whether we have new players
	if self:GetAnnouncer() then
		self:GetAnnouncer():OnHeroSelectionStarted()
	else
		print( "$$$$ ANNOUNCER NIL!!" )
	end
	
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
	netTable[ "x" ] = hRoom:GetOrigin().x
	netTable[ "y" ] = hRoom:GetOrigin().y
	netTable[ "size" ] = flSize

	if GetMapName() == "main" then 
		netTable[ "map_name" ] = hRoom:GetMapName()
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
	else
		local szDirName = "aghs2_encounters/"
		local szCurMapNameShort = string.sub( hRoom:GetMapName(), string.len( szDirName ) + 1, string.len( hRoom:GetMapName() ) )
		netTable[ "map_name" ] = szCurMapNameShort

		netTable[ "scale" ] = 7

		-- Per-Room Overrides
		if hRoom:GetMinimapOriginX() ~= nil then
			netTable[ "x" ] = hRoom:GetMinimapOriginX()
		end
		if hRoom:GetMinimapOriginY() ~= nil then
			netTable[ "y" ] = hRoom:GetMinimapOriginY()
		end
		if hRoom:GetMinimapSize() ~= nil then
			netTable[ "size" ] = hRoom:GetMinimapSize()
		end
		if hRoom:GetMinimapScale() ~= nil then
			netTable[ "scale" ] = hRoom:GetMinimapScale()
		end
		if hRoom:GetMinimapMapName() ~= nil then
			netTable[ "map_name" ] = hRoom:GetMinimapMapName()
		end
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
	Convars:RegisterCommand( "extra_lives", function(...) return self:Dev_ExtraLives( Entities:GetLocalPlayer():GetPlayerID() ) end, "Gives local player an extra life.", eCommandFlags )
	Convars:RegisterCommand( "aghanim_test_encounter", function(...) return self:Dev_TestEncounter( ... ) end, "Tests a specific encounter at a specific level", eCommandFlags )
	Convars:RegisterCommand( "fast_test_encounter", function(...) self.bFastTestEncounter = true; return self:Dev_TestEncounter( ... ) end, "Tests a specific encounter at a specific level", eCommandFlags )
	Convars:RegisterCommand( "set_new_players", function(...) return self:Dev_SetNewPlayers( ... ) end, "Sets whether there are new players or not", eCommandFlags )
	Convars:RegisterCommand( "aghanim_reset_encounter", function(...) self:Dev_ResetEncounter( ... ) end, "Resets aspects of an encounter. Must be implemented on a per-encounter basis", eCommandFlags )
	Convars:RegisterCommand( "kill_beast", function(...) return self:Dev_KillBeast( ... ) end, "Kills the Primal Beast", eCommandFlags )
	Convars:RegisterCommand( "damage_beast", function(...) return self:Dev_DamageBeast( ... ) end, "Damages the Primal Beast. Arg1 = damage amount", eCommandFlags )
	Convars:RegisterCommand( "feed", function(...) return self:Dev_KillPlayer( Entities:GetLocalPlayer():GetPlayerID() ) end, "Removes all the player's lives and kills them", eCommandFlags )
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

	if self.bHasSetAscensionLevel == false then 
		self:AllocateRoomLayout()
		self:AssignEncountersToRooms()

		if self.bHasAnyNewPlayers == true and self:GetAscensionLevel() == 0 then
			self:ReassignTrapRoomToNormalEncounter( 1 )
		end

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
	end

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

		if GetMapName() == "hub" then
			for _,hEncounter in pairs ( hRoom.vecPotentialEncounters ) do
				if hEncounter and type( hEncounter ) ~= "string" then 
					hEncounter.bEliteEncounter = false  
					hEncounter:OnEliteRankChanged( 0 )
				end
			end
		end	
	end


	local vecHubEliteEncounters = {}
	

	for nAct=1,3 do
		local nCriticalPathElites = 0
		print( "Selecting " .. MAP_ATLAS_ELITE_ROOMS_PER_ACT[nLevel+1][nAct] .. " elite encounters for act " .. nAct )
		print( "There are " .. #vecEliteRooms[ nAct ] .. " possible rooms for elites" )
		-- Assign elite rooms
		for nEliteRoom=1, MAP_ATLAS_ELITE_ROOMS_PER_ACT[nLevel+1][nAct] do
			print ( "Remaining possible elite rooms:" .. #vecEliteRooms[nAct] )
			if #vecEliteRooms[nAct] == 0 then
				print( "ran out of elite rooms" )
				break
			end

			local nPick = self.hMapRandomStream:RandomInt( 1, #vecEliteRooms[nAct] )

			local szEliteRoom = vecEliteRooms[nAct][nPick]
			--print( "Selecting elite room " ..  szEliteRoom )
			if GetMapName() == "main" then 
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
			else
				local vecPossibleEliteEncounters = {} 
				for _,szEncounterDefName in pairs ( MAP_ATLAS[ szEliteRoom ].encounters ) do
					
					if ENCOUNTER_DEFINITIONS[ szEncounterDefName ] and ENCOUNTER_DEFINITIONS[ szEncounterDefName ].nEncounterType ~= ROOM_TYPE_TRAPS then 
						local bFound = false 
						for _,szPreviouslyFoundEliteEncounters in pairs ( vecHubEliteEncounters ) do
							if szPreviouslyFoundEliteEncounters == szEncounterDefName then 
								bFound = true 
							end
						end

						if not bFound then 
							print( "Potential Encounter: " .. szEncounterDefName )
							table.insert( vecPossibleEliteEncounters, szEncounterDefName )
						end
					end
				end

				if #vecPossibleEliteEncounters == 0 then 
					print( "Error: failed to assign elite encounters, none possible at room " .. szEliteRoom )
				else
					local nEncounterPick = self.hMapRandomStream:RandomInt( 1, #vecPossibleEliteEncounters )
					local szEliteEncounterName = vecPossibleEliteEncounters[ nEncounterPick ]
					if szEliteEncounterName then 
						table.remove( vecPossibleEliteEncounters, nEncounterPick )
						table.insert( vecHubEliteEncounters, szEliteEncounterName )

						print( "Assigning Elite Status to encounter " .. szEliteEncounterName .. " in room " .. szEliteRoom )
						local hEliteEncounter = nil 
						for _,hPotentialEncounter in pairs ( self.rooms[ szEliteRoom ].vecPotentialEncounters ) do
							if hPotentialEncounter:GetName() == szEliteEncounterName then 
								hEliteEncounter = hPotentialEncounter
								break
							end
						end
						
						if hEliteEncounter then 
							print( "The encounter is one of the door options.  Assignment successful." )
							hEliteEncounter.bEliteEncounter = true 
							hEliteEncounter:OnEliteRankChanged( 1 )
							nCriticalPathElites = nCriticalPathElites + 1
							local bRemove = ( nLevel <= AGHANIM_ASCENSION_MAGICIAN ) or ( #vecPossibleEliteEncounters == 0 )
							if bRemove then 
								table.remove( vecEliteRooms[ nAct ], nPick )
							end
						else
							--print( "The encounter is not one of the door options; elite encounter hidden." )
						end		
					else 
						print( "Failed to assign elite encounter; not enough encounters" )
					end 
				end		
			end
		end

		if GetMapName() == "hub" then 
			print( "Act " .. nAct .. " has " .. nCriticalPathElites .. " elite encounters as door choices" )
		end
	end

	-- Now that we know our ascension level and eliteness, we can pick the abilities we want to use

	if GetMapName() == "main" then 
		for k,room in pairs(self.rooms) do
			if room:GetEncounter() then
				room:GetEncounter():SelectAscensionAbilities()
			end
		end	
	else
		for k,room in pairs( self.rooms ) do	
			if room:GetName() ~= "hub" and ( room:GetType() == ROOM_TYPE_ENEMY or room:GetType() == ROOM_TYPE_BOSS ) then 
				print( "Assigning ascension abilities for room " .. room:GetName() )
				if room:GetType() == ROOM_TYPE_BOSS then
					local hEncounter = room:GetEncounter()
					if hEncounter ~= nil then
						hEncounter:SelectAscensionAbilities()
					end
				else
					if room.vecPotentialEncounters ~= nil and #room.vecPotentialEncounters > 0 then
						for _,hEncounter in pairs ( room.vecPotentialEncounters ) do
							hEncounter:SelectAscensionAbilities()
						end
					end
				end
			end 	
		end	

		self:ApplyGlobalAscensionModifiers()
	end

end 

--------------------------------------------------------------------------------

function CAghanim:GetMaxAllowedAscensionLevel( )
	return AGHANIM_ASCENSION_APEX_MAGE	
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

function CAghanim:ApplyGlobalAscensionModifiers()
	if self.nAscensionLevel >= AGHANIM_ASCENSION_MAGICIAN then 
		self.nStartingLives = self.nStartingLives - ASCENSION_MAGICIAN_LESS_STARTING_LIVES

		for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
			if hPlayerHero ~= nil then
				hPlayerHero.nRespawnsRemaining = self.nStartingLives
				CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ), { respawns = hPlayerHero.nRespawnsRemaining } )
			end
		end
	end

	if self.nAscensionLevel >= AGHANIM_ASCENSION_SORCERER then 
		self.nGoldModifier = 100 - ASCENSION_SORCERER_LESS_GOLD_EARNED_PCT
	end

	if self.nAscensionLevel >= AGHANIM_ASCENSION_GRAND_MAGUS then 
		self.nCursedItemSlots = ASCENSION_GRAND_MAGUS_CURSED_ITEMS
	end

	-- Apex Mage boss modifiers applied in CMapEncounter:SelectAscensionAbilities
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
	elseif nExitRoomType == ROOM_TYPE_TRANSITIONAL or nExitRoomType == ROOM_TYPE_STARTING or nExitRoomType == ROOM_TYPE_EVENT then
		szRewardResult = "REWARD_TYPE_NONE"
	end
	
	print( "Setting Room Reward for " .. szRoomName .. " to " .. szRewardResult )
	return szRewardResult

end


--------------------------------------------------------------------------------
-- Allocates the room layout
function CAghanim:AllocateRoomLayout()
	self.nMaxDepth = 0
	self.rooms = {}
	self.RoomRewards = {}
	self.bMapFlipped = false

	if GetMapName() == "main" then
		self:AllocateRoomLayout_2020()	
	else
		self:AllocateRoomLayout_2021()
	end	
end

--------------------------------------------------------------------------------

function CAghanim:AllocateRoomLayout_2020()
	
	local vecPotentialTrapRooms = { {}, {}, {} }
	local vecHiddenRooms = { {}, {}, {} } 

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

function CAghanim:AllocateRoomLayout_2021()
	local vecPotentialTrapRooms = { {}, {}, {} }
	local vecPotentialEliteRooms = { {}, {}, {} } 
	local vecPotentialEventRooms = { {}, {}, {} }
	local vecPotentialHiddenRooms = { {}, {}, {} }
	local vecForcedEventRooms = { }

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

		if roomDef.nRoomType == ROOM_TYPE_ENEMY and roomDef.nDepth > self.nMaxDepth then
			self.nMaxDepth = roomDef.nDepth
		end

		local vMins = vCenter - roomDef.vSize / 2
		local vMaxs = vCenter + roomDef.vSize / 2
		self.rooms[ roomDef.name ] = CMapRoom( roomDef.name, roomDef.nRoomType, roomDef.nDepth, vMins, vMaxs, vCenter, roomDef )
		self.rooms[ roomDef.name ].vecPotentialEncounters = deepcopy( roomDef.encounters )
		ShuffleListInPlace( self.rooms[ roomDef.name ].vecPotentialEncounters, self.hMapRandomStream )
		self.rooms[ roomDef.name ].szSingleExitRoomName = roomDef.exit
		if roomDef.nRoomType == ROOM_TYPE_EVENT then
			if roomDef.bForceEvent == true then 
				table.insert( vecForcedEventRooms, roomDef.name )
			else
				table.insert( vecPotentialEventRooms[ self.rooms[ roomDef.name ].nAct ], roomDef.name )
			end
			--self.rooms[ roomDef.name ]:SetHidden( true )
		end

		self.rooms[ roomDef.name ].nExitChoices = roomDef.nExitChoices

		if ( roomDef.nRoomType == ROOM_TYPE_ENEMY ) and ( roomDef.bCannotBeTrap == nil or roomDef.bCannotBeTrap == false ) then
			table.insert( vecPotentialTrapRooms[ self.rooms[ roomDef.name ].nAct ], roomDef.name )
		end

		local bSuppress = ( roomDef.nDepth == 2 )
		if ( not roomDef.bCannotBeElite ) and ( bSuppress == false ) then
			table.insert( vecPotentialEliteRooms[ self.rooms[ roomDef.name ].nAct ], roomDef.name )

			--print( "inserting possible hidden room: " .. roomDef.name )
			table.insert( vecPotentialHiddenRooms[ self.rooms[ roomDef.name ].nAct ], roomDef.name )
		end	
	end

	-- Assign forced event rooms

	local vecEventRoomsPerAct = deepcopy( MAP_EVENT_ROOMS_PER_ACT )
	for _,szForcedEventRoomName in pairs ( vecForcedEventRooms ) do
		local szForcedPrecursorRoomName = string.sub( szForcedEventRoomName, 1, string.len( szForcedEventRoomName ) - 6 )
		self.rooms[ szForcedPrecursorRoomName ].hEventRoom = self.rooms[ szForcedEventRoomName ]
		
		if FREE_EVENT_ROOMS == true then 
			self.rooms[ szForcedPrecursorRoomName ].nExitChoices = 1
		else
			self.rooms[ szForcedPrecursorRoomName ].nExitChoices = 2
		end

		vecEventRoomsPerAct[ self.rooms[ szForcedPrecursorRoomName ]:GetAct() ] = vecEventRoomsPerAct[ self.rooms[ szForcedPrecursorRoomName ]:GetAct() ] - 1
	end


	for nAct=1,3 do

		-- Assign trap rooms
		local nBonusTrapRoomChance = 0
		if self:GetAscensionLevel() > AGHANIM_ASCENSION_APPRENTICE then 
			nBonusTrapRoomChance = MAP_BONUS_TRAP_ROOMS_LATER_ASCENSIONS_PCT
		end
		if nAct > 1 then 
			nBonusTrapRoomChance = nBonusTrapRoomChance + MAP_BONUS_TRAP_ROOMS_LATER_ACTS_PCT
		end 

		local nActTrapRoomCount = MAP_TRAP_ROOMS_PER_ACT[ nAct ]
		if self.hMapRandomStream:RandomInt( 1, 100 ) < nBonusTrapRoomChance then 
			nActTrapRoomCount = nActTrapRoomCount + 1
			print( "Act " .. nAct .. " rolled an extra trap room!" )
		end

		for nTrapRoom = 1, nActTrapRoomCount do
			local nPick = self.hMapRandomStream:RandomInt( 1, #vecPotentialTrapRooms[ nAct ] )
			self.rooms[ vecPotentialTrapRooms[ nAct ][ nPick ] ].bSpawnTrapRoom = true
			table.remove( vecPotentialTrapRooms[ nAct ], nPick )		
		end

		-- Assign hidden rooms
		for nHiddenRoom = 1, MAP_HIDDEN_ENCOUNTERS_PER_ACT[ nAct ] do
		 	local nPick = self.hMapRandomStream:RandomInt( 1, #vecPotentialHiddenRooms[ nAct ] )
		 	local szHiddenRoomName = vecPotentialHiddenRooms[ nAct ][ nPick ]
			print( "Selecting hidden room option " ..  szHiddenRoomName )

			local nExitOptionHidden = self.hMapRandomStream:RandomInt( 1, 2 )
		 	self.rooms[ szHiddenRoomName ]:SetExitOptionHidden( nExitOptionHidden )
		 	print( "Room " .. szHiddenRoomName .. " setting exit option " .. nExitOptionHidden .. " hidden")
			table.remove( vecPotentialHiddenRooms[ nAct ], nPick )
		 end	

		for nEventRoom = 1, vecEventRoomsPerAct[ nAct ] do
			if #vecPotentialEventRooms[ nAct ] == 0 then 
				break 
			end

			local nPick = self.hMapRandomStream:RandomInt( 1, #vecPotentialEventRooms[ nAct ] )
			local szEventRoomName = vecPotentialEventRooms[ nAct ][ nPick ]
			
			local szPrecursorRoomName = string.sub( szEventRoomName, 1, string.len( szEventRoomName ) - 6 )
			self.rooms[ szPrecursorRoomName ].hEventRoom = self.rooms[ szEventRoomName ]
			self.rooms[ szEventRoomName ].bActiveEvent = true
			
			if FREE_EVENT_ROOMS == true then 
				self.rooms[ szPrecursorRoomName ].nExitChoices = 1
			else
				self.rooms[ szPrecursorRoomName ].nExitChoices = 2
			end

			table.remove( vecPotentialEventRooms[ nAct ], nPick )
		end
	end

	for k,v in pairs ( self.rooms ) do
		local roomDef =  MAP_ATLAS[ v:GetName() ]
		if roomDef then
			local hExitRoom = self.rooms[ roomDef.exit ]
			if hExitRoom then
				hExitRoom.nEncountersToSelect = roomDef.nExitChoices
				if hExitRoom.nRoomType == ROOM_TYPE_BOSS then 
					hExitRoom.nEncountersToSelect = 1
				end
			end
			local hEventRoom = self.rooms[ roomDef.name .. "_event" ]
			if hEventRoom then
				hEventRoom.nEncountersToSelect = 1
			end

			if v:GetName() == "a2_1" or v:GetName() == "a3_1" then 
				v.nEncountersToSelect = 2
			end
		end
		
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
	if GetMapName() == "main" then 
		self:AssignEncountersToRooms_2020()
	else
		self:AssignEncountersToRooms_2021()
	end
end

--------------------------------------------------------------------------------

function CAghanim:AssignEncountersToRooms_2020()
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
				print( "using encounter immediate victory in room " .. room:GetName() )
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

function CAghanim:AssignEncountersToRooms_2021()
	local vecEventRooms = {}

	for k,room in pairs ( self.rooms ) do
		local RewardPossibilites = deepcopy( ROOM_CHOICE_REWARDS )
		ShuffleListInPlace( RewardPossibilites, self.hMapRandomStream )

		-- Have to normalize since the original set of rewards is *not* exactly normalized
		NormalizeFloatArrayInPlace( RewardPossibilites, 100.0 )

		if room:GetName() == "hub" then
			room:AssignEncounter( "encounter_hub" )
			room.szMapName = "hub" 
			room:SetRoomEncounterReward( "encounter_hub", "REWARD_TYPE_NONE" )
		else
			local nPotentialEncounters = #room.vecPotentialEncounters
			local nEncountersToSelect = room.nEncountersToSelect
			if nPotentialEncounters == 0 then
				print( "AssignEncountersToRooms_2021: Room " .. room:GetName() .. " has no potential encounters, assigning encounter_test_immediate_victory" )
				room:AssignEncounter( "encounter_test_immediate_victory" )
				
				local szReward = self:AssignRoomReward( room:GetName(), RewardPossibilites )
				room:SetRoomEncounterReward( "encounter_test_immediate_victory", szReward )
				goto continue
			else
				print( "AssignEncountersToRooms_2021: Room " .. room:GetName() .. " has " .. nPotentialEncounters .. " potential encounters." )
				local vecTrapRoomNames = {}

				for nEncounterIndex = #room.vecPotentialEncounters, 1, -1 do
					local szEncounterName = room.vecPotentialEncounters[ nEncounterIndex ]
					local encDef = ENCOUNTER_DEFINITIONS[ szEncounterName ]
					
					if encDef then 
						local bRemove = false 
						if nEncountersToSelect >= #room.vecPotentialEncounters then 
							print( "AssignEncountersToRooms_2021: # of encounters to select is greater than or equal to remaining pending encounters, aborting pruning of encounters" )
							break
						end

						if encDef.nEncounterType == ROOM_TYPE_TRAPS then 
							if room.bSpawnTrapRoom ~= true then
								print( "AssignEncountersToRooms_2021: Removing potential encounter " .. szEncounterName .. "; room did not spawn a potential trap." )
			 
								bRemove = true 
							else 
								table.insert( vecTrapRoomNames, szEncounterName )
							end
						end

						if encDef.nRequiredAscension ~= nil and self:GetAscensionLevel() < encDef.nRequiredAscension then 
							print( "AssignEncountersToRooms_2021: Removing potential encounter " .. szEncounterName .. "; ascension level " .. encDef.nRequiredAscension .. " required (current: " .. self:GetAscensionLevel() .. ")" )
							bRemove = true  
						end

						if bRemove then 
							table.remove( room.vecPotentialEncounters, nEncounterIndex )
						end
					end
				end

				
				while #vecTrapRoomNames > 1 do 
					if nEncountersToSelect >= #room.vecPotentialEncounters then 
						print( "AssignEncountersToRooms_2021: # of encounters to select is greater than or equal to remaining pending encounters, aborting pruning of additional trap encounters" )
						break
					end

					ShuffleListInPlace( vecTrapRoomNames, self.hMapRandomStream )

					for k,v in pairs( room.vecPotentialEncounters ) do
						if v == vecTrapRoomNames[ #vecTrapRoomNames ] then 
							table.remove( room.vecPotentialEncounters, k )
						end
					end

					table.remove( vecTrapRoomNames, #vecTrapRoomNames )
				end

				-- if room.bSpawnTrapRoom ~= true then 
				-- 	for k,v in pairs ( room.vecPotentialEncounters ) do
				-- 		if nEncountersToSelect >= #room.vecPotentialEncounters then 
				-- 			print( "# of encounters to select is greater than or equal to remaining pending encounters in non-trap room, aborting pruning of trap encounters")
				-- 			break
				-- 		end

				-- 		local def = ENCOUNTER_DEFINITIONS[ v ]
				-- 		if def and def.nEncounterType == ROOM_TYPE_TRAPS then 
				-- 			table.remove( room.vecPotentialEncounters, k )
				-- 		end	
				-- 	end
				-- else
				-- 	local vecTrapRoomIndices = {}
				-- 	for k,v in pairs ( room.vecPotentialEncounters ) do
				-- 		local def = ENCOUNTER_DEFINITIONS[ v ]
				-- 		if def and def.nEncounterType == ROOM_TYPE_TRAPS then 
				-- 			table.insert( vecTrapRoomIndices, k )
				-- 		end	
				-- 	end

				-- 	while #vecTrapRoomIndices > 1 do 
				-- 		ShuffleListInPlace( vecTrapRoomIndices, self.hMapRandomStream )
				-- 		table.remove( vecTrapRoomIndices, #vecTrapRoomIndices )
				-- 	end
				-- end

				if room.nRoomType == ROOM_TYPE_EVENT then 
					if room.bActiveEvent == true then
						table.insert( vecEventRooms, room )
					end
					goto continue
				end

				while #room.vecPotentialEncounters > nEncountersToSelect do
					local nIndex = self.hMapRandomStream:RandomInt( 1, #room.vecPotentialEncounters )
					table.remove( room.vecPotentialEncounters, nIndex )
				end

				if self:GetAscensionLevel() == AGHANIM_ASCENSION_APPRENTICE and  ( room:GetName() == "a1_1" or room:GetName() == "a1_2" ) then 
					RewardPossibilites[ "REWARD_TYPE_EXTRA_LIVES" ] = nil 
				    NormalizeFloatArrayInPlace( RewardPossibilites, 100.0 )
				    --print( "Apprentice removing extra lives reward from first rooms" )
				    --PrintTable( RewardPossibilites, " ))) " )
				end

				--print( "AghsLab2: Room " .. room:GetName() .. " has selected " .. #room.vecPotentialEncounters .. " encounters: "  
				for i,szEncounterName in pairs ( room.vecPotentialEncounters ) do
					print( "*-> " .. szEncounterName )
					local hEncounterClass = require( "encounters/2021/" .. szEncounterName )
					if hEncounterClass == nil then
						print( "ERROR: Encounter class " .. szEncounterName .. " not found.\n" )
						return
					end

					local hEncounter = hEncounterClass( room, szEncounterName )
					if hEncounter == nil then
						print( "ERROR: Failed to create Encounter " .. szEncounterName .. "\n" )
						return
					end

					local encounterDef = ENCOUNTER_DEFINITIONS[ szEncounterName ]
					if encounterDef == nil then
						print( "ERROR: Failed to find encounter def " .. szEncounterName .. "\n" )
						return
					end

					--hEncounter:AssignEncounterType( encounterDef.nEncounterType )
					if room:GetExitOptionHidden() == i then 
						print( "AssignEncountersToRooms_2021: Setting encounter " .. szEncounterName .. " hidden!" )
						hEncounter:SetEncounterHidden( true )
					end
					room.vecPotentialEncounters[ i ] = hEncounter

					
					local szReward = self:AssignRoomReward( room:GetName(), RewardPossibilites )
					room:SetRoomEncounterReward( szEncounterName, szReward )
				    RewardPossibilites[ szReward ] = nil 
				    NormalizeFloatArrayInPlace( RewardPossibilites, 100.0 )

				    if nEncountersToSelect == 1 then 
						room:AssignPendingEncounter( hEncounter )
					end
				end
			end
		end

		::continue::
	end

	local vecEventsUsed = {}
	for _,hEventRoom in pairs( vecEventRooms ) do 
		local vecPossibleEvents = deepcopy( hEventRoom.vecPotentialEncounters )
		if #vecPossibleEvents > 1 then 
			for nIndexToRemove = #vecPossibleEvents, 1, -1 do
				szPossibleEventName = vecPossibleEvents[ nIndexToRemove ]
				for _,szUsedEventName in pairs ( vecEventsUsed ) do 
					if szUsedEventName == szPossibleEventName then 
					--	print( "Event encounter " .. szUsedEventName .. " has already spawned; removing it from the pool in room " .. hEventRoom:GetName() )
						table.remove( vecPossibleEvents, nIndexToRemove )
						goto next_possible_event
					end
				end

				::next_possible_event::
			end
		end

		local nEventRoomIndex = self.hMapRandomStream:RandomInt( 1, #vecPossibleEvents )
		local szEventEncounterName = vecPossibleEvents[ nEventRoomIndex ]
		if szEventEncounterName == nil then
			print( "Error - somehow got nil event name for room " .. hEventRoom:GetName() .. ", falling back to shard shop" )
			szEventEncounterName = "encounter_event_minor_shard_shop"
		end

		hEventRoom:AssignEncounter( szEventEncounterName )
		hEventRoom:SetRoomEncounterReward( szEventEncounterName, "REWARD_TYPE_NONE" )
		table.insert( vecEventsUsed, szEventEncounterName )

		local eventEncounterDef = ENCOUNTER_DEFINITIONS[ szEventEncounterName ]
		if eventEncounterDef and eventEncounterDef.szDisableEvents ~= nil then
			for _,szEventToDisable in pairs ( eventEncounterDef.szDisableEvents ) do
				print( "Event " .. szEventEncounterName .. " has been selected, disabling associated event " .. szEventToDisable )
				table.insert( vecEventsUsed, szEventToDisable )
			end
		end

		print( hEventRoom:GetName() .. " has been assigned event " .. szEventEncounterName )		
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
		"@encounter_outpost_1_override",	
		"@encounter_outpost_2_override",	
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

	if GetMapName() == "main" then
		return self:GetExitOptionData_2020( nOptionNumber )
	else
		return self:GetExitOptionData_2021( nOptionNumber )
	end
end

--------------------------------------------------------------------------------

function CAghanim:GetExitOptionData_2020( nOptionNumber )
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
		print( "No exits!" )
		return nil
	end

	-- Gotta do this before we tweak the option number for the rest of this algorithm
	local hOverrideLocators = self:GetCurrentRoom():FindAllEntitiesInRoomByName( "*encounter_outpost_" .. nOptionNumber .. "_override" )

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
		flOverrideYaw = -1.0;
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
		exitData.flXOffset = 0
		exitData.flYOffset = 0
		exitData.flZOffset = 25
	end

	return exitData
end

--------------------------------------------------------------------------------

function CAghanim:GetExitOptionData_2021( nOptionNumber )
	--print( "GetExitOptionData_2021" )
	local hExitRoom = self:GetRoom( self:GetCurrentRoom().szSingleExitRoomName )
	if hExitRoom == nil then
		print( "Error! No Exit room." )
		return
	end

	local bEventExitOption = false 
	if self:GetCurrentRoom().hEventRoom ~= nil then 
		hExitRoom = self:GetCurrentRoom().hEventRoom
		bEventExitOption = true
	end

	print( "GetExitOptionData_2021: " .. self:GetCurrentRoom():GetName() .. " to " .. hExitRoom:GetName() )
	local hOverrideLocators = nil
	if hExitRoom:GetName() == "hub" then 
		hOverrideLocators = self:GetCurrentRoom():FindAllEntitiesInRoomByName( "*encounter_outpost_" .. nOptionNumber .. "_override" )
		local hEncounter = hExitRoom:GetEncounter() 
		local strPreviewUnit = hEncounter:GetPreviewUnit()
		local exitData =
		{
			nExitDirection = self:GetCurrentRoom().nSingleExitDirection,
			vExitLocation = hExitRoom:GetOrigin(),
			szEncounterPreviewUnit = "npc_dota_boss_aghanim",
			flEncounterPreviewModelScale = 1.0,
			nEncounterType = ROOM_TYPE_STARTING,
			bIsEliteEncounter = false,
			szNextRoomName = hExitRoom:GetName(),
			szRewardType = hExitRoom:GetPotentialEncounterRoomReward( hEncounter.szEncounterName ),
			szEncounterName = hEncounter:GetName(),
			szAscensionNames = nil,
			nExitCount = 1,
			nDepth = hExitRoom:GetDepth(),
			flZOffset = 0,
			flOverrideYaw = -1.0;
			bPedestal = true,
		}

		if #hOverrideLocators > 0 then
			exitData.vOverrideLocation = hOverrideLocators[1]:GetAbsOrigin()
		end

		return exitData 
	else 
		local flOverrideYaw = -1.0
		local szOverrideLocatorName = "*encounter_outpost_" .. nOptionNumber .. "_override" 
		if self:GetCurrentRoom():GetName() == "hub" then 
			szOverrideLocatorName = "act_" .. tostring( hExitRoom:GetAct() ) .. "_*encounter_outpost_" .. nOptionNumber .. "_override"
			--print( "using override locator name in hub:" .. szOverrideLocatorName )
		else
			if bEventExitOption then 
				--This room spawned an event room.  That means we need to update the exits to point to the event.
				szOverrideLocatorName = "*encounter_outpost_event" 
			end
		end

		hOverrideLocators = self:GetCurrentRoom():FindAllEntitiesInRoomByName( szOverrideLocatorName )
		if hOverrideLocators == nil or #hOverrideLocators == 0 then
			print( 'ERROR - Override locations are now required! Please add ' .. szOverrideLocatorName .. ' to the map ' .. self:GetCurrentRoom():GetName() )
		end

		local nNumExitChoices = self:GetCurrentRoom().nExitChoices
		if bEventExitOption and not FREE_EVENT_ROOMS then 
			nNumExitChoices = 2
		end

		local hRequestedExitEncounter = nil 
		if nNumExitChoices > 1 then 
			local nPotentialEncounters = #hExitRoom.vecPotentialEncounters
			if nNumExitChoices ~= nPotentialEncounters then
				print( "CAghanim:GetExitOptionData_2021 - Error!  Room " .. self:GetCurrentRoom():GetName() .. " does not have equal exit choices ( " .. nNumExitChoices .." ) and potential encounters ( "..  nPotentialEncounters .. " )!" )
				return
			end

			hRequestedExitEncounter = hExitRoom.vecPotentialEncounters[ nOptionNumber ]
		else
			hRequestedExitEncounter = hExitRoom:GetEncounter()
		end

		if hRequestedExitEncounter == nil then
			print( "Error getting requested exit encounter!" )
			return
		end

		local bHidePrimal = hExitRoom:GetName() == "a3_4_boss" and self:GetAscensionLevel() == AGHANIM_ASCENSION_APPRENTICE
		local bIsHidden = ( hExitRoom:GetExitOptionHidden() == nOptionNumber ) or bHidePrimal
		--print(  "ExitOption " .. nOptionNumber .. ": it's hidden:" .. tostring( bIsHidden ) )
		
		local strPreviewUnit = hRequestedExitEncounter:GetPreviewUnit()
		--print( strPreviewUnit )
		local hAscensionAbilities = hRequestedExitEncounter:GetAscensionAbilities()
		local szAscensionAbilities = ""
		for i = 1,#hAscensionAbilities do
			if i ~= 1 then
				szAscensionAbilities = szAscensionAbilities .. ";"
			end
			szAscensionAbilities = szAscensionAbilities .. hAscensionAbilities[i] 
		end

		local exitData =
		{
			nExitDirection = self:GetCurrentRoom().nSingleExitDirection,
			vExitLocation = hExitRoom:GetOrigin(),
			szEncounterPreviewUnit = strPreviewUnit,
			flEncounterPreviewModelScale = ENCOUNTER_PREVIEW_SCALES[ strPreviewUnit ],
			nEncounterType = hRequestedExitEncounter:GetEncounterType(),
			bIsEliteEncounter = hRequestedExitEncounter:IsEliteEncounter(),
			szNextRoomName = hExitRoom:GetName(),
			szRewardType = hExitRoom:GetPotentialEncounterRoomReward( hRequestedExitEncounter:GetName() ),
			szEncounterName = hRequestedExitEncounter:GetName(),
			szAscensionNames = szAscensionAbilities,
			nExitCount = nNumExitChoices,
			nDepth = hExitRoom:GetDepth(),
			bPedestal = false,
			flZOffset = 15,
			flOverrideYaw = -1.0;
		}


		--if self:GetCurrentRoom():GetExitReward( nOptionNumber ) then
	--		print( "Exit option " .. nOptionNumber .. " for room " .. self:GetCurrentRoom().szRoomName  .. " has reward type " .. exits[nOptionNumber]:GetRoomChoiceReward() .. " in room " .. exits[nOptionNumber].szRoomName )
	--	end
		if exitData.flEncounterPreviewModelScale == nil then
			exitData.flEncounterPreviewModelScale = 1.0
		end

		if hRequestedExitEncounter:GetEncounterType() == ROOM_TYPE_BOSS then 
			exitData.flEncounterPreviewModelScale = exitData.flEncounterPreviewModelScale * 2
		end

		if #hOverrideLocators > 0 then
			exitData.vOverrideLocation = hOverrideLocators[1]:GetAbsOrigin()
			local vAngles = hOverrideLocators[1]:GetAnglesAsVector()
			exitData.flOverrideYaw = vAngles.y
		else
			print( 'Falling back to room origin for effigy override location' )
			exitData.vOverrideLocation = self:GetCurrentRoom():GetOrigin()
		end

		if ENCOUNTER_EFFIGY_OFFSETS[ strPreviewUnit ] then 
			local vOffset = ENCOUNTER_EFFIGY_OFFSETS[ strPreviewUnit ]
			exitData.vOverrideLocation.x = exitData.vOverrideLocation.x + vOffset.x 
			exitData.vOverrideLocation.y = exitData.vOverrideLocation.y + vOffset.y
			exitData.flZOffset = exitData.flZOffset + vOffset.z 
	 	end

		if bEventExitOption then 
			exitData.bIsEliteEncounter = false
			bIsHidden = false
		end

		if bIsHidden then
			exitData.szEncounterPreviewUnit = "models/ui/exclamation/questionmark.vmdl"
			exitData.flEncounterPreviewModelScale = 0.0015
	
			if exitData.nEncounterType == ROOM_TYPE_TRAPS then
				exitData.bIsEliteEncounter = hExitRoom:ShouldDisplayHiddenAsElite()
			end

			if not bEventExitOption then 
				exitData.nEncounterType = ROOM_TYPE_ENEMY
			end

			if bHidePrimal then 
				exitData.nEncounterType = ROOM_TYPE_BOSS
				exitData.flEncounterPreviewModelScale = 0.00225
			end

			exitData.flXOffset = 0
			exitData.flYOffset = 0
			exitData.flZOffset = 60
		end

		--PrintTable( exitData, " --- " )

		return exitData
	end
end

--------------------------------------------------------------------------------

function CAghanim:OnNextRoomSelected( event )
	self:GetCurrentRoom():OnNextRoomSelected( event.selected_room, event.selected_encounter )
end

--------------------------------------------------------------------------------

-- Evaluate the state of the game
function CAghanim:OnThink()

	local nGameState = GameRules:State_Get()
	if nGameState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if self.bSetHeroAvailability ~= true then
			self:SetHeroAvailability()
			self.bSetHeroAvailability = true
		end
		self:ComputeHasNewPlayers()
	elseif nGameState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		local bCheckDefeat = self.bForceCheckDefeat
		if self:GetCurrentRoom() and self:GetCurrentRoom():GetEncounter() and self:GetCurrentRoom():GetEncounter():HasStarted() and self:GetCurrentRoom():GetEncounter():NeedsToThink() then
			self:GetCurrentRoom():GetEncounter():OnThink()
			bCheckDefeat = true
		end
		if bCheckDefeat then
			self:_CheckForDefeat()
		end

		if FREE_EVENT_ROOMS and self:GetCurrentRoom() and self:GetCurrentRoom():GetEncounter() and self:GetCurrentRoom():GetEncounter().bHasGeneratedRewards and self.hAutoChannelEventOutpostBuff ~= nil then 
			if self:HaveAllRewardsBeenSelected() then
				self.hAutoChannelEventOutpostBuff:ScheduleAutoChannelComplete( 5.0 )
				self.hAutoChannelEventOutpostBuff = nil 
			end
		end
	elseif nGameState >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	--CustomNetTables:SetTableValue( "special_ability_upgrades", tostring( 0 ), SPECIAL_ABILITY_UPGRADES[szHeroName] )
	return 0.25
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
		print( "CAghanim:SetCurrentRoom - Setting current room to " .. hRoom:GetName() )
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
				if room:GetEncounter() then
					return room:GetEncounter():GetPreviewUnit()
				else
					return "npc_dota_creature_huskar"
				end
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
	--print( "Adding minor ability upgrade for playerID " .. hHero:GetPlayerOwnerID() )
	--PrintTable( upgradeTable, "upgrade" )

	if hHero.MinorAbilityUpgrades == nil then
		hHero.MinorAbilityUpgrades = {}
	end

	local szAbilityName = upgradeTable[ "ability_name" ]
	if hHero.MinorAbilityUpgrades[ szAbilityName ] == nil then
		hHero.MinorAbilityUpgrades[ szAbilityName ] = {}
	end

	
	local szSpecialValueName = upgradeTable[ "special_value_name" ]
	if szSpecialValueName ~= nil then 
		if hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ] == nil then
			hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ] = {}
		end
		local newUpgradeTable = {}
		newUpgradeTable[ "operator" ] = upgradeTable[ "operator" ]
		newUpgradeTable[ "value" ] = upgradeTable[ "value" ]
		newUpgradeTable[ "elite" ] = upgradeTable[ "elite" ]
		table.insert( hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ], newUpgradeTable )
	else
		local SpecialValues = upgradeTable[ "special_values" ]
		if SpecialValues == nil then 
			print( "ERROR! Malformed multiple special values minor ability upgrade" )
			return
		end

		for _,SpecialValue in pairs( SpecialValues ) do 
			szSpecialValueName = SpecialValue[ "special_value_name" ]

			if hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ] == nil then
				hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ] = {}
			end

			local newUpgradeTable = {}
			newUpgradeTable[ "operator" ] = SpecialValue[ "operator" ]
			newUpgradeTable[ "value" ] = SpecialValue[ "value" ]
			newUpgradeTable[ "elite" ] = upgradeTable[ "elite" ]
			--print( "inserting new ugprade table" )
			--PrintTable( newUpgradeTable, " -> " )
			table.insert( hHero.MinorAbilityUpgrades[ szAbilityName ][ szSpecialValueName ], newUpgradeTable )
		end
	end

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

function CAghanim:AddMiscBuffToScoreboard( hHero, buffTable )
	if hHero == nil then 
		return 
	end

	if hHero.MiscBuffs == nil then 
		hHero.MiscBuffs = {}
	end

	if buffTable == nil then 
		return 
	end

	local szAttribute = buffTable[ "attribute" ]
	if szAttribute == nil then 
		return
	end

	if hHero.MiscBuffs[ szAttribute ] == nil then 
		hHero.MiscBuffs[ szAttribute ] = {}
	end

	table.insert( hHero.MiscBuffs[ szAttribute ], buffTable )
	CustomNetTables:SetTableValue( "misc_buffs", tostring( hHero:GetPlayerOwnerID() ), hHero.MiscBuffs )
end

--------------------------------------------------------------------------------

function CAghanim:GetFragmentDropEV()
	local fDropEV = 0
	for _, odds in pairs( ARCANE_FRAGMENT_RANDOM_DROP_CHANCES ) do
		fDropEV = fDropEV + ( ( odds.high_chance - odds.low_chance ) * odds.num_fragments )
	end
	fDropEV = fDropEV / 100

	--print( 'CAghanim:GetFragmentDropEV() calculated an average number of drops: ' .. fDropEV )

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

	if hEncounter == nil then
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

	local nDepth = math.max( 2, hRoom:GetDepth() )
	local vecPotentialItems = GetPricedNeutralItems( nDepth, bElite )
	local vecFilteredItems = GameRules.Aghanim:FilterPreviouslyDroppedItems( deepcopy( vecPotentialItems ) )

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

	print( "Room " .. hRoom:GetName() .. " has produced a neutral item drop " .. szItemDrop )
	
	--if self:GetTestEncounterDebugRoom() ~= nil then
	--	print( "adding neutral item to debug crate:" .. szItemDrop ) 
	--	table.insert( self.debugItemsToStuffInCrate.RoomReward, szItemDrop )
	--end	

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
			quest_stars = 0,
			blessings = {},
			depth_list = {},
		}

		table.insert( self.SignOutTable[ "player_list" ], nPlayerID, SignOutPlayer )

		local netTable = {}
		netTable[ "arcane_fragments" ] = 0
		netTable[ "battle_points" ] = 0
		netTable[ "weekly_quest_stars" ] = 0
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

function CAghanim:RegisterEncounterComplete( hEncounter, flDuration )
	local hRoom = self:GetCurrentRoom()
	if hRoom == nil then
		print( "CAghanim:RegisterEncounterComplete: Current Room is nil!" )
		return
	end
	local nDepth = hRoom:GetDepth()
	
	if hEncounter.nEncounterType == ROOM_TYPE_STARTING and nDepth ~= 1 then
		return -- Returns to the hub don't get new depths
	end

	-- Also, we don't have depth stats for depth 1 anyway, so just return. FIXME if we want to track Hub stats.
	if nDepth == 1 then
		return
	end

	local tStats = self.SignOutTable[ "team_depth_list" ][ nDepth ]
	if tStats == nil then
		print( "CAghanim:RegisterEncounterComplete: team_depth_list does not have depth " .. nDepth )
		return
	end

	if hEncounter.nEncounterType == ROOM_TYPE_EVENT then
		tStats.event_duration = flDuration
	else
		tStats.duration = flDuration
	end
end

--------------------------------------------------------------------------------

function CAghanim:RegisterBlessingStat( nPlayerID, szBlessingName, nLevel )	
	self.SignOutTable[ "player_list" ][ nPlayerID ].blessings[szBlessingName] = nLevel

	local blessings = CustomNetTables:GetTableValue( "game_global", "blessings" )
	if blessings[ tostring( nPlayerID) ] == nil then
		blessings[ tostring( nPlayerID ) ] = {}
	end	

	blessings[ tostring( nPlayerID ) ][ szBlessingName ] = nLevel
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
	for i=1,99 do
		if stats.selected_reward[ "value" .. i] ~= nil then
			self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth]["selected_reward_value" .. i] = stats.selected_reward[ "value" .. i]
		else
			break
		end
	end
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
	self.SignOutTable[ "player_list" ][ nPlayerID ].depth_list[szRoomDepth].lives_purchased = 0

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

function CAghanim:GrantAllPlayersQuestStar()
	local connectedPlayers = self:GetConnectedPlayers()
	for i = 1, #connectedPlayers do 
		local nPlayerID = connectedPlayers[ i ]
		
		if self.SignOutTable[ "player_list" ][ nPlayerID ][ "quest_stars" ] == nil then 
			self.SignOutTable[ "player_list" ][ nPlayerID ][ "quest_stars" ] = 0
		end
		
		self.SignOutTable[ "player_list" ][ nPlayerID ][ "quest_stars" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "quest_stars" ] + 1

		local eEventAudit_PlayedMatch = 35
		local nQuantity = 1
		local nDefaultToMatchIDAtSignout = 0
		PlayerResource:RecordEventActionGrantForPrimaryEvent( nPlayerID, "aghanim_stars",  eEventAudit_PlayedMatch, nQuantity, nDefaultToMatchIDAtSignout )

		local netTable = {}
		netTable[ "arcane_fragments" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "arcane_fragments" ] + self.SignOutTable[ "player_list" ][ nPlayerID ][ "bonus_arcane_fragments" ]
		netTable[ "battle_points" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "battle_points" ]
		netTable[ "weekly_quest_stars" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "quest_stars" ]
		CustomNetTables:SetTableValue( "currency_rewards", tostring( nPlayerID ), netTable )

	end
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

	-- Apply battle pass arcane fragment multiplier per player
	if not bBattlePoints then
		local nActionGranted = PlayerResource:GetEventGameCustomActionClaimCountByName( nPlayerID, "labyrinth_arcane_fragment_bonus_rate" )
		local fMult = 1 + ARCANE_FRAGMENT_BP_BONUS_PER_GRANT * nActionGranted
		nDesiredPoints = math.ceil( nDesiredPoints * fMult )
	end

	-- Clamps the amount of points to the amount remaining
	local nPoints = self:RegisterCurrencyGrant( nPlayerID, nDesiredPoints, bBattlePoints )			
	if nPoints == 0 then
		return 0
	end

	local nDigits = string.len( tostring( nPoints ) )
	if bBattlePoints then
		--print ( "Awarding player " .. nPlayerID .. " " .. nPoints .. " battle points for " .. szReason )
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
		--print ( "Awarding player " .. nPlayerID .. " " .. nPoints .. " arcane fragments for " .. szReason )
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
	netTable[ "weekly_quest_stars" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "quest_stars" ]
	CustomNetTables:SetTableValue( "currency_rewards", tostring( nPlayerID ), netTable )

	return nPoints

end

--------------------------------------------------------------------------------

function CAghanim:GrantAllPlayersAghanimClone( szActionName )
	local connectedPlayers = self:GetConnectedPlayers()
	for i = 1, #connectedPlayers do
		local nPlayerID = connectedPlayers[ i ]

		local eEventAudit_PlayedMatch = 35
		local nQuantity = 1
		local nDefaultToMatchIDAtSignout = 0

		print( "Awarding player action " .. szActionName .. " for encountering an aghanim clone!" )
		PlayerResource:RecordEventActionGrantForPrimaryEvent( nPlayerID, szActionName, eEventAudit_PlayedMatch, nQuantity, nDefaultToMatchIDAtSignout )
	end
end
 
 -------------------------------------------------------------------------------

function CAghanim:MarkGameWon()
	self.bWonGame = true

	printf("======== ENDING GAME - VICTORY ==========\n");
	if GetMapName() ~= "hub" then
		self:GetAnnouncer():OnGameWon()
	end
	GameRules.Aghanim:OnGameFinished()
	GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS )
end

--------------------------------------------------------------------------------

function CAghanim:_CheckForDefeat()
	if self.bPlayerHasSpawned == false then
		return
	end

	local bAnyHeroesAlive = false
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero ~= nil then
			-- TODO: make sure that servers will die when everyone DCs, since we don't want AFK checks for this mode 
			if hPlayerHero:IsRealHero() and hPlayerHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and 
				( hPlayerHero:IsAlive() or hPlayerHero:IsReincarnating() or ( hPlayerHero:GetRespawnsDisabled() == false ) ) then
				bAnyHeroesAlive = true
			end
		end
	end

	if bAnyHeroesAlive == false and self.bInVictorySequence == false then
		printf("======== ENDING GAME ==========\n");
		if self:GetCurrentRoom() ~= nil and self:GetCurrentRoom():GetEncounter() ~= nil then
			self:RegisterEncounterComplete( self:GetCurrentRoom():GetEncounter(), GameRules:GetGameTime() - self:GetCurrentRoom():GetEncounter():GetStartTime() )
		end
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
	if self:GetCurrentRoom() == nil then
		printf( "ERROR - win_encounter command failed, current room is nil" )
		return
	end

	if self:GetCurrentRoom():IsActivated() == false then 
		printf( "ERROR - win_encounter command failed, current room is not activated" )
		return
	end
		 
	if self:GetCurrentRoom():GetEncounter() == nil then
		printf( "ERROR - win_encounter command failed, current encounter is nil" )
		return
	end

	self:GetCurrentRoom():GetEncounter():Dev_ForceCompleteEncounter()
end

--------------------------------------------------------------------------------

function CAghanim:Dev_KillBeast()
	if self:GetCurrentRoom() == nil then
		printf( "ERROR - kill_beast command failed, current room is nil" )
		return
	end

	if self:GetCurrentRoom():IsActivated() == false then 
		printf( "ERROR - kill_beast command failed, current room is not activated" )
		return
	end

	local hEncounter = self:GetCurrentRoom():GetEncounter()
		 
	if hEncounter == nil then
		printf( "ERROR - kill_beast command failed, current encounter is nil" )
		return
	end

	if hEncounter.hBeast == nil then
		printf( "ERROR - kill_beast command failed, Beast is nil" )
		return
	end

	local damageInfo = 
	{
		victim = hEncounter.hBeast,
		attacker = hEncounter.hBeast,
		damage = 999999,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = nil,
	}

	ApplyDamage( damageInfo )
end

--------------------------------------------------------------------------------

function CAghanim:Dev_DamageBeast( cmdName, nDamage )
	if self:GetCurrentRoom() == nil then
		printf( "ERROR - damage_beast command failed, current room is nil" )
		return
	end

	if self:GetCurrentRoom():IsActivated() == false then 
		printf( "ERROR - damage_beast command failed, current room is not activated" )
		return
	end

	local hEncounter = self:GetCurrentRoom():GetEncounter()
		 
	if hEncounter == nil then
		printf( "ERROR - damage_beast command failed, current encounter is nil" )
		return
	end

	if hEncounter.hBeast == nil then
		printf( "ERROR - damage_beast command failed, Beast is nil" )
		return
	end

	local damageInfo = 
	{
		victim = hEncounter.hBeast,
		attacker = hEncounter.hBeast,
		damage = tonumber( nDamage ),
		damage_type = DAMAGE_TYPE_PURE,
		ability = nil,
	}

	ApplyDamage( damageInfo )
end

--------------------------------------------------------------------------------

function CAghanim:Dev_SetAscensionLevel( cmdName, szLevel )
	if szLevel ~= nil then
		local nLevel = tonumber( szLevel ) 
		self:SetAscensionLevel( nLevel )
	end
end

--------------------------------------------------------------------------------

function CAghanim:Dev_SetNewPlayers( cmdName, szNewPlayers )
	self.bHasAnyNewPlayers = tonumber( szNewPlayers ) > 0
end

--------------------------------------------------------------------------------

function CAghanim:Dev_ExtraLives( nCommandedPlayer )

	if nCommandedPlayer == -1 or nCommandedPlayer > DOTA_MAX_TEAM_PLAYERS - 1 then
		nCommandedPlayer = nil
	end
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if ( nCommandedPlayer == nil or nCommandedPlayer == nPlayerID ) and PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero ~= nil then
				printf("adding lives to %d", nPlayerID)
				hPlayerHero.nRespawnsRemaining = math.min( hPlayerHero.nRespawnsMax, hPlayerHero.nRespawnsRemaining + 1 )
				CustomGameEventManager:Send_ServerToPlayer( hPlayerHero:GetPlayerOwner(), "gained_life", {} )
				CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ),  { respawns = hPlayerHero.nRespawnsRemaining } )
			end	
		end
	end
end

--------------------------------------------------------------------------------

function CAghanim:Dev_KillPlayer( nCommandedPlayer )

	if nCommandedPlayer == -1 or nCommandedPlayer > DOTA_MAX_TEAM_PLAYERS - 1 then
		nCommandedPlayer = nil
	end
	local bForceCheckDefeat = true
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero ~= nil then
				local bNotDefeated = hPlayerHero:IsAlive() or hPlayerHero.nRespawnsRemaining > 0 or hPlayerHero:GetTimeUntilRespawn() > 2147483646
				if nCommandedPlayer == nil or nCommandedPlayer == nPlayerID then
					bNotDefeated = false
					printf("Killing player %d", nPlayerID)
					for i=1,hPlayerHero.nRespawnsRemaining do
						self:RegisterPlayerDeathStat( nPlayerID, self:GetCurrentRoom():GetDepth() )
					end
					hPlayerHero.nRespawnsRemaining = 0

					--CustomGameEventManager:Send_ServerToPlayer( hPlayerHero:GetPlayerOwner(), "life_lost", {} )
					CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ),  { respawns = 0 } )

					local damageInfo = 
					{
						victim = hPlayerHero,
						attacker = hPlayerHero,
						damage = 99999999,
						damage_type = DAMAGE_TYPE_PURE,
						ability = nil,
					}

					ApplyDamage( damageInfo )
				end
				if bNotDefeated then
					bForceCheckDefeat = false
				end
			end	
		end
	end
	if bForceCheckDefeat then
		self.bForceCheckDefeat = true
	end
end

--------------------------------------------------------------------------------

function CAghanim:Dev_TestEncounter( cmdName, szEncounterName, szIsElite )
	if GetMapName() == "hub" then 
		self:Dev_TestEncounter_2021( cmdName, szEncounterName, szIsElite )
		return
	end

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
	GameRules:GetGameModeEntity():SetThink( "OnTestEncounterThink", self, "TestEncounterThink", 0.1 )

end

--------------------------------------------------------------------------------

function CAghanim:Dev_TestEncounter_2021( cmdName, szTestEncounterName, szIsElite )
	local nEliteDepthBonus = 0
	if szIsElite ~= nil then
		nEliteDepthBonus = tonumber( szIsElite )
		if nEliteDepthBonus > 0 then
			nEliteDepthBonus = 1
		end
	end

	local encounterDef = ENCOUNTER_DEFINITIONS[ szTestEncounterName ]
	if encounterDef == nil then
		printf( "%s: Invalid encounter %s", cmdName, szTestEncounterName )
		return
	end

	local hCurrentRoom = self:GetCurrentRoom()
	if hCurrentRoom == nil then
		printf( "%s: Can't use since we're still loading", cmdName )
		return
	end

	local nCurrDepth = hCurrentRoom:GetDepth()

	local vecPossibleRoomDefs = {}
	for k,roomDef in pairs( MAP_ATLAS ) do
		for _,szRoomEncounterName in pairs ( roomDef.encounters ) do
			if szRoomEncounterName == szTestEncounterName then 
				table.insert( vecPossibleRoomDefs, roomDef )
			end
		end
	end

	if #vecPossibleRoomDefs == 0 then 
		print( "Error; test encounter found no valid rooms with the encounter " .. szTestEncounterName )
		return
	end

	local nLowestDepth = 999999 
	local hFinalRoom = nil 
	for _,testRoomDef in pairs ( vecPossibleRoomDefs ) do 
		if testRoomDef.nDepth < nLowestDepth then 
			hFinalRoom = self.rooms[ testRoomDef.name ]
			nLowestDepth = testRoomDef.nDepth 
		end 
	end

	if hFinalRoom == nil then 
		print( "Error; test encounter found no final room with the encounter " .. szTestEncounterName )
		return
	end

	if nLowestDepth <= nCurrDepth then 
		print( "Error; lowest possible depth is lower or equal to current depth" )
		return
	end

	print( "Dev_TestEncounter_2021: Beginning test encounter to room " .. hFinalRoom:GetName() .. " of encounter " .. szTestEncounterName )
	self.testEncounter =
	{
		hPrevRoom = self:GetCurrentRoom(),
		hFinalRoom = hFinalRoom,
		hExitRoom = nil,
		rewardClaimList = {}
	}

	self.debugItemsToStuffInCrate = 
	{
		RoomReward = {}
	}

	local hExitRoom = self.rooms[ self:GetCurrentRoom().szSingleExitRoomName ]
	local szNextRoomName = hExitRoom.szSingleExitRoomName
	while szNextRoomName ~= hFinalRoom:GetName() do 
		table.insert( self.testEncounter.rewardClaimList, hExitRoom )
		hExitRoom = self.rooms[ szNextRoomName ]
		print( "Adding room " .. szNextRoomName .. " to test_encounter auto complete" )

		szNextRoomName = hExitRoom.szSingleExitRoomName
		if szNextRoomName == "hub" then 
			if hExitRoom:GetName() == "a1_6_bonus" then 
				szNextRoomName = "a2_1"
			else
				szNextRoomName = "a3_1"
			end
		end

		if #self.testEncounter.rewardClaimList > 20 then 
			print( "error occured, stopping test encounter reward list addition" )
			break 
		end
	end

	if hExitRoom:GetType() == ROOM_TYPE_BONUS then 
		hExitRoom = self.rooms[ "hub" ]
	end

	print( "Dev_TestEncounter_2021: exit room: " .. hExitRoom:GetName() )
	
	hExitRoom.nExitChoices = 1
	hExitRoom.hEventRoom = nil 
	self.testEncounter.hExitRoom = hExitRoom

	print ( "Dev_TestEncounter_2021: Exit Room " .. hExitRoom:GetName() .. " has " .. hExitRoom.nExitChoices .. " exit choices" )

	hFinalRoom:SetEliteDepthBonus( nEliteDepthBonus )
	hFinalRoom:AssignEncounter( szTestEncounterName )
	hFinalRoom:SetRoomEncounterReward( szEncounterName, "REWARD_TYPE_GOLD" )
	hFinalRoom:GetEncounter():SelectAscensionAbilities()

	print( "Dev_TestEncounter_2021: Testing room " .. hFinalRoom:GetName() .. " has been set with encounter " .. szTestEncounterName )

		-- Win the current room assuming we haven't already won
	if self:GetCurrentRoom():GetDepth() ~= 1 and self:GetCurrentRoom():GetEncounter():IsComplete() == false then
		self:Dev_WinEncounter()
		self:GetCurrentRoom():GetEncounter():TryCompletingMapEncounter()
		self:GetCurrentRoom():GetEncounter():GenerateRewards()
	end

	GameRules:GetGameModeEntity():SetThink( "OnTestEncounterThink_2021", self, "TestEncounterThink", 0.25 )
end

--------------------------------------------------------------------------------

function CAghanim:Dev_ResetEncounter( )
	-- Reset the current room assuming we haven't already won
	if self:GetCurrentRoom():GetDepth() ~= 1 and self:GetCurrentRoom():GetEncounter():IsComplete() == false then
		self:GetCurrentRoom():GetEncounter():Dev_ResetEncounter()
	end
end

--------------------------------------------------------------------------------

function CAghanim:GrantEstimatedRoomRewards( hRoom )

	local nMinValue, nMaxValue = GetMinMaxGoldChoiceReward( hRoom:GetEncounter():GetDepth(), false )
	local nQuantity = math.random( nMinValue, nMaxValue ) / 3	-- *1/3 since it's 1/3 likely you'll pick it

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			PlayerResource:GetSelectedHeroEntity( nPlayerID ):ModifyGoldFiltered( nQuantity, true, DOTA_ModifyGold_Unspecified )
		end
	end

end

--------------------------------------------------------------------------------

function CAghanim:DetermineRewardSelectionState()

	local CurrentRoom = CustomNetTables:GetTableValue( "reward_options", "current_depth" )
	if CurrentRoom == nil then
		return nil
	end

	local szRoomDepth = CurrentRoom["1"]
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


function CAghanim:OnTestEncounterThink_2021()
	-- First handle all rewards being selected


	local CurrentRoom = CustomNetTables:GetTableValue( "reward_options", "current_depth" )
	if CurrentRoom == nil or self:HaveAllRewardsBeenSelected() == false then
		print( "OnTestEncounterThink_2021: All rewards have not been selected!" )
		return 0.1
	end

	local szRoomDepth = CurrentRoom["1"];
	print( "OnTestEncounterThink_2021:  Current depth: " .. szRoomDepth )
	-- Once all players have made a choice, deal with claiming the next depth

	local hRoom = nil 
	local szNextRoomName = nil 
	if #self.testEncounter.rewardClaimList > 0 then
	 	print( "OnTestEncounterThink_2021: Claiming rewards for room " .. self.testEncounter.rewardClaimList[1]:GetName() .. " depth " .. self.testEncounter.rewardClaimList[1]:GetDepth() ) 
	 	if ( tonumber( szRoomDepth ) + 1 ) ~= self.testEncounter.rewardClaimList[1]:GetDepth() then
	 		printf( "OnTestEncounterThink_2021: Warning!! Unexpected depth in claim list [was %d, expected %d]!!", self.testEncounter.rewardClaimList[1]:GetDepth(), tonumber( szRoomDepth ) + 1 )
	 	end

		hRoom = self.testEncounter.rewardClaimList[1]
		self.testEncounter.hPrevRoom = hRoom
		if hRoom == nil then 
			print( "OnTestEncounterThink_2021: Room is nil!" )
		end

		if hRoom:GetEncounter() == nil  then 
			print( "OnTestEncounterThink_2021: test encounter assigning room " .. hRoom:GetName() .. " encounter " .. hRoom.vecPotentialEncounters[ 1 ].szEncounterName )
			local szMapName = ENCOUNTER_DEFINITIONS[ hRoom.vecPotentialEncounters[ 1 ].szEncounterName ].szMapNames[ 1 ]
			hRoom:AssignPendingEncounter( hRoom.vecPotentialEncounters[ 1 ] )
			hRoom.szMapName = szMapName
		end
		
		hRoom:GetEncounter():GenerateRewards()
		self:GrantEstimatedRoomRewards( hRoom )

		szNextRoomName = hRoom.szSingleExitRoomName
		print( "OnTestEncounterThink_2021: Setting next room name: " .. szNextRoomName )

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

		if #self.testEncounter.rewardClaimList == 0 then 
			print( "OnTestEncounterThink_2021: Claimed reward list completed!" )
		end

		return 0.1
	end

	if self.testEncounter.hPrevRoom.szSingleExitRoomName then 
		print( "OnTestEncounterThink_2021: Setting next room: " .. self.testEncounter.hPrevRoom.szSingleExitRoomName )
	end
	
	local hNextRoom = self.rooms[ self.testEncounter.hPrevRoom.szSingleExitRoomName ]
	if hNextRoom ~= self.testEncounter.hExitRoom then 
		hNextRoom = self.testEncounter.hExitRoom
		print( "OnTestEncounterThink_2021: Setting final room: " .. self.testEncounter.hFinalRoom:GetName() )
	end

	if hNextRoom and hNextRoom:GetName() == "hub" or hNextRoom:GetType() == ROOM_TYPE_BONUS then 
		local Hub = self.rooms[ "hub" ]
		if self.testEncounter.bFinalRoomSelected == nil then
			local nNewAct = self.testEncounter.hPrevRoom:GetAct() + 1
			print( "OnTestEncounterThink_2021: Updating hub act: " .. nNewAct )
			Hub:GetEncounter():UpdateAct( nNewAct, self.testEncounter.hPrevRoom.nDepth )
		end
	end

	if self:GetCurrentRoom() ~= hNextRoom then 
		print( "OnTestEncounterThink_2021: Current Room in test encounter is " .. self:GetCurrentRoom():GetName() .. ", we need " .. hNextRoom:GetName() )
		if self.testEncounter.bHasTeleported then
			print( "OnTestEncounterThink_2021: We already teleported?" )
			self.testEncounter.bHasTeleported = false 
			return 0.1
		end

		if self.testEncounter.bFinalRoomSelected == nil then 
			print( "OnTestEncounterThink_2021: final room selected: " .. hNextRoom:GetName() )
			if hNextRoom:GetEncounter() then 
				print( "OnTestEncounterThink_2021: Final Room had its encounter set." )
				self.testEncounter.hPrevRoom:OnNextRoomSelected( hNextRoom:GetName(), hNextRoom:GetEncounter():GetName() )
			else
				self.testEncounter.hPrevRoom:OnNextRoomSelected( hNextRoom:GetName(), hNextRoom.vecPotentialEncounters[ 1 ].szEncounterName )
			end
			self.testEncounter.bFinalRoomSelected = true
			return 0.1 
		end

		if hNextRoom.bRoomGeometryReady == false or hNextRoom.bSpawnGroupReady == false then 
			print( "OnTestEncounterThink_2021: room geo not ready?" )
			if hNextRoom:GetEncounter() == nil then 
				print( "encounter is nil!" )
			else
				print( hNextRoom:GetEncounter():GetName() )
			end
			return 0.1 
		end

		-- teleport all players into the prev room, we're ready to go
		local vTeleportTarget = hNextRoom:GetOrigin()
		local hEndLocators = hNextRoom:FindAllEntitiesInRoomByName( "encounter_end_locator", true )
		if #hEndLocators > 0 then
			vTeleportTarget = hEndLocators[1]:GetAbsOrigin()
		end

		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
     			if hPlayerHero ~= nil then
     				print( "OnTestEncounterThink_2021: teleporting player from " .. tostring( hPlayerHero:GetAbsOrigin() ) .. " to " .. tostring( vTeleportTarget ) )
     				hPlayerHero:RemoveModifierByName( "modifier_battle_royale" )
     				FindClearSpaceForUnit( hPlayerHero, vTeleportTarget, true )
     				CenterCameraOnUnit( nPlayerID, hPlayerHero )
				end
			end
		end

		self.testEncounter.bHasTeleported = true
		return 0.1
	end

	-- Ok, we've teleported. Now we can finish the prev room and get its rewards
	if self:GetCurrentRoom() and self:GetCurrentRoom():GetEncounter() then 
		if self:GetCurrentRoom():GetEncounter():HasStarted() == false then 
			self:GetCurrentRoom():GetEncounter():Start()
		end
		print( "OnTestEncounterThink_2021: test encounter current room:" .. self:GetCurrentRoom():GetName() )
		self:GetCurrentRoom().nExitChoices = 1
		self:GetCurrentRoom().hEventRoom = nil 
		
	end

     
    for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero ~= nil then
				hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_battle_royale", { } )
			end
		end
	end

	self:Dev_WinEncounter()
	self.testEncounter = nil
	
	-- Disable thinking
	print( "OnTestEncounterThink_2021: Test Encounter Complete!" )
	return nil
end

--------------------------------------------------------------------------------

function CAghanim:EstimateFilteredGold( nPlayerID, nGoldAmount, nReason )
	--printf( "$$ Running estimated filter for %d for %d with reason %d", nPlayerID, nGoldAmount, nReason )
	local filterTable = {}
	filterTable[ "player_id_const" ] = nPlayerID
	filterTable[ "gold" ] = nGoldAmount
	filterTable[ "reason_const" ] = nReason
	local bOK = self:FilterModifyGold( filterTable )
	if bOK ~= true then
		filterTable[ "gold" ] = 0
	end
	--printf( "$$ Resulting gold %d", filterTable[ "gold" ] )
	return filterTable[ "gold" ]
end
