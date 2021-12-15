
modifier_event_doom_regen_reduction = class({})

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:GetTexture()
	return "doom_bringer_infernal_blade"
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:OnCreated( kv )
	if IsServer() then
		self.regen_reduction = kv[ "regen_reduction" ]

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:OnRefresh( kv )
    if IsServer() then
    	self.regen_reduction = kv.regen_reduction
    	
        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:AddCustomTransmitterData( )
	return
	{
		regen_reduction = self.regen_reduction,
	}
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:HandleCustomTransmitterData( data )
	self.regen_reduction = data.regen_reduction
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_doom_regen_reduction:GetModifierConstantHealthRegen( params )
	return -self.regen_reduction
end

