
modifier_sled_penguin_passive = class({})

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:OnCreated( kv )
	if IsServer() then
		self.hPlayerEnt = nil
		self.bRideComplete = false
		self.bRideStarted = false
		self.bThinking = false
	end
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end


-----------------------------------------------------------------------

function modifier_sled_penguin_passive:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type

		-- first, check if our owner has made an order that is *not* move to us
		-- if so, stop thinking.
		if self.bThinking and self:GetParent():GetOwnerEntity() == hOrderedUnit 
			and ( nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET or hTargetUnit ~= self:GetParent() ) then
			self:StartIntervalThink( -1 )
			self.bThinking = false
			return
		end

		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			return
		end

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() then
			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and hTargetUnit:GetOwnerEntity() == hOrderedUnit then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.25 )
			self.bThinking = true
			return
		end

		self:StartIntervalThink( -1 )
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_sled_penguin_passive:OnDestroy()
	if IsServer() then
		if self.hPlayerEnt ~= nil and self.hPlayerEnt:IsNull() == false then
			self.hPlayerEnt:RemoveModifierByName( "modifier_sled_penguin_movement" )
		end

		UTIL_Remove( self:GetParent() )
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_sled_penguin_passive:OnIntervalThink()
	if IsServer() then
		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Aghanim ~= nil and self.bRideStarted == false then
					self.hPlayerEnt:Interrupt()
					
					self:StartIntervalThink( -1 )
					self.bThinking = false
					self.bRideStarted = true

					EmitSoundOn( "SledPenguin.PlayerHopOn", self:GetParent() )

					self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_sled_penguin_movement", {} )
					self.hPlayerEnt:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_sled_penguin_movement", {} )

					if self:GetParent().Encounter ~= nil then
						self:GetParent().Encounter:OnPlayerRidePenguin( self.hPlayerEnt:GetPlayerOwnerID(), self:GetParent() )
					end
					
				end
			end
		end
	end
end

---------------------------------------------------------------------------
