LinkLuaModifier( "modifier_detect_invisible", "modifiers/modifier_detect_invisible", LUA_MODIFIER_MOTION_NONE )

modifier_monster_leash = class({})

--------------------------------------------------------------------------------

function modifier_monster_leash:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_monster_leash:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_monster_leash:OnCreated( kv )
	if IsServer() then
		self.flKillStartTime = -1
		self.bAddedGem = false
		
		self.bProvideVision = false
		self.fProvideVisionTime = TIME_BEFORE_PROVIDE_VISION
		self.vLastValidPos = self:GetParent():GetAbsOrigin()

		self:StartIntervalThink( 0.01 )
	end
end

-----------------------------------------------------------------------

function modifier_monster_leash:OnIntervalThink()

	local hEncounter = self:GetParent().Encounter
	if hEncounter == nil then
		self:Destroy()
		return
	end

	if self:GetParent():GetTeamNumber() ~= DOTA_TEAM_GOODGUYS then

		-- Check to see if we want to add a gem as counter-invisibility
		if self.bAddedGem == false and self:GetParent():IsConsideredHero() and 
			hEncounter:HasStarted() == true and ( ( GameRules:GetGameTime() - hEncounter:GetStartTime() ) > TIME_BEFORE_DETECT_INVIS ) then
			self.bAddedGem = true
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_detect_invisible", {} )
		end

		-- Provide vision if the room has gone on for too long - helps to protect against enemies getting lost or stuck
		if self.bProvideVision == false and
			hEncounter:HasStarted() == true and ( ( GameRules:GetGameTime() - hEncounter:GetStartTime() ) > self.fProvideVisionTime ) then

			self.bProvideVision = true
			self:GetParent():AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = -1 } )
		end

	end

	-- Only do more expensive checks for bosses + captains
	local bValidPosition = true
	if self:GetParent():IsBoss() or self:GetParent():IsConsideredHero() then
		bValidPosition = IsUnitInValidPosition( self:GetParent() )
	end

	local vOrigin = self:GetParent():GetAbsOrigin()
	if vOrigin.z <= -1000 then
		bValidPosition = false
	end

	local vClampedPos = hEncounter:GetRoom():ClampPointToRoomBounds( vOrigin, 128.0 )
	local bIsInRoom = ( vOrigin == vClampedPos )

	if bIsInRoom == true and bValidPosition == true then
		self.flKillStartTime = -1
		self.vLastValidPos = self:GetParent():GetAbsOrigin()
		return
	end

	if self.flKillStartTime < 0 then
		self.flKillStartTime = GameRules:GetGameTime()
	end

	if bIsInRoom == false then
		self:GetParent():SetAbsOrigin( vClampedPos )
	end

	-- For flying or non-motioncontrolled entities, be more generous
	if bValidPosition == false then
		local bIsMotionControlled = self:GetParent():IsCurrentlyHorizontalMotionControlled() == true or self:GetParent():IsCurrentlyVerticalMotionControlled() == true
		if self:GetParent():HasFlyMovementCapability() == false and bIsMotionControlled == false then
			FindClearSpaceForUnit( self:GetParent(), self.vLastValidPos, true )
		end
	end		

	--print ("killcountdown = ", self.killcountdown )
	-- only kill the unit if they are in a bad position for 3 seconds, 
	-- to make sure it's not a weird flying unit thing that is actually behaving legally.
	if ( GameRules:GetGameTime() - self.flKillStartTime ) >= 3 then
		SendToServerConsole( "say *** KILLING ROGUE UNIT " .. self:GetParent():GetUnitName() .. " at " .. tostring( vOrigin ) )
		self:GetParent():ForceKill( false )	
	end

end