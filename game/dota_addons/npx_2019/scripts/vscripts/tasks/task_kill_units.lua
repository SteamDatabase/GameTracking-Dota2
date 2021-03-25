require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_KillUnits == nil then
	CDotaNPXTask_KillUnits = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_KillUnits:StartTask()
	if self.hUnits == nil then
		print( "ERROR - Cannot start task kill_units without setting the units!" )
		return
	end

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_KillUnits:SetUnitsToKill( hUnits )
	self.hUnits = {}

	for k,v in pairs( hUnits ) do
		self.hUnits[k] = v
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_KillUnits:AddUnitsToKill( hUnits )
	if self.hUnits == nil then
		self.hUnits = {}
	end

	for k,v in pairs( hUnits ) do
		table.insert( self.hUnits, v )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_KillUnits:RegisterTaskEvent()
	for _,Unit in pairs ( self.hUnits ) do
		self:GetScenario():HintNPC( Unit )
	end

	self.nProgress = 0
	self.nGoal = #self.hUnits

	if  self.hTaskInfo.TaskParams.RequiredKills ~= nil and #self.hUnits < self.hTaskInfo.TaskParams.RequiredKills then
		print( "ERROR - Cannot register task event kill_units without with more required kills than there is units!" )
		return
	end

	if self.hTaskInfo.TaskParams.RequiredKills == nil then
		self.nRemainingAlive = 0
	else 
		self.nRemainingAlive = #self.hUnits - self.hTaskInfo.TaskParams.RequiredKills
	end
	self.bMustBeExactKills = false
	if self.hTaskInfo.TaskParams.MustBeExactKills  ~= nil then
		self.bMustBeExactKills = self.hTaskInfo.TaskParams.MustBeExactKills
	end
	self.nTaskListener = ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDotaNPXTask_KillUnits, "OnEntityKilled" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXTask_KillUnits:OnEntityKilled( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end
	
	if hVictim then
		for i=#self.hUnits,1,-1 do 
			local hUnit = self.hUnits[i]
			if hUnit:entindex() == hVictim:entindex() then
				self:GetScenario():EndHintNPC( hVictim:entindex() )
				table.remove( self.hUnits, i )
				print( 'CDotaNPXTask_KillUnits - progress updated ' .. self.nProgress .. ' updating to ' .. self.nProgress+1 )
				self.nProgress = self.nProgress + 1
				self:OnTaskProgress()
			end
		end

		if #self.hUnits == self.nRemainingAlive and not self.bMustBeExactKills then
			self:CompleteTask( true )
		end
	end
end

--------------------------------------------------------------------------------

function CDotaNPXTask_KillUnits:OnThink()
	if self.nTaskListener == -1 or not self:IsActive() then
		return
	end

	if self.hUnits == nil then
		return
	end
	
	
	if #self.hUnits == self.nRemainingAlive then
		self:CompleteTask( true )
	elseif #self.hUnits < self.nRemainingAlive and self.bMustBeExactKills then
		self.CompleteTask( false )
		return -1
	end
end


return CDotaNPXTask_KillUnits