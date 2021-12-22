
require( "utility_functions" )

modifier_event_leshrac_pulse_nova = class( {} )

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:GetTexture()
	return "leshrac_pulse_nova"
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:OnCreated( kv )
	if IsServer() then
		self.cooldown = self:GetAbility():GetSpecialValueFor( "cooldown" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.int_mult_for_damage = self:GetAbility():GetSpecialValueFor( "int_mult_for_damage" )
		self.activation_delay = self:GetAbility():GetSpecialValueFor( "activation_delay" )

		self:SetHasCustomTransmitterData( true )

		self.fNextPulseTime = GameRules:GetGameTime()

		self:StartIntervalThink( 0.1 )
	end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:OnRefresh( kv )
    if IsServer() then
    	self.cooldown = self:GetAbility():GetSpecialValueFor( "cooldown" )
    	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
    	self.int_mult_for_damage = self:GetAbility():GetSpecialValueFor( "int_mult_for_damage" )
    	self.activation_delay = self:GetAbility():GetSpecialValueFor( "activation_delay" )

        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:AddCustomTransmitterData( )
	return
	{
		cooldown = self.cooldown,
		radius = self.radius,
		int_mult_for_damage = self.int_mult_for_damage,
		activation_delay = self.activation_delay,
	}
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:HandleCustomTransmitterData( data )
	self.cooldown = data.cooldown
	self.radius = data.radius
	self.int_mult_for_damage = data.int_mult_for_damage
	self.activation_delay = data.activation_delay
end


--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:OnIntervalThink()
	if not IsServer() then
		return -1
	end

	if self:GetParent():IsCreature() then
		-- It's not a real ability on Leshrac npc, he just has it so we can read its values in
		-- the event npc interaction dialog. Just return early before we error on GetIntellect.
		return
	end

	if not self:GetParent():IsSilenced() and not self:GetParent():IsMuted() and GameRules:GetGameTime() >= self.fNextPulseTime then
		local enemies = Util_FindEnemiesAroundUnit( self:GetParent(), self.radius, true )

		if #enemies > 0 then
			local kv_activated =
			{
				duration = self.activation_delay,
			}
			self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_event_leshrac_pulse_nova_activated", kv_activated )

			self.fNextPulseTime = GameRules:GetGameTime() + self.cooldown
			self:SetDuration( self.cooldown, true )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:OnTooltip( params )
	return self.int_mult_for_damage
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova:OnDestroy()
	if not IsServer() then
		return
	end

	if self:GetParent():IsCreature() then
		-- It's not a real ability on Leshrac npc, he just has it so we can read its values in
		-- the event npc interaction dialog. Just return early before we error on GetIntellect.
		return
	end

	-- Re-make the modifier, we're using it as a player-visible timer for the pulses
	if self:GetParent():IsAlive() then
		local kv =
		{
			duration = -1,
		}

		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_event_leshrac_pulse_nova", kv )
	else
		local kv_thinker =
		{
			duration = -1,
		}

		CreateModifierThinker( self:GetParent(), self:GetAbility(), "modifier_event_leshrac_pulse_nova_recreate",
			kv_thinker, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false
		)
	end
end

--------------------------------------------------------------------------------
