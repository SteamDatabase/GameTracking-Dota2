
modifier_event_necrophos_life_cost = class( {} )

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:GetTexture()
	return "necrolyte_death_seeker"
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:OnCreated( kv )
	if IsServer() then
		self.hp_penalty = kv[ "hp_penalty" ]

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:OnRefresh( kv )
    if IsServer() then
    	self.hp_penalty = kv.hp_penalty

        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:AddCustomTransmitterData( )
	return
	{
		hp_penalty = self.hp_penalty,
	}
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:HandleCustomTransmitterData( data )
	self.hp_penalty = data.hp_penalty
end


--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:GetModifierHealthBonus( params )
	return -self.hp_penalty
end

--------------------------------------------------------------------------------

function modifier_event_necrophos_life_cost:OnTooltip( params )
	return self.hp_penalty
end

--------------------------------------------------------------------------------
