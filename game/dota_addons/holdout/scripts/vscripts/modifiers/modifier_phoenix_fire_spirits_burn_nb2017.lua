modifier_phoenix_fire_spirits_burn_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_burn_nb2017:OnCreated( kv )
	self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
	self.attackspeed_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	self.lifesteal_pct = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )
	if IsServer() then
		self:StartIntervalThink( self.tick_interval )

		if self:GetParent():IsConsideredHero() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		else
			local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn_creep.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( nFXIndexB, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndexB, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
			self:AddParticle( nFXIndexB, false, false, -1, false, false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_burn_nb2017:OnRefresh( kv )
	self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
	self.attackspeed_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )
	self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
	self.lifesteal_pct = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_burn_nb2017:OnIntervalThink()
	if IsServer() then

		local talentDamage = 0
		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_phoenix_3" )
		if hTalent ~= nil and hTalent:GetLevel() > 0 then
			talentDamage = hTalent:GetSpecialValueFor( "value" )
		end

		local damageOutput = ( self.damage_per_second + talentDamage ) * self.tick_interval

		local damage =
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = damageOutput,
			damage_type = DAMAGE_TYPE_MAGICAL
		}

		ApplyDamage( damage )

		self:GetCaster():Heal( self.damage_per_second * ( self.lifesteal_pct / 100.0 ), self:GetAbility() )
		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() );
		ParticleManager:ReleaseParticleIndex( nFXIndex );
	end
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_burn_nb2017:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_burn_nb2017:GetModifierAttackSpeedBonus_Constant( params )
	return self.attackspeed_slow
end

--------------------------------------------------------------------------------

function modifier_phoenix_fire_spirits_burn_nb2017:OnTooltip( params )
	return self.damage_per_second
end
