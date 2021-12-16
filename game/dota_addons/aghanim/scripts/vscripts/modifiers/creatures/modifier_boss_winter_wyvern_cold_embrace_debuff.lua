
modifier_boss_winter_wyvern_cold_embrace_debuff = class({})

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_debuff:OnCreated( kv )
	self.linger_movement_slow = self:GetAbility():GetSpecialValueFor( "linger_movement_slow" )
	self.linger_damage = self:GetAbility():GetSpecialValueFor( "linger_damage" )

	if IsServer() then 
		self:OnIntervalThink()
		self:StartIntervalThink( 1.0 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast_slow.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false  )
	end
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

------------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.linger_movement_slow
end

-------------------------------------------------------------------------------

function modifier_boss_winter_wyvern_cold_embrace_debuff:OnIntervalThink()
	if IsServer() == false then 
		return 
	end

	local damageInfo = 
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.linger_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	}

	ApplyDamage( damageInfo )
end