gaoler_melee_smash = class({})
LinkLuaModifier( "modifier_gaoler_melee_smash_thinker", "modifiers/creatures/modifier_gaoler_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function gaoler_melee_smash:ProcsMagicStick()
	return false
end
-----------------------------------------------------------------------------

function gaoler_melee_smash:GetPlaybackRateOverride()
	return 0.5
end

-----------------------------------------------------------------------------

function gaoler_melee_smash:OnSpellStart()
	if IsServer() then
		--EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )
		local flSpeed = self:GetSpecialValueFor( "base_swing_speed" )
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCaster():GetOrigin() + vToTarget * self:GetCastRange( self:GetCaster():GetOrigin(), nil ) + self:GetCaster():GetRightVector() * 125
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_gaoler_melee_smash_thinker", { duration = flSpeed }, vTarget, self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------

