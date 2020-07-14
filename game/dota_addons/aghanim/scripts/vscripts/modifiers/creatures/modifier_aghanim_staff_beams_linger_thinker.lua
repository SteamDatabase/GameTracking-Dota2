
modifier_aghanim_staff_beams_linger_thinker = class({})

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:GetModifierAura()
	return "modifier_aghanim_staff_beams_debuff"
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:GetAuraRadius()
	return self.beam_radius
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:OnCreated( kv )
	self.beam_radius = self:GetAbility():GetSpecialValueFor( "beam_radius" )
	if IsServer() then
		EmitSoundOn( "n_black_dragon.Fireball.Target", self:GetParent() )
		self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/staff_beam_linger.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.beam_radius, 1, 1 ) )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:OnDestroy()
	if IsServer() then
		StopSoundOn( "n_black_dragon.Fireball.Target", self:GetParent() )
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_staff_beams_linger_thinker:OnRefresh( kv )
	self.beam_radius = self:GetAbility():GetSpecialValueFor( "beam_radius" )
end

--------------------------------------------------------------------------------
