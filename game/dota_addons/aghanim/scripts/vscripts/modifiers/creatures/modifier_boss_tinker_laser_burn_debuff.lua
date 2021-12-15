
modifier_boss_tinker_laser_burn_debuff = class({})

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_debuff:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_debuff:OnCreated( kv )
	if IsServer() then
		self.burn_dps = self:GetAbility():GetSpecialValueFor( "burn_dps" )
		self.damage_interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )

		EmitSoundOn( "Hero_Huskar.Burning_Spear", self:GetParent() )

		self:OnIntervalThink()
		self:StartIntervalThink( self.damage_interval )
	end
end

-----------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_debuff:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Huskar.Burning_Spear", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_debuff:OnIntervalThink()
	if IsServer() then
		local fDamage = self.burn_dps * self.damage_interval
		local damageInfo = 
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = fDamage * self.damage_interval,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
		}
		ApplyDamage( damageInfo )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_beam_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

-----------------------------------------------------------------------------
