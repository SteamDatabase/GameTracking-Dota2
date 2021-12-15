
modifier_aghanim_clone = class({})

--------------------------------------------------------------------------------

function modifier_aghanim_clone:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 100000
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:GetStatusEffectName()  
	return "particles/status_fx/status_effect_faceless_chronosphere.vpcf"
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:GetEffectName() 
	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:OnCreated( kv )
	if IsServer() then 
		self.nFXIndex = ParticleManager:CreateParticle( "particles/gameplay/aghanim_clone_trap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 3, 3, 3 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )

		self.nFXIndex2 = ParticleManager:CreateParticle( "particles/gameplay/aghanim_clone_trap_upper.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex2 , 1, Vector( 3, 3, 3 ) )
		self:AddParticle( self.nFXIndex2, false, false, -1, false, false )

		self.nParticleFX = ParticleManager:CreateParticle( "particles/gameplay/agh_clone_prison_debuff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nParticleFX, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nParticleFX, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nParticleFX, false, false, -1, false, false )
	end
end


--------------------------------------------------------------------------------

function modifier_aghanim_clone:OnDestroy()
	if IsServer() then 
		--ParticleManager:DestroyParticle( self.nParticleFX, false )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_FEARED] = false,
		[MODIFIER_STATE_TAUNTED] = false,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_BLIND] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:GetOverrideAnimationRate( params )
	return 0.1
end

--------------------------------------------------------------------------------

function modifier_aghanim_clone:GetActivityTranslationModifiers( params )
	return "aghs_lab_2021"
end
