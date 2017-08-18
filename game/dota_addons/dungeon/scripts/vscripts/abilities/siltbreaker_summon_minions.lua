
siltbreaker_summon_minions = class({})
LinkLuaModifier( "modifier_siltbreaker_summon_minions", "modifiers/modifier_siltbreaker_summon_minions", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_summon_minions:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions:OnAbilityPhaseStart()
	if IsServer() then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )
		local fImmuneDuration = self.channel_duration + self:GetCastPoint()
		--self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_immunity", { duration = fImmuneDuration } )
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/siltbreaker_channel_summons.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end 
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_summon_minions", {} )
	end
end

-----------------------------------------------------------------------------

function siltbreaker_summon_minions:OnChannelFinish( bInterrupted )
	if IsServer() then
		
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_summon_minions" )
	end
end

-----------------------------------------------------------------------------

