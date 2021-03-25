require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_AttackStackTarget == nil then
	CDotaNPXTask_AttackStackTarget = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackStackTarget:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
	self.bPrecacheDone = false

	PrecacheUnitByNameAsync( hTaskInfo.TaskParams.EntityName, function ( sg ) 
		self.bPrecacheDone = true
	end, -1 )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackStackTarget:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self.hTaskInfo.TaskParams.SpawnPos, true )
 	end
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackStackTarget:CheckTaskStart()
	local bResult = true
	if CDotaNPXTask.CheckTaskStart ~= nil then
		bResult = CDotaNPXTask:CheckTaskStart()
	end
	print( "Precache done? " .. tostring( self.bPrecacheDone ) )
	return ( bResult and self.bPrecacheDone )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackStackTarget:StartTask()
	CDotaNPXTask.StartTask( self )
	local nTeam = DOTA_TEAM_BADGUYS
	if self.hTaskInfo.TaskParams.Team ~= nil then
		if self.hTaskInfo.TaskParams.Team == "DOTA_TEAM_NEUTRALS" then
			nTeam = DOTA_TEAM_NEUTRALS
		elseif self.hTaskInfo.TaskParams.Team == "DOTA_TEAM_GOODGUYS" then
			nTeam = DOTA_TEAM_GOODGUYS
		end
	end
	-- Creating Neutral Creep
	self.hUnit = CreateUnitByName( self.hTaskInfo.TaskParams.EntityName, self.hTaskInfo.TaskParams.SpawnPos, true, nil, nil, nTeam )
	if self.hTaskInfo.TaskParams.SpawnAngles ~= nil then
		self.hUnit:SetAbsAngles( self.hTaskInfo.TaskParams.SpawnAngles[1], self.hTaskInfo.TaskParams.SpawnAngles[2], self.hTaskInfo.TaskParams.SpawnAngles[3] )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackStackTarget:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackStackTarget:OnThink()
	CDotaNPXTask.OnThink( self )
	local targetUnits = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, self.hTaskInfo.TaskParams.SpawnPos, self.hUnit, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
	if #targetUnits > 0 then
		for _,target in pairs( targetUnits ) do
			if target:GetUnitName() == self.hTaskInfo.TaskParams.EntityName then
				if target:GetAggroTarget() == self:GetScenario():GetPlayerHero() then
					self:CompleteTask( true )
				end
			end
		end
	end
end

----------------------------------

function CDotaNPXTask_AttackStackTarget:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	if self:UseHints() then
 		self:GetScenario():HintLocation( self.hTaskInfo.TaskParams.SpawnPos, false )
 	end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_AttackStackTarget