
modifier_treasure_chest = class({})

--------------------------------------------------------------------------------

function modifier_treasure_chest:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_treasure_chest:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			return
		end

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() then
			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.25 )
			return
		end

		self:StartIntervalThink( -1 )
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_treasure_chest:OnTakeDamage( params )
	return 0
end

-----------------------------------------------------------------------

function modifier_treasure_chest:OnIntervalThink()
	if IsServer() then
		if not self.bWasOpened then
			if self.hPlayerEnt ~= nil then
				local flOpenDistance = 150.0
				if flOpenDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
					if GameRules.Aghanim ~= nil then
						self.hPlayerEnt:Interrupt()
						self:GetParent():StartGesture( ACT_DOTA_PRESENT_ITEM )
						GameRules.Aghanim:OnTreasureOpen( self.hPlayerEnt, self:GetParent() )
						self.bWasOpened = true
						self.hPlayerEnt = nil

						self.fTimeChestOpened = GameRules:GetGameTime()
						self:StartIntervalThink( 4 )

						return -1
					end
				end
			end
		else
			self:GetParent():Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:GetFixedDayVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:GetFixedNightVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_treasure_chest:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		
		if self.bWasOpened then
			state[MODIFIER_STATE_UNSELECTABLE] = true

			if self.fTimeChestOpened and ( GameRules:GetGameTime() > self.fTimeChestOpened + 2.5 ) then
				state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
			end
		end
	end
	
	return state
end

--------------------------------------------------------------------------------
