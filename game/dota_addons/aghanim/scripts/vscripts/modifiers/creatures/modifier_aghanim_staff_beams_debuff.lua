
modifier_aghanim_staff_beams_debuff = class({})

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_debuff:IsHidden()
	return true
end


-----------------------------------------------------------------------------

function modifier_aghanim_staff_beams_debuff:OnCreated( kv )
	if IsServer() then
		self.beam_dps = self:GetAbility():GetSpecialValueFor( "beam_dps" )
		self.beam_dps_pct = self:GetAbility():GetSpecialValueFor( "beam_dps_pct" )
		self.damage_interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
		self:OnIntervalThink()
		self:StartIntervalThink( self.damage_interval )

		EmitSoundOn( "Hero_Huskar.Burning_Spear", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_staff_beams_debuff:OnDestroy()
	if IsServer() then
		StopSoundOn( "Hero_Huskar.Burning_Spear", self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_staff_beams_debuff:OnIntervalThink()
	if IsServer() then
		local flHealthPctDamage = self.beam_dps_pct * self:GetParent():GetMaxHealth() / 100
		local flDamage = self.beam_dps + flHealthPctDamage
		local damageInfo = 
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage * self.damage_interval,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}
		ApplyDamage( damageInfo )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_beam_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

-----------------------------------------------------------------------------