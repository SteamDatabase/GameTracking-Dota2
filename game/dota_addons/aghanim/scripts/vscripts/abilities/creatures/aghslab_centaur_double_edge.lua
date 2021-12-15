aghslab_centaur_double_edge = class({})
LinkLuaModifier( "modifier_aghslab_centaur_double_edge_thinker", "modifiers/creatures/modifier_aghslab_centaur_double_edge_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghslab_centaur_double_edge:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/centaur/double_edge_ground_preview.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9.vpcf", context )
end

--------------------------------------------------------------------------------

function aghslab_centaur_double_edge:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------

function aghslab_centaur_double_edge:OnSpellStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.delay = self:GetSpecialValueFor( "delay" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_aghslab_centaur_double_edge_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )

	local nPreviewRadius = self.radius * 0.7
	self.nTargetPosFX = ParticleManager:CreateParticle( "particles/creatures/centaur/double_edge_ground_preview.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( self.nTargetPosFX, 0, self:GetCursorPosition() )
	ParticleManager:SetParticleControl( self.nTargetPosFX, 1, Vector( nPreviewRadius, nPreviewRadius, nPreviewRadius ) )
end

--------------------------------------------------------------------------------


