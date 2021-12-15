require( "spawner" )

--------------------------------------------------------------------------------

if CMapRoom == nil then
	CMapRoom = class({})
	_G.CMapRoom = CMapRoom
end

--------------------------------------------------------------------------------

function CMapRoom:constructor( szRoomName, nRoomType, nDepth, vMins, vMaxs, vOrigin, roomDef )
	self.szRoomName = szRoomName
	self.nRoomType = nRoomType
	self.nDepth = nDepth
	self.nEliteDepthBonus = 0
	self.vMins = vMins
	self.vMaxs = vMaxs
	self.vOrigin = vOrigin
	self.nAct = tonumber( string.sub( szRoomName, 2, 2 ) )
	if szRoomName == "hub" then
		self.nAct = 1
	end
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
	if GetMapName() == "hub" then 
		self.szMapName = "hub"
	end
	self.szRoomChoiceReward = nil
	self.bHasCrystal = false
	self.nPlayerChosenExitDirection = ROOM_EXIT_INVALID
	self.nPlayerEntranceDirection = ROOM_EXIT_INVALID

	--AghSlab2
	self.nExitChoices = 0
	self.nEncountersToSelect = 0
	self.nNumEliteEncounters = 0
	self.nHiddenExitOption = 0
	self.bSpawnTrapRoom = false
	self.vecPotentialEncounters = {}
	self.bRoomGeometryReady = false 
	self.hEventPrefabSpawnGroupHandle = nil
	self.bEventPrefabReady = false 


	self.hRandomStream = CreateUniformRandomStream( GameRules.Aghanim:GetRandomSeed() + MakeStringToken( szRoomName ) )
	self.bDisplayHiddenAsElite = ( self:RoomRandomInt( 1, 4 ) == 1 )

	if roomDef ~= nil then
		self.flMinimapOriginX = roomDef.flMinimapOriginX
		self.flMinimapOriginY = roomDef.flMinimapOriginY
		self.flMinimapSize = roomDef.flMinimapSize
		self.nMinimapScale = roomDef.nMinimapScale
		self.szMinimapMapName = roomDef.szMinimapMapName
	end
end

--------------------------------------------------------------------------------

function CMapRoom:ShouldDisplayHiddenAsElite( )
	if self.nRoomType == ROOM_TYPE_EVENT then 
		return false 
	end

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
	if self:GetEncounter() then
		self:GetEncounter():OnEliteRankChanged( nEliteDepthBonus )
	end
	self:SendRoomToClient()
end

--------------------------------------------------------------------------------

function CMapRoom:SetHidden( )
	self.bHidden = true
end

--------------------------------------------------------------------------------

function CMapRoom:IsHidden( )
	if GetMapName() == "hub" then 
		return self.nHiddenExitOption > 0 
	end
	return self.bHidden
end

--------------------------------------------------------------------------------

function CMapRoom:SetExitOptionHidden( nOption )
	self.nHiddenExitOption = nOption 
end

--------------------------------------------------------------------------------

function CMapRoom:GetExitOptionHidden()
	return self.nHiddenExitOption
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

	local hEncounterClass = nil
	if GetMapName() == "main" then 
		hEncounterClass = require( "encounters/" .. self.szEncounterName )
	else
		hEncounterClass = require( "encounters/2021/" .. self.szEncounterName )
	end
	if hEncounterClass == nil then
		print( "ERROR: Encounter class " .. szEncounterName .. " not found.\n" )
		return
	end

	self.Encounter = hEncounterClass( self, self.szEncounterName )
	if self.Encounter == nil then
		print( "ERROR: Failed to create Encounter " .. szEncounterName .. "\n" )
		return
	end

	self.vecPotentialEncounters = {}
end

--------------------------------------------------------------------------------

function CMapRoom:AssignPendingEncounter( hEncounter )
	if hEncounter == nil then 
		print( "trying to assign nil pending encounter!" )
	end
	-- NOTE: For debugging, it's possible to re-assign a new encounter to an existing room.
	-- In that case, clean up any temporary state
	self.szMapName = nil
	if self.hSpawnGroupHandle ~= nil then
		UnloadSpawnGroupByHandle( self.hSpawnGroupHandle ) 
		self.hSpawnGroupHandle = nil
	end
	self.bSpawnGroupReady = false

	-- At this point, we're ready to assign the encounter
	self.szEncounterName = hEncounter.szEncounterName

	--print( "AssignEncounter: " .. self:GetName() .." -> " .. szEncounterName )

	local hEncounterClass = nil
	if GetMapName() == "main" then 
		hEncounterClass = require( "encounters/" .. self.szEncounterName )
	else
		hEncounterClass = require( "encounters/2021/" .. self.szEncounterName )
	end
	if hEncounterClass == nil then
		print( "ERROR: Encounter class " .. szEncounterName .. " not found.\n" )
		return
	end

	self.Encounter = hEncounter
	if self.Encounter == nil then
		print( "ERROR: Failed to create Encounter " .. szEncounterName .. "\n" )
		return
	end

	self.vecPotentialEncounters = {}
end


--------------------------------------------------------------------------------

function CMapRoom:FindAllEntitiesInRoomByName( szEntityName, bWarnIfNotFound )

	local hEntityList = Entities:FindAllByName( szEntityName )

	for i=#hEntityList, 1, -1 do
		if hEntityList[i]:GetSpawnGroupHandle() ~= self:GetSpawnGroupHandle() and ( hEntityList[i]:GetSpawnGroupHandle() ~= self.hEventPrefabSpawnGroupHandle ) then
			table.remove( hEntityList, i )
		end
	end	

	--print( self.szEncounterName )
	--print( szEntityName )
	--print( self:GetMapName() )

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

	if GetMapName() == "hub" then
		print( "Finishing room spawn 2021" )
		--ManuallyTriggerSpawnGroupCompletion( hSpawnGroupHandle )
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
	--print( "room " .. self:GetName() .. " origin: ( " .. self.vOrigin.x  .. ", " .. self.vOrigin.y .. ", " .. self.vOrigin.z .. ")" )
	--print ( "creating vis blockers for room " .. self:GetName() .. " from ( " .. self.vMins.x + 1 .. ", " .. self.vMins.y + 1 .. ", " .. self.vMins.z .. ") to (" .. self.vMaxs.x - 1 .. ", " .. self.vMaxs.y - 1 .. ", " .. self.vMaxs.z .. ")" )

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

function CMapRoom:SpawnBridgeAtExit( szExitName )
	-- NOTE: Do not break in the loop; necessary for double N exits in the main map
	local hBridges = self:FindAllEntitiesInRoomByName( "spawn_bridge_" .. szExitName, true )
	for i=1, #hBridges do

		hBridges[i]:ForceSpawn( )

		local hActualBridges = Entities:FindAllByClassnameWithin( "prop_dynamic", hBridges[i]:GetAbsOrigin(), 300.0 )
		for j=1, #hActualBridges do
			if string.find( hActualBridges[j]:GetName(), "room_gate" ) == nil then 
				local vAngles = hBridges[i]:GetAnglesAsVector()
				hActualBridges[j]:SetAbsAngles( vAngles.x, vAngles.y, vAngles.z )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapRoom:OnSpawnRoomComplete( hSpawnGroupHandle )
	print( "OnRoomSpawnComplete" )
	if GetMapName() == "main" then
		self:OnSpawnRoomComplete_2020( hSpawnGroupHandle )
		return
	else
		self:OnSpawnRoomComplete_2021( hSpawnGroupHandle )
		return
	end
end

--------------------------------------------------------------------------------

function CMapRoom:OnSpawnRoomComplete_2020( hSpawnGroupHandle )
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

function CMapRoom:OnEventExitPrefabSpawnComplete( hSpawnGroupHandle )
	if ( hSpawnGroupHandle == self.hEventPrefabSpawnGroupHandle ) then
		print( "prefab finished spawning" )
		self.bEventPrefabReady = true 
		if self.bRoomGeometryReady then 
			self:OpenExit( "entrance", nil )
		end
	end
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function CMapRoom:OnSpawnRoomComplete_2021( hSpawnGroupHandle )
	print( "CMapRoom:OnSpawnRoomComplete_2021 - " .. self:GetName() )
	if ( hSpawnGroupHandle == self.hSpawnGroupHandle ) then
		self.bRoomGeometryReady = true
		self.bSpawnGroupReady = true 
		self:OnEncounterLoaded()
		self:GetEncounter():Introduce()

		-- Set up vis blockers on the new room
		self:CreateVisBlockers()

		local hCurrentRoom = GameRules.Aghanim:GetCurrentRoom()
		if hCurrentRoom == nil then
			print ( "OnSpawnRoomComplete_2021: Current room is nil! ")
			return
		end

		if hCurrentRoom:GetName() == "hub" then 
			local nAct = self.nAct 
			if nAct == 1 then
				hCurrentRoom:SpawnBridgeAtExit( "W" )	
				hCurrentRoom:OpenExit( "W", nil )			
			elseif nAct == 2 then
				hCurrentRoom:SpawnBridgeAtExit( "N" )
				hCurrentRoom:OpenExit( "N", nil )			
			else
				hCurrentRoom:SpawnBridgeAtExit( "E" )
				hCurrentRoom:OpenExit( "E", nil )		
			end	
			self:OpenExit( "entrance", nil )			
		else
			if self.nRoomType == ROOM_TYPE_EVENT then 
				hCurrentRoom:SpawnBridgeAtExit( "event_exit" )
				hCurrentRoom:OpenExit( "event_exit", nil )

				if self.bEventPrefabReady then 
					self:OpenExit( "entrance", nil )
					print( "WARNING!! The event door prefab was not ready when the exits were opened" )
				end
			else
				hCurrentRoom:SpawnBridgeAtExit( "exit" )
				hCurrentRoom:OpenExit( "exit", nil )

				if hCurrentRoom.nRoomType == ROOM_TYPE_EVENT then 								
					self:OpenExit( "event_entrance", nil )
				else
					self:OpenExit( "entrance", nil )
				end
			end 		
		end
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

	local bElite = false 
	local bHidden = false 
	if GetMapName() == "hub" then 
		bElite = self.Encounter:IsEliteEncounter()
		bHidden = self.Encounter:IsHiddenEncounter()
	else
		bElite = self:IsElite() 
		bHidden = self:IsHidden()
	end

	local roomStats = 
	{
		szEncounterName = self.Encounter:GetName(),
		bIsElite = bElite,
		bIsHidden = bHidden,
		nRoomType = self:GetType(),
		szReward = self:GetRoomChoiceReward(),
		ascensionAbilities = self.Encounter:GetAscensionAbilities(),
	}

	return roomStats

end

--------------------------------------------------------------------------------

function CMapRoom:ComputeRoomStats_Unselected( hEncounter )

	if hEncounter == nil then
		return nil
	end

	local bElite = false 
	local bHidden = false 
	if GetMapName() == "hub" then 
		bElite = hEncounter:IsEliteEncounter()
		bHidden = hEncounter:IsHiddenEncounter()
	else
		bElite = self:IsElite() 
		bHidden = self:IsHidden()
	end

	local roomStats = 
	{
		szEncounterName = hEncounter:GetName(),
		bIsElite = bElite,
		bIsHidden = bHidden,
		nRoomType = hEncounter.nEncounterType,
		szReward = self:GetPotentialEncounterRoomReward( hEncounter:GetName() ),
		ascensionAbilities = hEncounter:GetAscensionAbilities(),
	}

	return roomStats

end


--------------------------------------------------------------------------------

function CMapRoom:OnNextRoomSelected( szSelectedRoomName, szSelectedEncounterName )

	if self.szExitRoomSelected ~= nil then
		return
	end

	printf( "OnNextRoomSelected %s\n", szSelectedRoomName )
	if GetMapName() == "main" then 
		self:OnNextRoomSelected_2020( szSelectedRoomName )
	else
		self:OnNextRoomSelected_2021( szSelectedRoomName, szSelectedEncounterName )
	end

end

--------------------------------------------------------------------------------

function CMapRoom:OnNextRoomSelected_2020( szSelectedRoomName )

	self.szExitRoomSelected = szSelectedRoomName
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
	
function CMapRoom:OnNextRoomSelected_2021( szSelectedRoomName, szSelectedEncounterName )
	print( "OnNextRoomSelected_2021: Room: " .. szSelectedRoomName  )
	if szSelectedEncounterName == nil then
		return
	end

	-- Record the event room length.
	if self:GetEncounter():GetEncounterType() == ROOM_TYPE_EVENT then
		GameRules.Aghanim:RegisterEncounterComplete( self:GetEncounter(), GameRules:GetGameTime() - self:GetEncounter():GetStartTime() )
	end


	print( "OnNextRoomSelected_2021: Encounter: " .. szSelectedEncounterName )
	self.szExitRoomSelected = szSelectedRoomName

	-- Register the room selection
	local roomSelectionStats = 
	{
		depth = self:GetDepth() + 1
	}

	local ExitRoom = GameRules.Aghanim:GetRoom( self.szExitRoomSelected )
	if ExitRoom == nil then
		print( "exit room is nil" )
		return
	end

	if szSelectedRoomName == "hub" then 
		ExitRoom:GetEncounter():ResetHeroState()
		ExitRoom:GetEncounter():UpdateAct()
		print( "Exit Room is hub.. don't spawn things." ) 
		for nPlayerID = 0,AGHANIM_PLAYERS-1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero then
				hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_return_to_hub", { duration = 6.1 } )
			end

		end

		return 
	end

	-- Must set the map name prior to getting the neighboring room height difference
	local EncounterData = ENCOUNTER_DEFINITIONS[ szSelectedEncounterName ]
	if EncounterData == nil then 
		print( "ERROR: Encounter " .. szSelectedEncounterName .. " has no data in room_tables" )
		return
	end

	local mapList = EncounterData.szMapNames
	local szMapName = nil 
	if mapList then
	  	szMapName = mapList[ self:RoomRandomInt( 1, #mapList ) ]
	else
		print( "Warning: Encounter " .. szSelectedEncounterName .. " has no maps listed in data, falling back to template map" )
		szMapName = MAP_ATLAS[ szSelectedRoomName ].szTemplateMap
	end

	if szMapName == nil then 
		print( "Error! szMapName is nil for " .. szSelectedRoomName .. ": " .. szSelectedEncounterName )
		return
	end

	if #ExitRoom.vecPotentialEncounters > 0 and ExitRoom:GetEncounter() == nil then 
		local hPendingEncounter = nil 
		for _,hEncounter in pairs ( ExitRoom.vecPotentialEncounters ) do 
			if hEncounter then
				if hEncounter.szEncounterName == szSelectedEncounterName then 
					hPendingEncounter = hEncounter 
				else
					-- record unselected encounter stats, have to do this before encounter is assigned.
					roomSelectionStats.unselectedRoom = ExitRoom:ComputeRoomStats_Unselected( hEncounter )
				end
			end
		end

		if hPendingEncounter then 
			ExitRoom:AssignPendingEncounter( hPendingEncounter )
		else 
			ExitRoom:AssignEncounter( szSelectedEncounterName )
		end
	end

	local hNextEncounter = ExitRoom:GetEncounter()
	if hNextEncounter then 
		if hNextEncounter:IsEliteEncounter() then 
			ExitRoom:SetEliteDepthBonus( 1 )
		end
		ExitRoom.nRoomType = hNextEncounter:GetEncounterType()
		ExitRoom:SendRoomToClient()
	else
		print( "ERROR! Exit Room " .. ExitRoom:GetName() .. " could not find its encounter!" )
	end

	-- Record stats
	roomSelectionStats.selectedRoom = ExitRoom:ComputeRoomStats()

	if ExitRoom:GetEncounter().nEncounterType ~= ROOM_TYPE_EVENT then
		GameRules.Aghanim:RegisterEncounterStats( roomSelectionStats )
	end


	ExitRoom.szMapName = szMapName
	local szDirName = "aghs2_encounters/"
	local szNewMapNameShort = string.sub( szMapName, string.len( szDirName ) + 1, string.len( szMapName ) )
	if self.szMapName == nil then 
		self.szMapName = "none" 
		print ( "WARNING! Room " .. self:GetName() .. " had no map name assigned?" )
	end
	local szCurMapNameShort = string.sub( self.szMapName, string.len( szDirName ) + 1, string.len( self.szMapName ) )
	local flNewMapHeightOffset = MAP_ENTRANCE_HEIGHTS[ szNewMapNameShort ]
	local flCurMapHeightOffset = MAP_EXIT_HEIGHTS[ szCurMapNameShort ]
	if flNewMapHeightOffset == nil then 
		flNewMapHeightOffset = 0
	end

	if flCurMapHeightOffset == nil then 
		flCurMapHeightOffset = 0
	end  

	print( "ThisRoom z:" .. self.vOrigin.z )
	print( "ExitRoom z:" .. ExitRoom.vOrigin.z )

	local flOriginalZ = ExitRoom.vOrigin.z

	ExitRoom.vOrigin.z = self.vOrigin.z + flNewMapHeightOffset - flCurMapHeightOffset

	print( "flSpawnHeight " .. ExitRoom.vOrigin.z )
	if ExitRoom.nRoomType == ROOM_TYPE_EVENT then 
		--print( "attempting to spawn event door prefab" ) 
		local vSpawnLoc = Vector( ExitRoom.vOrigin.x, ExitRoom.vOrigin.y, ExitRoom.vOrigin.z )
		vSpawnLoc.z = ExitRoom.vOrigin.z - flNewMapHeightOffset + 128.0
		local szPrefabName = "prefabs/event_exits/" .. ExitRoom:GetName() .. "_exit"
		print( "Spawning room event prefab " .. szPrefabName .." at ( " .. vSpawnLoc.x .. ", " .. vSpawnLoc.y .. ", " .. vSpawnLoc.z .. " )" )
		ExitRoom.hEventPrefabSpawnGroupHandle = DOTA_SpawnMapAtPosition( szPrefabName, vSpawnLoc, false, nil, Dynamic_Wrap( CMapRoom, "OnEventExitPrefabSpawnComplete" ), ExitRoom )
	end

	print( "Spawning room " .. szSelectedRoomName .. " with encounter " .. szSelectedEncounterName .. " on map " .. szMapName .. " at ( " .. ExitRoom.vOrigin.x .. ", " .. ExitRoom.vOrigin.y .. ", " .. ExitRoom.vOrigin.z .. " )" )
	ExitRoom.hSpawnGroupHandle = DOTA_SpawnMapAtPosition( szMapName, ExitRoom.vOrigin, false, nil, Dynamic_Wrap( CMapRoom, "OnSpawnRoomComplete" ), ExitRoom )
	
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

	if GetMapName() == "hub" then
		if self.nRoomType == ROOM_TYPE_EVENT and self.OnEventRoomComplete ~= nil then 
			self:OnEventRoomComplete()
		end
	end
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

function CMapRoom:SetRoomEncounterReward( szEncounterName, szReward )
	if self.vecPotentialEncounters == nil or #self.vecPotentialEncounters == 0 or szEncounterName == "encounter_hub" then 
		return
	end

	for _,hEncounter in pairs ( self.vecPotentialEncounters ) do
		if hEncounter:GetName() == szEncounterName and hEncounter.szRoomChoiceReward == nil then 
			hEncounter.szRoomChoiceReward = szReward 
			print( "Room " .. self:GetName() .. " has been assigned " .. szReward .. " for encounter " .. szEncounterName )
			break
		end
	end
end

--------------------------------------------------------------------------------

function CMapRoom:GetPotentialEncounterRoomReward( szEncounterName )
	if self.Encounter and self.Encounter:GetName() == szEncounterName then 
		return self.Encounter.szRoomChoiceReward
	end

	if self.vecPotentialEncounters == nil or #self.vecPotentialEncounters == 0 or szEncounterName == "encounter_hub" then 
		return "REWARD_TYPE_NONE"
	end

	for _,hEncounter in pairs ( self.vecPotentialEncounters ) do
		if hEncounter:GetName() == szEncounterName then 
			if hEncounter.szRoomChoiceReward == nil then 
				return "REWARD_TYPE_NONE"
			end
			return hEncounter.szRoomChoiceReward
		end
	end

	return "REWARD_TYPE_NONE"
end

--------------------------------------------------------------------------------

function CMapRoom:GetRoomChoiceReward()
	if GetMapName() == "main" then 
		return self.szRoomChoiceReward
	end

	local szReward = "REWARD_TYPE_NONE"
	if self.Encounter ~= nil then 
		szReward = self:GetPotentialEncounterRoomReward( self.Encounter:GetName() )
		if szReward == nil then 
			print( "No Reward found for encounter " .. self.Encounter:GetName() )
			szReward = "REWARD_TYPE_NONE"
		end
	end

	--print ( "GetRoomChoiceReward() " .. self:GetName() .. " " .. szReward )
	return szReward
end

--------------------------------------------------------------------------------

function CMapRoom:SendRoomToClient()
	if self:GetAct() == nil then 
		print( "CMapRoom:GetAct() is nil!" )
		return
	end

	if GameRules.Aghanim:GetCurrentRoom() == nil then 
		print( "GameRules.Aghanim:GetCurrentRoom() is nil!" )
		return 
	end

	 if GameRules.Aghanim:GetCurrentRoom():GetAct() == nil then
		print( "GameRules.Aghanim:GetCurrentRoom():GetAct() is nil!" )
		return 
	end

	local netTable = {}
	netTable[ "room_name" ] = self:GetName()
	if GameRules.Aghanim:GetCurrentRoom() and self:GetAct() <= GameRules.Aghanim:GetCurrentRoom():GetAct() then
		netTable[ "reward" ] = self:GetRoomChoiceReward()				
		netTable[ "map_name" ] = self:GetMapName()
		netTable[ "room_type" ] = self:GetType()
		netTable[ "depth" ] = self:GetDepth()
		netTable[ "entrance_direction" ] = self:GetPlayerEntranceDirection()
		netTable[ "exit_direction" ] = self:GetPlayerChosenExitDirection()

		netTable[ "completed" ] = 0
		if self:GetEncounter() and self:GetEncounter():IsComplete() then
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

function CMapRoom:GetMinimapOriginX()
	return self.flMinimapOriginX
end

--------------------------------------------------------------------------------

function CMapRoom:GetMinimapOriginX()
	return self.flMinimapOriginX
end

--------------------------------------------------------------------------------

function CMapRoom:GetMinimapOriginY()
	return self.flMinimapOriginY
end

--------------------------------------------------------------------------------

function CMapRoom:GetMinimapSize()
	return self.flMinimapSize
end

--------------------------------------------------------------------------------

function CMapRoom:GetMinimapScale()
	return self.nMinimapScale
end

--------------------------------------------------------------------------------

function CMapRoom:GetMinimapMapName()
	return self.szMinimapMapName
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

function CMapRoom:GetRoomRandomStream()
	return self.hRandomStream 
end

--------------------------------------------------------------------------------

function CMapRoom:RoomRandomInt( nMinInt, nMaxInt )
	return self.hRandomStream:RandomInt( nMinInt, nMaxInt )
end

--------------------------------------------------------------------------------

function CMapRoom:RoomRandomFloat( flMin, flMin )
	return self.hRandomStream:RandomFloat( flMin, flMin )
end
