
modifier_boss_dark_willow_shadow_realm_debuff = class({})

--------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm_debuff:OnCreated( kv )
	self.pass_thru_slow_pct = self:GetAbility():GetSpecialValueFor( "pass_thru_slow_pct" )
	if IsServer() then 
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( 1200, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 5, Vector( 100, 100, 100 ) )
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm_debuff:OnDestroy()
	if IsServer() then 
		ParticleManager:DestroyParticle( self.nFXIndex, false )
	end
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_shadow_realm_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.pass_thru_slow_pct
end
