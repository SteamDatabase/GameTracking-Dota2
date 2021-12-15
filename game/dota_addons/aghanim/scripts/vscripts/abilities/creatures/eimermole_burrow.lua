
eimermole_burrow = class({})

LinkLuaModifier( "modifier_eimermole_burrow", "modifiers/creatures/modifier_eimermole_burrow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_eimermole_burrow_aura_effect", "modifiers/creatures/modifier_eimermole_burrow_aura_effect", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function eimermole_burrow:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/eimermole/burrow_start.vpcf", context )
end

--------------------------------------------------------------------------------

function eimermole_burrow:OnAbilityPhaseStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.damage = self:GetSpecialValueFor( "damage" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/eimermole/burrow_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )

		local vDirection = self:GetCaster():GetForwardVector()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.nBurrowFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nBurrowFX, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControlForward( self.nBurrowFX, 0, vDirection )
		ParticleManager:ReleaseParticleIndex( self.nBurrowFX )

		EmitSoundOn( "n_creep_Ursa.Clap", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function eimermole_burrow:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		ParticleManager:DestroyParticle( self.nBurrowFX, false )
	end 
end

--------------------------------------------------------------------------------

function eimermole_burrow:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

function eimermole_burrow:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		ParticleManager:DestroyParticle( self.nBurrowFX, false )

		local fDuration = self:GetSpecialValueFor( "burrow_duration" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_eimermole_burrow", { duration = fDuration } )
	end
end

--------------------------------------------------------------------------------
