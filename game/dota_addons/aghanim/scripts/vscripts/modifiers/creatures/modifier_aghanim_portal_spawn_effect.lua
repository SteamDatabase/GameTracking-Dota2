modifier_aghanim_portal_spawn_effect = class({})

---------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:IsHidden()
	return true
end

---------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 1.0 )
	end
end


--------------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:OnIntervalThink()
	if IsServer() then
		self:GetParent():RemoveEffects( EF_NODRAW )
		self:StartIntervalThink( -1 )
	end
end

--------------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 20000
end

---------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

---------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

--------------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

---------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:GetModifierModelScale( params )
	return ( self:GetElapsedTime() / self:GetDuration() - 1.0 ) * 100
end

---------------------------------------------------------------------------

function modifier_aghanim_portal_spawn_effect:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end
