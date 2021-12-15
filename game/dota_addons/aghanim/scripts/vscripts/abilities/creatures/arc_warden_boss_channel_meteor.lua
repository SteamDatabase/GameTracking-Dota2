arc_warden_boss_channel_meteor = class{}
LinkLuaModifier( "modifier_boss_arc_warden_damage_counter", "modifiers/creatures/modifier_boss_arc_warden_damage_counter", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_arc_warden_shard_counter", "modifiers/creatures/modifier_boss_arc_warden_shard_counter", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_arc_warden_glimpse", "modifiers/creatures/modifier_boss_arc_warden_glimpse", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_boss_arc_warden_phase_delay", "modifiers/creatures/modifier_boss_arc_warden_phase_delay", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function arc_warden_boss_channel_meteor:Precache( context )
	PrecacheResource( "particle", "particles/items_fx/blink_dagger_start.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/blink_dagger_end.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/lifestealer/lifestealer_damage_counter_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/arc_warden_boss/nemestice_meteor_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/arc_warden_boss/meteor_channel.vpcf", context )

	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context )
end

--------------------------------------------------------------------------------

function arc_warden_boss_channel_meteor:OnAbilityPhaseStart()
	if IsServer() then
		--StartSoundEventFromPositionReliable( "Aghanim.ShardAttack.Channel", self:GetCaster():GetAbsOrigin() )
		--self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_shard_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end

-------------------------------------------------------------------------------

function arc_warden_boss_channel_meteor:OnChannelThink( flInterval )
	if IsServer() then
	end
end


-------------------------------------------------------------------------------

function arc_warden_boss_channel_meteor:OnChannelFinish( bInterrupted )
	if IsServer() then
		--StopSoundOn( "Aghanim.ShardAttack.Loop", self:GetCaster() )
		--ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end
