if CCavernHUDRoshan == nil then
	CCavernHUDRoshan = class({})
end

--------------------------------------------------------------------

function CCavernHUDRoshan:constructor( Room )
	self.nCurDepth = 0
	self.bImpendingWarningForDepth = false
	self.bImminentWarningForDepth = false
	self.RoomsToDestroy = {}
	self.hRoshan = CreateUnitByName( "npc_dota_cavern_roshan", Room:GetAntechamberCenter(), true, nil, nil, DOTA_TEAM_BADGUYS )
	self.hRoshan:AddEffects( EF_NODRAW )
end

--------------------------------------------------------------------

function CCavernHUDRoshan:SetNextMove()
	self.bImpendingWarningForDepth = false
	self.bImminentWarningForDepth = false
	self.RoomsToDestroy = {}
	self.flNextRingDestroyGameTime = GameRules:GetGameTime() + CAVERN_ROSHAN_HUD_RING_DESTROY_INTERVAL
	self.flNextImpendingWarnTime = self.flNextRingDestroyGameTime - CAVERN_ROSHAN_HUD_RING_DESTROY_IMPENDING_WARNING_TIME
	self.flNextImminentWarnTime = self.flNextRingDestroyGameTime - CAVERN_ROSHAN_HUD_RING_DESTROY_IMMINENT_WARNING_TIME
	self.nCurDepth = self.nCurDepth + 1
	if self.nCurDepth == 5 then
		return
	end
	--print( "set next move to destroy rooms of depth " .. self.nCurDepth )
	for _,Room in pairs( GameRules.Cavern.Rooms ) do
		if Room:GetDepth() == self.nCurDepth then
			--print( "Adding room to destroy " .. Room:GetRoomID() )
			table.insert( self.RoomsToDestroy, Room )
		end
	end
end

--------------------------------------------------------------------

function CCavernHUDRoshan:WarnOfImpendingMove()
	--print( "WarnOfImpendingMove" )
	if self.bImpendingWarningForDepth == false then
		local gameEvent = {}
		gameEvent["int_value"] = CAVERN_ROSHAN_HUD_RING_DESTROY_IMPENDING_WARNING_TIME
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#Cavern_RoshanMoving"
		FireGameEvent( "dota_combat_event_message", gameEvent )


		for _,Room in pairs ( self.RoomsToDestroy ) do
			Room:SetupRoshanPreview()
			local fShakeAmt = 15
			local fShakeDuration = 1
			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( Room:GetRoomCenter(), fShakeAmt, 100.0, fShakeDuration, 500.0, 0, true )
			for nCurTeam = DOTA_TEAM_CUSTOM_1,( DOTA_TEAM_CUSTOM_1 + CAVERN_TEAMS_PER_GAME - 1 ) do
				EmitAnnouncerSoundForTeamOnLocation( "RoshanDT.Beg", nCurTeam, Room:GetRoomCenter() )
			end
		end
		self.bImpendingWarningForDepth = true
	end
end

--------------------------------------------------------------------

function CCavernHUDRoshan:WarnOfImminentMove()
	--print( "WarnOfImpendingMove" )
	if self.bImminentWarningForDepth == false then
		local gameEvent = {}
		gameEvent["int_value"] = CAVERN_ROSHAN_HUD_RING_DESTROY_IMMINENT_WARNING_TIME
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#Cavern_RoshanMoving"
		FireGameEvent( "dota_combat_event_message", gameEvent )

		for _,Room in pairs ( self.RoomsToDestroy ) do
			Room:BeginDestructionFX()
			local fShakeAmt = 30
			local fShakeDuration = CAVERN_ROSHAN_HUD_RING_DESTROY_IMMINENT_WARNING_TIME
			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( Room:GetRoomCenter(), fShakeAmt, 100.0, fShakeDuration, 900.0, 0, true )
			for nCurTeam = DOTA_TEAM_CUSTOM_1,( DOTA_TEAM_CUSTOM_1 + CAVERN_TEAMS_PER_GAME - 1 ) do
				EmitAnnouncerSoundForTeamOnLocation( "RoshanDT.Death2", nCurTeam, Room:GetRoomCenter() )
			end
		end
		self.bImminentWarningForDepth = true
	end
end

--------------------------------------------------------------------

function CCavernHUDRoshan:DestroyRooms()
	--print( "DestroyRooms" )

	local gameEvent = {}
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#Cavern_RoshanMoveBegin"
	FireGameEvent( "dota_combat_event_message", gameEvent )

	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsRealHero() and Hero:IsTempestDouble() == false then
			local fShakeAmt = 50
			local fShakeDuration = 2
			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( Hero:GetOrigin(), fShakeAmt, 100.0, fShakeDuration, 500.0, 0, true )
			EmitSoundOnClient( "RoshanDT.Death2", Hero:GetPlayerOwner() )
		end
	end

	for _,Room in pairs ( self.RoomsToDestroy ) do
		Room:SetDestroyedByRoshan( true )
	end

	self:SetNextMove()
end

--------------------------------------------------------------------

function CCavernHUDRoshan:RoshanThink()
	if self.nCurDepth == 5 then
		return
	end

	if self.nCurDepth == 0 then
		self:SetNextMove()
	end

	local now = GameRules:GetGameTime()
	local netTable = {}
	netTable["rosh_next_move_time"] = math.max( 0, tonumber( self.flNextRingDestroyGameTime - GameRules:GetGameTime() ) )
	netTable["rosh_next_move_direction"] = 0
	netTable["rosh_currently_moving"] = 0	

	if now > self.flNextImpendingWarnTime and now < self.flNextRingDestroyGameTime then	
		netTable["rosh_currently_moving"] = 1	
		if self.bImpendingWarningForDepth == false then
			self:WarnOfImpendingMove()
		end
	end

	if now > self.flNextImminentWarnTime and now < self.flNextRingDestroyGameTime then	
		netTable["rosh_currently_moving"] = 1	
		if self.bImminentWarningForDepth == false then
			self:WarnOfImminentMove()
		end
	end

	CustomNetTables:SetTableValue( "rosh_tracker", string.format( "%d", 0 ), netTable )

	if now > self.flNextRingDestroyGameTime then
		self:DestroyRooms()
	end
end

--------------------------------------------------------------------