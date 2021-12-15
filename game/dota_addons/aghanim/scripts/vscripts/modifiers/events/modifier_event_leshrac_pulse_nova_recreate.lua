
modifier_event_leshrac_pulse_nova_recreate = class( {} )

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_recreate:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_recreate:OnCreated( kv )
	if IsServer() then
		self.cooldown = self:GetAbility():GetSpecialValueFor( "cooldown" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.int_mult_for_damage = self:GetAbility():GetSpecialValueFor( "int_mult_for_damage" )

		self:SetHasCustomTransmitterData( true )

		self:StartIntervalThink( 0.05 )
	end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_recreate:OnRefresh( kv )
    if IsServer() then
		self.cooldown = self:GetAbility():GetSpecialValueFor( "cooldown" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.int_mult_for_damage = self:GetAbility():GetSpecialValueFor( "int_mult_for_damage" )

        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_recreate:AddCustomTransmitterData( )
	return
	{
		cooldown = self.cooldown,
		radius = self.radius,
		int_mult_for_damage = self.int_mult_for_damage,
	}
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_recreate:HandleCustomTransmitterData( data )
	self.cooldown = data.cooldown
	self.radius = data.radius
	self.int_mult_for_damage = data.int_mult_for_damage
end


--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_recreate:OnIntervalThink()
	if not IsServer() then
		return -1
	end

	if self:GetCaster():IsAlive() then
		local kv =
		{
			duration = -1,
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_event_leshrac_pulse_nova", kv )

		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_recreate:OnDestroy()
	if not IsServer() then
		return
	end

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
