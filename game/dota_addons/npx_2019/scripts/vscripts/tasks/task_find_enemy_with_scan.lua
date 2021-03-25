require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_FindEnemyWithScan == nil then
	CDotaNPXTask_FindEnemyWithScan = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_FindEnemyWithScan:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )

	print( "CDotaNPXTask_FindEnemyWithScan:RegisterTaskEvent" )

	self:AddListener( ListenToGameEvent( "dota_scan_found_enemy", Dynamic_Wrap( CDotaNPXTask_FindEnemyWithScan, "OnScanFoundEnemy" ), self ) )
end

--------------------------------------------------------------------------------

function CDotaNPXTask_FindEnemyWithScan:OnScanFoundEnemy( event )
	print( "OnScanFoundEnemy" )
	PrintTable( event )

	if self.hScenario.hPlayerHero:GetTeamNumber() == event.teamnumber then
		self:CompleteTask( true )
	end
end

--------------------------------------------------------------------------------

return CDotaNPXTask_FindEnemyWithScan