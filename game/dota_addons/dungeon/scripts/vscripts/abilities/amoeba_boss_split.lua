amoeba_boss_split = class({})
LinkLuaModifier( "modifier_amoeba_boss_split", "modifiers/modifier_amoeba_boss_split", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------------------------------

function amoeba_boss_split:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 0, 0, 255 ) )
	end
	return true
end

-------------------------------------------------------------------

function amoeba_boss_split:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

-------------------------------------------------------------------

function amoeba_boss_split:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		EmitSoundOn( "Hero_NagaSiren.MirrorImage", self:GetCaster() )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_amoeba_boss_split", { duration = self:GetSpecialValueFor( "invuln_duration" ) } )
	end
end