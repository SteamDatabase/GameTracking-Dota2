
modifier_boss_tinker_laser_burn_thinker = class({})

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:GetModifierAura()
	return "modifier_boss_tinker_laser_burn_debuff"
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		printf( "modifier_boss_tinker_laser_burn_thinker:OnCreated" )

		EmitSoundOn( "n_black_dragon.Fireball.Target", self:GetParent() )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/staff_beam_linger.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 1, 1 ) )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:OnDestroy()
	if IsServer() then
		StopSoundOn( "n_black_dragon.Fireball.Target", self:GetParent() )

		ParticleManager:DestroyParticle( self.nFXIndex, false )

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_burn_thinker:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
