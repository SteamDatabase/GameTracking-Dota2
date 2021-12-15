aghslab_leshrac_split_earth = class({})
LinkLuaModifier( "modifier_aghslab_leshrac_split_earth", "modifiers/creatures/modifier_aghslab_leshrac_split_earth", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghslab_leshrac_split_earth_thinker", "modifiers/creatures/modifier_aghslab_leshrac_split_earth_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghslab_leshrac_split_earth:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/leshrac/split_earth_ground_preview.vpcf", context )
end

--------------------------------------------------------------------------------

function aghslab_leshrac_split_earth:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function aghslab_leshrac_split_earth:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.delay = self:GetSpecialValueFor( "delay" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_aghslab_leshrac_split_earth_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )

	local nPreviewRadius = self.radius * 0.7
	self.nTargetPosFX = ParticleManager:CreateParticle( "particles/creatures/leshrac/split_earth_ground_preview.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.nTargetPosFX, 0, self:GetCursorPosition() )
	ParticleManager:SetParticleControl( self.nTargetPosFX, 1, Vector( nPreviewRadius, nPreviewRadius, nPreviewRadius ) )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




