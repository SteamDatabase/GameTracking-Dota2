
modifier_skeleton_mage_grenade_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade_thinker:OnCreated( kv )
	if IsServer() then
		if not self:GetCaster() then
			self:Destroy()
			return
		end

		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.area_duration = self:GetAbility():GetSpecialValueFor( "area_duration" )
		self.linger_duration = self:GetAbility():GetSpecialValueFor( "linger_duration" )

		local fDistance = ( self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin() ):Length2D()
		-- @note: fTimeToTarget probably isn't doing anything, I think the particle sets its own duration in the vpcf
		local fTimeToTarget = fDistance / self:GetAbility():GetSpecialValueFor( "projectile_speed" )
		--printf( "fDistance: %d, fTimeToTarget: %.1f", fDistance, fTimeToTarget )

		local nPreviewRadius = self.radius
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/creature_spell_marker.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( nPreviewRadius, -nPreviewRadius, -nPreviewRadius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 2, Vector( fTimeToTarget, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )

		self.bPlayedImpact = false
	end
end

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade_thinker:PlayImpact()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/neutral_fx/black_dragon_fireball.vpcf", PATTACH_WORLDORIGIN, nil );
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() );
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin() );
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.area_duration, 0, 0 ) );
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		EmitSoundOn( "SkeletonMage.Grenade.Target", self:GetParent() )
		
		self:SetDuration( self.area_duration, true )
		self.bPlayedImpact = true

		self:StartIntervalThink( 0.0 )
	end
end

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade_thinker:OnIntervalThink()
	if IsServer() then
		if self.bPlayedImpact == false then
			self:PlayImpact()
			return -1
		end

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil then
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_skeleton_mage_grenade", { duration = self.linger_duration } )
			end
		end

		self:StartIntervalThink( 0.25 )
	end
end

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

----------------------------------------------------------------------------------------
