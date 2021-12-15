modifier_amoeba_boss_ink = class({})

----------------------------------------------------------------------

function modifier_amoeba_boss_ink:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf"
end

----------------------------------------------------------------------

function modifier_amoeba_boss_ink:OnCreated( kv )
	self.movement_speed_pct = self:GetAbility():GetSpecialValueFor( "movement_speed_pct" )
	self.turn_rate_pct = self:GetAbility():GetSpecialValueFor( "turn_rate_pct" )
	if IsServer() then
		local flStackCount = self:GetStackCount() / 10.0
		self.nFXIndex = ParticleManager:CreateParticle( "particles/status_fx/status_effect_stickynapalm.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 1, flStackCount, -1 ) )
		self:AddParticle( self.nFXIndex, false, true, 13, false, false )
	end
end

----------------------------------------------------------------------

function modifier_amoeba_boss_ink:OnRefresh( kv )
	if IsServer() then
		local flStackCount = self:GetStackCount() / 10.0
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 1, flStackCount, -1 ) )
	end
end

----------------------------------------------------------------------

function modifier_amoeba_boss_ink:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

----------------------------------------------------------------------

function modifier_amoeba_boss_ink:GetModifierTurnRate_Percentage( params )
	return self:GetStackCount() * self.turn_rate_pct
end

----------------------------------------------------------------------

function modifier_amoeba_boss_ink:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.movement_speed_pct
end