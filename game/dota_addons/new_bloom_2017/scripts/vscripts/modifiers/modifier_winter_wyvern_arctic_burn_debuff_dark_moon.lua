modifier_winter_wyvern_arctic_burn_debuff_dark_moon = class ({})

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_debuff_dark_moon:GetStatusEffectName( void ) 
	return "particles/status_fx/status_effect_wyvern_arctic_burn.vpcf"
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_debuff_dark_moon:OnCreated( kv )
	self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )
	self.percent_damage = self:GetAbility():GetSpecialValueFor( "percent_damage" )
	

	if IsServer() then
		self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_winter_wyvern_1" )
		if hTalent and hTalent:GetLevel() > 0 then
			self.move_slow = self.move_slow + hTalent:GetSpecialValueFor( "value" ) 
		end
		self:StartIntervalThink( self.tick_rate )
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end


--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_debuff_dark_moon:OnRefresh( kv )
	self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )
	self.percent_damage = self:GetAbility():GetSpecialValueFor( "percent_damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	if IsServer() then
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_winter_wyvern_1" )
		if hTalent and hTalent:GetLevel() > 0 then
			self.move_slow = self.move_slow + hTalent:GetSpecialValueFor( "value" ) 
		end
	end
end


--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_debuff_dark_moon:OnIntervalThink()
	if self:GetParent() and self:GetParent():IsAncient() == false then
		local flDamage = 0.01 * self.percent_damage * self:GetParent():GetHealth()
		local damage =
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_debuff_dark_moon:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_debuff_dark_moon:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.move_slow
end