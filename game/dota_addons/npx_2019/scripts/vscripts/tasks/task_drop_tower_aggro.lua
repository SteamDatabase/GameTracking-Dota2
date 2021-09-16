require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_DropTowerAggro == nil then
	CDotaNPXTask_DropTowerAggro = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_DropTowerAggro:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
end

----------------------------------------------------------------------------

function CDotaNPXTask_DropTowerAggro:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
 	self.bIsActive = true
 	self.hHero = self:GetScenario():GetPlayerHero()
end

----------------------------------------------------------------------------

function CDotaNPXTask_DropTowerAggro:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_DropTowerAggro:OnThink()
	CDotaNPXTask.OnThink( self )
	local targetUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.hHero:GetAbsOrigin(), self.hUnit, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #targetUnits > 0 then
		for _,target in pairs( targetUnits ) do
			if target:GetUnitName() == self.hTaskInfo.TaskParams.TowerName then
				if target:GetAggroTarget() ~= self.hHero then
					--print( "Drop Aggro Task Complete" )
					self:CompleteTask( true )
				end
			end
		end
	end
end

----------------------------------

function CDotaNPXTask_DropTowerAggro:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_DropTowerAggro