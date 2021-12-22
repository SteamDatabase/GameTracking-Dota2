
boss_earthshaker_smash = class({})
LinkLuaModifier( "modifier_ogre_tank_melee_smash_thinker", "modifiers/creatures/modifier_ogre_tank_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function boss_earthshaker_smash:Precache( context )
	PrecacheResource( "particle", "particles/creatures/ogre/ogre_melee_smash.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_earthshaker_smash:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "TempleGuardian.PreAttack", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_earthshaker_smash:OnSpellStart()
	if IsServer() then
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCaster():GetOrigin() + vToTarget * self:GetCastRange( self:GetCaster():GetOrigin(), nil )
		CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_tank_melee_smash_thinker", { duration = 0 }, vTarget, self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------
