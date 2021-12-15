modifier_aghslab_phantom_lancer_doppelganger_thinker = class({})

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger_thinker:OnCreated( kv )
	self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
	if IsServer() then
		self:StartIntervalThink( self.delay )

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/phantom_lancer/phantom_lancer_fall20_immortal/phantom_lancer_fall20_immortal_doppelganger_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_aghslab_phantom_lancer_doppelganger_thinker:OnIntervalThink()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
