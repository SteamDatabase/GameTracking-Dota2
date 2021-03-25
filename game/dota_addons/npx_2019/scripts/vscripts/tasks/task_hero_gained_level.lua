require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_HeroGainedLevel == nil then
	CDotaNPXTask_HeroGainedLevel = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_HeroGainedLevel:StartTask()
	CDotaNPXTask.StartTask( self )

	if self.hScenario.hPlayerHero:GetLevel() == self.hTaskInfo.TaskParams.Level then
		self:CompleteTask()
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_HeroGainedLevel:RegisterTaskEvent()
	self.nLevel = self.hTaskInfo.TaskParams.Level
	self.nTaskListener = ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CDotaNPXTask_HeroGainedLevel, "OnHeroGainedLevel" ), self )
end

--------------------------------------------------------------------------------

function CDotaNPXTask_HeroGainedLevel:OnHeroGainedLevel( event )
	if event.player_id == 0 and event.level == self.nLevel then
		self:CompleteTask()
	end
end

----------------------------------------------------------------------------

return CDotaNPXTask_HeroGainedLevel