thunder_mountain_zeus_cloud = class({})

LinkLuaModifier( "modifier_thunder_mountain_zeus_cloud_passive", "modifiers/creatures/modifier_thunder_mountain_zeus_cloud_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_thunder_mountain_zeus_cloud_thinker", "modifiers/creatures/modifier_thunder_mountain_zeus_cloud_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function thunder_mountain_zeus_cloud:GetIntrinsicModifierName()
	return "modifier_thunder_mountain_zeus_cloud_passive"
end

-----------------------------------------------------------------------

function thunder_mountain_zeus_cloud:Precache( context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast_pre.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_lightning_bolt_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_lightning_bolt_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zeus/zeus_cloud.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/zeus_cloud_projectile.vpcf", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )

	PrecacheUnitByNameSync( "npc_dota_zeus_cloud", context, -1 )
end

-----------------------------------------------------------------------

function thunder_mountain_zeus_cloud:OnAbilityPhaseStart()
	if IsServer() == false then 
		return true 
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	return true 
end

-----------------------------------------------------------------------

function thunder_mountain_zeus_cloud:OnAbilityPhaseInterrupted()
end

-----------------------------------------------------------------------

function thunder_mountain_zeus_cloud:OnSpellStart()
	if IsServer() == false then 
		return 
	end


	CreateModifierThinker( self:GetCaster(), self, "modifier_thunder_mountain_zeus_cloud_thinker", { duration = self:GetSpecialValueFor( "bolt_delay" ) }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

-----------------------------------------------------------------------
