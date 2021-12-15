gaoler_shock = class({})
LinkLuaModifier( "modifier_gaoler_shock", "modifiers/creatures/modifier_gaoler_shock", LUA_MODIFIER_MOTION_NONE )
-----------------------------------------------------------------------

function gaoler_shock:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

--------------------------------------------------------------------------------

function gaoler_shock:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/gaoler/gaoler_telegraph.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end

-----------------------------------------------------------------------

function gaoler_shock:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-----------------------------------------------------------------------

function gaoler_shock:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_gaoler_shock", {} )
		EmitSoundOn( "Hero_Razor.SeveringCrest.Loop", self:GetCaster() )
	end
end

-----------------------------------------------------------------------

function gaoler_shock:OnChannelFinish( bInterrpted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_gaoler_shock" )
		StopSoundOn( "Hero_Razor.SeveringCrest.Loop", self:GetCaster() )
	end
end