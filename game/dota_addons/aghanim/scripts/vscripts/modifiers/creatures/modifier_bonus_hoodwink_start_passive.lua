modifier_bonus_hoodwink_start_passive = class({})
----------------------------------------------------------------------------------

function modifier_bonus_hoodwink_start_passive:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_bonus_hoodwink_start_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_bonus_hoodwink_start_passive:OnCreated( kv )
	if IsServer() then
		self.hPlayerEnt = self:GetParent():GetOwnerEntity()
		self.bOrdered = false
		self.bSwallowed = false
	end
end

----------------------------------------------------------------------------------

function modifier_bonus_hoodwink_start_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end


-----------------------------------------------------------------------

function modifier_bonus_hoodwink_start_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_bonus_hoodwink_start_passive:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type

		if hOrderedUnit == self.hPlayerEnt then
			self.bOrdered = hTargetUnit == self:GetParent() and ( nOrderType == DOTA_UNIT_ORDER_MOVE_TO_TARGET or nOrderType == DOTA_UNIT_ORDER_ATTACK_TARGET )
			if self.bOrdered then
				self:StartIntervalThink( 0.25 )
			else
				self:StartIntervalThink( -1 )
			end
		end
	end

	return 0
end


-----------------------------------------------------------------------

function modifier_bonus_hoodwink_start_passive:OnIntervalThink()
	if IsServer() then
		if self.bSwallowed == true or self.bOrdered == false or GameRules.Aghanim == nil then
			return
		end

		if self.hPlayerEnt:IsPositionInRange( self:GetParent():GetAbsOrigin(), 250.0 ) then
			self.hPlayerEnt:Interrupt()
			self:StartIntervalThink( -1 )


			if self.Encounter ~= nil then
				self.Encounter:OnHeroSwallowed( self.hPlayerEnt, self:GetParent() )
				self.bSwallowed = true
			end
		end
	end
end

