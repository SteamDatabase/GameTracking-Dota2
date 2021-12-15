aghslab_night_stalker_void = class({})
LinkLuaModifier( "modifier_aghslab_night_stalker_void", "modifiers/creatures/modifier_aghslab_night_stalker_void", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghslab_night_stalker_void_thinker", "modifiers/creatures/modifier_aghslab_night_stalker_void_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghslab_night_stalker_void:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/nightstalker/void_preview.vpcf", context )
end

--------------------------------------------------------------------------------

function aghslab_night_stalker_void:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function aghslab_night_stalker_void:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.delay = self:GetSpecialValueFor( "delay" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_aghslab_night_stalker_void_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )

	local nPreviewRadius = self.radius * 0.7
	self.nTargetPosFX = ParticleManager:CreateParticle( "particles/creatures/nightstalker/void_preview.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.nTargetPosFX, 0, self:GetCursorPosition() )
	ParticleManager:SetParticleControl( self.nTargetPosFX, 1, Vector( nPreviewRadius, nPreviewRadius, nPreviewRadius ) )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




