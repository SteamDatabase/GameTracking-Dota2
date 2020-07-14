modifier_morty_start_passive = class({})
----------------------------------------------------------------------------------

function modifier_morty_start_passive:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_morty_start_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_morty_start_passive:OnCreated( kv )
	if IsServer() then
		self.hPlayerEnt = nil
		self.bRideComplete = false
		self.bRideStarted = false
	end
end

----------------------------------------------------------------------------------

function modifier_morty_start_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end


-----------------------------------------------------------------------

function modifier_morty_start_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_morty_start_passive:OnOrder( params )
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

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and hTargetUnit:GetOwnerEntity() == hOrderedUnit then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.25 )
			return
		end

		self:StartIntervalThink( -1 )
	end

	return 0
end


-----------------------------------------------------------------------

function modifier_morty_start_passive:OnIntervalThink()
	if IsServer() then
		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Aghanim ~= nil and self.bRideStarted == false then
					self.hPlayerEnt:Interrupt()
					
					self:StartIntervalThink( -1 )
					self.bRideStarted = true
					
					local hRideMorty = self.hPlayerEnt:AddNewModifier( self:GetParent(), nil, "modifier_ride_morty", {} )
					if hRideMorty ~= nil then
						self.hPlayerEnt:RemoveModifierByName( "modifier_bonus_room_start" )
					end

					if self.Encounter ~= nil then
						self.Encounter:OnPlayerRideMorty( self.hPlayerEnt:GetPlayerOwnerID(), self:GetParent() )
					end
				
				end
			end
		end
	end
end

