require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_ChaseUnits == nil then
	CDotaNPXTask_ChaseUnits = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_ChaseUnits:StartTask()
	if self.hUnits == nil then
		print( "ERROR - Cannot start task chase_units without setting the units!" )
		return
	end
	for _,unit in pairs(self.hUnits) do
		unit.nShouldRunAway = true		
	end
	CDotaNPXTask.StartTask( self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_ChaseUnits:SetUnitsToChase( hUnits )
	self.hUnits = hUnits
end

----------------------------------------------------------------------------

function CDotaNPXTask_ChaseUnits:RegisterTaskEvent()	
	self.nTaskListener = ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDotaNPXTask_ChaseUnits, "OnEntityKilled" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXTask_ChaseUnits:OnEntityKilled( event )
	local hVictim = nil  
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end
	if hVictim then
		for i=#self.hUnits,1,-1 do 
			local hUnit = self.hUnits[i]			
			if hUnit:entindex() == hVictim:entindex() then
				table.remove( self.hUnits, i )			
			else 
				if not hUnit:IsAlive() then
					table.remove( self.hUnits, i )
				end
			end
		end

		if #self.hUnits == 0 then
			self:CompleteTask()
		end
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_ChaseUnits:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
end

----------------------------------------------------------------------------

return CDotaNPXTask_ChaseUnits