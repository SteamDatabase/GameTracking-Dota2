
--------------------------------------------------------------------------------

print( "Cavern addon is booting up..." )

if CCavern == nil then
	CCavern = class({})
	_G.CCavern = CCavern
end

--------------------------------------------------------------------------------

require( "constants" ) -- require constants first
require( "utility_functions" ) -- require utility_functions early (other required files may use its functions)
require( "cavern_utility_functions" ) 
require( "precache" )
require( "events" )
require( "filters" )
require( "triggers" )
require( "cavern_encounters_table" )
require( "cavern_room" )
require( "cavern_hud_roshan" )
require( "cavern_roshan" ) 
require( "tables/treasure_chest_rewards" )
require( "voice_lines" )

LinkLuaModifier( "modifier_antechamber_start",			"modifiers/modifier_antechamber_start",    		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_attack_speed_bonus",			"modifiers/modifier_attack_speed_bonus",   		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blocked_gate", 				"modifiers/modifier_blocked_gate", 				LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_breakable_container", 		"modifiers/modifier_breakable_container", 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_penalty", 				"modifiers/modifier_death_penalty", 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disable_autoattack", 		"modifiers/modifier_disable_autoattack", 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_force_draw_minimap", 		"modifiers/modifier_force_draw_minimap", 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_spawner", 			"modifiers/modifier_generic_spawner", 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_player_light",				"modifiers/modifier_player_light",				LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_room_destruction",			"modifiers/modifier_room_destruction",    		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_chest", 			"modifiers/modifier_treasure_chest", 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treasure_chest_anim", 		"modifiers/modifier_treasure_chest_anim", 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_destructible_gate", 			"modifiers/modifier_destructible_gate", 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_destructible_gate_anim",		"modifiers/modifier_destructible_gate_anim",	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_invuln",				"modifiers/modifier_lycan_invuln",				LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_lich_statue", 		"modifiers/modifier_creature_lich_statue", 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_provides_fow_position", 		"modifiers/modifier_provides_fow_position", 	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_not_on_minimap", 			"modifiers/modifier_not_on_minimap", 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_troll_camp", 				"modifiers/modifier_troll_camp", 				LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function Precache( context )
	print( "Preaching Cavern assets..." )
	GameRules.Cavern = CCavern()

	for _,Item in pairs( g_ItemPrecache ) do
    	PrecacheItemByNameSync( Item, context )
    end

    for _,Unit in pairs( g_UnitPrecache ) do
    	PrecacheUnitByNameAsync( Unit, function( unit ) end )
    end

    for _,Model in pairs( g_ModelPrecache ) do
    	PrecacheResource( "model", Model, context )
    end

	for _,Model in pairs( CavernTreeModelNames ) do
    	PrecacheResource( "model", Model, context )
    end

    for _,Particle in pairs( g_ParticlePrecache ) do
    	PrecacheResource( "particle", Particle, context )
    end

    for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
    	PrecacheResource( "particle_folder", ParticleFolder, context )
    end

    for _,Sound in pairs( g_SoundPrecache ) do
    	PrecacheResource( "soundfile", Sound, context )
    end
end

--------------------------------------------------------------------------------

function Activate()
	print( "Activating Cavern game mode..." )
	GameRules.Cavern:InitGameMode()
end

--------------------------------------------------------------------------------

function CCavern:InitGameMode()
	print( "CCavern:InitGameMode()" )

	self.m_TeamColors = {}
	self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 243, 201, 9 }		--		Yellow
	self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }		--		Orange
	self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }		--		Blue
	self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }	--		Green
	self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }		--		Brown
	self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }	--		Cyan
	self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }	--		Olive
	self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }	--		Purple

	-- Color for Radiant team
	local radiantColor = { 61, 210, 150 } -- Teal
	SetTeamCustomHealthbarColor( DOTA_TEAM_GOODGUYS, radiantColor[1], radiantColor[2], radiantColor[3] )

	-- Colors for custom teams.  Start at 2 because we don't want to change Dire team's color.
	for team = 2, ( DOTA_TEAM_COUNT - 1 ) do
		color = self.m_TeamColors[ team ]
		if color then
			SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
		end
	end

	self.Rooms = {}
	self.LivingHeroes = {}
	self.LivingTeams = {}
	self.RoomsDiscoveredByTeam = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_1] = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_2] = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_3] = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_4] = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_5] = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_6] = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_7] = {}
	self.RoomsDiscoveredByTeam[DOTA_TEAM_CUSTOM_8] = {}

	self.nFullTeams = 0
	self.bEnforceRoomTypeRatio = true

	self.CombatEncounterPool = { {}, {}, {}, {}, {} }
	self.TrapEncounterPool = {}
	
	self.nNextTeamFinishPosition = CAVERN_TEAMS_PER_GAME
	self.HeroesByTeam = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_1] = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_2] = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_3] = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_4] = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_5] = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_6] = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_7] = {}
	self.HeroesByTeam[DOTA_TEAM_CUSTOM_8] = {}

	self.EventMetaData = {}
	self.EventMetaData[ "event_name" ]  = "underhollow"
	self.PlayerPointsData = {}
	self.SignOutTable = {}

	self.DevExpressMode = false
	if GameRules:GetGameSessionConfigValue("DevExpressMode", "0") == "1" then
		self.DevExpressMode = true
	end

	self.DevDisableRosh = false
	if GameRules:GetGameSessionConfigValue("DevDisableRosh", "0") == "1" then
		self.DevDisableRosh = true
	end

	self.SpawnGroups = {}
	self.Encounters = {}
	self.Roshan = nil
	self.TrapsPerDepth = CAVERN_TRAPS_PER_DEPTH

	self.bUseTeamSelect = false

	self.bBigCheeseDropped = false

	self.bFillWithBots = false
	if self.DevExpressMode == true then
		self.bFillWithBots = false
	end

	self.GameMode = GameRules:GetGameModeEntity()
	self:SetupAchievements()
	self:SetupGameRules()
	self:SetupGameModeEntity()
	self:SetupGameEventListeners()

	self:RegisterConCommands()

	self.flNextGameReportTime = GameRules:GetGameTime() + CAVERN_GAME_REPORT_INTERVAL

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )
end

--------------------------------------------------------------------------------

function CCavern:SetupAchievements()
	self.SignOutTable["points"] = {}
	self.SignOutTable["chickens_found"] = {}
	self.SignOutTable["stats"] = {}
	self.SignOutTable["big_cheese"] = {}
	self.SignOutTable["encounters_cleared"] = {}
end

--------------------------------------------------------------------------------

function CCavern:SetupGameRules()
	print( "CCavern:SetupGameRules()" )
	if self.bUseTeamSelect == true then
		GameRules:SetCustomGameSetupTimeout( 30 )
		GameRules:SetCustomGameSetupAutoLaunchDelay( 30 )
	else
		GameRules:SetCustomGameSetupTimeout( 0 )
		GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	end
	
	GameRules:SetHeroRespawnEnabled( false )	
	GameRules:SetHeroSelectionTime( 60.0 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetPreGameTime( 45.0 )
	GameRules:SetPostGameTime( 45.0 )
	GameRules:SetTreeRegrowTime( 300.0 )
	GameRules:SetStartingGold( CAVERN_STARTING_GOLD )
	GameRules:SetGoldTickTime( 999999.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetSafeToLeave( true )
	GameRules:SetSameHeroSelectionEnabled( false )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroMinimapIconScale( 0.75 )
	GameRules:SetCustomGameAllowHeroPickMusic( false )
	
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	for nCurTeam = DOTA_TEAM_CUSTOM_1,( DOTA_TEAM_CUSTOM_1 + CAVERN_TEAMS_PER_GAME - 1 ) do
		GameRules:SetCustomGameTeamMaxPlayers( nCurTeam, CAVERN_PLAYERS_PER_TEAM )
	end

	if self.DevExpressMode then
		GameRules:SetCustomGameSetupTimeout( 1 )
		GameRules:SetCustomGameSetupAutoLaunchDelay( 1 )
		GameRules:SetHeroSelectionTime( 5.0 )
		GameRules:SetPreGameTime( 5.0 )
		GameRules:SetPostGameTime( 10.0 )
	end

end

--------------------------------------------------------------------------------

function CCavern:SetupGameModeEntity()
	print( "CCavern:SetupGameModeEntity()" )
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )
 	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled( false )
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
	GameRules:GetGameModeEntity():SetKillableTombstones( true )
	GameRules:GetGameModeEntity():SetCustomScanCooldown( CAVERN_SCAN_COOLDOWN )
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( false )
	GameRules:GetGameModeEntity():SetPauseEnabled( false )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( CCavern, "ItemAddedToInventoryFilter" ), self )
end

--------------------------------------------------------------------------------

function CCavern:SetupGameEventListeners()
	print( "CCavern:SetupGameEventListeners()" )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CCavern, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( CCavern, 'OnPlayerReconnected' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CCavern, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CCavern, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CCavern, "OnPlayerGainedLevel" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CCavern, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( CCavern, "OnPlayerRevived" ), self )
	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( CCavern, "OnPlayerBuyback" ), self )
	ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( CCavern, "OnItemSpawned" ), self )
	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( CCavern, "OnNonPlayerUsedAbility" ), self )
	ListenToGameEvent( "dota_on_hero_finish_spawn", Dynamic_Wrap( CCavern, "OnHeroFinishSpawn" ), self )
	ListenToGameEvent( "dota_holdout_revive_eliminated", Dynamic_Wrap( CCavern, "OnPlayerReviveEliminated" ), self )
end

--------------------------------------------------------------------------------

function CCavern:SetupEncounters()
	print( "CCavern:SetupEncounters()" )
	for _,Encounter in pairs ( g_Encounters ) do
		require( string.format( "encounters.%s", Encounter ) )
		local newEncounter = _G[Encounter]
		if newEncounter ~= nil then
			local newEncounterTableEntry = 
			{
				szName = Encounter,
				Levels = newEncounter:GetEncounterLevels(),
				nType = newEncounter:GetEncounterType(),
			}
			table.insert( self.Encounters, newEncounterTableEntry )
		end
	end
	--PrintTable( self.Encounters, " "  )
end

--------------------------------------------------------------------------------

function CCavern:SetupRooms()
	print( "CCavern:SetupRooms()" )

	-- clear out the gate array
	CCavernGate.Reset()

	local nRoomCount = CAVERN_GRID_WIDTH * CAVERN_GRID_HEIGHT
	
	self:RegenerateWeightList()

	local ValidSpawnRooms = {}
	local ValidRoshanSpawnRooms = {}
	local ValidCheeseSpawnRooms = {}

	for j=1,nRoomCount do
		local hRoomVolume = Entities:FindByName( nil, "room_" .. j )
		if hRoomVolume == nil then
			print( "CCavern:SetupRooms - ERROR - No room volume found for room # " .. j )
			return
		end

		local newRoom = CCavernRoom( j, CAVERN_ROOM_TYPE_INVALID, hRoomVolume )
		table.insert( self.Rooms, j, newRoom )
	end

	for _,Room in pairs( self.Rooms ) do
		local hAntechamberVolume = Entities:FindByName( nil, "room_" .. Room:GetRoomID() .. "_ante" )
		if hAntechamberVolume == nil then
			--print( "CCavern:SetupRooms - ERROR - No antechamber volume found for room # " .. Room:GetRoomID() )
		else
			Room:SetAntechamberVolume( hAntechamberVolume )
		--	print( "Assigning antechamber volume for room " .. Room:GetRoomID() )
		end
		if Room:IsValidSpawnRoom() then
			table.insert( ValidSpawnRooms, Room )
		end
		if Room:IsValidRoshanSpawnRoom() then
			table.insert( ValidRoshanSpawnRooms, Room )
		end
		if Room:IsValidCheeseSpawnRoom() then
			table.insert( ValidCheeseSpawnRooms, Room )
		end
	end

	for _,Room in pairs( self.Rooms ) do
		self:GenerateRoomAdjacency( Room )
	end

	if CAVERN_PLAYER_SPAWN_SYMMETRY == true then
		local TeamsToSpawn = {}
		for nTeam=DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_1+CAVERN_TEAMS_PER_GAME-1 do
			table.insert( TeamsToSpawn, nTeam )
		end

		local nFirstSpawnRoomIdx = RandomInt( 1, #ValidSpawnRooms )
		local FirstSpawnRoom = self.Rooms[4]--ValidSpawnRooms[nFirstSpawnRoomIdx]
		local nFirstSpawnTeamIdx = RandomInt( 1, #TeamsToSpawn )
		
		FirstSpawnRoom:SetTeamSpawnInRoom( TeamsToSpawn[nFirstSpawnTeamIdx] )
		print( "Team " .. TeamsToSpawn[nFirstSpawnTeamIdx] .. " is set to spawn in room " .. FirstSpawnRoom:GetRoomID() )
	 	table.remove( TeamsToSpawn, nFirstSpawnTeamIdx )
	 --	self:BlockNeighborPathsBetweenSpawns( FirstSpawnRoom )
	
		local nNextXMin = FirstSpawnRoom:GetRoomX() - ( ( CAVERN_GRID_WIDTH / 2 ) - 1 )
		local nNextXMax = FirstSpawnRoom:GetRoomX() + ( ( CAVERN_GRID_WIDTH / 2 ) - 1 )
		local nNextX = nil
		local nNextY = FirstSpawnRoom:GetRoomY()
		if nNextXMin > 0 then
			nNextX = nNextXMin
		else
			nNextX = nNextXMax
		end

		--print( "Next X: " .. nNextX )
		--print( "Next Y: " .. nNextY )

		local SecondSpawnRoom = nil
		for _,TestSecondRoom in pairs ( self.Rooms ) do
			if TestSecondRoom ~= nil and TestSecondRoom:GetRoomX() == nNextX and TestSecondRoom:GetRoomY() == nNextY then
				SecondSpawnRoom = TestSecondRoom
			end
		end

		local nSecondSpawnTeamIdx = RandomInt( 1, #TeamsToSpawn )
		SecondSpawnRoom:SetTeamSpawnInRoom( TeamsToSpawn[nSecondSpawnTeamIdx] )
		print( "Team " .. TeamsToSpawn[nSecondSpawnTeamIdx] .. " is set to spawn in room " .. SecondSpawnRoom:GetRoomID() )
		table.remove( TeamsToSpawn, nSecondSpawnTeamIdx )
	--	self:BlockNeighborPathsBetweenSpawns( SecondSpawnRoom )

		local nX1Dist = FirstSpawnRoom:GetRoomX()
		local nY1Dist = FirstSpawnRoom:GetRoomY()
		local nX2Dist = SecondSpawnRoom:GetRoomX() 
		local nY2Dist = SecondSpawnRoom:GetRoomY() 

		local RemainingSpawnRoomXs = { 	FirstSpawnRoom:GetRoomY(), SecondSpawnRoom:GetRoomY(), 
										CAVERN_GRID_WIDTH, CAVERN_GRID_WIDTH, 
										CAVERN_GRID_WIDTH - nX1Dist, CAVERN_GRID_WIDTH - nX2Dist }
		
		local RemainingSpawnRoomYs = { 	CAVERN_GRID_HEIGHT - nX1Dist, CAVERN_GRID_HEIGHT - nX2Dist, 
										FirstSpawnRoom:GetRoomX(), SecondSpawnRoom:GetRoomX(), 
										CAVERN_GRID_HEIGHT, CAVERN_GRID_HEIGHT }

		for _,nTeamID in pairs ( TeamsToSpawn ) do
			local nRandomRoomIdx = RandomInt( 1, #RemainingSpawnRoomXs )
			local x = RemainingSpawnRoomXs[nRandomRoomIdx]
			local y = RemainingSpawnRoomYs[nRandomRoomIdx]
			local SpawnRoom = nil
			for _, Room in pairs( self.Rooms ) do
				if Room ~= nil and Room:GetRoomX() == x and Room:GetRoomY() == y then
					SpawnRoom = Room
				end
			end

			SpawnRoom:SetTeamSpawnInRoom( nTeamID )
			table.remove( RemainingSpawnRoomXs, nRandomRoomIdx )
			table.remove( RemainingSpawnRoomYs, nRandomRoomIdx )
			print( "Team " .. nTeamID .. " is set to spawn in room " .. SpawnRoom:GetRoomID() )
		--	self:BlockNeighborPathsBetweenSpawns( SpawnRoom )
		end
	else
		local nTeamsSpawnPlacementRemaining = CAVERN_TEAMS_PER_GAME
		for nTeam=DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_1+CAVERN_TEAMS_PER_GAME-1 do
			local nRandomRoomIDX = RandomInt( 1, #ValidSpawnRooms )
			local SpawnRoom = ValidSpawnRooms[nRandomRoomIDX]

			for i = #ValidSpawnRooms,1,-1 do
				if SpawnRoom == ValidSpawnRooms[i] then
				--	print( "Team Spawn: Removing spawn room " .. SpawnRoom:GetRoomID() )
					table.remove( ValidSpawnRooms, i )
				end
			end

			print( "Team " .. nTeam .. " is set to spawn in room " .. SpawnRoom:GetRoomID() )
			nTeamsSpawnPlacementRemaining = nTeamsSpawnPlacementRemaining - 1
			
			for nDir = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
				local SpawnRoomNeighbor = SpawnRoom:GetNeighboringRoom( nDir )
				if SpawnRoomNeighbor ~= nil then
					for j = #ValidSpawnRooms,1,-1 do
						if SpawnRoomNeighbor == ValidSpawnRooms[j] and #ValidSpawnRooms > nTeamsSpawnPlacementRemaining then
						--	print( "Neighbor: Removing spawn room " .. SpawnRoomNeighbor:GetRoomID() )
							table.remove( ValidSpawnRooms, j )
						end
					end
					for nDir2 = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
						local SpawnRoomSecondNeighbor = SpawnRoomNeighbor:GetNeighboringRoom( nDir2 )
						if SpawnRoomSecondNeighbor ~= nil then
							for k = #ValidSpawnRooms,1,-1 do
								if SpawnRoomSecondNeighbor == ValidSpawnRooms[k] and RandomInt( 0, 4 ) ~= 0 and #ValidSpawnRooms > nTeamsSpawnPlacementRemaining then
								--	print( "Second Neighbor: Removing spawn room " .. SpawnRoomSecondNeighbor:GetRoomID() )
									SpawnRoomNeighbor:SetPath( nDir2, CAVERN_PATH_TYPE_DESTRUCTIBLE )
									SpawnRoomSecondNeighbor:SetPath( CAVERN_PATH_OPPOSITES[nDir2], CAVERN_PATH_TYPE_DESTRUCTIBLE )
									table.remove( ValidSpawnRooms, k )
								end
							end
						end
					end
				end
			end

			SpawnRoom:SetTeamSpawnInRoom( nTeam )
			SpawnRoom:SetRoomType( CAVERN_ROOM_TYPE_MOB )
		 	SpawnRoom:SetRoomLevel( 1 )
		end
	end
	
	self:GenerateDifficultiesConcentric()

	for _,Room in pairs( self.Rooms ) do
		self:GeneratePaths( Room )
	end

	for _,Room in pairs( self.Rooms ) do
		self:BlockPathsLeadingToCenter( Room )
		if Room:GetTeamSpawnInRoom() ~= nil then
			self:BlockNeighborPathsBetweenSpawns( Room )
		end
	end

	for _,Room in pairs( self.Rooms ) do
		self:GenerateRoomTypes( Room )
	end

	for _,Room in pairs( self.Rooms ) do
		self:GenerateEncounters( Room )
		if CAVERN_ENCOUNTER_SPAWN_MODE == CAVERN_ENCOUNTER_SPAWN_ALL then
			Room:StartEncounter()
		end
	end

	for _,Room in pairs( self.Rooms ) do
		self:ReplacePathsBasedOnRoom( Room, CAVERN_ROOM_TYPE_TRAP, CAVERN_PATH_TYPE_OPEN, CAVERN_PATH_TYPE_DESTRUCTIBLE )
	end


	local RoshRoom = nil
	for _,PotentialRoshRoom in pairs( ValidRoshanSpawnRooms ) do
		if PotentialRoshRoom ~= nil and PotentialRoshRoom:GetTeamSpawnInRoom() == nil then
			RoshRoom = PotentialRoshRoom
		end
	end
	if CAVERN_ROSHAN_AS_HUD_ELEMENT == true then
		self.Roshan = CCavernHUDRoshan( RoshRoom )
	else
		
		self.Roshan = CCavernRoshan( RoshRoom )
	end 

	

	self:PrintRoomDebugGrid()
	--self:PrintRoomAccessibility()
end

--------------------------------------------------------------------

function CCavern:BlockNeighborPathsBetweenSpawns( Room )
	local PossibleRoomSets = {}
	for nDir = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		local RoomSet = {}
		local Neighbor = Room:GetNeighboringRoom( nDir )
		if Neighbor ~= nil and Neighbor:GetDepth() == 1 and Neighbor:GetTeamInitialCombatRoom() == nil then
			--Check secondary neighbor to make sure this path is long enough
			table.insert( RoomSet, Neighbor )
			for nDir2 = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
				local Neighbor2 = Neighbor:GetNeighboringRoom( nDir2 )
				if Neighbor2 ~= nil and Neighbor2:GetDepth() == 1 and Neighbor2:GetTeamInitialCombatRoom() == nil and Neighbor2 ~= Room then
					table.insert( RoomSet, Neighbor2 )
					table.insert( PossibleRoomSets, RoomSet )
				end
			end
		end
 	end

 	local nRoomSetIdx = RandomInt( 1, #PossibleRoomSets )
 	local RoomSetForTeam = PossibleRoomSets[nRoomSetIdx]
 	if #RoomSetForTeam ~= 2 then
 		print ( "ERROR - Room Set for Team is not 2 rooms!" )
 	end

 	-- Block path directly across from antechamber
 	local AntechamberDirNeighbor = Room:GetNeighboringRoom( CAVERN_PATH_OPPOSITES[Room:GetAntechamberPathDirection()] )
 	if AntechamberDirNeighbor ~= nil and AntechamberDirNeighbor:GetDepth() > Room:GetDepth() then
		Room:SetPath( CAVERN_PATH_OPPOSITES[Room:GetAntechamberPathDirection()], CAVERN_PATH_TYPE_BLOCKED )
		AntechamberDirNeighbor:SetPath( Room:GetAntechamberPathDirection(), CAVERN_PATH_TYPE_BLOCKED )
	end

	local CombatRoom = RoomSetForTeam[1]
	local CombatRoom2 = RoomSetForTeam[2]

	--Block the alternate path that doesn't belong to us
 	for nDir = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
 		local AlternatePathNeighbor = Room:GetNeighboringRoom( nDir )
 		if AlternatePathNeighbor ~= nil and AlternatePathNeighbor:GetDepth() == 1 and AlternatePathNeighbor ~= CombatRoom then
 			Room:SetPath( nDir, CAVERN_PATH_TYPE_BLOCKED )
 			AlternatePathNeighbor:SetPath( CAVERN_PATH_OPPOSITES[nDir], CAVERN_PATH_TYPE_BLOCKED )
 		end
 	end 

	--Block the path from Combat 1 to the mid
	CombatRoom:SetTeamInitialCombatRoom( Room:GetTeamSpawnInRoom() )
 	for nDir = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
 		local CombatRoomNeighbor = CombatRoom:GetNeighboringRoom( nDir )
 		if CombatRoomNeighbor ~= nil and CombatRoomNeighbor:GetDepth() > 1 then
 			CombatRoom:SetPath( nDir, CAVERN_PATH_TYPE_BLOCKED )
 			CombatRoomNeighbor:SetPath( CAVERN_PATH_OPPOSITES[nDir], CAVERN_PATH_TYPE_BLOCKED )
 		end
 	end 
 	
 	--Destructible path leading away from the spawn
 	CombatRoom2:SetTeamInitialCombatRoom( Room:GetTeamSpawnInRoom() )
 	for nDir = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
 		local CombatRoomNeighbor2 = CombatRoom2:GetNeighboringRoom( nDir )
 		if CombatRoomNeighbor2 ~= nil and CombatRoomNeighbor2 ~= CombatRoom then
 			CombatRoom2:SetPath( nDir, CAVERN_PATH_TYPE_DESTRUCTIBLE )
 			CombatRoomNeighbor2:SetPath( CAVERN_PATH_OPPOSITES[nDir], CAVERN_PATH_TYPE_DESTRUCTIBLE )
 		end
 	end 
end

--------------------------------------------------------------------

function CCavern:GenerateRoomTypes( Room )
	if Room:GetRoomType() ~= CAVERN_ROOM_TYPE_INVALID then
		return
	end

	--if #self.WeightedResults == 0 then
	--	self:RegenerateWeightList()
	--end

	--local nRoomHorizontalPos = Room:GetRoomX()
--	local nRoomVerticalPos = Room:GetRoomY()

	if Room:GetDepth() == 1 or Room:GetDepth() == 4 then
		if Room:GetDepth() == 1 and Room:GetTeamInitialCombatRoom() == nil then
			Room:SetRoomType( CAVERN_ROOM_TYPE_TRAP )
		else
			Room:SetRoomType( CAVERN_ROOM_TYPE_MOB )
		end
	else
		local RoomType = CAVERN_ROOM_TYPE_MOB
		--print( "there are " .. self.TrapsPerDepth[Room:GetDepth()]  .. " traps remaining at depth " .. Room:GetDepth() )
		if self.TrapsPerDepth[Room:GetDepth()] > 0 then
			local nRoll = RandomInt( 0, 4 )
			if nRoll == 0 then
				RoomType = CAVERN_ROOM_TYPE_TRAP
				self.TrapsPerDepth[Room:GetDepth()] = self.TrapsPerDepth[Room:GetDepth()] - 1
			end
		end

		Room:SetRoomType( RoomType )
		--local nTypeIndex = RandomInt( 1, #self.WeightedResults )
		--Room:SetRoomType( self.WeightedResults[nTypeIndex] )

		--if self.bEnforceRoomTypeRatio then
		--	table.remove( self.WeightedResults, nTypeIndex )
		--end
	end
end

--------------------------------------------------------------------
function CCavern:GenerateRoomAdjacency( Room )

	local nRoomID = Room:GetRoomID()
	local nRoomHorizontalPos = Room:GetRoomX()
	local nRoomVerticalPos = Room:GetRoomY()

	--If we're next to a room that already generated, share its path
	local NorthRoom = self.Rooms[nRoomID - CAVERN_GRID_WIDTH]
	if NorthRoom ~= nil then
		Room:SetNeighboringRoom( CAVERN_PATH_DIR_NORTH, NorthRoom )	
		NorthRoom:SetNeighboringRoom( CAVERN_PATH_DIR_SOUTH, Room )
	end
	local SouthRoom = self.Rooms[nRoomID + CAVERN_GRID_WIDTH]
	if SouthRoom ~= nil then
		Room:SetNeighboringRoom( CAVERN_PATH_DIR_SOUTH, SouthRoom )
		SouthRoom:SetNeighboringRoom( CAVERN_PATH_DIR_NORTH, Room )	
	end
	local WestRoom = self.Rooms[nRoomID - 1]
	if WestRoom ~= nil and nRoomHorizontalPos ~= 1 then
		Room:SetNeighboringRoom( CAVERN_PATH_DIR_WEST, WestRoom )
		WestRoom:SetNeighboringRoom( CAVERN_PATH_DIR_EAST, Room )		
	end
	local EastRoom = self.Rooms[nRoomID + 1]
	if EastRoom ~= nil  and nRoomHorizontalPos ~= CAVERN_GRID_WIDTH  then
		Room:SetNeighboringRoom( CAVERN_PATH_DIR_EAST, EastRoom )
		EastRoom:SetNeighboringRoom( CAVERN_PATH_DIR_WEST, Room )
	end
end


function CCavern:GeneratePaths( Room )
	local nRoomID = Room:GetRoomID()
	--print( "Generating Paths for Room " .. nRoomID )
	local nRoomHorizontalPos = nRoomID % CAVERN_GRID_WIDTH
	if nRoomHorizontalPos == 0 then
		nRoomHorizontalPos = CAVERN_GRID_WIDTH
	end
	local nRoomVerticalPos = math.ceil( nRoomID / CAVERN_GRID_HEIGHT )
	Room:SetRoomXY( nRoomHorizontalPos, nRoomVerticalPos )
	--print( "( " .. nRoomHorizontalPos .. ", " .. nRoomVerticalPos .. " )" )

	local nCavernHallOpenWeightBonus = 0
	if Room.nRoomType == CAVERN_ROOM_TYPE_TRAP then
		nCavernHallOpenWeightBonus = 10
	end
	
	local RoomWeights = {}
	for nPath = 1,CAVERN_PATH_TYPE_BLOCKED do
		if nPath == CAVERN_PATH_TYPE_OPEN then
			for i = 0,CAVERN_HALL_OPEN_WEIGHT+nCavernHallOpenWeightBonus do
				table.insert( RoomWeights, CAVERN_PATH_TYPE_OPEN )
			end
		end
		if nPath == CAVERN_PATH_TYPE_DESTRUCTIBLE then
			for i = 0,CAVERN_HALL_DESTRUCTIBLE_WEIGHT do
				table.insert( RoomWeights, CAVERN_PATH_TYPE_DESTRUCTIBLE )
			end
		end
		if nPath == CAVERN_PATH_TYPE_BLOCKED then
			for i = 0,CAVERN_HALL_BLOCKED_WEIGHT do
				table.insert( RoomWeights, CAVERN_PATH_TYPE_BLOCKED )
			end
		end
	end

	-- Fill out map boundaries
	if nRoomHorizontalPos == 1 then
		Room:SetPath( CAVERN_PATH_DIR_WEST, CAVERN_PATH_TYPE_BLOCKED )
	end
	if nRoomHorizontalPos == CAVERN_GRID_WIDTH then
		Room:SetPath( CAVERN_PATH_DIR_EAST, CAVERN_PATH_TYPE_BLOCKED )
	end
	if nRoomVerticalPos == 1 then
		Room:SetPath( CAVERN_PATH_DIR_NORTH, CAVERN_PATH_TYPE_BLOCKED )
	end
	if nRoomVerticalPos == CAVERN_GRID_HEIGHT then
		Room:SetPath( CAVERN_PATH_DIR_SOUTH, CAVERN_PATH_TYPE_BLOCKED )
	end

	--If we're next to a room that already generated, share its path
	local NorthRoom = self.Rooms[nRoomID - CAVERN_GRID_WIDTH]
	if NorthRoom ~= nil then
		if NorthRoom:ArePathsGenerated() and Room:GetPath( CAVERN_PATH_DIR_NORTH ) == CAVERN_PATH_TYPE_INVALID then
			--print( "Inheriting north path from north neighbor" )
			Room:SetPath( CAVERN_PATH_DIR_NORTH, NorthRoom:GetPath( CAVERN_PATH_DIR_SOUTH ) )
		end
	end
	local SouthRoom = self.Rooms[nRoomID + CAVERN_GRID_WIDTH]
	if SouthRoom ~= nil then
		if SouthRoom:ArePathsGenerated() and Room:GetPath( CAVERN_PATH_DIR_SOUTH ) == CAVERN_PATH_TYPE_INVALID then	
			--print( "Inheriting south path from south neighbor" )	
			Room:SetPath( CAVERN_PATH_DIR_SOUTH, SouthRoom:GetPath( CAVERN_PATH_DIR_NORTH ) )
		end
	end
	local WestRoom = self.Rooms[nRoomID - 1]
	if WestRoom ~= nil and nRoomHorizontalPos ~= 1 then
		if WestRoom:ArePathsGenerated() and Room:GetPath( CAVERN_PATH_DIR_WEST ) == CAVERN_PATH_TYPE_INVALID then
			--print( "Inheriting west path from west neighbor" )			
			Room:SetPath( CAVERN_PATH_DIR_WEST, WestRoom:GetPath( CAVERN_PATH_DIR_EAST ) )
		end
	end
	local EastRoom = self.Rooms[nRoomID + 1]
	if EastRoom ~= nil  and nRoomHorizontalPos ~= CAVERN_GRID_WIDTH  then
		if EastRoom:ArePathsGenerated() and Room:GetPath( CAVERN_PATH_DIR_EAST ) == CAVERN_PATH_TYPE_INVALID then
			--print( "Inheriting east path from east neighbor" )				
			Room:SetPath( CAVERN_PATH_DIR_EAST, EastRoom:GetPath( CAVERN_PATH_DIR_WEST ) )
		end
	end

	local nBlockages = 0
	for nDirBlockCheck = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		if Room:GetPath( nDirBlockCheck ) == CAVERN_PATH_TYPE_BLOCKED then
			nBlockages = nBlockages + 1
		end
	end

	for nDirToAssign = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		if Room:GetPath( nDirToAssign ) == CAVERN_PATH_TYPE_INVALID then
			
			if (nRoomVerticalPos == 1 or nRoomVerticalPos == CAVERN_GRID_HEIGHT) and (nDirToAssign == CAVERN_PATH_DIR_WEST or nDirToAssign == CAVERN_PATH_DIR_EAST) then
				Room:SetPath( nDirToAssign, CAVERN_PATH_TYPE_OPEN )
			elseif (nRoomHorizontalPos == 1 or nRoomHorizontalPos == CAVERN_GRID_WIDTH) and (nDirToAssign == CAVERN_PATH_DIR_NORTH or nDirToAssign == CAVERN_PATH_DIR_SOUTH) then
				Room:SetPath( nDirToAssign, CAVERN_PATH_TYPE_OPEN )
			else
				local nIndex = RandomInt( 1, #RoomWeights )
				local nType = RoomWeights[nIndex]
				if nBlockages == 3 then
					repeat
						nIndex = RandomInt( 1, #RoomWeights )
						nType = RoomWeights[nIndex]
					until ( nType ~= CAVERN_PATH_TYPE_BLOCKED )
				end
				Room:SetPath( nDirToAssign, nType )
			end

			if nType == CAVERN_PATH_TYPE_BLOCKED then
				nBlockages = nBlockages + 1
			end
		end
	end

	local bRoomPassable = false
	for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		if Room:GetPath( nDir ) ~= CAVERN_PATH_TYPE_BLOCKED then
			bRoomPassable = true
		end
	end 

	if bRoomPassable == false then
		print( "WARNING: An impassable room has been generated!" )
	end
	Room:SetPathsGenerated( true )
end

--------------------------------------------------------------------

function CCavern:ReplacePathsBasedOnRoom( Room, nRoomType, nSourceType, nDestType )
	for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		if Room:GetRoomType() == nRoomType then
			if Room:GetPath( nDir ) == nSourceType then
				Room:SetPath( nDir , nDestType )
				local NeighboringRoom = Room:GetNeighboringRoom( nDir ) 
				if NeighboringRoom ~= nil then
					NeighboringRoom:SetPath( CAVERN_PATH_OPPOSITES[nDir] , nDestType )
				end
			end
		end
	end 
end

--------------------------------------------------------------------

function CCavern:BlockPathsLeadingToCenter( Room )	
	for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		local NeighboringRoom = Room:GetNeighboringRoom( nDir ) 
		if Room:GetPath( nDir ) == CAVERN_PATH_TYPE_OPEN then
			if Room:GetDepth() < NeighboringRoom:GetDepth() then
				local nResult = RandomInt( 0, 2 )
				local PathType = nil
				if nResult == 0 then
					PathType = CAVERN_PATH_TYPE_DESTRUCTIBLE
				else
					PathType = CAVERN_PATH_TYPE_BLOCKED
				end
				Room:SetPath( nDir , PathType )
				if NeighboringRoom ~= nil then
					NeighboringRoom:SetPath( CAVERN_PATH_OPPOSITES[nDir] , PathType )
				end
			end
		else
			-- Open ring 2/3 hack
			if ( Room:GetDepth() == 2 and NeighboringRoom:GetDepth() == 2 ) or ( Room:GetDepth() == 3 and NeighboringRoom:GetDepth() == 3 ) then
				Room:SetPath( nDir , CAVERN_PATH_TYPE_OPEN )
				NeighboringRoom:SetPath( CAVERN_PATH_OPPOSITES[nDir] , CAVERN_PATH_TYPE_OPEN )
			end
		end
	end 
end
	
--------------------------------------------------------------------

function CCavern:GenerateDifficultiesConcentric()

	local DifficultyProbabilities = { 
			{ {1,1},  }, 
			{ {1,2} }, 
			{ {1,3} }, 
			{ {1,4} }, 
		}

	for _,Room in pairs( self.Rooms ) do
		local nDepth = Room:GetDepth()
		local flRand = RandomFloat(0,1)
		local flAccumProb = 0
		for _,ProbTable in pairs(DifficultyProbabilities[nDepth]) do
			flAccumProb = flAccumProb + ProbTable[1]
			if flRand <= flAccumProb and Room:GetTeamSpawnInRoom() == nil then
				Room:SetRoomLevel(ProbTable[2])
				break
			end
		end
		
	end


end
--------------------------------------------------------------------

function CCavern:GenerateEncounters( Room )
	if Room:GetRoomLevel() == CAVERN_ROOM_DIFFICULTY_INVALID then
		print( "ERROR - Room has invalid difficulty!" )
		self:PrintRoomDebug( "", Room:GetRoomID() )
	end

	local PossibleEncounters

	if Room:GetRoomType() == CAVERN_ROOM_TYPE_TRAP then
		PossibleEncounters = self.TrapEncounterPool
	else
		PossibleEncounters = self.CombatEncounterPool[ Room:GetRoomLevel() ]
	end


	local NeighborEncounters = {}

	for nDir = CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		local Neighbor = Room:GetNeighboringRoom( nDir )
		if Neighbor ~= nil and Neighbor.szSelectedEncounterName ~= nil then
			table.insert( NeighborEncounters, Neighbor.szSelectedEncounterName )
		end
 	end

 	local bReshuffle = true

 	for _,PossibleEncounter in pairs(PossibleEncounters) do
 		if not TableContainsValue(NeighborEncounters, PossibleEncounter) then
 			bReshuffle = false
 		end
 	end

	if bReshuffle then
		PossibleEncounters = {}
		for _,CurEncounter in pairs( self.Encounters ) do
			if CurEncounter.nType == Room:GetRoomType() then
				for _,nLevel in pairs ( CurEncounter.Levels ) do
					if nLevel == Room:GetRoomLevel() then
						table.insert( PossibleEncounters, CurEncounter.szName )
					end
				end
			end
		end
	end

	--printf("pool has %d level %d encounters", #PossibleEncounters, Room:GetRoomLevel() )

 	local bRemoveFromTable = true
	local SelectedEncounter = GetRandomUnique( PossibleEncounters, NeighborEncounters, bRemoveFromTable )

	if SelectedEncounter ~= nil then
		Room:SetEncounter( SelectedEncounter, Room:GetRoomLevel() )
	end
end

--------------------------------------------------------------------------------

function CCavern:RegenerateWeightList()
	self.WeightedResults = {}

	for i = 1,CAVERN_ROOM_MOB_WEIGHT do
		table.insert( self.WeightedResults, CAVERN_ROOM_TYPE_MOB )
	end
	for i = 1,CAVERN_ROOM_TRAP_WEIGHT do
		table.insert( self.WeightedResults, CAVERN_ROOM_TYPE_TRAP )
	end

	--for i = 1,CAVERN_ROOM_TREASURE_WEIGHT do
	--	table.insert( self.WeightedResults, CAVERN_ROOM_TYPE_TREASURE )
	--end

	--for i = 1,CAVERN_ROOM_SPECIAL_WEIGHT do
	--	table.insert( self.WeightedResults, CAVERN_ROOM_TYPE_SPECIAL )
	--end

end

--------------------------------------------------------------------------------

function CCavern:AssignTeams()
	print( "Assigning teams.. " )

	if PlayerResource:HaveAllPlayersJoined() then	


		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			local bAssigned = false
			if not PlayerResource:IsValidPlayerID( nPlayerID ) then
				bAssigned = true
			end

			for nCurTeam = DOTA_TEAM_CUSTOM_1,( DOTA_TEAM_CUSTOM_1 + CAVERN_TEAMS_PER_GAME - 1 ) do
				-- In the future, we'll receive our team assignments before hand from the GC, so parties who entered together will be on the same team.
				local nTeamPlayerCount = PlayerResource:GetPlayerCountForTeam( nCurTeam )
				if not bAssigned and nTeamPlayerCount < CAVERN_PLAYERS_PER_TEAM  then
					print( PlayerResource:GetPlayerName( nPlayerID )  .. " (" .. nPlayerID .. ") is being assigned to team ID " .. nCurTeam )
					PlayerResource:SetCustomTeamAssignment( nPlayerID, nCurTeam )
					bAssigned = true
					nTeamPlayerCount = nTeamPlayerCount + 1
					if nTeamPlayerCount == CAVERN_PLAYERS_PER_TEAM then
						--self.nNextTeamFinishPosition = self.nNextTeamFinishPosition + 1
					end
				end
			end

			if not bAssigned then
				print( "Something went horribly wrong in assigning " .. PlayerResource:GetPlayerName( nPlayerID ) .. ", playerID " .. nPlayerID .. " !" )
			end
		end

		if self.bFillWithBots == true then
			GameRules:BotPopulate()
		end
	end
end

--------------------------------------------------------------------------------

function CCavern:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
			hPlayer:MakeRandomHeroSelection()
		end	
	end
end

---------------------------------------------------------

function CCavern:OnThink()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		self:UpdatePlayerColor( nPlayerID )
	end
	
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
		if not self.DevDisableRosh then
			self.Roshan:RoshanThink()
		end

		if self.bFillWithBots == true then
			for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
				if PlayerResource:IsFakeClient( nPlayerID ) then
					local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if hHero ~= nil then
						ExecuteOrderFromTable({
							UnitIndex = hHero:entindex(),
							OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
							Position = Vector( 0, 0, 0 )
						})
					end
				end
			end
		end
		self:CheckForDefeat()
	end

	return 1.0
end

--------------------------------------------------------------------------------

function CCavern:CheckForDefeat()

	if self.GameOver == true then
		return
	end

	local Heroes = HeroList:GetAllHeroes()

	self.Teams = {}
	self.LivingTeams = {}
	self.Heroes = {}
	self.LivingHeroes = {}

	
	for nCurTeam = DOTA_TEAM_CUSTOM_1, (DOTA_TEAM_CUSTOM_1 + CAVERN_TEAMS_PER_GAME) do
		local nTeamNetWorth = 0
		local nTeamHeroes = 0
		local nTeamHeroesAlive = 0
		local nTeamLevel = 0
		local nTeamKills = 0
		local nTeamDeaths = 0
		
		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == nCurTeam then
				nTeamHeroes = nTeamHeroes + 1
				nTeamLevel = nTeamLevel + Hero:GetLevel()
				nTeamKills = nTeamKills + PlayerResource:GetKills( Hero:GetPlayerOwnerID() )
				nTeamDeaths = nTeamDeaths + PlayerResource:GetDeaths( Hero:GetPlayerOwnerID() )
				nTeamNetWorth = nTeamNetWorth + PlayerResource:GetNetWorth( Hero:GetPlayerOwnerID() )
				self.Heroes[Hero:GetPlayerOwnerID()] = Hero
				if ( Hero:IsAlive() or Hero:IsReincarnating() ) and not Hero:HasOwnerAbandoned() then
					nTeamHeroesAlive = nTeamHeroesAlive + 1
					self.LivingHeroes[Hero:GetPlayerOwnerID()] = Hero
				end
			end
		end

		-- To add: Rooms explored, encounters (and type) completed
		if nTeamHeroes > 0 then
			local TeamData = {}
			TeamData["TeamID"] = nCurTeam
			TeamData["TeamHeroes"] = nTeamHeroesAlive
			TeamData["TeamHeroesAlive"] = nTeamHeroesAlive
			TeamData["TeamNetWorth"] = nTeamNetWorth
			TeamData["TeamAverageLevel"] = nTeamLevel / nTeamHeroesAlive
			TeamData["TeamKills"] = nTeamKills
			TeamData["TeamDeaths"] = nTeamDeaths
			self.Teams[nCurTeam] = TeamData 
			if nTeamHeroesAlive > 0 then
				self.LivingTeams[nCurTeam] = TeamData 
			end
		end
	end

	for TeamID,TeamData in pairs(self.Teams) do
		TeamData["HeroesRemaining"] = TableLength(self.LivingHeroes)
		TeamData["EnemyHeroesRemaining"] = TableLength(self.LivingHeroes) - TeamData["TeamHeroesAlive"]
	end

	for PlayerID,Hero in pairs(self.Heroes) do
		if not Hero:HasOwnerAbandoned() then
			local TeamData = self.Teams[Hero:GetTeamNumber()]
			if Hero:GetPlayerOwner() then
				CustomGameEventManager:Send_ServerToPlayer( Hero:GetPlayerOwner(), "on_team_info", TeamData ) 	
			end
		end
	end

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		local PlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if PlayerResource:IsValidTeamPlayerID( nPlayerID ) and PlayerHero ~= nil and PlayerHero:IsAlive() == false then
			local nTeam = PlayerResource:GetTeam( nPlayerID )
			local bActive = false
			for _,ActiveTeam in pairs ( self.LivingTeams ) do
				if ActiveTeam and ActiveTeam["TeamID"] == nTeam then
					--PrintTable( ActiveTeam, " " )
					bActive = true
				end
			end
			if bActive == false and nTeam ~= 1 and self.DevExpressMode == false and PlayerHero.bEliminated == false then
				self:OnHeroDefeated( PlayerHero )
				UTIL_Remove( PlayerHero.Tombstone )
			end
		end
	end

	-- if you're competing against others, then it's last team standing
	if TableLength( self.Teams ) > 1 then
		--printf("checking multiplayer victory condition: Teams %d, LivingTeams: %d", TableLength(self.Teams), TableLength(self.LivingTeams) )
		if TableLength( self.LivingTeams) < 2 then
			for TeamID,TeamData in pairs( self.LivingTeams ) do
				for _,Hero in pairs ( self.HeroesByTeam[TeamID] ) do
					self.EventMetaData[Hero:GetPlayerOwnerID()]["team_position"] = 1
				end
				self:OnBattlePointsEarned( TeamID, CAVERN_BP_REWARD_WIN, "points_game_winner" )
				self:OnGameFinished()
				
				GameRules:SetCustomVictoryMessageDuration( 10 )
				GameRules:SetCustomVictoryMessage( VICTORY_MESSAGES[TeamID] )
				GameRules:SetGameWinner( TeamID )

				self:PlayVictoryStinger()
				self:PlayAnnouncerVictoryLine( TeamID )
				self.GameOver = true
				break
			end
		end
	-- if there's only one team then it's basically a PvE only
	else
		--printf("checking single player victory condition: Teams %d, LivingTeams: %d, GameOver %s", TableLength(self.Teams), TableLength(self.LivingTeams), self.GameOver )
		if TableLength( self.LivingTeams ) < 1 and self.DevExpressMode == false then
			for TeamID,TeamData in pairs( self.Teams ) do
				self:OnGameFinished()
				GameRules:MakeTeamLose( TeamID )
				self.GameOver = true
				break
			end
		end
	end

	--CustomNetTables:SetTableValue
	if GameRules:GetGameTime() > self.flNextGameReportTime then
		self.flNextGameReportTime = GameRules:GetGameTime() + CAVERN_GAME_REPORT_INTERVAL
		--self:PrintGameReport()
	end
end

--------------------------------------------------------------------------------

function CCavern:PlayAnnouncerVictoryLine( nTeamID )

	local szVictoryLine = nil

	if nTeamID == DOTA_TEAM_CUSTOM_1 then
		szVictoryLine = VictoryLines[ 1 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_2 then
		szVictoryLine = VictoryLines[ 2 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_3 then
		szVictoryLine = VictoryLines[ 3 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_4 then
		szVictoryLine = VictoryLines[ 4 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_5 then
		szVictoryLine = VictoryLines[ 5 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_6 then
		szVictoryLine = VictoryLines[ 6 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_7 then
		szVictoryLine = VictoryLines[ 7 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_8 then
		szVictoryLine = VictoryLines[ 8 ]
	end

	assert( szVictoryLine ~= nil, "ERROR: CCavern:PlayAnnouncerVictoryLine -- szVictoryLine is nil" )

	EmitAnnouncerSound( szVictoryLine )
end

--------------------------------------------------------------------------------

function CCavern:PlayAnnouncerTeamDefeatLine( nTeamID )

	local szTeamDefeatLine = nil

	if nTeamID == DOTA_TEAM_CUSTOM_1 then
		szTeamDefeatLine = TeamDefeatLines[ 1 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_2 then
		szTeamDefeatLine = TeamDefeatLines[ 2 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_3 then
		szTeamDefeatLine = TeamDefeatLines[ 3 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_4 then
		szTeamDefeatLine = TeamDefeatLines[ 4 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_5 then
		szTeamDefeatLine = TeamDefeatLines[ 5 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_6 then
		szTeamDefeatLine = TeamDefeatLines[ 6 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_7 then
		szTeamDefeatLine = TeamDefeatLines[ 7 ]
	elseif nTeamID == DOTA_TEAM_CUSTOM_8 then
		szTeamDefeatLine = TeamDefeatLines[ 8 ]
	end

	assert( szTeamDefeatLine ~= nil, "ERROR: CCavern:PlayAnnouncerTeamDefeatLine -- szTeamDefeatLine is nil" )

	EmitAnnouncerSound( szTeamDefeatLine )
end

--------------------------------------------------------------------------------

function CCavern:PlayVictoryStinger()
	local Heroes = HeroList:GetAllHeroes()
	for _, Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsRealHero() and Hero:IsTempestDouble() == false then
			EmitSoundOnClient( "Stinger.Victory", Hero:GetPlayerOwner() )
		end
	end
end

--------------------------------------------------------------------------------

function CCavern:PrintGameReport()
	print( TableLength(self.LivingHeroes) .. " players alive on " .. TableLength(self.LivingTeams) .. " teams." )
	for _,Team in pairs( self.LivingTeams ) do 
		PrintTable( Team, " " )
	end
end

--------------------------------------------------------------------------------

function CCavern:PrintRoomDebugGrid()
	print( "\n" )
	print( "===========================================================================")
	print( "Map of " .. #self.Rooms .. " rooms" )
	self:PrintRoomReport()
	print( "Legend:" )
	print( "Mobs: " .. self:GetStringForDebugGridRoomType( CAVERN_ROOM_TYPE_MOB ) )
	print( "Trap: " .. self:GetStringForDebugGridRoomType( CAVERN_ROOM_TYPE_TRAP ) )
	print( "Treasure: " .. self:GetStringForDebugGridRoomType( CAVERN_ROOM_TYPE_TREASURE ) )
	print( "Team Spawn: " .. self:GetStringForDebugGridRoomType( CAVERN_ROOM_TYPE_TEAM_SPAWN ) )
	print( "Special: " .. self:GetStringForDebugGridRoomType( CAVERN_ROOM_TYPE_SPECIAL ) )
	print( "Roshan:"  .. self:GetStringForDebugGridRoomType( CAVERN_ROOM_TYPE_ROSHAN ) )
	print( "Destroyed: " ..  self:GetStringForDebugGridRoomType( CAVERN_ROOM_TYPE_DESTROYED ) )
	print( "Destructible hallway: " .. self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_EAST, CAVERN_PATH_TYPE_DESTRUCTIBLE ) .. " or " .. self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_NORTH, CAVERN_PATH_TYPE_DESTRUCTIBLE ) )

	local nCurRoom = 1
	local nCurRow = 0
	local nRoomPhase = 1
	local str_table = {}
	for i=1,CAVERN_GRID_HEIGHT * 7 do
		nCurRoom = ( nCurRow * CAVERN_GRID_WIDTH ) + 1
		for j=1,CAVERN_GRID_WIDTH do
			local cur_str = ""
			if nRoomPhase == 1 then
				if nCurRoom > 9 then
					cur_str = nCurRoom .. "--" .. self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_NORTH, self.Rooms[nCurRoom]:GetPath( CAVERN_PATH_DIR_NORTH ) ) .. "----"
				else
					cur_str = nCurRoom .. "---" .. self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_NORTH, self.Rooms[nCurRoom]:GetPath( CAVERN_PATH_DIR_NORTH ) ) .. "----"
				end	
			end
			if nRoomPhase == 2 or nRoomPhase == 6 then
				cur_str = "|         |"
			end 
			if nRoomPhase == 3 or nRoomPhase == 5 then
				cur_str = self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_WEST, self.Rooms[nCurRoom]:GetPath( CAVERN_PATH_DIR_WEST ) ) .. "         " .. self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_EAST, self.Rooms[nCurRoom]:GetPath( CAVERN_PATH_DIR_EAST ) )
			end
			if nRoomPhase == 4 then
				cur_str = self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_WEST, self.Rooms[nCurRoom]:GetPath( CAVERN_PATH_DIR_WEST ) ) .. "  " .. self:GetStringForDebugGridRoomType( self.Rooms[nCurRoom]:GetRoomType() ) .. "(" .. self.Rooms[nCurRoom]:GetRoomLevel() .. ")" .. "  " .. self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_EAST, self.Rooms[nCurRoom]:GetPath( CAVERN_PATH_DIR_EAST ) )
			end
			if nRoomPhase == 7 then 
				cur_str = "----" .. self:GetStringForDebugGridPathType( CAVERN_PATH_DIR_SOUTH, self.Rooms[nCurRoom]:GetPath( CAVERN_PATH_DIR_SOUTH ) ) .. "----"
			end
		
			table.insert( str_table, cur_str )
			nCurRoom = nCurRoom + 1
		end

		nRoomPhase = nRoomPhase + 1
		
		print( table.concat( str_table ) )
		str_table = {}
		if nRoomPhase > 7 then
			nRoomPhase = 1	
			nCurRow = nCurRow + 1
		end
	end


	print( table.concat( str_table ) )
end

--------------------------------------------------------------------------------

function CCavern:GetStringForDebugGridPathType( nDirection, nPathType )
	if nPathType == CAVERN_PATH_TYPE_OPEN then
		if nDirection == CAVERN_PATH_DIR_NORTH or nDirection == CAVERN_PATH_DIR_SOUTH then
			return "   "
		end
		if nDirection == CAVERN_PATH_DIR_EAST or nDirection == CAVERN_PATH_DIR_WEST then
			return " "
		end
	end
	if nPathType == CAVERN_PATH_TYPE_DESTRUCTIBLE then
		if nDirection == CAVERN_PATH_DIR_NORTH or nDirection == CAVERN_PATH_DIR_SOUTH then
			return "ooo"
		end
		if nDirection == CAVERN_PATH_DIR_EAST or nDirection == CAVERN_PATH_DIR_WEST then
			return "O"
		end
	end
	if nPathType == CAVERN_PATH_TYPE_BLOCKED then
		if nDirection == CAVERN_PATH_DIR_NORTH or nDirection == CAVERN_PATH_DIR_SOUTH then
			return "---"
		end
		if nDirection == CAVERN_PATH_DIR_EAST or nDirection == CAVERN_PATH_DIR_WEST then
			return "|"
		end
	end

	return "err"
end

--------------------------------------------------------------------------------

function CCavern:GetStringForDebugGridRoomType( nRoomType )
	if nRoomType == CAVERN_ROOM_TYPE_INVALID then
		return "  "
	end
	if nRoomType == CAVERN_ROOM_TYPE_MOB then
		return " M"
	end
	if nRoomType == CAVERN_ROOM_TYPE_TRAP then
		return " X"
	end
	if nRoomType == CAVERN_ROOM_TYPE_TREASURE then
		return " *"
	end
	if nRoomType == CAVERN_ROOM_TYPE_TEAM_SPAWN then
		return " P"
	end
	if nRoomType == CAVERN_ROOM_TYPE_SPECIAL then
		return " ?"
	end
	if nRoomType == CAVERN_ROOM_TYPE_DESTROYED then
		return "@@"
	end
	if nRoomType == CAVERN_ROOM_TYPE_ROSHAN then
		return " R"
	end

	return "er"
end

--------------------------------------------------------------------------------

function CCavern:GetStringForRoomDebugRoomType( nRoomType )
	if nRoomType == CAVERN_ROOM_TYPE_INVALID then
		return "CAVERN_ROOM_TYPE_INVALID"
	end
	if nRoomType == CAVERN_ROOM_TYPE_MOB then
		return "CAVERN_ROOM_TYPE_MOB"
	end
	if nRoomType == CAVERN_ROOM_TYPE_TRAP then
		return "CAVERN_ROOM_TYPE_TRAP"
	end
	if nRoomType == CAVERN_ROOM_TYPE_TREASURE then
		return "CAVERN_ROOM_TYPE_TREASURE"
	end
	if nRoomType == CAVERN_ROOM_TYPE_TEAM_SPAWN then
		return "CAVERN_ROOM_TYPE_TEAM_SPAWN"
	end
	if nRoomType == CAVERN_ROOM_TYPE_SPECIAL then
		return "CAVERN_ROOM_TYPE_SPECIAL"
	end

	return "CAVERN_ROOM_TYPE_INVALID"
end

--------------------------------------------------------------------------------

function CCavern:GetStringForRoomDebugPathType( nPathType )
	if nPathType == CAVERN_PATH_TYPE_INVALID then
		return "CAVERN_PATH_TYPE_INVALID"
	end
	if nPathType == CAVERN_PATH_TYPE_OPEN then
		return "CAVERN_PATH_TYPE_OPEN"
	end
	if nPathType == CAVERN_PATH_TYPE_DESTRUCTIBLE then
		return "CAVERN_PATH_TYPE_DESTRUCTIBLE"
	end
	if nPathType == CAVERN_PATH_TYPE_BLOCKED then
		return "CAVERN_PATH_TYPE_BLOCKED"
	end

	return "CAVERN_PATH_TYPE_INVALID"
end

--------------------------------------------------------------------------------

function CCavern:GetStringForDirection( nDir )
	if nDir == CAVERN_PATH_DIR_NORTH then
		return "NORTH"
	end
	if nDir == CAVERN_PATH_DIR_SOUTH then
		return "SOUTH"
	end
	if nDir == CAVERN_PATH_DIR_EAST then
		return "EAST"
	end
	if nDir == CAVERN_PATH_DIR_WEST then
		return "WEST"
	end

	return "INVALID DIRECTION"
end


--------------------------------------------------------------------------------

function CCavern:PrintRoomReport()
	for i=CAVERN_ROOM_TYPE_MOB,CAVERN_ROOM_TYPE_SPECIAL do
		local nCount = 0
		for _,Room in pairs ( self.Rooms ) do
			if Room:GetRoomType() == i then
				nCount = nCount + 1
			end
		end
		print( self:GetStringForRoomDebugRoomType( i ) .. ": " .. nCount )
	end 
end

--------------------------------------------------------------------------------

function CCavern:PrintRoomDebug( cmdName, nRoomID )
	local nRoomID = tonumber( nRoomID )
	local Room = self.Rooms[nRoomID]
	if Room == nil then
		return
	end

	print( "RoomID: " .. Room:GetRoomID() )
	print( "Room Type: " .. self:GetStringForRoomDebugRoomType( Room:GetRoomType() ) )
	print( "North Path: " .. self:GetStringForRoomDebugPathType( Room:GetPath( CAVERN_PATH_DIR_NORTH ) ) )
	NorthRoom = Room:GetNeighboringRoom( CAVERN_PATH_DIR_NORTH )
	if NorthRoom == nil then
		print( "North Neighbor: none" )
	else
		print( "North Neighbor: " .. NorthRoom:GetRoomID() )
	end
	
	print( "South Path: " .. self:GetStringForRoomDebugPathType( Room:GetPath( CAVERN_PATH_DIR_SOUTH ) ) )
	SouthRoom = Room:GetNeighboringRoom( CAVERN_PATH_DIR_SOUTH )
	if SouthRoom == nil then
		print( "South Neighbor: none" )
	else
		print( "South Neighbor: " .. SouthRoom:GetRoomID() )
	end
	
	print( "East Path: " .. self:GetStringForRoomDebugPathType( Room:GetPath( CAVERN_PATH_DIR_EAST ) ) )
	EastRoom = Room:GetNeighboringRoom( CAVERN_PATH_DIR_EAST )
	if EastRoom == nil then
		print( "East Neighbor: none" )
	else
		print( "East Neighbor: " .. EastRoom:GetRoomID() )
	end
	
	print( "West Path: " .. self:GetStringForRoomDebugPathType( Room:GetPath( CAVERN_PATH_DIR_WEST ) ) )
	WestRoom = Room:GetNeighboringRoom( CAVERN_PATH_DIR_WEST )
	if WestRoom == nil then
		print( "West Neighbor: none" )
	else
		print( "West Neighbor: " .. WestRoom:GetRoomID() )
	end
	
end

--------------------------------------------------------------------------------

function CCavern:PrintRoomAccessibility()
	local nUnreachableRoomIDs = {}
	for _,Room in pairs( self.Rooms ) do
		table.insert( nUnreachableRoomIDs, Room:GetRoomID() )
	end
end


function CCavern:FindClosestRoom( vPosition )

	local flClosestDistSq = 1e20
	local hClosestRoom = nil

	for _,hRoom in pairs( self.Rooms ) do
		local flRoomDistSq = VectorDistanceSq( vPosition, hRoom.vRoomCenter )
		if flRoomDistSq < flClosestDistSq then
			flClosestDistSq = flRoomDistSq
			hClosestRoom = hRoom
		end
	end

	return hClosestRoom
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function CCavern:ColorForTeam( teamID )
	local color = self.m_TeamColors[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end

	return color
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function CCavern:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

---------------------------------------------------------------------------

function CCavern:RemoveTombstoneVisionDummy( hHero )
	if hHero.hTombstoneVisionDummy == nil then
		--printf( "WARNING: RemoveTombstoneVisionDummy -- hTombstoneVisionDummy is nil for unit named %s. (found no unit to remove)", hHero:GetUnitName() )
	else
		UTIL_Remove( hHero.hTombstoneVisionDummy )
	end
end


---------------------------------------------------------------------------
-- Con Commands
---------------------------------------------------------------------------

function CCavern:RegisterConCommands()
	Convars:RegisterCommand( "cavern_print_room", function(...) return self:PrintRoomDebug( ... ) end, "Print the contents of a room.", FCVAR_CHEAT )
	Convars:RegisterCommand( "cavern_teleport_to_room", function(...) return self:cavern_teleport_to_room( ... ) end, "Teleport to room #.", FCVAR_CHEAT )
	Convars:RegisterCommand( "cavern_start_encounter", function(...) return self:cavern_start_encounter( ... ) end, "Start an encounter in the current room.", FCVAR_CHEAT )
	Convars:RegisterCommand( "cavern_scratch", function(...) return self:cavern_scratch( ... ) end, "Scratch command for testing", FCVAR_CHEAT )
	Convars:RegisterConvar(  "cavern_allow_respawn",  "0", "Allow players to respawn even after team death", FCVAR_ARCHIVE )

end

function CCavern:cavern_teleport_to_room( cmdName, szRoomNumber )
	-- find the trigger volume
	local hRoomVolume = Entities:FindByName( nil, "room_" .. szRoomNumber )
	if hRoomVolume == nil then
		print( "CCavern:TeleportToRoom - ERROR - No room volume found for room # " .. szRoomNumber )
		return
	end

	local vTeleportPos = hRoomVolume:GetAbsOrigin()
	vTeleportPos.y = vTeleportPos.y - 800

	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and hHero:IsRealHero() then
			FindClearSpaceForUnit( hHero, vTeleportPos, true )
		end
	end
end

--------------------------------------------------------------------------------

function CCavern:cavern_start_encounter( cmdName, szEncounterName , nPlayerID , nLevel )

	local hHero = PlayerResource:GetSelectedHeroEntity( tonumber(nPlayerID) )
	local vPosition = hHero:GetAbsOrigin()
	local hRoom = self:FindClosestRoom( vPosition )

	--if hRoom.ActiveEncounter ~=nil then
	--	hRoom.ActiveEncounter:Cleanup()
	--	hRoom.ActiveEncounter:Reset()
	--end

	hRoom:SetEncounter( szEncounterName, nLevel )
	hRoom:StartEncounter()

end

--------------------------------------------------------------------------------

function CCavern:cavern_scratch( cmdName, nPlayerID )

	local hHero = PlayerResource:GetSelectedHeroEntity( tonumber(nPlayerID) )
	local vPosition = hHero:GetAbsOrigin()
	local hRoom = self:FindClosestRoom( vPosition )
	hRoom:CreateNeighborSigns( true )

end


--------------------------------------------------------------------------------
-- End Con Commands
