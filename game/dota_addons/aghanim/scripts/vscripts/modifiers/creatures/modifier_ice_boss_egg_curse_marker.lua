modifier_ice_boss_egg_curse_marker = class({})

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_curse_marker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_curse_marker:GetStatusEffectName()
	return "particles/status_fx/status_effect_iceblast_half.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_curse_marker:OnCreated( kv )
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor( "radius" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )

		self.nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_ground.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex2 , 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex2 , 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex2 , 2, Vector( radius, radius, radius ) )
		--self:AddParticle( self.nFXIndex2 , false, false, -1, false, true )

		self.nFXIndex3 = ParticleManager:CreateParticle( "particles/gameplay/generic_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex3, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex3, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( self.nFXIndex3, 2, Vector( 999, 999, 999 ) )
		--ParticleManager:ReleaseParticleIndex( self.nFXIndex3 )

		self:StartIntervalThink( 0.25 )

	end
end

--------------------------------------------------------------------------------

function modifier_ice_boss_egg_curse_marker:OnIntervalThink()
	if IsServer() == false then 
		return 
	end

	if self.nFXIndex2 then 
		ParticleManager:DestroyParticle( self.nFXIndex2, false )
	end

	self.nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_ground.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( self.nFXIndex2 , 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex2 , 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex2 , 2, Vector( radius, radius, radius ) )
	--self:AddParticle( self.nFXIndex2 , false, false, -1, false, true )
end

--------------------------------------------------------------------------------


function modifier_ice_boss_egg_curse_marker:OnDestroy()
	if IsServer() == false then 
		return 
	end

	if self.nFXIndex2 then 
		ParticleManager:DestroyParticle( self.nFXIndex2, false )
	end

	if self.nFXIndex3 then
		ParticleManager:DestroyParticle( self.nFXIndex3, true )
	end
end