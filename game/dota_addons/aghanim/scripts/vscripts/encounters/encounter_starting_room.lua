require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_StartingRoom == nil then
	CMapEncounter_StartingRoom = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_StartingRoom:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )
	self:GetRoom().hSpawnGroupHandle = GetActiveSpawnGroupHandle()
	self.bRewardsSelected = false
	self.bSpokenGameStartLine = false
	self.bAllButtonsReady = false
end

--------------------------------------------------------------------------------

function CMapEncounter_StartingRoom:Start()

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

function CMapEncounter_StartingRoom:OnAscensionLevelSelected( event )
	print( "Ascension Level " .. event.level .. " selected" )
	GameRules.Aghanim:SetAscensionLevel( event.level - 1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_StartingRoom:OnThink()
	CMapEncounter.OnThink( self )

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
			GameRules.Aghanim:GetAnnouncer():OnGameStarted( )
			self.bSpokenGameStartLine = true
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
		self:UpdateEncounterObjective( "objective_select_aghanims_fragmants", nNumSelected, nil )

		if #vecPlayers > 0 and nNumSelected == #vecPlayers then
			self:GetRoom().bSpawnGroupReady = true
			self.bRewardsSelected = true
		end
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_StartingRoom:InitializeObjectives()
	--CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "objective_stand_on_buttons", 0, 4 )
	self:AddEncounterObjective( "objective_select_aghanims_fragmants", 0, 4 )

end

--------------------------------------------------------------------------------

function CMapEncounter_StartingRoom:OnTriggerStartTouch( event )

	if self.bAllButtonsReady == true then
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

		self.nPlayersReady = self.nPlayersReady + 1
		self:UpdateEncounterObjective( "objective_stand_on_buttons", self.nPlayersReady, nil )

		local vecPlayers = GameRules.Aghanim:GetConnectedPlayers()
		if #vecPlayers > 0 then
			if self.nPlayersReady == #vecPlayers then

				self.bAllButtonsReady = true
				GameRules.Aghanim:SetExpeditionStartTime( GameRules:GetGameTime() )

				self:GenerateRewards()

				-- We want to announce rewards during the starting room
				GameRules.Aghanim:GetAnnouncer():OnSelectRewards()	

				-- Open the main gate
				local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "main_gate_open_relay", false )
				for _, hRelay in pairs( hRelays ) do
					hRelay:Trigger( nil, nil )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_StartingRoom:OnTriggerEndTouch( event )

	if self.bAllButtonsReady == true then
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

function CMapEncounter_StartingRoom:CheckForCompletion()
	return GameRules.Aghanim:HasSetAscensionLevel() == true and self.bRewardsSelected == true
end


--------------------------------------------------------------------------------

function CMapEncounter_StartingRoom:OnComplete()
	CMapEncounter.OnComplete( self )

	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:SetAbilityPoints( 1 )
			EmitSoundOnClient( "General.LevelUp", hHero:GetPlayerOwner() )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, nil ) )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_StartingRoom
