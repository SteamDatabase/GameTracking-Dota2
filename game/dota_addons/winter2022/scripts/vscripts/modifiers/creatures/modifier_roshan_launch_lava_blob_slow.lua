
modifier_roshan_launch_lava_blob_slow = class({})

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:OnCreated( kv )
	if IsServer() then
		if not self:GetAbility() then
			self:Destroy()
			return
		end

		self:SetHasCustomTransmitterData( true )

		--self.burn_damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
		--self.burn_interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )
		self.move_slow_pct = self:GetAbility():GetSpecialValueFor( "move_slow_pct" )
		--self.burn_damage_per_tick = self.burn_damage * self.burn_interval;

		--self:StartIntervalThink( self.burn_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:AddCustomTransmitterData( )
	return
	{
		move_slow_pct = self.move_slow_pct,
	}
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:HandleCustomTransmitterData( data )
	self.move_slow_pct = data.move_slow_pct
end

-----------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:GetEffectName()
	return "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_magma.vpcf"
end

-----------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:StatusEffectPriority()
	return 30
end

-----------------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetParent() == nil then
		return
	end

	if self:GetCaster() == nil then
		return
	end

	local damage = 
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.burn_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	}

	local fActualDamage = ApplyDamage( damage )
	SendOverheadEventMessage( self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_DAMAGE, self:GetParent(), fActualDamage, nil )
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.move_slow_pct
end
