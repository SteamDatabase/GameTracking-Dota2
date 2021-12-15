
modifier_ascension_meteoric_thinker = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_meteoric_thinker:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ascension_meteoric_thinker:OnCreated( kv )
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		self.land_time = self:GetAbility():GetSpecialValueFor( "land_time" )
		self.impact_radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )

		EmitSoundOn( "DOTA_Item.MeteorHammer.Channel", self:GetParent() )

		self.nFXIndexA = ParticleManager:CreateParticle( "particles/ascension/meteoric_target.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndexA, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndexA, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )

		self.nFXIndexB = ParticleManager:CreateParticle( "particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nFXIndexB, 0, self:GetParent():GetAbsOrigin() )

		self.nFXIndexC = ParticleManager:CreateParticle( "particles/items4_fx/meteor_hammer_spell_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
end

-----------------------------------------------------------------------------------------

function modifier_ascension_meteoric_thinker:OnDestroy()
	if IsServer() then
		if self:GetCaster() and self:GetCaster():IsAlive() then
			FindClearSpaceForUnit( self:GetCaster(), self:GetParent():GetAbsOrigin(), true )
			self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_ascension_meteoric_land", { duration = self.land_time } )
		end
		StopSoundOn( "DOTA_Item.MeteorHammer.Channel", self:GetParent() )
		ParticleManager:DestroyParticle( self.nFXIndexA, true )
		ParticleManager:DestroyParticle( self.nFXIndexB, true )
		ParticleManager:DestroyParticle( self.nFXIndexC, true )

		UTIL_Remove( self:GetParent() )
	end
end


-----------------------------------------------------------------------------------------