
temple_guardian_rage_hammer_smash = class({})

--------------------------------------------------------------------------------

function temple_guardian_rage_hammer_smash:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "TempleGuardian.PreAttack", self:GetCaster() )
	end
	return true
end

--------------------------------------------------------------------------------

function temple_guardian_rage_hammer_smash:GetPlaybackRateOverride()
	return 0.6090 -- was 0.5500 -- Playbackrate ratio should be kept inversely proportional to RageHammerSmash base_swing_speed
end

-----------------------------------------------------------------------------

function temple_guardian_rage_hammer_smash:OnSpellStart()
	if IsServer() then
		local flSpeed = self:GetSpecialValueFor( "base_swing_speed" )
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCaster():GetOrigin() + vToTarget * self:GetCastRange( self:GetCaster():GetOrigin(), nil )
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_tank_melee_smash_thinker", { duration = flSpeed }, vTarget, self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------

