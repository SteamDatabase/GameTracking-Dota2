require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_SelectUnit == nil then
	CDotaNPXTask_SelectUnit = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_SelectUnit:RegisterTaskEvent()
	self.szUnitName = self.hTaskInfo.TaskParams.UnitName
	self.nPlayerID = 0
	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_SelectUnit:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_SelectUnit:OnThink()
	CDotaNPXTask.OnThink(self)
	print( PlayerResource:GetSelectedHeroEntity( self.nPlayerID ) )
	local playerHero = self:GetScenario():GetPlayerHero()
	local targetUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, playerHero:GetOrigin(), playerHero, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #targetUnits > 0 then
		for _,target in pairs( targetUnits ) do
			if target:GetUnitName() == self.hTaskInfo.TaskParams.UnitName then
				self.hUnit = target
				print( self.hUnit )
			end
		end
	end
	if PlayerResource:GetSelectedHeroEntity( self.nPlayerID ) == self.hUnit then
		self:CompleteTask( true )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_SelectUnit:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_SelectUnit