
treant_miniboss_entangle = class({})

LinkLuaModifier( "modifier_treant_miniboss_entangle", "modifiers/creatures/modifier_treant_miniboss_entangle", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_treant_miniboss_entangle_thinker", "modifiers/creatures/modifier_treant_miniboss_entangle_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function treant_miniboss_entangle:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/treant_miniboss/entangle_vines.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/wyvern_generic_blast_pre.vpcf", context )
end

--------------------------------------------------------------------------------

function treant_miniboss_entangle:OnAbilityPhaseStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )

		local vCastPos = self:GetCursorPosition()

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, vCastPos, true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 29, 55, 184 ) )

		self.nTargetPosFX = ParticleManager:CreateParticle( "particles/act_2/wyvern_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nTargetPosFX, 0, GetGroundPosition( self:GetCursorPosition(), self:GetCaster() ) )
		ParticleManager:SetParticleControl( self.nTargetPosFX, 1, Vector( self.radius, 2, 1 ) )
		ParticleManager:SetParticleControl( self.nTargetPosFX, 15, Vector( 200, 30, 0 ) )
		ParticleManager:SetParticleControl( self.nTargetPosFX, 16, Vector( 1, 0, 0 ) )

		--EmitSoundOn( "n_creep_Ursa.Clap", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function treant_miniboss_entangle:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		ParticleManager:DestroyParticle( self.nTargetPosFX, false )
	end 
end

--------------------------------------------------------------------------------

function treant_miniboss_entangle:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		ParticleManager:DestroyParticle( self.nTargetPosFX, false )

		local vCastPos = self:GetCursorPosition()

		local root_duration = self:GetSpecialValueFor( "root_duration" )

		CreateModifierThinker( self:GetCaster(), self, "modifier_treant_miniboss_entangle_thinker", { duration = root_duration }, vCastPos, self:GetCaster():GetTeamNumber(), false )

		EmitSoundOn( "TreantMiniboss.Overgrowth.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
