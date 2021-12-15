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

function modifier_monster_leash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_monster_leash:OnCreated( kv )
	if IsServer() then
		self.flKillStartTime = -1
		self.bAddedGem = false
		
		self.bProvideVision = false
		self.fProvideVisionTime = TIME_BEFORE_PROVIDE_VISION

		self.nLeashCounter = 0

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

	local vOrigin = self:GetParent():GetAbsOrigin()
	local vClampedPos = hEncounter:GetRoom():ClampPointToRoomBounds( vOrigin, 128.0 )
	if ( vOrigin - vClampedPos ):Length2D() > 1.0 then
		-- in a bad position.
		
		if self.nLeashCounter < 2 then
			self.flKillStartTime = -1

			local flBorder = 128.0		
			if self.nLeashCounter == 1 then
				flBorder = 1024.0
			end
			vClampedPos = hEncounter:GetRoom():ClampPointToRoomBounds( vOrigin, flBorder )

			FindClearSpaceForUnit( self:GetParent(), vClampedPos, true )
			
			self.nLeashCounter = self.nLeashCounter + 1

			print( "teleporting unit via monster leash: " .. self:GetParent():GetUnitName() )
			print( "Leash counter: " .. self.nLeashCounter )
			print( "from " .. tostring( vOrigin ) .. " to " .. tostring( vClampedPos ) )
			print( "room maxes: " .. tostring( hEncounter:GetRoom():GetMaxs() ) )
			print( "room mins: " .. tostring( hEncounter:GetRoom():GetMins() ) )

			return
		else
			if self.flKillStartTime < 0 then
				self.flKillStartTime = GameRules:GetGameTime()
			end
		end
	else
		self.nLeashCounter = 0
		return
	end

	

	--print ("killcountdown = ", self.killcountdown )
	-- only kill the unit if they are in a bad position for 3 seconds, 
	-- to make sure it's not a weird flying unit thing that is actually behaving legally.
	if ( GameRules:GetGameTime() - self.flKillStartTime ) >= 3 and self:GetParent():GetUnitName() ~= "npc_dota_creature_aghsfort_primal_beast_boss" then
		--SendToServerConsole( "say *** KILLING ROGUE UNIT " .. self:GetParent():GetUnitName() .. " at " .. tostring( vOrigin ) )
		print( "*** KILLING ROGUE UNIT " .. self:GetParent():GetUnitName() .. " at " .. tostring( vOrigin ) )
		self:GetParent():ForceKill( false )

		self:Destroy()
		return
	end

end