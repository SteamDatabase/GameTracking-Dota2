EXPORTS = {}

EXPORTS.Init = function( self )
	-- Defer the initialization to first tick, to allow spawners to set state.
	self.aiState = {
		hAggroTarget = nil,
		flShoutRange = 300,
		nWalkingMoveSpeed = 140,
		nAggroMoveSpeed = 280,
		flAcquisitionRange = 600,
		vTargetWaypoint = nil,
	}
	self:SetContextThink( "init_think", function() 
		self.aiThink = aiThink
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ShoutInRadius = ShoutInRadius
		self.RoamBetweenWaypoints = RoamBetweenWaypoints
        self:SetAcquisitionRange( self.aiState.flAcquisitionRange )
        self.bIsRoaring = false

	    -- Generate nearby waypoints for this unit
	    local tWaypoints = {}
	    local nWaypointsPerRoamNode = 10
	    local nMinWaypointSearchDistance = 0
	    local nMaxWaypointSearchDistance = 2048

	    while #tWaypoints < nWaypointsPerRoamNode do
	    	local vWaypoint = self:GetAbsOrigin() + RandomVector( RandomFloat( nMinWaypointSearchDistance, nMaxWaypointSearchDistance ) )
	    	if GridNav:CanFindPath( self:GetAbsOrigin(), vWaypoint ) then
	    		table.insert( tWaypoints, vWaypoint )
	    	end
	    end
	    self.aiState.tWaypoints = tWaypoints
	    self:SetContextThink( "ai_base_creature.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end


function aiThink( self )
    if not self:IsAlive() then
    	return
    end
	if GameRules:IsGamePaused() then
		return 0.1
	end
	if self:CheckIfHasAggro() then
		return RandomFloat( 0.5, 1.5 )
	end
	return self:RoamBetweenWaypoints()
end

--------------------------------------------------------------------------------
-- CheckIfHasAggro
--------------------------------------------------------------------------------
function CheckIfHasAggro( self )
    if self:GetAggroTarget() ~= nil then
        self:SetBaseMoveSpeed( self.aiState.nAggroMoveSpeed )
        if self:GetAggroTarget() ~= self.aiState.hAggroTarget then
            self.aiState.hAggroTarget = self:GetAggroTarget()
            self:ShoutInRadius()
        end
        
		local existingParticle = self:Attribute_GetIntValue( "particleID", -1 )
		if existingParticle == -1 then
			local nAggroParticleID = ParticleManager:CreateParticle( "particles/items2_fx/mask_of_madness.vpcf", PATTACH_OVERHEAD_FOLLOW, self )
			ParticleManager:SetParticleControlEnt( nAggroParticleID, PATTACH_OVERHEAD_FOLLOW, self, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", self:GetAbsOrigin(), true )
			self:Attribute_SetIntValue( "particleID", nAggroParticleID )
		end

		if not self.bIsRoaring then
			PlayRoarSound( self )
		end

        return true
    else
		local nAggroParticleID = self:Attribute_GetIntValue( "particleID", -1 )
		if nAggroParticleID ~= -1 then
			ParticleManager:DestroyParticle( nAggroParticleID, true )
			self:DeleteAttribute( "particleID" )
		end    	
        self:SetBaseMoveSpeed( self.aiState.nWalkingMoveSpeed )
        self.bIsRoaring = false
        return false
    end
end

--------------------------------------------------------------------------------
-- PlayRoarSound
--------------------------------------------------------------------------------
function PlayRoarSound( self )
	if self:GetUnitName() == "npc_dota_creature_zombie" or self:GetUnitName() == "npc_dota_creature_zombie_crawler" then
		--EmitSoundOn( "Zombie.Roar", self )
	elseif self:GetUnitName() == "npc_dota_creature_bear" or self:GetUnitName() == "npc_dota_creature_bear_large" then
		EmitSoundOn( "Bear.Roar", self )
	end
	self.bIsRoaring = true
end

--------------------------------------------------------------------------------
-- ShoutInRadius
--------------------------------------------------------------------------------
function ShoutInRadius( self )
    local tNearbyCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", self:GetOrigin(), self.aiState.flShoutRange )
    for k, hCreature in pairs( tNearbyCreatures ) do
        if hCreature:GetAggroTarget() == nil then -- only set new attack target on the creature if it doesn't already have an aggro target
            hCreature:MoveToTargetToAttack( self.aiState.hAggroTarget )
        end
    end
end


--------------------------------------------------------------------------------
-- RoamBetweenWaypoints
--------------------------------------------------------------------------------
function RoamBetweenWaypoints( self )
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
    	self:MoveToPositionAggressive( aiState.vWaypoint )
    end
   	return RandomFloat( 0.5, 1.0 )
end

return EXPORTS
