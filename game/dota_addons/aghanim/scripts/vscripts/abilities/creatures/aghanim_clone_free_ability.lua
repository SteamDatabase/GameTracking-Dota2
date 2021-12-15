aghanim_clone_free_ability = class({})

----------------------------------------------------------------------------------------

function aghanim_clone_free_ability:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_beam_channel.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_beam_burn.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam_linger.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam_tgt_ring.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_debug_ring.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context )
end

----------------------------------------------------------------------------------------

function aghanim_clone_free_ability:OnAbilityPhaseStart()
	if IsServer() then
		StartSoundEventFromPositionReliable( "Aghanim.StaffBeams.WindUp", self:GetCaster():GetAbsOrigin() )
		self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_beam_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end

--------------------------------------------------------------------------------

function aghanim_clone_free_ability:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Phoenix.SunRay.Cast", self:GetCaster() )
		EmitSoundOn( "Hero_Phoenix.SunRay.Loop", self:GetCaster() )

		local hAghanimClone = GameRules.Aghanim:GetCurrentRoom():GetEncounter().hAghanimClone

		self.nBeamFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/staff_beam.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex , 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff_fx", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex , 1, hAghanimClone, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hAghanimClone:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex , 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hAghanimClone:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFXIndex , 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )

		
	end
end

-------------------------------------------------------------------------------

function aghanim_clone_free_ability:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		ParticleManager:DestroyParticle( self.nBeamFXIndex, false )
		StopSoundOn( "Hero_Phoenix.SunRay.Cast", self:GetCaster() )
		StopSoundOn( "Hero_Phoenix.SunRay.Loop", self:GetCaster() )
		EmitSoundOn( "Hero_Phoenix.SunRay.Stop", self:GetCaster() )
	end
end