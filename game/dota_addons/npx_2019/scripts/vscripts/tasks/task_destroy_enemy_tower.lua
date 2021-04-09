require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_DestroyEnemyTower == nil then
	CDotaNPXTask_DestroyEnemyTower = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_DestroyEnemyTower:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_DestroyEnemyTower:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
 	self.hHero = self:GetScenario():GetPlayerHero()
 	self.nTaskListener = ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDotaNPXTask_DestroyEnemyTower, "OnEntityKilled" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_DestroyEnemyTower:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_DestroyEnemyTower:OnEntityKilled( event )
	hVictim = EntIndexToHScript( event.entindex_killed )
	if hVictim:GetUnitName() == self.hTaskInfo.TaskParams.TowerName then
		self:CompleteTask( true )
	else
		--print( hVictim:GetUnitName() )
	end
end

----------------------------------

function CDotaNPXTask_DestroyEnemyTower:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_DestroyEnemyTower