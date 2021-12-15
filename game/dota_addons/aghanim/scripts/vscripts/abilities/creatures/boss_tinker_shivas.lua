
require( "utility_functions" )
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

boss_tinker_shivas = class({})

LinkLuaModifier( "modifier_boss_tinker_shivas_thinker", "modifiers/creatures/modifier_boss_tinker_shivas_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_tinker_shivas", "modifiers/creatures/modifier_boss_tinker_shivas", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_tinker_shivas:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/items2_fx/shivas_guard_active.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_tinker_shivas:OnAbilityPhaseStart()
	if IsServer() then
		self.blast_radius = self:GetSpecialValueFor( "blast_radius" )

		EmitSoundOn( "Boss_Tinker.Shivas.Cast", self:GetCaster() )

		local nWarningRadius = self.blast_radius * 0.5

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( nWarningRadius, nWarningRadius, nWarningRadius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_tinker_shivas:OnAbilityPhaseInterrupted()
	if IsServer() then
		StopSoundOn( "Boss_Tinker.Shivas.Cast", self:GetCaster() )

		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function boss_tinker_shivas:OnSpellStart()
	if IsServer() then
		StopSoundOn( "Boss_Tinker.Shivas.Cast", self:GetCaster() )

		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		local kv =
		{
			duration = -1,
		}

		CreateModifierThinker( self:GetCaster(), self, "modifier_boss_tinker_shivas_thinker", kv,
			self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false
		)

		EmitSoundOn( "DOTA_Item.ShivasGuard.Activate", self:GetCaster() )
		--EmitSoundOnLocationWithCaster( self:GetCaster():GetAbsOrigin(), "DOTA_Item.ShivasGuard.Activate", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
