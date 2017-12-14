function Spawn(entityKeyValues)
	thisEntity.aiState = {}

    Timers:CreateTimer(.1,function()
	-- Generate nearby waypoints for this unit
    local tWaypoints = {}
    local nWaypointsPerRoamNode = 6
    local nMinWaypointSearchDistance = 200
    local nMaxWaypointSearchDistance = 600

    while #tWaypoints < nWaypointsPerRoamNode do
    	local vWaypoint = thisEntity:GetAbsOrigin() + RandomVector( RandomFloat( nMinWaypointSearchDistance, nMaxWaypointSearchDistance ) )
    	if GridNav:CanFindPath( thisEntity:GetAbsOrigin(), vWaypoint ) then
    		table.insert( tWaypoints, vWaypoint )
    	end
    end
    thisEntity.aiState.tWaypoints = tWaypoints

	Timers:CreateTimer(0,
      function()
        return thisEntity:AIThink()
      end)
    end)
end

function thisEntity:AIThink()
    if self:IsNull() then return end
	if not self:IsAlive() then
    	return
    end
	if GameRules:IsGamePaused() then
		return 0.1
	end
	
	return self:RoamBetweenWaypoints()
end

function thisEntity:RoamBetweenWaypoints()
	local gameTime = GameRules:GetGameTime()
	local aiState = self.aiState
	if aiState.vWaypoint ~= nil then
		local flRoamTimeLeft = aiState.flNextWaypointTime - gameTime
		if flRoamTimeLeft <= 0 then
			aiState.vWaypoint = nil
		end
	end
    if aiState.vWaypoint == nil then
        aiState.vWaypoint = aiState.tWaypoints[ RandomInt( 1, #aiState.tWaypoints ) ]
        aiState.flNextWaypointTime = gameTime + RandomFloat( 2, 4 )
    	self:MoveToPosition( aiState.vWaypoint )
    end
   	return RandomFloat( 0.5, 1.0 )
end