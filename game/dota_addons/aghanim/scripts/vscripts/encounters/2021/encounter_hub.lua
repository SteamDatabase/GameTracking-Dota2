require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "event_npcs/event_npc_life_vendor" )
require( "event_npcs/event_npc_aghanim")
require( "event_npcs/event_npc_zeus" )
require( "event_npcs/event_npc_warlock_tome_shop" )
require( "event_npcs/event_npc_tinker_range_retrofit" )
require( "event_npcs/event_npc_small_tiny_shrink" )
require( "event_npcs/event_npc_slark" )
require( "event_npcs/event_npc_ogre_magi_casino" )
require( "event_npcs/event_npc_neutral_item_shop" )
require( "event_npcs/event_npc_naga_siren_bottle_runes" )
require( "event_npcs/event_npc_morphling_attribute_shift" )
require( "event_npcs/event_npc_big_tiny_grow" )
require( "event_npcs/event_npc_brewmaster_bartender" )
require( "event_npcs/event_npc_doom_life_swap" )
require( "event_npcs/event_npc_leshrac")
require( "event_npcs/event_npc_necrophos")

_G.ORACLE_SHARD_SHOP_CLASS = require( "event_npcs/event_npc_minor_shard_shop" )

LinkLuaModifier( "modifier_aghanim_animation_activity_modifier", "modifiers/creatures/modifier_aghanim_animation_activity_modifier", LUA_MODIFIER_MOTION_VERTICAL )

--------------------------------------------------------------------------------

if CMapEncounter_Hub == nil then
	CMapEncounter_Hub = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:GetRoom().hSpawnGroupHandle = GetActiveSpawnGroupHandle()
	self.bRewardsSelected = false
	self.bSpokenGameStartLine = false
	self.bAllButtonsReady = false
	self.bAwaitHubReturnTouch = false
	self.EventNPCs = {}
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:Precache( context )
	CMapEncounter.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:ExitRoomUnitSpawnCallback()
	print( "Precache complete." )
end

_G.DEBUG_EVENT_NPCS = false

--------------------------------------------------------------------------------

function CMapEncounter_Hub:Start()
	if self.hAghanim == nil then 
		local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_aghanim", true )
		if hSpawner[ 1 ] then 
			if GameRules.Aghanim:GetAnnouncer() == nil then 
				print( "ERROR! GameRules.Aghanim:GetAnnouncer() is nil!" )
			end

			local hAghanim = GameRules.Aghanim:GetAnnouncer():GetUnit()
			if hAghanim == nil then 
				print( "ERROR! GameRules.Aghanim:GetAnnouncer():GetUnit() is nil!" )
			end


			self.hAghanim = CEvent_NPC_Aghanim( hSpawner[ 1 ]:GetAbsOrigin(), hAghanim )
			hAghanim:RemoveEffects( EF_NODRAW )
			hAghanim:SetModelScale( 1.2 + 0.1 * GameRules.Aghanim:GetAscensionLevel() )
			hAghanim:AddNewModifier( hAghanim, nil, "modifier_aghanim_animation_activity_modifier", {} ) 

			if DEBUG_EVENT_NPCS then
				local hRoshan = CEvent_NPC_LifeVendor( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				--local hMorphling = CEvent_NPC_MorphlingAttributeShift( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				--local hWarlock = CEvent_NPC_WarlockTomeShop( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				--[[
				local hOgre = CEvent_NPC_OgreMagiCasino( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				local hSmallTiny = CEvent_NPC_SmallTiny_Shrink( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				local hBigTiny = CEvent_NPC_BigTiny_Grow( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				local hBrewmaster = CEvent_NPC_BrewmasterBartender( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				local hDoom = CEvent_NPC_DoomLifeSwap( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				local hWarlock = CEvent_NPC_WarlockTomeShop( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				
				local hTinker = CEvent_NPC_Tinker_RangeRetrofit( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				local hSlark = CEvent_NPC_Slark( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				local hAlchemist = CEvent_NPC_NeutralItemShop( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				
				local hNAga = CEvent_NPC_Naga_BottleRunes( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250 , 500 ) ), nil )
				CEvent_NPC_Zeus( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250, 500 ) ), nil )
				CEvent_NPC_Leshrac( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 250, 500 ) ), nil )
				]]
				--CEvent_NPC_Necrophos( hSpawner[ 1 ]:GetAbsOrigin() + RandomVector( RandomInt( 300, -300 ) ), nil )
			end
		else
			print( "ERROR: CMapEncounter_Hub:Start() - spawner_aghanim is missing. This is ok if you're launching for minimap creation.")
		end
	end

	if self:GetRoom().szSingleExitRoomName then 
		local ExitRoom = GameRules.Aghanim:GetRoom( self:GetRoom().szSingleExitRoomName ) 
		if ExitRoom and ExitRoom.vecPotentialEncounters and #ExitRoom.vecPotentialEncounters > 0 then 
			for _,hPendingEncounter in pairs ( ExitRoom.vecPotentialEncounters ) do 
				if hPendingEncounter then
					print( "hub precaching preview units" )
					PrecacheUnitByNameAsync( hPendingEncounter:GetPreviewUnit(), Dynamic_Wrap( getclass( self ), "ExitRoomUnitSpawnCallback" ),  -1 )
					
				end
			end
		end
	end

	self.flStartTime = GameRules:GetGameTime()

	if GameRules.Aghanim:HasSetAscensionLevel() == false then
		-- Default the ascension level now in case we do any developer shit, and juke the system to think we haven't set it yet
		GameRules.Aghanim:SetAscensionLevel( 0 )
		GameRules.Aghanim.bHasSetAscensionLevel = false

		local nMaxOption = GameRules.Aghanim:GetMaxAllowedAscensionLevel()
		local nOption = 0
		while nOption <= nMaxOption do
			local hAscensionLocator = Entities:FindByName( nil, "ascension_picker_locator_" .. ( nOption + 1 ) )
			if hAscensionLocator == nil then 
				break
			end

			local vOrigin = hAscensionLocator:GetAbsOrigin()
			local vAngles = hAscensionLocator:GetAnglesAsVector()
			local pickerTable = 
			{ 	
				MapUnitName = "npc_dota_aghsfort_watch_tower_option_1",
				origin = tostring( vOrigin.x ) .. " " .. tostring( vOrigin.y ) .. " " .. tostring( vOrigin.z ),
				angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z ),
				OptionNumber = tostring( nOption + 1 ), 
				teamnumber = DOTA_TEAM_NEUTRALS,
				AscensionLevelPicker = 1,
			}

			CreateUnitFromTable( pickerTable, vOrigin )
			nOption = nOption + 1
		end

		if nOption == 0 then
			print( "Unable to find ascension_picker_locator_ entities!\n" )
			self:OnAscensionLevelSelected( { level = 1 } )
			return
		end
	end

	-- Use encounter name to display "select ascension level"
	self:Introduce()

	-- Uncomment out to preview effigies
	--self:PreviewEffigies()

	-- Players Ready
	self.nPlayersReady = 0
	local nTriggerStartTouchEvent = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( getclass( self ), "OnTriggerStartTouch" ), self )
	table.insert( self.EventListeners, nTriggerStartTouchEvent )
	local nTriggerEndTouchEvent = ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( getclass( self ), "OnTriggerEndTouch" ), self )
	table.insert( self.EventListeners, nTriggerEndTouchEvent )
	local nAscensionSelectedEvent = ListenToGameEvent( "aghsfort_ascension_level_selected", Dynamic_Wrap( getclass( self ), "OnAscensionLevelSelected" ), self )
	table.insert( self.EventListeners, nAscensionSelectedEvent )

end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:OnAscensionLevelSelected( event )
	print( "Ascension Level " .. event.level .. " selected" )
	GameRules.Aghanim:SetAscensionLevel( event.level - 1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:OnThink()
	CMapEncounter.OnThink( self )

	--print( "hub thinking" )

	-- Don't speak until all players are connected
	if self.bSpokenGameStartLine == false then

		local nConnectedPlayerCount = 0
		local nPlayerCount = 0
		for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) then
				nPlayerCount = nPlayerCount + 1
				if PlayerResource:GetConnectionState( nPlayerID ) == DOTA_CONNECTION_STATE_CONNECTED then
					nConnectedPlayerCount = nConnectedPlayerCount + 1
				end
			end
		end

		if nConnectedPlayerCount == nPlayerCount then
			self.nPlayerCount = nPlayerCount
			GameRules.Aghanim:GetAnnouncer():OnGameStarted( )
			self.bSpokenGameStartLine = true
		end

	end

	if self.nPlayerCount ~= nil and self.bSetupAghanimNPC == nil then
		local nHeroes = 0
		for nPlayerID = 0, AGHANIM_PLAYERS -1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
			if hPlayerHero then
				nHeroes = nHeroes + 1
			end
		end
		if nHeroes == self.nPlayerCount then
			self.bSetupAghanimNPC = true
			if self.hAghanim then
				self.hAghanim.bAllPlayersLoaded = true
				self.hAghanim:InitializePlayerOptions() -- run this again once everyone spawns
			end
			GameRules.Aghanim:SetExpeditionStartTime( GameRules:GetGameTime() )
			self:GenerateRewards()
			-- We want to announce rewards during the starting room
			-- done in NPC - GameRules.Aghanim:GetAnnouncer():OnSelectRewards()
		end
	end

	-- Update UI indicating who has picked their reward
	local vecRewardState = GameRules.Aghanim:DetermineRewardSelectionState()
	if vecRewardState ~= nil then
		local nNumSelected = 0
		local vecPlayers = GameRules.Aghanim:GetConnectedPlayers()
		for i=1,#vecPlayers do
			if vecRewardState[ tostring( vecPlayers[i] ) ] == true then
				nNumSelected = nNumSelected + 1
			end
		end
		self:UpdateEncounterObjective( "objective_talk_to_aghanim", nNumSelected, nil )

		if #vecPlayers > 0 and nNumSelected == #vecPlayers then
			self:GetRoom().bSpawnGroupReady = true
			self.bRewardsSelected = true
		end
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:InitializeObjectives()
	--CMapEncounter.InitializeObjectives( self )

	--self:AddEncounterObjective( "objective_stand_on_buttons", 0, 4 )
	self:AddEncounterObjective( "objective_talk_to_aghanim", 0, 4 )

end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:OnTriggerStartTouch( event )
	if self.bAwaitHubReturnTouch == true then 
		self.bAwaitHubReturnTouch = false 

		for i=1,#self.EventListeners do
			StopListeningToGameEvent( self.EventListeners[i] )
			self.EventListeners[i] = nil
		end
		
		self:OpenActDoor()
		self:SpawnBossPreviewEntity()
		self:SpawnEndLevelEntities()
		self:GetRoom().szExitRoomSelected = nil

	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:AddEventNPCToHub( szLocatorName, hEventNPCClass )
	local hSpawners = self:GetRoom():FindAllEntitiesInRoomByName( szLocatorName, true )
	if hSpawners[ 1 ] == nil then 
		print( "Failed to add event NPC to hub; no spawners - spawner not in hub map, or NPC already added to the hub" )
		return
	end

	local hEventNPC = hEventNPCClass( hSpawners[ 1 ]:GetAbsOrigin() )
	if hEventNPC == nil then 
		print( "failed to create event npc class" )
		return
	end

	for _,hCurSpawner in pairs ( hSpawners ) do
		UTIL_Remove( hCurSpawner )
	end

	table.insert( self.EventNPCs, hEventNPC )
	return hEventNPC
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:OnTriggerEndTouch( event )

	if self.bAllButtonsReady == true or self.bSetupAghanimNPC then
		return
	end

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	if szTriggerName == "trigger_player_1"
		or szTriggerName == "trigger_player_2"
		or szTriggerName == "trigger_player_3"
		or szTriggerName == "trigger_player_4" then
		--printf( "szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

		self.nPlayersReady = self.nPlayersReady - 1
		self:UpdateEncounterObjective( "objective_stand_on_buttons", self.nPlayersReady, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:CheckForCompletion()
	return GameRules.Aghanim:HasSetAscensionLevel() == true and self.bRewardsSelected == true
end


--------------------------------------------------------------------------------

function CMapEncounter_Hub:OnComplete()
	CMapEncounter.OnComplete( self )

	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:SetAbilityPoints( 1 )
			EmitSoundOnClient( "General.LevelUp", hHero:GetPlayerOwner() )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, nil ) )
		end
	end

	--Opens the act 1 door
	self:OpenActDoor()
	self.hAghanim.bAllPlayersHaveShards = true
	self.hAghanim:InitializePlayerOptions()

	GameRules.Aghanim:GetAnnouncer():OnAllTalkedToAghanim()
end


--------------------------------------------------------------------------------

function CMapEncounter_Hub:UpdateAct( nAct, nDepth )
	if nAct == nil then
		nAct = GameRules.Aghanim:GetCurrentRoom():GetAct() + 1
	end
	self:GetRoom().nAct = nAct
	print( "Act has been updated to " .. self:GetRoom():GetAct() )

	if nDepth == nil then
		nDepth = GameRules.Aghanim:GetCurrentRoom().nDepth
	end

	self:GetRoom().nDepth = nDepth
	self:GetRoom().szSingleExitRoomName = "a" .. self:GetRoom():GetAct() .. "_1"
	
	GameRules.Aghanim:SetCurrentRoom( self:GetRoom() )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		GameRules.Aghanim:SetPlayerCurrentRoom( nPlayerID, GameRules.Aghanim:GetCurrentRoom() )
	end

	self.bAwaitHubReturnTouch = true 
	local nTriggerStartTouchEvent = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( getclass( self ), "OnTriggerStartTouch" ), self )
	table.insert( self.EventListeners, nTriggerStartTouchEvent )

	for _,hEventNPC in pairs ( self.EventNPCs ) do 
		hEventNPC:ResetAllOptionStockCounts()
	end

	if nAct == 2 then
		self.Oracle = self:AddEventNPCToHub( "spawner_oracle", ORACLE_SHARD_SHOP_CLASS ) 
		if self.Oracle then 
			self.Oracle.bInHub = true
		end

		local hSpawner = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_roshan", true )
		if hSpawner[ 1 ] then 
			local hRoshanEventNPC = CEvent_NPC_LifeVendor( hSpawner[ 1 ]:GetAbsOrigin() )
			if hRoshanEventNPC then
				table.insert( self.EventNPCs, hRoshanEventNPC )
				if hRoshanEventNPC:GetEntity() then 
					hRoshanEventNPC:GetEntity():SetAbsAngles( 0, 180, 0 )
				end
			end
		end
	else
		if self.Oracle then 
			self.Oracle:InitializePlayerOptions()
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:OpenActDoor()
	local nAct = self:GetRoom():GetAct() 
	local szActGateRelay = "act_" .. tostring( nAct ) .. "_gate_open_relay" 
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( szActGateRelay, false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:FindEncounterEndLocator()
	local nAct = self:GetRoom():GetAct() 
	local szExitLocatorListName = "act_" .. tostring( nAct ) .. "_encounter_end_locator"
	local hExitLocatorList = self:GetRoom():FindAllEntitiesInRoomByName( szExitLocatorListName, false )
	if #hExitLocatorList == 0 then
		return nil
	end

	return hExitLocatorList[1]
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:SpawnBossPreviewEntity()
	local nAct = self:GetRoom():GetAct()
	local szBossPreviewLocatorName = "act_" .. tostring( nAct ) .. "_encounter_boss_preview_locator"
	local hBossPreviewEntity = self:GetRoom():FindAllEntitiesInRoomByName( szBossPreviewLocatorName, false )
	if #hBossPreviewEntity == 0 then
		return
	end

	-- Find the boss room for the act this encounter is in
	local hBossRoom = nil
  	for _,room in pairs( GameRules.Aghanim:GetRoomList() ) do
  
  		if room:GetType() == ROOM_TYPE_BOSS and room:GetAct() == nAct then
  			hBossRoom = room
  			break;
  		end
	end

	if hBossRoom == nil then
		return
	end


	local strPreviewUnit = nil
	if hBossRoom:GetEncounter() then 
		strPreviewUnit = hBossRoom:GetEncounter():GetPreviewUnit()
	else
		strPreviewUnit = "npc_dota_tusk_boss"
	end


	local bossPreviewTable = 
	{ 	
		BossUnit = strPreviewUnit, 
		BossModelScale = ENCOUNTER_PREVIEW_SCALES[ strPreviewUnit ],
		ExtraModelScale = 2,
		EncounterType = ROOM_TYPE_BOSS,
	}


	if strPreviewUnit == "npc_dota_creature_aghsfort_primal_beast_boss" and GameRules.Aghanim:GetAscensionLevel() == AGHANIM_ASCENSION_APPRENTICE then 
		bossPreviewTable.ModelName = "models/ui/exclamation/questionmark.vmdl"
		bossPreviewTable.BossUnit = nil
		bossPreviewTable.BossModelScale = 0.0015
		bossPreviewTable.ExtraModelScale = 1.5
	end

	if bossPreviewTable.BossModelScale == nil then
		bossPreviewTable.BossModelScale = 1.0
	end

	for i=1,#hBossPreviewEntity do
		local vOrigin = hBossPreviewEntity[i]:GetAbsOrigin()
		local vAngles = hBossPreviewEntity[i]:GetAnglesAsVector()
		bossPreviewTable.origin = tostring( vOrigin.x ) .. " " .. tostring( vOrigin.y ) .. " " .. tostring( vOrigin.z )
		bossPreviewTable.angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z )

		SpawnEntityFromTableAsynchronous( "dota_aghsfort_boss_preview", bossPreviewTable, nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:GetPreviewUnit()
	return "npc_dota_boss_aghanim"
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:SpawnEndLevelEntities()
	self.bHasSpawnedEndLevelEntities = true

	local vExitTemplate = Entities:FindByName( nil, "encounter_end_template" )
	if vExitTemplate == nil then
		print( "Unable to find encounter_end_template\n" )
		return
	end

	local hExitLocator = self:FindEncounterEndLocator()
	if hExitLocator == nil then
		print ( "Unable to find Encounter Exit Locator" )
		return
	end

	local vExitLocation = hExitLocator:GetAbsOrigin()
	local vSpawnLocation = Vector( vExitLocation.x, vExitLocation.y, GetGroundHeight( vExitLocation, nil ) )
	vExitTemplate:DeleteCreatedSpawnGroups()
	vExitTemplate:SetAbsOrigin( vSpawnLocation )
	vExitTemplate:ForceSpawn()
	--print( "spawning HUB exit template at (" .. vSpawnLocation.x .. ", " .. vSpawnLocation.y .. ", " .. vSpawnLocation.z .. ")" )

	for _,hTemplateEnt in pairs ( vExitTemplate:GetSpawnedEntities() ) do	
		--print( "spawned " .. hTemplateEnt:GetName() .. " at (" .. hTemplateEnt:GetAbsOrigin().x .. ", " .. hTemplateEnt:GetAbsOrigin().y .. ", " .. hTemplateEnt:GetAbsOrigin().z .. ")" )
		if hTemplateEnt:GetName() == "shop" or hTemplateEnt:GetName() == "shop_trigger" or hTemplateEnt:GetName() == "shop_obstruction" or hTemplateEnt:GetName() == "shop_particles"  or hTemplateEnt:GetName() == "neutral_stash" then
			UTIL_Remove( hTemplateEnt )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Hub:PreviewEffigies()
	-- Spawn effigy previews
	print( "Spawning Effigy Previews" )
	local hEffigyPreviewEntity = self:GetRoom():FindAllEntitiesInRoomByName( "effigy_preview_locator", false )
	local strPreviewUnitTable = 
	{
		"npc_dota_creature_bonus_chicken",
		"npc_dota_creature_shroom_giant",
		"npc_dota_creature_year_beast",
		"npc_dota_creature_bonus_pig",
		"npc_dota_creature_huge_axe",
		"npc_dota_creature_drow_ranger_miniboss",
		"npc_dota_creature_venomancer",
		"npc_dota_creature_big_skeleton",
		"npc_dota_creature_large_ogre_seal_diretide",
		"npc_dota_creature_polarity_ghost_captain_positive",
		"npc_dota_creature_bloodbound_bloodseeker",
		"npc_dota_creature_amoeba_boss",
		"npc_dota_creature_aghsfort_primal_beast_boss",
	}
	
	for i=1,#hEffigyPreviewEntity do
		local vOrigin = hEffigyPreviewEntity[i]:GetAbsOrigin()
		local vAngles = hEffigyPreviewEntity[i]:GetAnglesAsVector()
		local strPreviewUnit = strPreviewUnitTable[i]
		local effigyPreviewTable = 
		{ 	
			BossUnit = strPreviewUnit, 
			BossModelScale = ENCOUNTER_PREVIEW_SCALES[ strPreviewUnit ],
			ExtraModelScale = 1,
			EncounterType = ROOM_TYPE_ENEMY,
		}
		effigyPreviewTable.origin = tostring( vOrigin.x ) .. " " .. tostring( vOrigin.y ) .. " " .. tostring( vOrigin.z )
		effigyPreviewTable.angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z )

		SpawnEntityFromTableAsynchronous( "dota_aghsfort_boss_preview", effigyPreviewTable, nil, nil )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Hub
