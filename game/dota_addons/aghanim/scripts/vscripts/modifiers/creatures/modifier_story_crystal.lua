
modifier_story_crystal = class({})

----------------------------------------

function modifier_story_crystal:OnCreated( kv )
	self.hPlayerEnt = nil

	if IsServer() then
		self.Players = {}
		self.bInMotion = false
		self.flMinHeight = 100
		self.flMaxHeight = 150
		self.bAscending = true
		self.flOssiclateTime = 5.0
		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_story_crystal:IsHidden()
	return true
end


---------------------------------------------------------------------------

function modifier_story_crystal:GetEffectName()
	return "particles/creatures/aghanim/aghanim_crystal_spellswap_ambient.vpcf"
end

--------------------------------------------------------------------------------

function modifier_story_crystal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_story_crystal:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
		state[ MODIFIER_STATE_ROOTED ] = false
		state[ MODIFIER_STATE_ATTACK_IMMUNE ] = true
	end

	return state
end

-----------------------------------------------------------------------

function modifier_story_crystal:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_story_crystal:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET and nOrderType ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
			return
		end

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() then
			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.1 )
			return
		end

		self:StartIntervalThink( -1 )
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_story_crystal:OnIntervalThink()
	if IsServer() then
		if self.bInMotion == false then
			if self:ApplyVerticalMotionController() == false then 
				self:Destroy()
			end
			self.bInMotion = true
			self:StartIntervalThink( -1 )
			return
		end

		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				local nPlayerID = self.hPlayerEnt:GetPlayerOwnerID()
				for _,nID in pairs ( self.Players ) do
					if nPlayerID == nID then
						return
					end
				end

				if GameRules.Aghanim ~= nil then
					self.hPlayerEnt:Interrupt()
					local nCrystalID = 1 + #GameRules.Aghanim.PlayerCrystals[ nPlayerID ]
					local szLine = tostring( "announcer_aghanim_agh_story_time_" .. tostring( nCrystalID ) .. "_01" )
					print( "crystal .. " .. nCrystalID .. "spoken to by " .. self.hPlayerEnt:GetUnitName() .. ", speaking line " .. szLine )
				--	EmitSoundOn( "wisp_thanks", self:GetParent() )
					EmitSoundOnLocationForPlayer( szLine, self:GetParent():GetAbsOrigin(), nPlayerID )
					table.insert( self.Players, nPlayerID )
					table.insert( GameRules.Aghanim.PlayerCrystals[ nPlayerID ], nCrystalID )
					self:StartIntervalThink( -1 )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_story_crystal:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController( self )
	end
end


--------------------------------------------------------------------------------

function modifier_story_crystal:UpdateVerticalMotion( me, dt )
	if IsServer() then
		local flGroundHeight = GetGroundHeight( self:GetParent():GetAbsOrigin(), self:GetParent() )
		local flCurHeight = self:GetParent():GetAbsOrigin().z - flGroundHeight
		local flChange = ( self.flMaxHeight - self.flMinHeight ) / self.flOssiclateTime * dt 
		if self.bAscending == false then
			flChange = flChange * -1
		end
		
		local vNewLocation = self:GetParent():GetAbsOrigin()
		vNewLocation.z = flGroundHeight + flCurHeight + flChange
		me:SetOrigin( vNewLocation )

		if ( vNewLocation.z - flGroundHeight ) > self.flMaxHeight then
			self.bAscending = false
		end
		if ( vNewLocation.z - flGroundHeight ) < self.flMinHeight then
			self.bAscending = true
		end
	end
end

--------------------------------------------------------------------------------

function modifier_story_crystal:OnVerticalMotionInterrupted()
	if IsServer() then
		print( "motion interrupted" )
		self:Destroy()
	end
end




