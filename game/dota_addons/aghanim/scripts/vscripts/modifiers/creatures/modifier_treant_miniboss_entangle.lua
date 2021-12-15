
modifier_treant_miniboss_entangle = class({})

-----------------------------------------------------------------------------

function modifier_treant_miniboss_entangle:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_entangle:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_entangle:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_entangle:OnCreated( kv )
	if not IsServer() then
		return
	end

	if self:GetParent():IsHero() then
		local nFXIndexA = ParticleManager:CreateParticle( "particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndexA, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( nFXIndexA, false, false, -1, false, false )
	else
		local nFXIndexB = ParticleManager:CreateParticle( "particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndexB, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( nFXIndexB, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_treant_miniboss_entangle:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ROOTED ] = true,

		[ MODIFIER_STATE_INVISIBLE ] = false,
	}

	return state
end

--------------------------------------------------------------------------------
