
modifier_eimermole_burrow_aura_effect = class({})

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow_aura_effect:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow_aura_effect:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow_aura_effect:OnCreated( kv )
	self.aura_movement_slow_pct = self:GetAbility():GetSpecialValueFor( "aura_movement_slow_pct" )
	self.aura_dps = self:GetAbility():GetSpecialValueFor( "aura_dps" )
	self.damage_interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )

	if IsServer() then
		self:StartIntervalThink( self.damage_interval )
	end
end

-----------------------------------------------------------------------------------------

function modifier_eimermole_burrow_aura_effect:OnIntervalThink()
	if IsServer() then
		local fDamage = self.aura_dps * self.damage_interval

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = fDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_eimermole_burrow_aura_effect:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.aura_movement_slow_pct
end

--------------------------------------------------------------------------------
