
modifier_fake_treasure_chest = class({})

--------------------------------------------------------------------------------

function modifier_fake_treasure_chest:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_fake_treasure_chest:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

--------------------------------------------------------------------------------

function modifier_fake_treasure_chest:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_fake_treasure_chest:OnOrder( params )
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

function modifier_fake_treasure_chest:OnIntervalThink()
	if IsServer() then
		if self.hPlayerEnt ~= nil then
			local flOpenDistance = 250.0
			if flOpenDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Dungeon ~= nil then
					self.hPlayerEnt:Interrupt()
					--GameRules.Dungeon:OnTreasureOpen( self.hPlayerEnt, self:GetParent() )
					self.hPlayerEnt = nil

					-- Gain Living Treasure modifier
					--self:GetParent():AddNewModifier( nil, self:GetAbility(), "modifier_living_treasure", { duration = -1 } )

					-- Lose Fake Treasure modifier
					self:Destroy()

					return -1
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_fake_treasure_chest:GetFixedDayVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_fake_treasure_chest:GetFixedNightVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_fake_treasure_chest:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
	end
	
	return state
end

--------------------------------------------------------------------------------

function modifier_fake_treasure_chest:OnDestroy()
	if IsServer() then
		self:GetParent():AddAbility( "living_treasure" )
	end
end

--------------------------------------------------------------------------------

