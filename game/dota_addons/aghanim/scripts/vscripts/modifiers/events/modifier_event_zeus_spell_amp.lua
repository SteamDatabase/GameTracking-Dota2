
modifier_event_zeus_spell_amp = class({})

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:GetTexture()
	return "npc_dota_hero_zuus"
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:OnCreated( kv )
	if IsServer() then
		self.spell_amp = kv[ "spell_amp" ]

		self:SetHasCustomTransmitterData( true )

		printf( "modifier_event_zeus_spell_amp [SERVER]: self.spell_amp == %d", self.spell_amp )
	else
		--printf( "modifier_event_zeus_spell_amp [CLIENT]: self.spell_amp == %d", self.spell_amp )
	end
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:OnRefresh( kv )
    if IsServer() then
    	self.spell_amp = kv.spell_amp
        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:AddCustomTransmitterData( )
	return
	{
		spell_amp = self.spell_amp,
	}
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:HandleCustomTransmitterData( data )
	self.spell_amp = data.spell_amp
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_zeus_spell_amp:GetModifierSpellAmplify_PercentageUnique()
	return self.spell_amp
end
