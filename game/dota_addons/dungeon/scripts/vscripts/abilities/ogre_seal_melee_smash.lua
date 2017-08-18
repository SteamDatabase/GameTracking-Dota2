
ogre_seal_melee_smash = class({})

LinkLuaModifier( "modifier_ogre_seal_smash_thinker", "modifiers/modifier_ogre_seal_smash_thinker", LUA_MODIFIER_MOTION_BOTH )

-----------------------------------------------------------------------------

function ogre_seal_melee_smash:ProcsMagicStick()
	return false
end

-----------------------------------------------------------------------------

function ogre_seal_melee_smash:GetCooldown( iLevel )
	return self.BaseClass.GetCooldown( self, self:GetLevel() ) / self:GetCaster():GetHasteFactor() 
end

-----------------------------------------------------------------------------

function ogre_seal_melee_smash:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "OgreTank.Grunt", self:GetCaster() )
		local flSpeed = self:GetSpecialValueFor( "base_swing_speed" )
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		vToTarget = vToTarget:Normalized()
		local vTarget = self:GetCaster():GetOrigin() + vToTarget * self:GetCastRange( self:GetCaster():GetOrigin(), nil )
		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_seal_smash_thinker", { duration = flSpeed }, vTarget, self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------

