require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_AttackEnemyTower == nil then
	CDotaNPXTask_AttackEnemyTower = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyTower:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyTower:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self.hTaskInfo.TaskParams.AttackPos, true )
 	end
 	self.bIsActive = true
 	self.hHero = self:GetScenario():GetPlayerHero()
 	self.nTaskListener = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CDotaNPXTask_AttackEnemyTower, "OnTowerHurt" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyTower:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyTower:OnTowerHurt( event )
	hAttacker = EntIndexToHScript( event.entindex_attacker )
	hVictim = EntIndexToHScript( event.entindex_killed )
	if hAttacker == self.hHero then
		print( "Hero attacking" )
		if hVictim:GetUnitName() == self.hTaskInfo.TaskParams.TowerName then
			print( "Hero Attacked Tower")
			self:CompleteTask( true )
		end
	end
end

----------------------------------

function CDotaNPXTask_AttackEnemyTower:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self.hTaskInfo.TaskParams.AttackPos, false )
 	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_AttackEnemyTower