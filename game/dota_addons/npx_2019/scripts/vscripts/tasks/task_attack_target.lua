require( "npx_task" ) 

----------------------------------------------------------------------------

if CDotaNPXTask_AttackTarget == nil then
	CDotaNPXTask_AttackTarget = class( {}, {}, CDotaNPXTask )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackTarget:constructor( hTaskInfo, hScenario )
	CDotaNPXTask.constructor( self, hTaskInfo, hScenario )
	self.bIsActive = false
	self.bPrecacheDone = false

	PrecacheUnitByNameAsync( hTaskInfo.TaskParams.EntityName, function ( sg ) 
		self.bPrecacheDone = true
	end, -1 )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackTarget:RegisterTaskEvent()
	CDotaNPXTask.RegisterTaskEvent( self )
	--if self:UseHints() then
 	--	self:GetScenario():HintLocation( self:GetGoalLocation(), true )
 	--end
 	self.bIsActive = true
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackTarget:CheckTaskStart()
	local bResult = true
	if CDotaNPXTask.CheckTaskStart ~= nil then
		bResult = CDotaNPXTask:CheckTaskStart()
	end
	print( "Precache done? " .. tostring( self.bPrecacheDone ) )
	return ( bResult and self.bPrecacheDone )
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackTarget:StartTask()
	CDotaNPXTask.StartTask( self )
	local nTeam = DOTA_TEAM_BADGUYS
	if self.hTaskInfo.TaskParams.Team ~= nil then
		if self.hTaskInfo.TaskParams.Team == "DOTA_TEAM_NEUTRALS" then
			nTeam = DOTA_TEAM_NEUTRALS
		elseif self.hTaskInfo.TaskParams.Team == "DOTA_TEAM_GOODGUYS" then
			nTeam = DOTA_TEAM_GOODGUYS
		end
	end
	self.hUnit = CreateUnitByName( self.hTaskInfo.TaskParams.EntityName, self.hTaskInfo.TaskParams.SpawnPos, true, nil, nil, nTeam )
	if self.hTaskInfo.TaskParams.SpawnAngles ~= nil then
		self.hUnit:SetAbsAngles( self.hTaskInfo.TaskParams.SpawnAngles[1], self.hTaskInfo.TaskParams.SpawnAngles[2], self.hTaskInfo.TaskParams.SpawnAngles[3] )
	end
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackTarget:IsActive()
	return self.bIsActive
end

----------------------------------------------------------------------------

function CDotaNPXTask_AttackTarget:OnThink()
	CDotaNPXTask.OnThink( self )
	if self.hUnit ~= nil and not self.hUnit:IsAlive() then
		self:CompleteTask( true )
	end
end

----------------------------------

function CDotaNPXTask_AttackTarget:UnregisterTaskEvent()
	CDotaNPXTask.UnregisterTaskEvent( self )
	--if self:UseHints() then
 	--	self:GetScenario():HintLocation( self:GetGoalLocation(), false )
 	--end
 	self.bIsActive = false
end

----------------------------------------------------------------------------

return CDotaNPXTask_AttackTarget