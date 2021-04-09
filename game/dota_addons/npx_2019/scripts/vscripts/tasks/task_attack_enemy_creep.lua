require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_AttackEnemyCreep == nil then
	CDotaNPXTask_AttackEnemyCreep = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyCreep:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyCreep:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
 	self.hHero = self:GetScenario():GetPlayerHero()
 	self.nTaskListener = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CDotaNPXTask_AttackEnemyCreep, "OnCreepHurt" ), self )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyCreep:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackEnemyCreep:OnCreepHurt( event )
	hAttacker = EntIndexToHScript( event.entindex_attacker )
	if hAttacker == self.hHero then
		self:CompleteTask( true )
	end
end

----------------------------------

function CDotaNPXTask_AttackEnemyCreep:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_AttackEnemyCreep