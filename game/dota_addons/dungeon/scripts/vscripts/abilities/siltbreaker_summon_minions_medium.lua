
siltbreaker_summon_minions_medium = class({})
LinkLuaModifier( "modifier_siltbreaker_summon_minions_medium", "modifiers/modifier_siltbreaker_summon_minions_medium", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_summon_minions_medium:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions_medium:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions_medium:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/siltbreaker_channel_summons.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end


	return true
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions_medium:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end 
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions_medium:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_summon_minions_medium", {} )
	end
end

-----------------------------------------------------------------------------

function siltbreaker_summon_minions_medium:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )

		self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_summon_minions_medium" )
	end
end

-----------------------------------------------------------------------------

