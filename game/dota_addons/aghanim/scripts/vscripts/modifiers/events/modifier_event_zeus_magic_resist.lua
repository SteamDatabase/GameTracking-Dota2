
modifier_event_zeus_magic_resist = class({})

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:GetTexture()
	return "item_cloak"
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:OnCreated( kv )
	if IsServer() then
		self.magic_resist = kv[ "magic_resist" ]

		self:SetHasCustomTransmitterData( true )
		printf( "modifier_event_zeus_magic_resist [SERVER]: self.magic_resist == %d", self.magic_resist )
	else
		--printf( "modifier_event_zeus_magic_resist [CLIENT]: self.magic_resist == %d", self.magic_resist )
	end
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:OnRefresh( kv )
    if IsServer() then
    	self.magic_resist = kv.magic_resist
   
        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:AddCustomTransmitterData()
	return
	{
		magic_resist = self.magic_resist,
	}
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:HandleCustomTransmitterData( data )
	if data.magic_resist ~= nil then
		self.magic_resist = tonumber( data.magic_resist )
	end
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_zeus_magic_resist:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end
