if CCavernRoom == nil then
	CCavernRoom = class({})
end

require( "cavern_gate" )
require( "cavern_encounters_table" )
require( "tables/cavern_tree_model_names" )

--------------------------------------------------------------------

function CCavernRoom:constructor( nRoomID, nRoomType, hRoomVolume )
	if hRoomVolume == nil then
		print( "CCavernRoom:constructor - ERROR - hRoomVolume is nil" )
		return
	end

	self.nRoomID  = nRoomID
	self.nRoomType = nRoomType
	self.hRoomVolume = hRoomVolume
	self.vRoomCenter = hRoomVolume:GetOrigin()

	self.hAntechamberVolume = nil
	self.vAntechamberCenter = nil
	self.AntechamberGate = nil
	--print( "Generating Paths for Room " .. nRoomID )
	self.nRoomX = nRoomID % CAVERN_GRID_WIDTH
	if self.nRoomX == 0 then
		self.nRoomX = CAVERN_GRID_WIDTH
	end
	self.nRoomY = math.ceil( nRoomID / CAVERN_GRID_HEIGHT )
	--print( "( " .. self.nRoomX .. ", " .. self.nRoomY .. " )" )	

	--print( string.format( "nRoomID: %d, self.vRoomCenter: %s", nRoomID, self.vRoomCenter ) )

	self.bPathsGenerated = false

	self.NorthPath = CAVERN_PATH_TYPE_INVALID
	self.SouthPath = CAVERN_PATH_TYPE_INVALID
	self.EastPath = CAVERN_PATH_TYPE_INVALID
	self.WestPath = CAVERN_PATH_TYPE_INVALID

	self.NorthNeighbor = nil
	self.SouthNeighbor = nil
	self.EastNeighbor = nil
	self.WestNeighbor = nil

	self.vExtent = self.hRoomVolume:GetBoundingMaxs() - self.hRoomVolume:GetBoundingMins()
	self.vHalfX = Vector( self.vExtent.x / 2.0, 0, 0 )
	self.vHalfY = Vector( 0, self.vExtent.y / 2.0, 0 )

	self.NorthGate = CCavernGate.GetGateFromPosition( self.vRoomCenter + self.vHalfY )
	self.SouthGate = CCavernGate.GetGateFromPosition( self.vRoomCenter - self.vHalfY )
	
	self.EastGate = CCavernGate.GetGateFromPosition( self.vRoomCenter + self.vHalfX )
	self.WestGate = CCavernGate.GetGateFromPosition( self.vRoomCenter - self.vHalfX )

	self.szSelectedEncounterName = nil
	self.ActiveEncounter = nil

	self.nTeamSpawnedInThisRoom = nil
	self.nTeamInitialCombatRoom = nil
	self.nRoomLevel = CAVERN_ROOM_DIFFICULTY_INVALID

	self.hWarnDummy = nil
	self.bDestroyedByRoshan = false

	self.NeighborSigns = {}
	self.PlayerHeroesPresent = {}
	
end

--------------------------------------------------------------------

function CCavernRoom:GetRoomID()
	return self.nRoomID
end

--------------------------------------------------------------------

function CCavernRoom:IsRoomAdjacentToMapCenter()
	for _, nRoomID in pairs( CAVERN_ROOMS_ADJACENT_TO_MAP_CENTER ) do
		if self.nRoomID == nRoomID then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------

function CCavernRoom:SetRoomType( nRoomType )
 	self.nRoomType = nRoomType
end

--------------------------------------------------------------------

function CCavernRoom:SetRoomXY( x, y )
	self.nRoomX = x
	self.nRoomY = y
end

--------------------------------------------------------------------

function CCavernRoom:GetRoomX()
	return self.nRoomX 
end

--------------------------------------------------------------------

function CCavernRoom:GetRoomY()
	return self.nRoomY
end


function CCavernRoom:GetDepth()
	local x,y = self:GetRoomX(),self:GetRoomY()
	-- NOTE this math only works if the room width/height are odd
	x,y = math.abs(x-(CAVERN_GRID_WIDTH+1)/2),math.abs(y-(CAVERN_GRID_HEIGHT+1)/2)
	local nDepth = math.floor(4 - math.max(x,y)) + 1
	return nDepth
end
--------------------------------------------------------------------

function CCavernRoom:GetGateByDirection( nDirection )
	if nDirection == CAVERN_PATH_DIR_NORTH then
		return self.NorthGate
	elseif nDirection == CAVERN_PATH_DIR_SOUTH then
		return self.SouthGate
	elseif nDirection == CAVERN_PATH_DIR_EAST then
		return self.EastGate
	elseif nDirection == CAVERN_PATH_DIR_WEST then
		return self.WestGate
	end
end

--------------------------------------------------------------------

function CCavernRoom:IsValidSpawnRoom()
	if CAVERN_PLAYER_SPAWN_SYMMETRY == true then
		if self:IsValidRoshanSpawnRoom()then
			return false
		end
		return self:GetRoomY() == 1
	end
	--return ( self:GetRoomX() <= 2 or self:GetRoomX() >= ( CAVERN_GRID_WIDTH - 1 ) or self:GetRoomY() <= 2 or self:GetRoomY() >= ( CAVERN_GRID_HEIGHT - 1 ) )
	return ( self:GetRoomX() <= 1 or self:GetRoomX() >= ( CAVERN_GRID_WIDTH ) or self:GetRoomY() <= 1 or self:GetRoomY() >= ( CAVERN_GRID_HEIGHT ) )
end

--------------------------------------------------------------------

function CCavernRoom:IsValidRoshanSpawnRoom()
	return ( ( self:GetRoomX() == 1 or self:GetRoomX() == CAVERN_GRID_WIDTH ) and ( self:GetRoomY() == 1 or self:GetRoomY() == CAVERN_GRID_HEIGHT ) )
end

--------------------------------------------------------------------

function CCavernRoom:IsValidCheeseSpawnRoom()
	return ( ( self:GetRoomX() == ( CAVERN_GRID_WIDTH / 2 ) or self:GetRoomX() == ( ( CAVERN_GRID_WIDTH / 2 ) + 1 ) ) and  ( self:GetRoomY() == ( CAVERN_GRID_HEIGHT / 2 ) or self:GetRoomY() == ( ( CAVERN_GRID_HEIGHT / 2 ) + 1 ) ) )
end

--------------------------------------------------------------------

function CCavernRoom:CreateWarningParticle( )
	self.nWarningFX = ParticleManager:CreateParticle( "particles/roshan_room_warninggoal.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( self.nWarningFX, 0, self:GetRoomCenter() )
end


--------------------------------------------------------------------

function CCavernRoom:SetupRoshanPreview()
	--print( "SetupRoshanPreview" )
	self:CreateWarningParticle()
	self.hWarnDummy = CreateUnitByName(  tostring( "npc_dota_room_destroyed_dummy" .. RandomInt( 1, 3 ) ), self:GetRoomCenter(), false, nil, nil, DOTA_TEAM_BADGUYS )
	if self.hWarnDummy ~= nil then
		self.hWarnDummy:AddNewModifier( RoomDestroyedDummy, nil, "modifier_not_on_minimap", {} )
	end

	if self.hWarnDummy ~= nil then
		for nTeam=DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_1+CAVERN_TEAMS_PER_GAME-1 do
			MinimapEvent( nTeam, self.hWarnDummy, self:GetRoomCenter().x, self:GetRoomCenter().y, DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK, CAVERN_ROSHAN_HUD_RING_DESTROY_IMPENDING_WARNING_TIME - CAVERN_ROSHAN_HUD_RING_DESTROY_IMMINENT_WARNING_TIME )
		end
	end
end

--------------------------------------------------------------------

function CCavernRoom:BeginDestructionFX()
	local vecRadius = Vector( 900, 900, 900 )
	if self.nFXDestroyIndex == nil then
		self.nFXDestroyIndex = ParticleManager:CreateParticle( "particles/npx_landslide_debris.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXDestroyIndex, 0, self:GetRoomCenter() )
	end

	if self.hWarnDummy ~= nil then
		for nTeam=DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_1+CAVERN_TEAMS_PER_GAME-1 do
			MinimapEvent( nTeam, self.hWarnDummy, self:GetRoomCenter().x, self:GetRoomCenter().y, DOTA_MINIMAP_EVENT_RADAR_TARGET, CAVERN_ROSHAN_HUD_RING_DESTROY_IMMINENT_WARNING_TIME )
		end
	end
end

--------------------------------------------------------------------

function CCavernRoom:SetDestroyedByRoshan( bDestroyed )
	self.bDestroyedByRoshan = bDestroyed
	if self.bDestroyedByRoshan == true then
	
		self:SetRoomType( CAVERN_ROOM_TYPE_DESTROYED )

		local nLevel = 1
		local fShakeAmt = 15
		local fShakeDuration = 0.75

		ScreenShake( self:GetRoomCenter(), fShakeAmt, 100.0, fShakeDuration, 1300.0, 0, true )

		for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
			local Gate = self:GetGateByDirection( nDir )
			if Gate ~= nil then
				EmitSoundOn( "Gate.Destroy", Gate )
				local nFXIndex = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl( nFXIndex, 0, Gate:GetPositionOfGate() )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 400, 400, 400 ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			--	Gate:SetPath( self, self:GetNeighboringRoom( nDir ), CAVERN_PATH_TYPE_BLOCKED )
			end
		end

		for _,Hero in pairs ( self.PlayerHeroesPresent ) do
			if Hero ~= nil and Hero:IsNull() == false then
				Hero:AddNewModifier( Hero, nil, "modifier_room_destruction", {} )
			end
		end

		if self.ActiveEncounter ~= nil then		
			self.ActiveEncounter:Cleanup()
		end

		if self.nWarningFX ~= nil then
			ParticleManager:DestroyParticle( self.nWarningFX, true )
		end
		
		if CAVERN_ROSHAN_AS_HUD_ELEMENT == false then
			local szDummyName = tostring( "npc_dota_room_destroyed_dummy" .. RandomInt( 1, 3 ) )
			local RoomDestroyedDummy = CreateUnitByName( szDummyName, self:GetRoomCenter(), false, nil, nil, DOTA_TEAM_BADGUYS )
			RoomDestroyedDummy:AddNewModifier( RoomDestroyedDummy, nil, "modifier_provides_fow_position", {} )
			RoomDestroyedDummy:AddNewModifier( RoomDestroyedDummy, nil, "modifier_force_draw_minimap", {} ) 
		else
			if self.hWarnDummy ~= nil then
				self.hWarnDummy:RemoveModifierByName( "modifier_not_on_minimap" )
				self.hWarnDummy:AddNewModifier( self.hWarnDummy, nil, "modifier_provides_fow_position", {} )
				self.hWarnDummy:AddNewModifier( self.hWarnDummy, nil, "modifier_force_draw_minimap", {} ) 
			end
		end

		if self.vAntechamberCenter ~= nil then
			local szDummyName = tostring( "npc_dota_room_destroyed_dummy" .. RandomInt( 1, 3 ) )
			local AnteDestroyedDummy = CreateUnitByName( szDummyName, self.vAntechamberCenter, false, nil, nil, DOTA_TEAM_BADGUYS )
			AnteDestroyedDummy:AddNewModifier( AnteDestroyedDummy, nil, "modifier_provides_fow_position", {} )
			AnteDestroyedDummy:AddNewModifier( AnteDestroyedDummy, nil, "modifier_force_draw_minimap", {} ) 
		end	
	end
end

--------------------------------------------------------------------

function CCavernRoom:IsDestroyedByRoshan()
	return self.bDestroyedByRoshan
end

--------------------------------------------------------------------

function CCavernRoom:CreateNeighborSigns( bClear )

	local hNeighbors = { self.WestNeighbor, self.EastNeighbor, self.SouthNeighbor, self.NorthNeighbor }
	local hOffsets = { -0.77*self.vHalfX, 0.82*self.vHalfX, -0.72*self.vHalfY, 0.72*self.vHalfY }
	-- useful if we want to have the orientation change with direction
	--local hFacing = { Vector(0,1,0), Vector(0,-1,0), Vector(-1,0,0), Vector(1,0,0) }

	local hParticleSystems = {}
	hParticleSystems[CAVERN_ROOM_TYPE_MOB] = "particles/room_sign_mobs.vpcf"
	hParticleSystems[CAVERN_ROOM_TYPE_TRAP]  = "particles/room_sign_trap.vpcf"
	hParticleSystems[CAVERN_ROOM_TYPE_TREASURE]  = "particles/room_sign_treasure.vpcf"
	hParticleSystems[CAVERN_ROOM_TYPE_TEAM_SPAWN] = "particles/room_sign_unknown.vpcf"
	hParticleSystems[CAVERN_ROOM_TYPE_SPECIAL] = "particles/room_sign_unknown.vpcf"
	local hBorderParticleSystems = { 
		"particles/room_sign_border_1.vpcf",
		"particles/room_sign_border_2.vpcf",
		"particles/room_sign_border_3.vpcf",
		"particles/room_sign_border_4.vpcf",
		"particles/room_sign_border_5.vpcf",
	}

	for nKey,hOffset in pairs(hOffsets) do	

		if bClear and self.NeighborSigns[nKey] then
			ParticleManager:DestroyParticle(self.NeighborSigns[nKey][1], true)
			ParticleManager:DestroyParticle(self.NeighborSigns[nKey][2], true)
		end

		if bClear or (not self.NeighborSigns[nKey]) then

			if hNeighbors[nKey] then
				local nRoomType = hNeighbors[nKey]:GetRoomType()
				local szParticleSystem = hParticleSystems[nRoomType]
				local szBorderParticleSystem = hBorderParticleSystems[hNeighbors[nKey]:GetRoomLevel()]

				if szParticleSystem and szBorderParticleSystem then
					--printf("creating sign for room type %d named %s at %s %s", nRoomType, szParticleSystem, nKey, hOffset)
					local hContentParticle = ParticleManager:CreateParticle( szParticleSystem, PATTACH_CUSTOMORIGIN, nil )
					local vPos = GetGroundPosition( self.vRoomCenter + hOffset, self.hRoomVolume )
					ParticleManager:SetParticleControl( hContentParticle, 0, vPos)
					ParticleManager:SetParticleShouldCheckFoW( hContentParticle, false )
					--ParticleManager:SetParticleControlForward( self.NeighborSigns[nKey], 0, hFacing[nKey] )
					local hBorderParticle = ParticleManager:CreateParticle( szBorderParticleSystem, PATTACH_CUSTOMORIGIN, nil )
					local vPos = GetGroundPosition( self.vRoomCenter + hOffset, self.hRoomVolume )
					ParticleManager:SetParticleControl( hBorderParticle, 0, vPos)
					ParticleManager:SetParticleShouldCheckFoW( hBorderParticle, false )
					self.NeighborSigns[nKey] = { hContentParticle, hBorderParticle }
				end

			end

		end
	end

end

--------------------------------------------------------------------

function CCavernRoom:GetRoomType()
	return self.nRoomType
end

--------------------------------------------------------------------

function CCavernRoom:SetRoomLevel( nRoomLevel )
	self.nRoomLevel = nRoomLevel
end


--------------------------------------------------------------------

function CCavernRoom:GetRoomLevel()
	return self.nRoomLevel
end

--------------------------------------------------------------------

function CCavernRoom:SetEncounter( szEncounterName, nLevel )
	if szEncounterName ~= nil then
		if self.ActiveEncounter ~= nil then
			self.ActiveEncounter:Cleanup()
			--self.ActiveEncounter:Reset()
			self.ActiveEncounter = nil
		end

		self.szSelectedEncounterName = szEncounterName

		self.ActiveEncounter = _G[self.szSelectedEncounterName](self)
		--print( "SetEncounter completed" )
		return
	end
end

--------------------------------------------------------------------

function CCavernRoom:GenerateDoodads()
	if self.ActiveEncounter ~= nil then
		self.ActiveEncounter:GenerateDoodads()
	end
end

--------------------------------------------------------------------

function CCavernRoom:StartEncounter()
	if self:IsDestroyedByRoshan() == true then
		return
	end
	
	if self.ActiveEncounter ~= nil and self:HasEncounterStarted() == false and self:IsEncounterCleared() == false and self.ActiveEncounter:Start() then
	--	printf( "Starting encounter \"%s\" in Room %d", self.szSelectedEncounterName, self.nRoomID )	
		self.ActiveEncounter:OnStartComplete()
	else
		--print ( "ERROR - Encounter named " .. self.szSelectedEncounterName .. " failed to start!" )
		if self.ActiveEncounter == nil then
		--	print ( "ActiveEncounter was nil" )
		elseif self.ActiveEncounter ~= nil and self.ActiveEncounter:IsCleared() == true then
		--	print ( "ActiveEncounter was already cleared" )
		end
		
	end
end

--------------------------------------------------------------------

function CCavernRoom:HasEncounterStarted()
	return self.ActiveEncounter ~= nil and self.ActiveEncounter.bActive
end

--------------------------------------------------------------------

function CCavernRoom:GetEncounter()
	return self.ActiveEncounter
end

--------------------------------------------------------------------

function CCavernRoom:IsEncounterCleared()
	if self.ActiveEncounter == nil then
		return false
	end

	return self.ActiveEncounter:IsCleared()
end

--------------------------------------------------------------------

function CCavernRoom:GetSelectedEncounterName()
	return self.szSelectedEncounterName
end

--------------------------------------------------------------------

function CCavernRoom:GetRoomVolume()
	return self.hRoomVolume
end

--------------------------------------------------------------------

function CCavernRoom:GetRoomCenter()
	return self.vRoomCenter
end

--------------------------------------------------------------------

function CCavernRoom:SetAntechamberVolume( hVolume )
	self.hAntechamberVolume = hVolume
	self.vAntechamberCenter = self.hAntechamberVolume:GetOrigin()
	local flMinDist = 999999
	for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		local Gate = self:GetGateByDirection( nDir )
		if Gate ~= nil then
			local flGateDist = ( Gate:GetPositionOfGate() - self.vAntechamberCenter ):Length2D()
			if flGateDist < flMinDist then
				flMinDist = flGateDist
				self.AntechamberGate = Gate
				self.AntechamberPathDir = nDir
			end
		end
	end
end

--------------------------------------------------------------------

function CCavernRoom:GetAntechamberVolume()
	return self.hAntechamberVolume
end

--------------------------------------------------------------------

function CCavernRoom:GetAntechamberCenter()
	return self.vAntechamberCenter
end

--------------------------------------------------------------------

function CCavernRoom:GetAntechamberPathDirection()
	return self.AntechamberPathDir
end

--------------------------------------------------------------------

function CCavernRoom:OpenAntechamber()
	if PlayerResource:GetPlayerCountForTeam( self.nTeamSpawnedInThisRoom ) == 0 then
		return
	end

	if self.AntechamberGate ~= nil then
		self.AntechamberGate:SetPath( self, nil, CAVERN_PATH_TYPE_OPEN )
		--self:StartEncounter()
	end
end

--------------------------------------------------------------------

function CCavernRoom:CloseAntechamber()
	if self.AntechamberGate ~= nil then
		self.AntechamberGate:SetPath( self, nil, CAVERN_PATH_TYPE_BLOCKED )
	end
end

--------------------------------------------------------------------

function CCavernRoom:SetPathsGenerated( bGenerated )
	self.bPathsGenerated = bGenerated
end

--------------------------------------------------------------------

function CCavernRoom:ArePathsGenerated()
	return self.bPathsGenerated 
end

--------------------------------------------------------------------

function CCavernRoom:SetPath( nDirection, nPathType )
	if nDirection == CAVERN_PATH_DIR_NORTH then
		--print( "Room " .. self:GetRoomID() .. ": Setting North Path to type " .. GameRules.Cavern:GetStringForRoomDebugPathType( nPathType ) )
		self.NorthPath = nPathType
		self.NorthGate:SetPath( self, self.NorthNeighbor, self.NorthPath )
	end
	if nDirection == CAVERN_PATH_DIR_SOUTH then
		--print( "Room " .. self:GetRoomID() .. ": Setting South Path to type " .. GameRules.Cavern:GetStringForRoomDebugPathType( nPathType ) )
		self.SouthPath = nPathType
		self.SouthGate:SetPath( self, self.SouthNeighbor, self.SouthPath )
	end
	if nDirection == CAVERN_PATH_DIR_EAST then
		--print( "Room " .. self:GetRoomID() .. ": Setting East Path to type " .. GameRules.Cavern:GetStringForRoomDebugPathType( nPathType ) )
		self.EastPath = nPathType
		self.EastGate:SetPath ( self, self.EastNeighbor,  self.EastPath )
	end
	if nDirection == CAVERN_PATH_DIR_WEST then
		--print( "Room " .. self:GetRoomID() .. ": Setting West Path to type " .. GameRules.Cavern:GetStringForRoomDebugPathType( nPathType ) )
		self.WestPath = nPathType
		self.WestGate:SetPath ( self, self.WestNeighbor,  self.WestPath )
	end
end

--------------------------------------------------------------------

function CCavernRoom:GetPath( nDirection )
	if nDirection == CAVERN_PATH_DIR_NORTH then
		return self.NorthPath
	end
	if nDirection == CAVERN_PATH_DIR_SOUTH then
		return self.SouthPath
	end
	if nDirection == CAVERN_PATH_DIR_EAST then
		return self.EastPath
	end
	if nDirection == CAVERN_PATH_DIR_WEST then
		return self.WestPath
	end

	return CAVERN_PATH_TYPE_INVALID
end

--------------------------------------------------------------------

function CCavernRoom:SetNeighboringRoom( nDirection, Room )
	if nDirection == CAVERN_PATH_DIR_NORTH then
		self.NorthNeighbor = Room
	end
	if nDirection == CAVERN_PATH_DIR_SOUTH then
		self.SouthNeighbor = Room
	end
	if nDirection == CAVERN_PATH_DIR_EAST then
		self.EastNeighbor = Room
	end
	if nDirection == CAVERN_PATH_DIR_WEST then
		self.WestNeighbor = Room
	end
end

--------------------------------------------------------------------

function CCavernRoom:GetNeighboringRoom( nDirection )
	if nDirection == CAVERN_PATH_DIR_NORTH then
		return self.NorthNeighbor
	end
	if nDirection == CAVERN_PATH_DIR_SOUTH then
		return self.SouthNeighbor
	end
	if nDirection == CAVERN_PATH_DIR_EAST then
		return self.EastNeighbor
	end
	if nDirection == CAVERN_PATH_DIR_WEST then
		return self.WestNeighbor
	end

	return nil
end

--------------------------------------------------------------------

function CCavernRoom:StartEncountersInNeighboringRooms()
	for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
		local Neighbor = self:GetNeighboringRoom( nDir )
		if Neighbor ~= nil and Neighbor:HasEncounterStarted() == false then
			local bSpawnEncounter = true
			if CAVERN_ENCOUNTER_SPAWN_MODE == CAVERN_ENCOUNTER_SPAWN_PATHABILITY and self:GetPath( nDir ) ~= CAVERN_PATH_TYPE_OPEN then
				bSpawnEncounter = false
				--print( "not spawning encounter" )
			end
			if bSpawnEncounter == true then
				Neighbor:StartEncounter()
			end	
		end	
	end
end

--------------------------------------------------------------------

function CCavernRoom:StopEncountersInNeighboringRooms()
--	print( "Stopping encounters for neighbors of room " .. self:GetRoomID() )
	local InitialNeighboringRooms = { self.NorthNeighbor, self.SouthNeighbor, self.WestNeighbor, self.EastNeighbor }
	for _,InitialNeighbor in pairs( InitialNeighboringRooms ) do
		local bStopEncounter = true
		if InitialNeighbor ~= nil and #InitialNeighbor.PlayerHeroesPresent == 0 then
			local SecondaryNeighboringRooms = { InitialNeighbor.NorthNeighbor, InitialNeighbor.SouthNeighbor, InitialNeighbor.WestNeighbor, InitialNeighbor.EastNeighbor }
			for _,SecondNeighbor in pairs( SecondaryNeighboringRooms ) do
				if SecondNeighbor ~= nil then 
				--	print( "Room " .. SecondNeighbor:GetRoomID() .. " has " .. #SecondNeighbor.PlayerHeroesPresent .. " heroes present" )
					if #SecondNeighbor.PlayerHeroesPresent > 0 then
						bStopEncounter = false
					--	print( "Room " .. SecondNeighbor:GetRoomID() .. " is not empty" )
					end
					
				end
			end
			if bStopEncounter and InitialNeighbor.ActiveEncounter ~= nil then
				if InitialNeighbor.ActiveEncounter:IsCleared() == false then
					--print( "All neighbors have no players, stopping encounter in room " .. InitialNeighbor:GetRoomID()  )
					InitialNeighbor.ActiveEncounter:Cleanup()
					InitialNeighbor.ActiveEncounter = nil
				end
			end
		end
	end
end

--------------------------------------------------------------------

function CCavernRoom:GetTeamSpawnInRoom()
	return self.nTeamSpawnedInThisRoom
end

--------------------------------------------------------------------

function CCavernRoom:SetTeamInitialCombatRoom( nTeam )
	self.nTeamInitialCombatRoom = nTeam
end

--------------------------------------------------------------------

function CCavernRoom:GetTeamInitialCombatRoom()
	return self.nTeamInitialCombatRoom
end

--------------------------------------------------------------------

function CCavernRoom:SetTeamSpawnInRoom( nTeam )
	self.nTeamSpawnedInThisRoom = nTeam
	self.nTeamInitialCombatRoom = nTeam
	self:SetRoomType( CAVERN_ROOM_TYPE_MOB )
	self:SetRoomLevel( 1 )
	
	local hAntechamberShop = CreateUnitByName( "npc_dota_cavern_shop", self:GetAntechamberCenter(), true, nil, nil, DOTA_TEAM_NEUTRALS )
	if hAntechamberShop ~= nil then
	 	hAntechamberShop:SetAbsOrigin( GetGroundPosition( self:GetAntechamberCenter(), hAntechamberShop ) )
	 	hAntechamberShop:SetShopType( DOTA_SHOP_HOME )
	 	local Trigger = SpawnDOTAShopTriggerRadiusApproximate( hAntechamberShop:GetOrigin(), CAVERN_SHOP_RADIUS )
	 	if Trigger then
	 		Trigger:SetShopType( DOTA_SHOP_HOME )
	 	end

	 	GameRules.Cavern:CreateShopOverheadParticle( hAntechamberShop )
	end
end

--------------------------------------------------------------------

function CCavern:CreateShopOverheadParticle( hShop )
	if IsServer() then
		assert( hShop ~= nil, "ERROR: CCavern:CreateShopOverheadParticle - hShop is nil" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/shop/shop_indicator_goal.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, hShop:GetAbsOrigin() + Vector( 0, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------
