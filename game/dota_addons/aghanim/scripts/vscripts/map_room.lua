require( "spawner" )

--------------------------------------------------------------------------------

if CMapRoom == nil then
	CMapRoom = class({})
	_G.CMapRoom = CMapRoom
end

--------------------------------------------------------------------------------

function CMapRoom:constructor( szRoomName, nRoomType, nDepth, vMins, vMaxs, vOrigin )
	self.szRoomName = szRoomName
	self.nRoomType = nRoomType
	self.nDepth = nDepth
	self.nEliteDepthBonus = 0
	self.vMins = vMins
	self.vMaxs = vMaxs
	self.vOrigin = vOrigin
	self.nAct = tonumber( string.sub( szRoomName, 2, 2 ) )
	self.bHidden = false;
	self.PlayerUnitsInRoom = {}
	self.szEncounterName = nil
	self.Encounter = nil
	self.exits = {}
	self.exitRewards = {}
	self.bActivated = false
	self.bSpawnGroupReady = false
	self.szExitRoomSelected = nil
	self.szMapName = "main"
	self.szRoomChoiceReward = nil
	self.bHasCrystal = false
	self.nPlayerChosenExitDirection = ROOM_EXIT_INVALID
	self.nPlayerEntranceDirection = ROOM_EXIT_INVALID

	self.hRandomStream = CreateUniformRandomStream( GameRules.Aghanim:GetRandomSeed() + MakeStringToken( szRoomName ) )
	self.bDisplayHiddenAsElite = ( self:RoomRandomInt( 1, 4 ) == 1 )
end

--------------------------------------------------------------------------------

function CMapRoom:ShouldDisplayHiddenAsElite( )
	return self.bDisplayHiddenAsElite
end

--------------------------------------------------------------------------------

function CMapRoom:AddExit( exitDirection, szRoomName )
	self.exits[ exitDirection ] = szRoomName
end

--------------------------------------------------------------------------------

function CMapRoom:GetExit( exitDirection )
	return self.exits[ exitDirection ]
end

--------------------------------------------------------------------------------

function CMapRoom:GetExits( )
	return self.exits
end

--------------------------------------------------------------------------------

function CMapRoom:GetExitDirectionForRoom( szRoomName )
	for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
		local szExitRoomName = self:GetExit( nExitDirection )
		if szRoomName == szExitRoomName then
			return nExitDirection
		end
	end
	return nil
end

--------------------------------------------------------------------------------
 
function CMapRoom:GetExitLocation( exitDirection )

	local bIsSpecialTransition = ( self.nDepth == 7 )
	if self.nRoomType ~= ROOM_TYPE_BOSS and bIsSpecialTransition == false then

		if exitDirection == ROOM_EXIT_LEFT then
			return Vector( self.vMins.x, self.vOrigin.y, self.vOrigin.z )
		elseif exitDirection == ROOM_EXIT_TOP then
			return Vector( self.vOrigin.x, self.vMaxs.y, self.vOrigin.z )
		elseif exitDirection == ROOM_EXIT_RIGHT then
			return Vector( self.vMaxs.x, self.vOrigin.y, self.vOrigin.z )
		end

	elseif self.nRoomType == ROOM_TYPE_BOSS then

		local nDivisor = 8
		if self.nDepth == 13 then
			nDivisor = 16
		end

		if exitDirection == ROOM_EXIT_LEFT then
			return Vector( self.vMins.x, self.vMins.y + ( self.vMaxs.y - self.vMins.y ) / nDivisor, self.vOrigin.z )
		elseif exitDirection == ROOM_EXIT_RIGHT then
			return Vector( self.vMaxs.x, self.vMins.y + ( self.vMaxs.y - self.vMins.y ) / nDivisor, self.vOrigin.z )
		end

	elseif bIsSpecialTransition == true then

		if exitDirection == ROOM_EXIT_TOP then
			if not GameRules.Aghanim:IsMapFlipped() then
				return Vector( self.vMins.x + ( self.vMaxs.x - self.vMins.x ) * 7 / 8, self.vMaxs.y, self.vOrigin.z )
			else
				return Vector( self.vMins.x + ( self.vMaxs.x - self.vMins.x ) * 1 / 8, self.vMaxs.y, self.vOrigin.z )
			end
		end

	end

	return nil
end

--------------------------------------------------------------------------------
 
function CMapRoom:GetNeighboringRoomHeightDifference( nExitDirection )

	local szExitRoomName = self:GetExit( nExitDirection )
	if szExitRoomName == nil then
		return 0
	end

	local exitRoom = GameRules.Aghanim:GetRoom( szExitRoomName )
	if exitRoom == nil then
		return 0
	end

	local zeroHeights = 
	{
		up = 0,
		left = 0,
		right = 0,
		down = 0
	}

	local myHeights = MAP_EXIT_HEIGHTS[ self:GetMapName() ]
	local theirHeights = MAP_EXIT_HEIGHTS[ exitRoom:GetMapName() ]
	if myHeights == nil then
		myHeights = zeroHeights
	end
	if theirHeights == nil then
		theirHeights = zeroHeights
	end

	if nExitDirection == ROOM_EXIT_LEFT then
		return myHeights.left - theirHeights.right
	end
	if nExitDirection == ROOM_EXIT_TOP then
		return myHeights.up - theirHeights.down
	end
	if nExitDirection == ROOM_EXIT_RIGHT then
		return myHeights.right - theirHeights.left
	end
	return 0
end

--------------------------------------------------------------------------------

function CMapRoom:SetEliteDepthBonus( nEliteDepthBonus )
	self.nEliteDepthBonus = nEliteDepthBonus
	self:GetEncounter():OnEliteRankChanged( nEliteDepthBonus )
	self:SendRoomToClient()
end

--------------------------------------------------------------------------------

function CMapRoom:SetHidden( )
	self.bHidden = true
end

--------------------------------------------------------------------------------

function CMapRoom:IsHidden( )
	return self.bHidden
end

--------------------------------------------------------------------------------

function CMapRoom:AssignEncounter( szEncounterName )

	-- NOTE: For debugging, it's possible to re-assign a new encounter to an existing room.
	-- In that case, clean up any temporary state
	self.szMapName = nil
	if self.hSpawnGroupHandle ~= nil then
		UnloadSpawnGroupByHandle( self.hSpawnGroupHandle ) 
		self.hSpawnGroupHandle = nil
	end
	self.bSpawnGroupReady = false

	-- At this point, we're ready to assign the encounter
	self.szEncounterName = szEncounterName

	--print( "AssignEncounter: " .. self:GetName() .." -> " .. szEncounterName )

	local hEncounterClass = require( "encounters/" .. self.szEncounterName )
	if hEncounterClass == nil then
		print( "ERROR: Encounter class " .. szEncounterName .. " not found.\n" )
		return
	end

	self.Encounter = hEncounterClass( self, self.szEncounterName )
	if self.Encounter == nil then
		print( "ERROR: Failed to create Encounter " .. szEncounterName .. "\n" )
		return
	end
end

--------------------------------------------------------------------------------

function CMapRoom:FindAllEntitiesInRoomByName( szEntityName, bWarnIfNotFound )

	local hEntityList = Entities:FindAllByName( szEntityName )

	for i=#hEntityList, 1, -1 do
		if hEntityList[i]:GetSpawnGroupHandle() ~= self:GetSpawnGroupHandle() then
			table.remove( hEntityList, i )
		end
	end	

	if #hEntityList == 0 and bWarnIfNotFound then
		print( "Unable to find entity " .. szEntityName .. " for encounter " .. self.szEncounterName .. " map " .. self:GetMapName() )
	end

	return hEntityList

end

--------------------------------------------------------------------------------

function CMapRoom:OnEncounterLoaded()
	-- This is the level stream load finished callback.

	-- We're only calling Find to print an error if none can be found
	self:FindAllEntitiesInRoomByName( "room_activate", true )

	self.Encounter:OnEncounterLoaded()
end

--------------------------------------------------------------------------------

function CMapRoom:IsInRoomBounds( vOrigin )
	if vOrigin.x > self.vMins.x and vOrigin.x < self.vMaxs.x and vOrigin.y > self.vMins.y and vOrigin.y < self.vMaxs.y then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function CMapRoom:IsValidSpawnPoint( vOrigin )

	local flBorder = 384
	if  vOrigin.x > ( self.vMins.x + flBorder ) and vOrigin.x < ( self.vMaxs.x - flBorder ) and 
		vOrigin.y > ( self.vMins.y + flBorder ) and vOrigin.y < ( self.vMaxs.y - flBorder ) then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function CMapRoom:ClampPointToRoomBounds( vOrigin, flBorder )

	if flBorder == nil then
		flBorder = 4
	end
	
	local vClamped = Vector( vOrigin.x, vOrigin.y, vOrigin.z )

	if vClamped.x < ( self.vMins.x + flBorder ) then
		vClamped.x = self.vMins.x + flBorder;
	elseif vClamped.x > ( self.vMaxs.x - flBorder ) then
		vClamped.x = self.vMaxs.x - flBorder;
	end

	if vClamped.y < ( self.vMins.y + flBorder ) then
		vClamped.y = ( self.vMins.y + flBorder )
	elseif vClamped.y > ( self.vMaxs.y - flBorder ) then
		vClamped.y = ( self.vMaxs.y - flBorder )
	end

	return vClamped
end

--------------------------------------------------------------------------------

function CMapRoom:LoadExitRooms()
	for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
		local szExitRoomName = self:GetExit( nExitDirection )
		if szExitRoomName ~= nil then
			local ExitRoom = GameRules.Aghanim:GetRoom( szExitRoomName )
			-- NOTE: the hSpawnGroupHandle test is if we respawn an exit room because of development-time testing
			if ExitRoom ~= nil and ExitRoom.hSpawnGroupHandle == nil then
				local EncounterData = ENCOUNTER_DEFINITIONS[ ExitRoom.szEncounterName ]
				if EncounterData ~= nil then
					
					-- Must set the map name prior to getting the neighboring room height difference
					local mapList = EncounterData.szMapNames
					if GameRules.Aghanim:IsMapFlipped() and EncounterData.szFlippedMapNames ~= nil then
						mapList = EncounterData.szFlippedMapNames
					end					
					local szMapName = mapList[ self:RoomRandomInt( 1, #mapList ) ]
					ExitRoom.szMapName = szMapName

					ExitRoom.vOrigin.z = self.vOrigin.z + self:GetNeighboringRoomHeightDifference( nExitDirection ) 
					print( "Spawning room " .. szExitRoomName .. " with encounter " .. ExitRoom.szEncounterName .. " on map " .. szMapName .. " at ( " .. ExitRoom.vOrigin.x .. ", " .. ExitRoom.vOrigin.y .. ", " .. ExitRoom.vOrigin.z .. " )" )
					ExitRoom.hSpawnGroupHandle = DOTA_SpawnMapAtPosition( szMapName, ExitRoom.vOrigin, 
						true, Dynamic_Wrap( CMapRoom, "OnRoomReadyToSpawn" ), Dynamic_Wrap( CMapRoom, "OnSpawnRoomComplete" ), ExitRoom )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapRoom:OnRoomReadyToSpawn( hSpawnGroupHandle )
	if ( hSpawnGroupHandle == self.hSpawnGroupHandle ) then
		--print( "OnRoomReadyToSpawn " .. self:GetName() .. "\n" )
		self.bSpawnGroupReady = true
	else
		print( "Unexpected OnRoomReadyToSpawn " .. self:GetName() .. " " .. hSpawnGroupHandle .. "->" .. self.hSpawnGroupHandle .. "\n" )
	end
end

--------------------------------------------------------------------------------

function CMapRoom:OpenExit( szExitDir, vSmallExitLocation )

	-- Open a gap in the force unseen blockers
	-- Only W or E exits have the possibility of being small exits
	if szExitDir == "W" then

		if vSmallExitLocation == nil then
			GameRules.Aghanim:ClearFowBlockers( 
				Vector( self.vMins.x + 1, self.vMins.y + 1, self.vMins.z ),
				Vector( self.vMins.x + 1, self.vMaxs.y - 1, self.vMins.z ) ) 
		else
			GameRules.Aghanim:ClearFowBlockers( 
				Vector( vSmallExitLocation.x + 1, vSmallExitLocation.y - 256, self.vMins.z ),
				Vector( vSmallExitLocation.x + 1, vSmallExitLocation.y + 256, self.vMins.z ) ) 
		end

	elseif szExitDir == "E" then

		if vSmallExitLocation == nil then
			GameRules.Aghanim:ClearFowBlockers( 
				Vector( self.vMaxs.x - 1, self.vMins.y + 1, self.vMins.z ),
				Vector( self.vMaxs.x - 1, self.vMaxs.y - 1, self.vMins.z ) ) 
		else
			GameRules.Aghanim:ClearFowBlockers( 
				Vector( vSmallExitLocation.x - 1, vSmallExitLocation.y - 256, self.vMins.z ),
				Vector( vSmallExitLocation.x - 1, vSmallExitLocation.y + 256, self.vMins.z ) ) 
		end

	elseif szExitDir == "N" then
		GameRules.Aghanim:ClearFowBlockers( 
			Vector( self.vMins.x + 1, self.vMaxs.y - 1, self.vMins.z ),
			Vector( self.vMaxs.x - 1, self.vMaxs.y - 1, self.vMins.z ) ) 
	elseif szExitDir == "S" then
		GameRules.Aghanim:ClearFowBlockers( 
			Vector( self.vMins.x + 1, self.vMins.y + 1, self.vMins.z ),
			Vector( self.vMaxs.x - 1, self.vMins.y + 1, self.vMins.z ) ) 
	end

	-- NOTE: Do not break in the loop; necessary for double N exits in the main map
	local roomUnlockList = self:FindAllEntitiesInRoomByName( "room_unlock_" .. szExitDir, true )
	if #roomUnlockList == 0 then
		print( "ERROR: Unable to find entity room_unlock_" .. szExitDir .. " in room  " .. self:GetName() )
	end		
	for i=1, #roomUnlockList do
		print( "Triggering " .. self:GetName() .. " room_unlock_" .. szExitDir .. " on ent " .. roomUnlockList[i]:entindex() .. " h " .. roomUnlockList[i]:GetSpawnGroupHandle() )
		roomUnlockList[i]:Trigger( nil, nil )
	end

end

--------------------------------------------------------------------------------

function CMapRoom:CreateVisBlockers( )

	GameRules.Aghanim:AddFowOutlineBlocker( 
		Vector( self.vMins.x + 1, self.vMins.y + 1, self.vMins.z ), 
		Vector( self.vMaxs.x - 1, self.vMaxs.y - 1, self.vMaxs.z ) )

end

--------------------------------------------------------------------------------

function CMapRoom:SpawnBridges( )

	for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
		local szExitRoomName = self:GetExit( nExitDirection )
		if szExitRoomName ~= nil then

			local szExitDir = "N"
			if nExitDirection == ROOM_EXIT_LEFT then
				szExitDir = "W"
			elseif nExitDirection == ROOM_EXIT_RIGHT then						
				szExitDir = "E"
			end

			-- NOTE: Do not break in the loop; necessary for double N exits in the main map
			local hBridges = self:FindAllEntitiesInRoomByName( "spawn_bridge_" .. szExitDir, true )
			for i=1, #hBridges do
				hBridges[i]:ForceSpawn( )
			end

		end
	end

end

--------------------------------------------------------------------------------

function CMapRoom:OnSpawnRoomComplete( hSpawnGroupHandle )

	if ( hSpawnGroupHandle == self.hSpawnGroupHandle ) then

		--print( "OnSpawnRoomComplete " .. self:GetName() .. "\n" )
		self:OnEncounterLoaded()

		-- Set up vis blockers on the new room
		self:CreateVisBlockers()

		-- Clear out the path between the two rooms
		for k,room in pairs(GameRules.Aghanim:GetRoomList()) do

			for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
				local szExitRoomName = room:GetExit( nExitDirection )
				if szExitRoomName ~= nil and room ~= self and szExitRoomName == self:GetName() and room:IsActivated() then
					local vSmallExitLocation = nil
					if room.nRoomType == ROOM_TYPE_BOSS then
						vSmallExitLocation = room:GetExitLocation( nExitDirection )
					end
					if nExitDirection == ROOM_EXIT_LEFT then
						room:OpenExit( "W", vSmallExitLocation )
						self:OpenExit( "E", vSmallExitLocation )
					elseif nExitDirection == ROOM_EXIT_TOP then
						room:OpenExit( "N", vSmallExitLocation )
						self:OpenExit( "S", vSmallExitLocation )	
					elseif nExitDirection == ROOM_EXIT_RIGHT then						
						room:OpenExit( "E", vSmallExitLocation )
						self:OpenExit( "W", vSmallExitLocation )	
					end
					break
				end
			end

		end

		self:SpawnBridges()

	else
		print( "Unexpected OnSpawnRoomComplete " .. self:GetName() .. " " .. hSpawnGroupHandle .. "->" .. self.hSpawnGroupHandle .. "\n" )
	end	
end

--------------------------------------------------------------------------------

function CMapRoom:AreAllExitRoomsReady()
	for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
		local szExitRoomName = self:GetExit( nExitDirection )
		if szExitRoomName ~= nil then
			local ExitRoom = GameRules.Aghanim:GetRoom( szExitRoomName )
			if ExitRoom ~= nil then
				local EncounterData = ENCOUNTER_DEFINITIONS[ ExitRoom.szEncounterName ]
				if EncounterData ~= nil then
					if not ExitRoom:IsMapReady() then
						return false
					end
				end
			end
		end
	end
	return true
end

--------------------------------------------------------------------------------

function CMapRoom:ComputeRoomStats( )

	if self.Encounter == nil then
		return nil
	end

	local roomStats = 
	{
		szEncounterName = self.Encounter:GetName(),
		bIsElite = self:IsElite(),
		bIsHidden = self:IsHidden(),
		nRoomType = self:GetType(),
		szReward = self:GetRoomChoiceReward(),
		ascensionAbilities = self.Encounter:GetAscensionAbilities(),
	}

	return roomStats

end


--------------------------------------------------------------------------------

function CMapRoom:OnNextRoomSelected( szSelectedRoomName )

	if self.szExitRoomSelected ~= nil then
		return
	end

	self.szExitRoomSelected = szSelectedRoomName
	printf( "OnNextRoomSelected %s\n", szSelectedRoomName )

	-- Register the room selection
	local roomSelectionStats = 
	{
		depth = self:GetDepth() + 1
	}

	for nExitDirection=ROOM_EXIT_LEFT,ROOM_EXIT_RIGHT do
		local szExitRoomName = self:GetExit( nExitDirection )
		if szExitRoomName ~= nil then
			local ExitRoom = GameRules.Aghanim:GetRoom( szExitRoomName )
			if ExitRoom ~= nil then
				if szExitRoomName == szSelectedRoomName then
					ManuallyTriggerSpawnGroupCompletion( ExitRoom:GetSpawnGroupHandle() )

					self.nPlayerChosenExitDirection = nExitDirection 
					ExitRoom.nPlayerEntranceDirection = GetEntranceDirectionForExitType( nExitDirection )
					
					self:SendRoomToClient()
					ExitRoom:SendRoomToClient()

					roomSelectionStats.selectedRoom = ExitRoom:ComputeRoomStats()
					if ExitRoom.Encounter ~= nil then
						ExitRoom.Encounter:Introduce()
					end
				else
					roomSelectionStats.unselectedRoom = ExitRoom:ComputeRoomStats()
					UnloadSpawnGroupByHandle( ExitRoom:GetSpawnGroupHandle() ) 
				end
			end
		end
	end	

	GameRules.Aghanim:RegisterEncounterStats( roomSelectionStats )
end

--------------------------------------------------------------------------------

function CMapRoom:GetExitRoomSelected( )
	return self.szExitRoomSelected
end

--------------------------------------------------------------------------------

function CMapRoom:Activate()
	if self.bActivated == false then
		self.bActivated = true

		self.nTriggerStartTouchListener = ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( getclass( self ), "OnTriggerStartTouch" ), self )
		self.nTriggerEndTouchListener = ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( getclass( self ), "OnTriggerEndTouch" ), self )

		self:LoadExitRooms()

		self.Encounter:Start()
	end
end

--------------------------------------------------------------------------------

function CMapRoom:OnEncounterCompleted()
	StopListeningToGameEvent( self.nTriggerStartTouchListener )
	StopListeningToGameEvent( self.nTriggerEndTouchListener )
end

--------------------------------------------------------------------------------
-- trigger_start_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short

--------------------------------------------------------------------------------
function CMapRoom:OnTriggerStartTouch( event )
	--printf( "map_room - OnTriggerStartTouch" )

	local sTriggerName = nil  
	if event.trigger_name ~= nil then
		sTriggerName = event.trigger_name
	end

	local hActivator = nil 
	if event.activator_entindex ~= nil then
		hActivator = EntIndexToHScript( event.activator_entindex )
	end

	local hCaller = nil 
	if event.caller_entindex ~= nil then
		hCaller = EntIndexToHScript( event.caller_entindex )
	end

	if sTriggerName == "room_activate" and hCaller:GetSpawnGroupHandle() == self:GetSpawnGroupHandle() and hActivator ~= nil and hActivator:GetTeamNumber() == DOTA_TEAM_GOODGUYS and hActivator:IsOwnedByAnyPlayer() and not hActivator:IsTempestDouble() then
		table.insert( self.PlayerUnitsInRoom, hActivator )
		if hActivator:IsRealHero() then
			local hCurrentRoomOfPlayer = GameRules.Aghanim:GetPlayerCurrentRoom( hActivator:GetPlayerOwnerID() )
			if hCurrentRoomOfPlayer ~= self then
				GameRules.Aghanim:SetPlayerCurrentRoom( hActivator:GetPlayerOwnerID(), self )
			end
			
		end
		--print( "Player unit " .. hActivator:GetUnitName() .. " just entered room " .. self:GetMapName() .. " (" .. #self.PlayerUnitsInRoom .. " new count)" )
	end
end

--------------------------------------------------------------------------------
-- trigger_end_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short

--------------------------------------------------------------------------------

function CMapRoom:OnTriggerEndTouch( event )
	local sTriggerName = nil  
	if event.trigger_name ~= nil then
		sTriggerName = event.trigger_name
	end

	local hActivator = nil 
	if event.activator_entindex ~= nil then
		hActivator = EntIndexToHScript( event.activator_entindex )
	end

	local hCaller = nil 
	if event.caller_entindex ~= nil then
		hCaller = EntIndexToHScript( event.caller_entindex )
	end

	if sTriggerName == "room_activate" and hCaller:GetSpawnGroupHandle() == self:GetSpawnGroupHandle() and hActivator ~= nil and hActivator:GetTeamNumber() == DOTA_TEAM_GOODGUYS and hActivator:IsOwnedByAnyPlayer() then
		for k,hUnit in pairs ( self.PlayerUnitsInRoom ) do
			if hUnit and hUnit == hActivator then
				table.remove( self.PlayerUnitsInRoom, k )
				--print( "Player unit " .. hActivator:GetUnitName() .. " just left room " .. self:GetMapName() .. " (" .. #self.PlayerUnitsInRoom .. " new count)" )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapRoom:SetRoomChoiceReward( szReward )
	self.szRoomChoiceReward = szReward
end

--------------------------------------------------------------------------------

function CMapRoom:GetRoomChoiceReward()
	return self.szRoomChoiceReward
end

--------------------------------------------------------------------------------

function CMapRoom:SendRoomToClient()
	local netTable = {}
	if GameRules.Aghanim:GetCurrentRoom() and self:GetAct() <= GameRules.Aghanim:GetCurrentRoom():GetAct() then
		netTable[ "reward" ] = self:GetRoomChoiceReward()				
		netTable[ "map_name" ] = self:GetMapName()
		netTable[ "room_type" ] = self:GetType()
		netTable[ "depth" ] = self:GetDepth()
		netTable[ "entrance_direction" ] = self:GetPlayerEntranceDirection()
		netTable[ "exit_direction" ] = self:GetPlayerChosenExitDirection()

		netTable[ "completed" ] = 0
		if self:GetEncounter():IsComplete() then
			netTable[ "completed" ] = 1
		end

		netTable[ "current_room" ] = 0
		if self == GameRules.Aghanim:GetCurrentRoom() then
			netTable[ "current_room" ] = 1
		end

		netTable[ "elite" ] = self:GetEliteRank()
	else
		netTable[ "reward" ] = "REWARD_TYPE_HIDDEN"
		netTable[ "map_name" ] = "none"
		netTable[ "room_type" ] = ROOM_TYPE_INVALID
		netTable[ "entrance_direction" ] = ROOM_EXIT_INVALID
		netTable[ "exit_direction" ] = ROOM_EXIT_INVALID
		netTable[ "depth" ] = self:GetDepth()

		if self:GetType() == ROOM_TYPE_BOSS or self:GetType() == ROOM_TYPE_BONUS then
			netTable[ "room_type" ] = self:GetType()
		end

		netTable[ "completed" ] = 0
		netTable[ "current_room" ] = 0
		netTable[ "elite" ] = 0
	end

	CustomNetTables:SetTableValue( "room_data", self:GetName(), netTable )
end

--------------------------------------------------------------------------------

function CMapRoom:IsInRoom( hUnit )
	for _,hUnitInRoom in pairs ( self.PlayerUnitsInRoom ) do
		if hUnitInRoom == hUnit then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function CMapRoom:GetPlayerUnitsInRoom()
	return self.PlayerUnitsInRoom
end

--------------------------------------------------------------------------------

function CMapRoom:IsActivated()
	if self.PlayerUnitsInRoom == nil or #self.PlayerUnitsInRoom == 0 then
		return false
	end
	return self.bActivated
end

--------------------------------------------------------------------------------

function CMapRoom:GetName()
	return self.szRoomName
end

--------------------------------------------------------------------------------

function CMapRoom:GetType()
	return self.nRoomType
end

--------------------------------------------------------------------------------

function CMapRoom:GetAct()
	return self.nAct
end

--------------------------------------------------------------------------------

function CMapRoom:GetDepth()
	return self.nDepth
end

--------------------------------------------------------------------------------

function CMapRoom:GetEliteRank()
	return self.nEliteDepthBonus
end

--------------------------------------------------------------------------------

function CMapRoom:IsElite()
	return self.nEliteDepthBonus > 0
end

--------------------------------------------------------------------------------

function CMapRoom:GetOrigin()
	return self.vOrigin
end

--------------------------------------------------------------------------------

function CMapRoom:GetMins()
	return self.vMins
end

--------------------------------------------------------------------------------

function CMapRoom:GetMaxs()
	return self.vMaxs
end

--------------------------------------------------------------------------------
 
function CMapRoom:GetEncounter()
	return self.Encounter
end

--------------------------------------------------------------------------------
 
function CMapRoom:GetEncounterName()
	return self.szEncounterName
end

--------------------------------------------------------------------------------
 
function CMapRoom:GetSpawnGroupHandle()
	return self.hSpawnGroupHandle
end

--------------------------------------------------------------------------------
 
function CMapRoom:IsMapReady()
	return self.bSpawnGroupReady
end

--------------------------------------------------------------------------------

function CMapRoom:GetMapName()
	return self.szMapName
end


--------------------------------------------------------------------------------

function CMapRoom:GetPlayerEntranceDirection()
	return self.nPlayerEntranceDirection
end

--------------------------------------------------------------------------------

function CMapRoom:GetPlayerChosenExitDirection()
	return self.nPlayerChosenExitDirection
end

--------------------------------------------------------------------------------

function CMapRoom:HasCrystal()
	return self.bHasCrystal
end

--------------------------------------------------------------------------------

function CMapRoom:RoomRandomInt( nMinInt, nMaxInt )
	return self.hRandomStream:RandomInt( nMinInt, nMaxInt )
end

--------------------------------------------------------------------------------

function CMapRoom:RoomRandomFloat( flMin, flMin )
	return self.hRandomStream:RandomFloat( flMin, flMin )
end
