temple_guardian_hammer_throw = class({})
LinkLuaModifier( "modifier_temple_guardian_hammer_throw", "modifiers/modifier_temple_guardian_hammer_throw", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function temple_guardian_hammer_throw:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/test_particle/generic_attack_charge.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 135, 192, 235 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )

		EmitSoundOn( "TempleGuardian.PreAttack", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function temple_guardian_hammer_throw:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )
	end 
end

--------------------------------------------------------------------------------

function temple_guardian_hammer_throw:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------

function temple_guardian_hammer_throw:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		
		local vLocation = self:GetCursorPosition()

		local kv = 
		{
			x = vLocation.x,
			y = vLocation.y,
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_hammer_throw", kv )
	end
end