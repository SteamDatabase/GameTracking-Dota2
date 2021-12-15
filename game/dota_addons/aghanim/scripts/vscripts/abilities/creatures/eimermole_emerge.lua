
eimermole_emerge = class({})

LinkLuaModifier( "modifier_eimermole_emerge", "modifiers/creatures/modifier_eimermole_emerge", LUA_MODIFIER_MOTION_BOTH )

----------------------------------------------------------------------------------------

function eimermole_emerge:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/ursa_thunderclap.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/eimermole/eimermole_emerge.vpcf", context )
end

--------------------------------------------------------------------------------

function eimermole_emerge:OnAbilityPhaseStart()
	if IsServer() then
		radius = self:GetSpecialValueFor( "radius" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		--EmitSoundOn( "n_creep_Ursa.Clap", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function eimermole_emerge:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function eimermole_emerge:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

function eimermole_emerge:OnSpellStart()
	if IsServer() then
		--ParticleManager:DestroyParticle( self.nPreviewFX, false )

		local vLocation = self:GetCursorPosition()
		local kv =
		{
			vLocX = vLocation.x,
			vLocY = vLocation.y,
			vLocZ = vLocation.z
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_eimermole_emerge", kv )

		EmitSoundOn( "Eimermole.Emerge.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
