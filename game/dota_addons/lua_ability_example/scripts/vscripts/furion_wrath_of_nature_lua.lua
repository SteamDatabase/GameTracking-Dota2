furion_wrath_of_nature_lua = class({})
LinkLuaModifier( "modifier_furion_wrath_of_nature_thinker_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function furion_wrath_of_nature_lua:OnAbilityPhaseStart()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_wrath_of_nature_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )


	return true
end

--------------------------------------------------------------------------------

function furion_wrath_of_nature_lua:OnSpellStart()
	self.hTarget = self:GetCursorTarget()
	self.vTargetPos = self:GetCursorPosition()

	EmitSoundOn( "Hero_Furion.WrathOfNature_Cast", self:GetCaster() )

	CreateModifierThinker( self:GetCaster(), self, "modifier_furion_wrath_of_nature_thinker_lua", kv, self.vTargetPos, self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------

function furion_wrath_of_nature_lua:GetAssociatedSecondaryAbilities()
	return "furion_force_of_nature_lua"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------