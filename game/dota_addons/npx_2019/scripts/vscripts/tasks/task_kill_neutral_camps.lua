require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_KillNeutralCamps == nil then
	CDotaNPXTask_KillNeutralCamps = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_KillNeutralCamps:RegisterTaskEvent()
	self.szCamps = self.hTaskInfo.TaskParams.CampNames
	self.nProgress = 0
	self.nGoal = #self.szCamps
	self:OnTaskProgress()
	self.nTaskListener = ListenToGameEvent( "dota_neutral_creep_camp_cleared", Dynamic_Wrap( CDotaNPXTask_KillNeutralCamps, "OnNeutralCreepCampCleared" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_KillNeutralCamps:OnNeutralCreepCampCleared( event )
	if event.killer_player_id == 0 then
		for k,v in pairs( self.szCamps ) do
			if v == event.camp_name then
				table.remove( self.szCamps, k )
				self.nProgress = self.nProgress + 1
				self:OnTaskProgress()
			end
		end

		if #self.szCamps == 0 then
			self:CompleteTask()
		end
	end
end


----------------------------------------------------------------------------

return CDotaNPXTask_KillNeutralCamps