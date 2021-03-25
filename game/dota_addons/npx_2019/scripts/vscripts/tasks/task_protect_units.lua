require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_ProtectUnits == nil then
	CDotaNPXTask_ProtectUnits = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_ProtectUnits:StartTask()
	if self.hUnits == nil then
		print( "ERROR - Cannot start task protect_units without setting the units!" )
		return
	end

	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_ProtectUnits:SetUnitsToProtect( hUnits )
	self.hUnits = {}
	for  k,v in pairs( hUnits ) do
		self.hUnits[k] = v
		if v then
			print( v:GetUnitName() )
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_ProtectUnits:AddUnitsToProtect( hUnits )
	if self.hUnits == nil then
		self.hUnits = {}
	end

	for k,v in pairs( hUnits ) do
		table.insert( self.hUnits, v )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_ProtectUnits:RegisterTaskEvent()
	for _,Unit in pairs ( self.hUnits ) do
		self:GetScenario():HintNPC( Unit )
	end

	if self.hTaskInfo and self.hTaskInfo.TaskParams then
		self.szFailureString = self.hTaskInfo.TaskParams.FailureString
	end

	self.nTaskListener = ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDotaNPXTask_ProtectUnits, "OnEntityKilled" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXTask_ProtectUnits:OnEntityKilled( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end
	
	if hVictim then
		for i=#self.hUnits,1,-1 do 
			local hUnit = self.hUnits[i]
			if hUnit:entindex() == hVictim:entindex() then
				if self.szFailureString then
					self:CompleteTask( false, false, self.szFailureString )
				else
					self:CompleteTask( false, false, "task_fail_protect_units" )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

return CDotaNPXTask_ProtectUnits