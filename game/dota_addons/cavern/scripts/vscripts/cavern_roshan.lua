
if CCavernRoshan == nil then
	CCavernRoshan = class({})
end

--------------------------------------------------------------------

function CCavernRoshan:constructor( Room )
	self.CurrentRoom = Room
	self.hRoshan = nil

	print( "Roshan will spawn in Room: " .. Room:GetRoomID() )

	self.nNextMoveDir = nil
	self.flNextMoveTime = CAVERN_ROSHAN_SPAWN_DELAY + CAVERN_ROSHAN_ROW_DESTROY_MAX_TIME
	self.flCurrMoveInterval = CAVERN_ROSHAN_ROW_DESTROY_MAX_TIME
	self.bMoveWarned = false
	self.TargetRoom = nil
	self.nNextWarnRoomIdx = nil
	self.bMoveInProgress = false
	self.bInAnteChamber = true
end

--------------------------------------------------------------------

function CCavernRoshan:CreateRoshan()
	self.hRoshan = CreateUnitByName( "npc_dota_cavern_roshan", self.CurrentRoom:GetAntechamberCenter(), true, nil, nil, DOTA_TEAM_BADGUYS )
	self.hRoshan:AddNewModifier( self.hRoshan, nil, "modifier_provides_fow_position", {} )
	self.hRoshan:AddNewModifier( self.hRoshan, nil, "modifier_force_draw_minimap", {} ) 
	self.hRoshan:SetShouldDoFlyHeightVisual( false )
	self.hRoshan:MoveToPositionAggressive( self.CurrentRoom:GetAntechamberCenter() )

	self:SetNextMove()
end

--------------------------------------------------------------------

function CCavernRoshan:SelectNewDirection( Room, nOldDir )
	local PossibleDirections = {}
	for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
	 	local TestRoom = Room:GetNeighboringRoom( nDir )
	 	if TestRoom ~= nil and TestRoom:IsDestroyedByRoshan() == false and nDir ~= nOldDir and nDir ~= CAVERN_PATH_OPPOSITES[nOldDir] then
	 		table.insert( PossibleDirections, nDir )
	 	end
	end

	return PossibleDirections[ RandomInt( 1, #PossibleDirections ) ]	
end

--------------------------------------------------------------------

function CCavernRoshan:SetNextMove()
	self.flNextMoveTime = GameRules:GetGameTime() + self.flCurrMoveInterval
	self.bMoveWarned = false

	local gameEvent = {}
	gameEvent["int_value"] = tonumber( self.flCurrMoveInterval )
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#Cavern_RoshanMoving"
	FireGameEvent( "dota_combat_event_message", gameEvent )
	
	--print( "In " .. self.flNextMoveTime - GameRules:GetGameTime() .. " seconds, Roshan will move " .. GameRules.Cavern:GetStringForDirection( self.nNextMoveDir )  )

	self.flCurrMoveInterval = math.max( CAVERN_ROSHAN_ROW_DESTROY_MIN_TIME, self.flCurrMoveInterval - CAVERN_ROSHAN_ROW_DESTROY_INTERVAL_REDUCTION )
	self.RoomsToDestroy = {}

	table.insert( self.RoomsToDestroy, self.CurrentRoom )

	if self.nNextMoveDir == nil then
		self.nNextMoveDir = self:SelectNewDirection( self.CurrentRoom, self.nNextMoveDir )
	else
		local TestRoom = self.CurrentRoom:GetNeighboringRoom( self.nNextMoveDir )
		if TestRoom == nil or TestRoom:IsDestroyedByRoshan() then
			self.nNextMoveDir = self:SelectNewDirection( self.CurrentRoom, self.nNextMoveDir )
		end
	end

	local Dirs = { CAVERN_PATH_DIR_NORTH, CAVERN_PATH_DIR_SOUTH, CAVERN_PATH_DIR_WEST, CAVERN_PATH_DIR_EAST }
	local nCurDir = self.nNextMoveDir
	while #Dirs > 0 do
		local OriginRoom = self.RoomsToDestroy[#self.RoomsToDestroy]
		self:CollectRoomsToDestroyInDirection( OriginRoom, nCurDir )
		for i=1,#Dirs do
			if Dirs[i] == nCurDir then
				table.remove( Dirs, i )
			end
		end
		nCurDir = self:SelectNewDirection( OriginRoom, nCurDir )
	end
	
	self.nNextWarnRoomIdx = 1
	self.TargetRoom = self.RoomsToDestroy[1]
	--print( "TargetRoomID = " .. self.TargetRoom:GetRoomID() )
	self.hRoshan:FaceTowards( self.TargetRoom:GetRoomCenter() )
end

--------------------------------------------------------------------

function CCavernRoshan:WarnOfImpendingMove()
	local gameEvent = {}
	gameEvent["int_value"] = 30
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#Cavern_RoshanMoving"
	FireGameEvent( "dota_combat_event_message", gameEvent )
	

	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsRealHero() and Hero:IsTempestDouble() == false then
			local fShakeAmt = 15
			local fShakeDuration = 1
			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( Hero:GetOrigin(), fShakeAmt, 100.0, fShakeDuration, 500.0, 0, true )
			EmitSoundOnClient( "RoshanDT.Beg", Hero:GetPlayerOwner() )
		end
	end

	for _,Room in pairs ( self.RoomsToDestroy ) do
		Room:CreateWarningParticle()
	end

	self.bMoveWarned = true
end

--------------------------------------------------------------------

function CCavernRoshan:BeginMove()
	--print( "Roshan move is beginning" )
	self.bMoveInProgress = true
	local gameEvent = {}
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#Cavern_RoshanMoveBegin"
	FireGameEvent( "dota_combat_event_message", gameEvent )

	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsRealHero() and Hero:IsTempestDouble() == false then
			local fShakeAmt = 5
			local fShakeDuration = 1
			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( Hero:GetOrigin(), fShakeAmt, 100.0, fShakeDuration, 500.0, 0, true )
			EmitSoundOnClient( "RoshanDT.Death2", Hero:GetPlayerOwner() )
		end
	end
end


--------------------------------------------------------------------

function CCavernRoshan:CollectRoomsToDestroyInDirection( Room, nDir ) 
	local TestRoom = Room:GetNeighboringRoom( nDir )
	while TestRoom ~= nil and TestRoom:IsDestroyedByRoshan() == false do
		--print( "Testing room to destroy: " .. TestRoom:GetRoomID() )
		local bFound = false
		for _,Room in pairs ( self.RoomsToDestroy ) do
			if Room == TestRoom then
				bFound = true
			end
		end
		if not bFound then
			--print( "Adding room to destroy: " .. TestRoom:GetRoomID() )
			table.insert( self.RoomsToDestroy, TestRoom )
		end
		TestRoom = TestRoom:GetNeighboringRoom( nDir )
	end
end

--------------------------------------------------------------------

function CCavernRoshan:DestroyRoom( Room )
	if Room:IsDestroyedByRoshan() == false then
		if RandomInt( 0, 1 ) == 1 then
			EmitSoundOn( "RoshanDT.Scream", self.hRoshan )
		else
			EmitSoundOn( "RoshanDT.Scream2", self.hRoshan )
		end
		Room:SetRoomType( CAVERN_ROOM_TYPE_ROSHAN )
		Room:SetDestroyedByRoshan( true )

		for i=#self.RoomsToDestroy,1,-1 do
			local TestRoom = self.RoomsToDestroy[i]
			if TestRoom ~= nil and TestRoom == Room then
				table.remove( self.RoomsToDestroy, i )
			end
		end
	end
end

--------------------------------------------------------------------

function CCavernRoshan:MoveIntoNextRoom()
	local OldRoom = self.CurrentRoom
	self.CurrentRoom = GameRules.Cavern:FindClosestRoom( self.hRoshan:GetOrigin() )
	local bUpdateMove = self.CurrentRoom == self.TargetRoom
	if self.bInAnteChamber then
		local flDistToInitialRoom = ( self.hRoshan:GetOrigin() - self.TargetRoom:GetRoomCenter() ):Length2D()
		if flDistToInitialRoom > 250 then
			bUpdateMove = false
		end
	end
	if bUpdateMove then
		if #self.RoomsToDestroy > 1 then
			self:DestroyRoom( OldRoom )
			self.TargetRoom = self.RoomsToDestroy[1]
			--print( "Updating target room to Room ID: " .. self.TargetRoom:GetRoomID() )
			--print( "There are " .. #self.RoomsToDestroy .. " rooms remaining to destroy this move." )
			for nDir=CAVERN_PATH_DIR_NORTH,CAVERN_PATH_DIR_WEST do
				local NeighborRoom = self.CurrentRoom:GetNeighboringRoom( nDir )
				if NeighborRoom ~= nil and NeighborRoom == self.TargetRoom then
					self.nNextMoveDir = nDir
				end
			end
		else
			self.bMoveInProgress = false
			self:SetNextMove()

			if self.nFXindex ~= nil then
				ParticleManager:DestroyParticle( self.nFXindex, true )
				self.nFXindex = nil
			end
		end	
		self.bInAnteChamber = false	
		--GameRules.Cavern:PrintRoomDebugGrid()
	else
		self.hRoshan:MoveToPosition( self.TargetRoom:GetRoomCenter() )
		local fShakeAmt = 15
		local fShakeDuration = 0.75
		--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
		ScreenShake( self.hRoshan:GetOrigin(), fShakeAmt, 100.0, fShakeDuration, 1300.0, 0, true )

		local vecRadius = Vector( 900, 900, 900 )
		if self.nFXindex == nil then
			self.nFXindex = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( self.nFXindex, 1, vecRadius )
		end
		
		ParticleManager:SetParticleControl( self.nFXindex, 0, self.hRoshan:GetAbsOrigin() )
	end
end

--------------------------------------------------------------------

function CCavernRoshan:RoshanThink()
	local now = GameRules:GetGameTime()
	if now < CAVERN_ROSHAN_UNKNOWN_EARLY_GAME_TIME then
		return
	end

	local netTable = {}
	local nMoveDir = self.nNextMoveDir
	if self.bInAnteChamber and self.TargetRoom ~= nil then
		nMoveDir = CAVERN_PATH_OPPOSITES[ self.TargetRoom:GetAntechamberPathDirection() ]
	--	print( nMoveDir )
	end
	netTable["rosh_next_move_time"] = math.max( 0, tonumber( self.flNextMoveTime - GameRules:GetGameTime() ) )
	netTable["rosh_next_move_direction"] = nMoveDir
	if self.bMoveInProgress == true then
		netTable["rosh_currently_moving"] = 1	
	else
		netTable["rosh_currently_moving"] = 0
	end
	CustomNetTables:SetTableValue( "rosh_tracker", string.format( "%d", 0 ), netTable )

	if now > CAVERN_ROSHAN_SPAWN_DELAY and self.hRoshan == nil then
		self:CreateRoshan()
	end

	if self.hRoshan == nil then
		return
	end


	if self.bMoveInProgress then
		if self.TargetRoom ~= nil then
			for nTeam=DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_1+CAVERN_TEAMS_PER_GAME-1 do
				MinimapEvent( nTeam, self.hRoshan, self.TargetRoom:GetRoomCenter().x, self.TargetRoom:GetRoomCenter().y, DOTA_MINIMAP_EVENT_RADAR_TARGET, 5.0 )
			end
		end
		self:MoveIntoNextRoom()
		return
	else
		local WarnRoom = self.RoomsToDestroy[self.nNextWarnRoomIdx]
		if WarnRoom ~= nil then
			for nTeam=DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_1+CAVERN_TEAMS_PER_GAME-1 do
				MinimapEvent( nTeam, self.hRoshan, WarnRoom:GetRoomCenter().x, WarnRoom:GetRoomCenter().y, DOTA_MINIMAP_EVENT_ENEMY_TELEPORTING, 5.0 )
			end
			self.nNextWarnRoomIdx = self.nNextWarnRoomIdx + 1
			if self.nNextWarnRoomIdx > #self.RoomsToDestroy then
				self.nNextWarnRoomIdx = 1
			end
		end

		if self.CurrentRoom then
			local vPos = self.CurrentRoom:GetRoomCenter()
			if self.bInAnteChamber then
				vPos = self.CurrentRoom:GetAntechamberCenter()
			end
			local flDist = ( self.hRoshan:GetAbsOrigin() - vPos ):Length2D()
			if flDist > 600 then
				--print( "Roshan ordered to move, no move in progress." )
				self.hRoshan:MoveToPosition( vPos )
			end
		end	
	end

	local flTimeLeft = self.flNextMoveTime - now 
	if flTimeLeft < 31 and self.bMoveWarned == false then
		self:WarnOfImpendingMove()
	end

	if now >= self.flNextMoveTime then
		self:BeginMove()		
	end
end