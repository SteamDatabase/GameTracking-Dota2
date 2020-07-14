
temple_guardian_rage_hammer_smash = class({})
LinkLuaModifier( "modifier_ogre_tank_melee_smash_thinker", "modifiers/creatures/modifier_ogre_tank_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function temple_guardian_rage_hammer_smash:Precache( context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
end

--------------------------------------------------------------------------------

function temple_guardian_rage_hammer_smash:OnAbilityPhaseStart()
	self.playback_rate = self:GetSpecialValueFor( "playback_rate" )

	if IsServer() then
		EmitSoundOn( "TempleGuardian.PreAttack", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function temple_guardian_rage_hammer_smash:GetPlaybackRateOverride()
	return self.playback_rate
end

-----------------------------------------------------------------------------

function temple_guardian_rage_hammer_smash:OnSpellStart()
	if IsServer() then
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCaster():GetOrigin() + vToTarget * self:GetCastRange( self:GetCaster():GetOrigin(), nil )
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_tank_melee_smash_thinker", { duration = 0 }, vTarget, self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------
